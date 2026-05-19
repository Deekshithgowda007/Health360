public with sharing class PatientPortalController {
    @AuraEnabled(cacheable=true)
    public static List<HospitalOption> getHospitals() {
        List<HealthcareProviderSpecialty> mappings = [
            SELECT
                AccountId,
                Account.Name,
                Account.ParentId,
                Account.Parent.Name,
                Account.Phone,
                Account.Website,
                Account.Image_URL__c,
                Account.ShippingCity,
                Account.ShippingState,
                Account.ShippingCountry,
                Account.Parent.Phone,
                Account.Parent.Website,
                Account.Parent.Image_URL__c,
                Account.Parent.ShippingCity,
                Account.Parent.ShippingState,
                Account.Parent.ShippingCountry
            FROM HealthcareProviderSpecialty
            WHERE AccountId != null
        ];

        Map<Id, HospitalOption> hospitalsById = new Map<Id, HospitalOption>();
        Map<Id, Set<Id>> hospitalBranchIds = new Map<Id, Set<Id>>();

        for (HealthcareProviderSpecialty mapping : mappings) {
            if (mapping.AccountId == null) {
                continue;
            }

            Id hospitalId = mapping.Account.ParentId != null ? mapping.Account.ParentId : mapping.AccountId;
            if (!hospitalsById.containsKey(hospitalId)) {
                HospitalOption option = new HospitalOption();
                option.id = hospitalId;
                option.name = mapping.Account.ParentId != null ? mapping.Account.Parent.Name : mapping.Account.Name;
                option.phone = mapping.Account.ParentId != null ? mapping.Account.Parent.Phone : mapping.Account.Phone;
                option.website = mapping.Account.ParentId != null ? mapping.Account.Parent.Website : mapping.Account.Website;
                option.imageUrl = mapping.Account.ParentId != null ? mapping.Account.Parent.Image_URL__c : mapping.Account.Image_URL__c;
                option.city = mapping.Account.ParentId != null ? mapping.Account.Parent.ShippingCity : mapping.Account.ShippingCity;
                option.state = mapping.Account.ParentId != null ? mapping.Account.Parent.ShippingState : mapping.Account.ShippingState;
                option.country = mapping.Account.ParentId != null ? mapping.Account.Parent.ShippingCountry : mapping.Account.ShippingCountry;
                hospitalsById.put(hospitalId, option);
                hospitalBranchIds.put(hospitalId, new Set<Id>());
            }

            hospitalBranchIds.get(hospitalId).add(mapping.AccountId);
        }

        List<HospitalOption> hospitals = hospitalsById.values();
        for (HospitalOption option : hospitals) {
            option.branchCount = hospitalBranchIds.containsKey(option.id) ? hospitalBranchIds.get(option.id).size() : 0;
        }
        hospitals.sort();
        return hospitals;
    }

    @AuraEnabled(cacheable=true)
    public static List<BranchOption> getBranches(String hospitalId) {
        if (String.isBlank(hospitalId)) {
            return new List<BranchOption>();
        }

        List<HealthcareProviderSpecialty> mappings = [
            SELECT
                AccountId,
                Account.Name,
                Account.ParentId,
                PractitionerId,
                Account.Phone,
                Account.Website,
                Account.Image_URL__c,
                Account.BillingStreet,
                Account.BillingCity,
                Account.BillingState,
                Account.BillingCountry,
                Account.BillingPostalCode,
                Account.ShippingCity,
                Account.ShippingCountry
            FROM HealthcareProviderSpecialty
            WHERE AccountId != null
            AND (Account.ParentId = :hospitalId OR AccountId = :hospitalId)
        ];

        Map<Id, BranchOption> branchesById = new Map<Id, BranchOption>();
        Map<Id, Set<Id>> branchDoctorIds = new Map<Id, Set<Id>>();

        for (HealthcareProviderSpecialty mapping : mappings) {
            if (!branchesById.containsKey(mapping.AccountId)) {
                BranchOption option = new BranchOption();
                option.id = mapping.AccountId;
                option.name = mapping.Account.Name;
                option.phone = mapping.Account.Phone;
                option.website = mapping.Account.Website;
                option.imageUrl = mapping.Account.Image_URL__c;
                option.address = joinValues(new List<String>{
                    mapping.Account.BillingStreet,
                    mapping.Account.BillingCity,
                    mapping.Account.BillingState,
                    mapping.Account.BillingPostalCode,
                    mapping.Account.BillingCountry
                }, ', ');
                option.city = mapping.Account.ShippingCity;
                option.country = mapping.Account.ShippingCountry;
                branchesById.put(mapping.AccountId, option);
                branchDoctorIds.put(mapping.AccountId, new Set<Id>());
            }

            if (mapping.PractitionerId != null) {
                branchDoctorIds.get(mapping.AccountId).add(mapping.PractitionerId);
            }
        }

        List<BranchOption> branches = branchesById.values();
        for (BranchOption option : branches) {
            option.doctorCount = branchDoctorIds.containsKey(option.id) ? branchDoctorIds.get(option.id).size() : 0;
        }
        branches.sort();
        return branches;
    }

    @AuraEnabled(cacheable=true)
    public static List<SpecialtyOption> getSpecialties(String hospitalId, String branchId) {
        if (String.isBlank(hospitalId) && String.isBlank(branchId)) {
            return new List<SpecialtyOption>();
        }

        List<HealthcareProviderSpecialty> mappings = [
            SELECT AccountId, Account.ParentId, SpecialtyId, Specialty.Name, PractitionerId
            FROM HealthcareProviderSpecialty
            WHERE SpecialtyId != null
            AND (
                AccountId = :branchId
                OR Account.ParentId = :hospitalId
                OR AccountId = :hospitalId
            )
        ];

        Map<Id, SpecialtyOption> specialtiesById = new Map<Id, SpecialtyOption>();
        Map<Id, Set<Id>> specialtyDoctorIds = new Map<Id, Set<Id>>();

        for (HealthcareProviderSpecialty mapping : mappings) {
            if (!specialtiesById.containsKey(mapping.SpecialtyId)) {
                SpecialtyOption option = new SpecialtyOption();
                option.id = mapping.SpecialtyId;
                option.name = mapping.Specialty.Name;
                specialtiesById.put(mapping.SpecialtyId, option);
                specialtyDoctorIds.put(mapping.SpecialtyId, new Set<Id>());
            }

            if (mapping.PractitionerId != null) {
                specialtyDoctorIds.get(mapping.SpecialtyId).add(mapping.PractitionerId);
            }
        }

        List<SpecialtyOption> specialties = specialtiesById.values();
        for (SpecialtyOption option : specialties) {
            option.doctorCount = specialtyDoctorIds.containsKey(option.id) ? specialtyDoctorIds.get(option.id).size() : 0;
        }
        specialties.sort();
        return specialties;
    }

    @AuraEnabled(cacheable=true)
    public static List<DoctorCard> getDoctors(String hospitalId, String branchId, String specialtyId, String searchTerm, String sortBy) {
        List<HealthcareProviderSpecialty> mappings;
        if (String.isBlank(hospitalId)) {
            mappings = [
                SELECT
                    AccountId,
                    Account.Name,
                    Account.ParentId,
                    Account.Parent.Name,
                    SpecialtyId,
                    Specialty.Name,
                    PractitionerId,
                    Practitioner.Name,
                    Practitioner.Image_URL__c,
                    Practitioner.Available_Appointment_Type__c,
                    Practitioner.Overview__c,
                    Practitioner.Area_of_Expertise__c,
                    Practitioner.Awards_and_Regonitions__c
                FROM HealthcareProviderSpecialty
                WHERE PractitionerId != null
            ];
        } else {
            mappings = [
                SELECT
                    AccountId,
                    Account.Name,
                    Account.ParentId,
                    Account.Parent.Name,
                    SpecialtyId,
                    Specialty.Name,
                    PractitionerId,
                    Practitioner.Name,
                    Practitioner.Image_URL__c,
                    Practitioner.Available_Appointment_Type__c,
                    Practitioner.Overview__c,
                    Practitioner.Area_of_Expertise__c,
                    Practitioner.Awards_and_Regonitions__c
                FROM HealthcareProviderSpecialty
                WHERE PractitionerId != null
                AND (Account.ParentId = :hospitalId OR AccountId = :hospitalId)
            ];
        }

        Map<String, DoctorCard> doctorsByKey = new Map<String, DoctorCard>();
        String normalizedSearch = String.isBlank(searchTerm) ? null : searchTerm.trim().toLowerCase();

        for (HealthcareProviderSpecialty mapping : mappings) {
            if (!String.isBlank(branchId) && mapping.AccountId != branchId) {
                continue;
            }
            if (!String.isBlank(specialtyId) && mapping.SpecialtyId != specialtyId) {
                continue;
            }
            String key = mapping.PractitionerId + ':' + mapping.AccountId;
            if (!doctorsByKey.containsKey(key)) {
                DoctorCard card = new DoctorCard();
                card.doctorId = mapping.PractitionerId;
                card.branchId = mapping.AccountId;
                card.doctorName = mapping.Practitioner.Name;
                card.specialtyId = mapping.SpecialtyId;
                card.specialtyName = mapping.Specialty.Name;
                card.branchName = mapping.Account.Name;
                card.hospitalName = mapping.Account.ParentId != null ? mapping.Account.Parent.Name : mapping.Account.Name;
                card.imageUrl = mapping.Practitioner.Image_URL__c;
                card.consultationMode = mapping.Practitioner.Available_Appointment_Type__c;
                card.overview = mapping.Practitioner.Overview__c;
                card.expertise = mapping.Practitioner.Area_of_Expertise__c;
                card.awards = mapping.Practitioner.Awards_and_Regonitions__c;
                card.recommendationScore = computeRecommendationScore(mapping);
                doctorsByKey.put(key, card);
            }
        }

        List<DoctorCard> doctors = new List<DoctorCard>();
        for (DoctorCard card : doctorsByKey.values()) {
            if (normalizedSearch != null) {
                String haystack = (
                    String.valueOf(card.doctorName) + ' ' +
                    String.valueOf(card.specialtyName) + ' ' +
                    String.valueOf(card.branchName) + ' ' +
                    String.valueOf(card.hospitalName)
                ).toLowerCase();
                if (!haystack.contains(normalizedSearch)) {
                    continue;
                }
            }
            doctors.add(card);
        }

        String requestedSort = String.isBlank(sortBy) ? 'recommended' : sortBy;
        for (DoctorCard card : doctors) {
            card.sortMode = requestedSort;
        }
        doctors.sort();
        return doctors;
    }

    @AuraEnabled(cacheable=true)
    public static DoctorDetail getDoctorDetail(String doctorId, String branchId) {
        if (String.isBlank(doctorId)) {
            return null;
        }

        List<HealthcareProviderSpecialty> mappings;
        if (String.isBlank(branchId)) {
            mappings = [
                SELECT
                    AccountId,
                    Account.Name,
                    Account.ParentId,
                    Account.Parent.Name,
                    Account.Phone,
                    Account.Website,
                    Account.BillingStreet,
                    Account.BillingCity,
                    Account.BillingState,
                    Account.BillingPostalCode,
                    Account.BillingCountry,
                    SpecialtyId,
                    Specialty.Name,
                    PractitionerId,
                    Practitioner.Name,
                    Practitioner.Image_URL__c,
                    Practitioner.Available_Appointment_Type__c,
                    Practitioner.Overview__c,
                    Practitioner.Area_of_Expertise__c,
                    Practitioner.Awards_and_Regonitions__c
                FROM HealthcareProviderSpecialty
                WHERE PractitionerId = :doctorId
            ];
        } else {
            mappings = [
                SELECT
                    AccountId,
                    Account.Name,
                    Account.ParentId,
                    Account.Parent.Name,
                    Account.Phone,
                    Account.Website,
                    Account.BillingStreet,
                    Account.BillingCity,
                    Account.BillingState,
                    Account.BillingPostalCode,
                    Account.BillingCountry,
                    SpecialtyId,
                    Specialty.Name,
                    PractitionerId,
                    Practitioner.Name,
                    Practitioner.Image_URL__c,
                    Practitioner.Available_Appointment_Type__c,
                    Practitioner.Overview__c,
                    Practitioner.Area_of_Expertise__c,
                    Practitioner.Awards_and_Regonitions__c
                FROM HealthcareProviderSpecialty
                WHERE PractitionerId = :doctorId
                AND AccountId = :branchId
            ];
        }

        if (mappings.isEmpty()) {
            return null;
        }

        DoctorDetail detail = new DoctorDetail();
        detail.doctorId = doctorId;
        detail.doctorName = mappings[0].Practitioner.Name;
        detail.imageUrl = mappings[0].Practitioner.Image_URL__c;
        detail.consultationMode = mappings[0].Practitioner.Available_Appointment_Type__c;
        detail.overview = mappings[0].Practitioner.Overview__c;
        detail.expertise = splitText(mappings[0].Practitioner.Area_of_Expertise__c);
        detail.awards = splitText(mappings[0].Practitioner.Awards_and_Regonitions__c);
        detail.branches = new List<BranchSummary>();
        detail.specialties = new List<String>();

        Set<String> specialtyNames = new Set<String>();
        Set<Id> branchIds = new Set<Id>();

        for (HealthcareProviderSpecialty mapping : mappings) {
            if (mapping.Specialty != null) {
                specialtyNames.add(mapping.Specialty.Name);
            }
            if (!branchIds.contains(mapping.AccountId)) {
                branchIds.add(mapping.AccountId);
                BranchSummary branch = new BranchSummary();
                branch.id = mapping.AccountId;
                branch.name = mapping.Account.Name;
                branch.hospitalName = mapping.Account.ParentId != null ? mapping.Account.Parent.Name : mapping.Account.Name;
                branch.phone = mapping.Account.Phone;
                branch.website = mapping.Account.Website;
                branch.address = joinValues(new List<String>{
                    mapping.Account.BillingStreet,
                    mapping.Account.BillingCity,
                    mapping.Account.BillingState,
                    mapping.Account.BillingPostalCode,
                    mapping.Account.BillingCountry
                }, ', ');
                detail.branches.add(branch);
            }
        }

        detail.specialties.addAll(specialtyNames);
        detail.specialties.sort();
        return detail;
    }

    @AuraEnabled(cacheable=true)
    public static List<ScheduleSlot> getDoctorSchedules(String doctorId, String branchId) {
        if (String.isBlank(doctorId) || String.isBlank(branchId)) {
            return new List<ScheduleSlot>();
        }

        List<TimeSlot> timeSlots = DoctorAppointmentController.getTimeSlots(doctorId, branchId);
        List<ScheduleSlot> schedules = new List<ScheduleSlot>();

        for (TimeSlot slot : timeSlots) {
            ScheduleSlot schedule = new ScheduleSlot();
            schedule.dayOfWeek = String.valueOf(slot.DayOfWeek);
            schedule.startTime = String.valueOf(slot.StartTime);
            schedule.endTime = String.valueOf(slot.EndTime);
            schedules.add(schedule);
        }

        return schedules;
    }

    @AuraEnabled(cacheable=true)
    public static PatientSummary lookupPatient(String identifier) {
        if (String.isBlank(identifier)) {
            return null;
        }

        List<Account> patients = [
            SELECT Id, Name, PersonEmail, Phone, PersonMailingCity, PersonMailingState, IsPersonAccount
            FROM Account
            WHERE IsPersonAccount = true
            AND (PersonEmail = :identifier OR Phone = :identifier)
            LIMIT 1
        ];

        if (patients.isEmpty()) {
            return null;
        }

        return toPatientSummary(patients[0]);
    }

    @AuraEnabled
    public static PatientSummary registerPatient(RegistrationRequest request) {
        if (request == null) {
            throw new AuraHandledException('Registration data is required.');
        }

        Lead newLead = new Lead();
        newLead.FirstName = request.firstName;
        newLead.LastName = request.lastName;
        newLead.Email = request.email;
        newLead.Phone = request.phone;
        newLead.Street = request.street;
        newLead.City = request.city;
        newLead.State = request.state;
        newLead.Country = request.country;
        newLead.PostalCode = request.postalCode;
        newLead.Company = String.isBlank(request.company) ? 'Patient Portal' : request.company;

        String leadResponse = DoctorAppointmentController.createLead(newLead);
        if (leadResponse == 'emailexits') {
            throw new AuraHandledException('An account already exists with this email address.');
        }
        if (leadResponse == 'phoneexixts') {
            throw new AuraHandledException('An account already exists with this phone number.');
        }
        if (String.isBlank(leadResponse)) {
            throw new AuraHandledException('We could not create the patient profile. Please try again.');
        }

        String accountId = DoctorAppointmentController.convertLeadToPersonAccount(leadResponse);
        Account patient = [
            SELECT Id, Name, PersonEmail, Phone, PersonMailingCity, PersonMailingState, IsPersonAccount
            FROM Account
            WHERE Id = :accountId
            LIMIT 1
        ];

        return toPatientSummary(patient);
    }

    @AuraEnabled(cacheable=true)
    public static AppointmentDashboard getPatientAppointments(String patientId) {
        AppointmentDashboard dashboard = new AppointmentDashboard();
        dashboard.upcoming = new List<AppointmentCard>();
        dashboard.history = new List<AppointmentCard>();

        if (String.isBlank(patientId)) {
            return dashboard;
        }

        List<ServiceAppointment> appointments = [
            SELECT
                Id,
                AppointmentNumber,
                Status,
                DueDate,
                SchedStartTime,
                SchedEndTime,
                AppointmentType,
                Zoom_Meeting_Url__c,
                ParentRecordId,
                AccountId,
                Account.Name,
                WorkType.Name
            FROM ServiceAppointment
            WHERE AccountId = :patientId OR ParentRecordId = :patientId
            ORDER BY SchedStartTime DESC
        ];

        for (ServiceAppointment appointment : appointments) {
            AppointmentCard card = new AppointmentCard();
            card.id = appointment.Id;
            card.appointmentNumber = appointment.AppointmentNumber;
            card.status = appointment.Status;
            card.mode = appointment.AppointmentType;
            card.workType = appointment.WorkType != null ? appointment.WorkType.Name : null;
            card.branchName = appointment.Account != null ? appointment.Account.Name : null;
            card.zoomLink = appointment.Zoom_Meeting_Url__c;
            card.startDateTime = appointment.SchedStartTime;
            card.endDateTime = appointment.SchedEndTime;
            card.displayDate = appointment.DueDate != null ? String.valueOf(appointment.DueDate) : null;

            if (appointment.Status == 'Scheduled') {
                dashboard.upcoming.add(card);
            } else {
                dashboard.history.add(card);
            }
        }

        return dashboard;
    }

    private static Integer computeRecommendationScore(HealthcareProviderSpecialty mapping) {
        Integer score = 0;
        if (String.isNotBlank(mapping.Practitioner.Overview__c)) {
            score += 3;
        }
        if (String.isNotBlank(mapping.Practitioner.Area_of_Expertise__c)) {
            score += 3;
        }
        if (String.isNotBlank(mapping.Practitioner.Awards_and_Regonitions__c)) {
            score += 2;
        }
        if (String.isNotBlank(mapping.Practitioner.Image_URL__c)) {
            score += 1;
        }
        if (String.isNotBlank(mapping.Practitioner.Available_Appointment_Type__c)) {
            score += 1;
        }
        return score;
    }

    private static PatientSummary toPatientSummary(Account patient) {
        PatientSummary summary = new PatientSummary();
        summary.id = patient.Id;
        summary.name = patient.Name;
        summary.email = patient.PersonEmail;
        summary.phone = patient.Phone;
        summary.city = patient.PersonMailingCity;
        summary.state = patient.PersonMailingState;
        return summary;
    }

    private static List<String> splitText(String rawValue) {
        List<String> values = new List<String>();
        if (String.isBlank(rawValue)) {
            return values;
        }

        for (String value : rawValue.split(',')) {
            String trimmedValue = value != null ? value.trim() : null;
            if (String.isNotBlank(trimmedValue)) {
                values.add(trimmedValue);
            }
        }
        return values;
    }

    private static String joinValues(List<String> values, String separator) {
        List<String> filteredValues = new List<String>();
        for (String value : values) {
            if (String.isNotBlank(value)) {
                filteredValues.add(value);
            }
        }
        return String.join(filteredValues, separator);
    }

    public class HospitalOption implements Comparable {
        @AuraEnabled public Id id;
        @AuraEnabled public String name;
        @AuraEnabled public String city;
        @AuraEnabled public String state;
        @AuraEnabled public String country;
        @AuraEnabled public String phone;
        @AuraEnabled public String website;
        @AuraEnabled public String imageUrl;
        @AuraEnabled public Integer branchCount;

        public Integer compareTo(Object other) {
            HospitalOption otherHospital = (HospitalOption) other;
            return String.valueOf(name).toLowerCase().compareTo(String.valueOf(otherHospital.name).toLowerCase());
        }
    }

    public class BranchOption implements Comparable {
        @AuraEnabled public Id id;
        @AuraEnabled public String name;
        @AuraEnabled public String city;
        @AuraEnabled public String country;
        @AuraEnabled public String address;
        @AuraEnabled public String phone;
        @AuraEnabled public String website;
        @AuraEnabled public String imageUrl;
        @AuraEnabled public Integer doctorCount;

        public Integer compareTo(Object other) {
            BranchOption otherBranch = (BranchOption) other;
            return String.valueOf(name).toLowerCase().compareTo(String.valueOf(otherBranch.name).toLowerCase());
        }
    }

    public class SpecialtyOption implements Comparable {
        @AuraEnabled public Id id;
        @AuraEnabled public String name;
        @AuraEnabled public Integer doctorCount;

        public Integer compareTo(Object other) {
            SpecialtyOption otherSpecialty = (SpecialtyOption) other;
            return String.valueOf(name).toLowerCase().compareTo(String.valueOf(otherSpecialty.name).toLowerCase());
        }
    }

    public class DoctorCard implements Comparable {
        @AuraEnabled public Id doctorId;
        @AuraEnabled public String doctorName;
        @AuraEnabled public Id specialtyId;
        @AuraEnabled public String specialtyName;
        @AuraEnabled public Id branchId;
        @AuraEnabled public String branchName;
        @AuraEnabled public String hospitalName;
        @AuraEnabled public String consultationMode;
        @AuraEnabled public String overview;
        @AuraEnabled public String expertise;
        @AuraEnabled public String awards;
        @AuraEnabled public String imageUrl;
        @AuraEnabled public Integer recommendationScore;
        @AuraEnabled public String sortMode;

        public Integer compareTo(Object other) {
            DoctorCard otherCard = (DoctorCard) other;
            String effectiveSort = String.isBlank(sortMode) ? 'recommended' : sortMode;

            if (effectiveSort == 'name') {
                return String.valueOf(doctorName).toLowerCase().compareTo(String.valueOf(otherCard.doctorName).toLowerCase());
            }
            if (effectiveSort == 'specialty') {
                Integer specialtyCompare = String.valueOf(specialtyName).toLowerCase().compareTo(String.valueOf(otherCard.specialtyName).toLowerCase());
                if (specialtyCompare != 0) {
                    return specialtyCompare;
                }
            }
            if (effectiveSort == 'branch') {
                Integer branchCompare = String.valueOf(branchName).toLowerCase().compareTo(String.valueOf(otherCard.branchName).toLowerCase());
                if (branchCompare != 0) {
                    return branchCompare;
                }
            }

            Integer scoreCompare = otherCard.recommendationScore - recommendationScore;
            if (scoreCompare != 0) {
                return scoreCompare;
            }
            return String.valueOf(doctorName).toLowerCase().compareTo(String.valueOf(otherCard.doctorName).toLowerCase());
        }
    }

    public class DoctorDetail {
        @AuraEnabled public Id doctorId;
        @AuraEnabled public String doctorName;
        @AuraEnabled public String imageUrl;
        @AuraEnabled public String consultationMode;
        @AuraEnabled public String overview;
        @AuraEnabled public List<String> specialties;
        @AuraEnabled public List<String> expertise;
        @AuraEnabled public List<String> awards;
        @AuraEnabled public List<BranchSummary> branches;
    }

    public class BranchSummary {
        @AuraEnabled public Id id;
        @AuraEnabled public String name;
        @AuraEnabled public String hospitalName;
        @AuraEnabled public String address;
        @AuraEnabled public String phone;
        @AuraEnabled public String website;
    }

    public class ScheduleSlot {
        @AuraEnabled public String dayOfWeek;
        @AuraEnabled public String startTime;
        @AuraEnabled public String endTime;
    }

    public class RegistrationRequest {
        @AuraEnabled public String firstName;
        @AuraEnabled public String lastName;
        @AuraEnabled public String email;
        @AuraEnabled public String phone;
        @AuraEnabled public String street;
        @AuraEnabled public String city;
        @AuraEnabled public String state;
        @AuraEnabled public String country;
        @AuraEnabled public String postalCode;
        @AuraEnabled public String company;
    }

    public class PatientSummary {
        @AuraEnabled public Id id;
        @AuraEnabled public String name;
        @AuraEnabled public String email;
        @AuraEnabled public String phone;
        @AuraEnabled public String city;
        @AuraEnabled public String state;
    }

    public class AppointmentDashboard {
        @AuraEnabled public List<AppointmentCard> upcoming;
        @AuraEnabled public List<AppointmentCard> history;
    }

    public class AppointmentCard {
        @AuraEnabled public Id id;
        @AuraEnabled public String appointmentNumber;
        @AuraEnabled public String status;
        @AuraEnabled public String mode;
        @AuraEnabled public String workType;
        @AuraEnabled public String branchName;
        @AuraEnabled public String zoomLink;
        @AuraEnabled public DateTime startDateTime;
        @AuraEnabled public DateTime endDateTime;
        @AuraEnabled public String displayDate;
    }
}
