public with sharing class DoctorAppointmentDashboardApex {
    public class PractitionerContext {
        @AuraEnabled public String practitionerId;
        @AuraEnabled public String practitionerName;
        @AuraEnabled public String doctorEmail;
        @AuraEnabled public Boolean found;
    }

    public class ClinicalUpdateResult {
        @AuraEnabled public Boolean success;
        @AuraEnabled public Integer recordsCreated;
        @AuraEnabled public String patientId;
        @AuraEnabled public String patientName;
        @AuraEnabled public String warningMessage;
    }

    @AuraEnabled
    public static PractitionerContext getLoggedInPractitionerContext() {
        PractitionerContext context = new PractitionerContext();
        context.found = false;

        List<HealthcareProvider> providers = [
            SELECT PractitionerId, Practitioner.Name, User__r.Email
            FROM HealthcareProvider
            WHERE User__c = :UserInfo.getUserId()
            AND PractitionerId != null
            LIMIT 1
        ];

        if (!providers.isEmpty()) {
            context.practitionerId = providers[0].PractitionerId;
            context.practitionerName = providers[0].Practitioner != null ? providers[0].Practitioner.Name : null;
            context.doctorEmail = providers[0].User__r != null ? providers[0].User__r.Email : null;
            context.found = true;
        }

        return context;
    }

    @AuraEnabled
    public static PractitionerContext getPractitionerContextByEmail(String emailAddress) {
        PractitionerContext context = new PractitionerContext();
        context.found = false;

        if (String.isBlank(emailAddress)) {
            return context;
        }

        emailAddress = emailAddress.trim();

        List<HealthcareProvider> providers = [
            SELECT PractitionerId, Practitioner.Name, Practitioner.Email, User__r.Email
            FROM HealthcareProvider
            WHERE PractitionerId != null
            AND (User__r.Email = :emailAddress OR Practitioner.Email = :emailAddress)
            LIMIT 1
        ];

        if (!providers.isEmpty()) {
            context.practitionerId = providers[0].PractitionerId;
            context.practitionerName = providers[0].Practitioner != null ? providers[0].Practitioner.Name : null;
            if (providers[0].User__r != null && !String.isBlank(providers[0].User__r.Email)) {
                context.doctorEmail = providers[0].User__r.Email;
            } else if (providers[0].Practitioner != null) {
                context.doctorEmail = providers[0].Practitioner.Email;
            } else {
                context.doctorEmail = emailAddress;
            }
            context.found = true;
        }

        return context;
    }

    @AuraEnabled
    public static Boolean sendDoctorOtpToLoggedInUser(String otp) {
        if (String.isBlank(otp)) {
            return false;
        }

        User currentUser = [
            SELECT Id, Email, Name
            FROM User
            WHERE Id = :UserInfo.getUserId()
            LIMIT 1
        ];

        if (String.isBlank(currentUser.Email)) {
            return false;
        }

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] { currentUser.Email });
        mail.setSenderDisplayName('Salesforce Support');
        mail.setSubject('Doctor Dashboard Verification Code');
        mail.setBccSender(false);
        mail.setUseSignature(true);
        mail.setHtmlBody('Hello ' + currentUser.Name + ',<br/><br/>Your doctor dashboard verification code is <b>' + otp + '</b>.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        return true;
    }

    @AuraEnabled
    public static Boolean sendDoctorOtpByEmail(String emailAddress, String doctorName, String otp) {
        if (String.isBlank(emailAddress) || String.isBlank(otp)) {
            return false;
        }

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] { emailAddress.trim() });
        mail.setSenderDisplayName('Salesforce Support');
        mail.setSubject('Doctor Dashboard Verification Code');
        mail.setBccSender(false);
        mail.setUseSignature(true);
        mail.setHtmlBody('Hello ' + (String.isBlank(doctorName) ? 'Doctor' : doctorName) + ',<br/><br/>Your doctor dashboard verification code is <b>' + otp + '</b>.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        return true;
    }

    @AuraEnabled
    public static DoctorAppointmentController.AppointmentReminderResult sendAppointmentReminder(String serviceAppointmentId) {
        return DoctorAppointmentController.sendAppointmentReminder(serviceAppointmentId);
    }

    @AuraEnabled
    public static DoctorAppointmentController.AppointmentReminderResult sendAppointmentCompletion(String serviceAppointmentId) {
        return DoctorAppointmentController.sendAppointmentCompletion(serviceAppointmentId);
    }

    @AuraEnabled
    public static ClinicalUpdateResult saveClinicalUpdate(
        String serviceAppointmentId,
        String clinicalPayloadJson
    ) {
        if (String.isBlank(serviceAppointmentId)) {
            throw new AuraHandledException('Appointment id is required.');
        }
        if (String.isBlank(clinicalPayloadJson)) {
            throw new AuraHandledException('Clinical update details are required.');
        }

        Map<String, Object> payload = (Map<String, Object>) JSON.deserializeUntyped(clinicalPayloadJson);
        String encounterType = payload.containsKey('encounterType') ? String.valueOf(payload.get('encounterType')) : null;
        String encounterSummary = payload.containsKey('encounterSummary') ? String.valueOf(payload.get('encounterSummary')) : null;
        String allergyName = payload.containsKey('allergyName') ? String.valueOf(payload.get('allergyName')) : null;
        String allergySeverity = payload.containsKey('allergySeverity') ? String.valueOf(payload.get('allergySeverity')) : null;
        String conditionName = payload.containsKey('conditionName') ? String.valueOf(payload.get('conditionName')) : null;
        String conditionSeverity = payload.containsKey('conditionSeverity') ? String.valueOf(payload.get('conditionSeverity')) : null;
        String medicationName = payload.containsKey('medicationName') ? String.valueOf(payload.get('medicationName')) : null;
        String immunizationName = payload.containsKey('immunizationName') ? String.valueOf(payload.get('immunizationName')) : null;
        String procedureName = payload.containsKey('procedureName') ? String.valueOf(payload.get('procedureName')) : null;
        String carePlanSubject = payload.containsKey('carePlanSubject') ? String.valueOf(payload.get('carePlanSubject')) : null;
        String carePlanNotes = payload.containsKey('carePlanNotes') ? String.valueOf(payload.get('carePlanNotes')) : null;
        Date immunizationDate = null;
        if (payload.containsKey('immunizationDate') && payload.get('immunizationDate') != null && String.isNotBlank(String.valueOf(payload.get('immunizationDate')))) {
            immunizationDate = Date.valueOf(String.valueOf(payload.get('immunizationDate')));
        }

        ServiceAppointment appointment = [
            SELECT Id, AccountId, Account.Name, SchedStartTime
            FROM ServiceAppointment
            WHERE Id = :serviceAppointmentId
            LIMIT 1
        ];

        if (appointment.AccountId == null) {
            throw new AuraHandledException('No patient is linked to this appointment.');
        }

        try {
            Integer createdCount = 0;
            List<String> warnings = new List<String>();

            if (String.isNotBlank(allergyName)) {
                insert new AllergyIntolerance(
                    PatientId = appointment.AccountId,
                    Status = 'Active',
                    Type = 'Allergy',
                    Category = 'Medication',
                    Severity = String.isBlank(allergySeverity) ? 'Moderate' : allergySeverity
                );
                createdCount++;
            }

            if (String.isNotBlank(conditionName)) {
                Id conditionCodeId = ensureCodeSetBundle(conditionName.trim());
                if (conditionCodeId != null) {
                    HealthCondition condition = new HealthCondition();
                    condition.PatientId = appointment.AccountId;
                    condition.ConditionCodeId = conditionCodeId;
                    condition.ConditionStatus = 'Active';
                    condition.DiagnosticStatus = 'Confirmed';
                    condition.Severity = String.isBlank(conditionSeverity) ? 'Moderate' : conditionSeverity;
                    insert condition;
                    createdCount++;
                } else {
                    warnings.add('Health condition code not found for "' + conditionName + '"');
                }
            }

            if (String.isNotBlank(medicationName)) {
                Id medicationId = ensureMedication(medicationName.trim());
                MedicationRequest medicationRequest = new MedicationRequest();
                medicationRequest.PatientId = appointment.AccountId;
                medicationRequest.MedicationId = medicationId;
                medicationRequest.Status = 'Active';
                medicationRequest.Type = 'Order';
                insert medicationRequest;
                createdCount++;
            }

            if (String.isNotBlank(encounterSummary) || String.isNotBlank(encounterType)) {
                ClinicalEncounter encounter = new ClinicalEncounter();
                encounter.PatientId = appointment.AccountId;
                Datetime encounterStartDate = appointment.SchedStartTime != null ? appointment.SchedStartTime : System.now();
                if (encounterStartDate > System.now()) {
                    encounterStartDate = System.now();
                }
                encounter.StartDate = encounterStartDate;
                encounter.Category = 'Follow-up';
                encounter.Status = 'Finished';
                if (String.isNotBlank(encounterType)) {
                    Id encounterTypeId = ensureCodeSetBundle(encounterType.trim());
                    if (encounterTypeId != null) {
                        encounter.TypeId = encounterTypeId;
                    } else {
                        warnings.add('Encounter type code not found for "' + encounterType + '"');
                    }
                }
                insert encounter;
                createdCount++;
            }

            if (String.isNotBlank(immunizationName)) {
                Id vaccineCodeId = ensureCodeSetBundle(immunizationName.trim());
                if (vaccineCodeId != null) {
                    PatientImmunization immunization = new PatientImmunization();
                    immunization.PatientId = appointment.AccountId;
                    immunization.VaccineCodeId = vaccineCodeId;
                    immunization.VaccinationDate = immunizationDate == null ? Date.today() : immunizationDate;
                    immunization.Status = 'Completed';
                    insert immunization;
                    createdCount++;
                } else {
                    warnings.add('Immunization code not found for "' + immunizationName + '"');
                }
            }

            if (String.isNotBlank(procedureName)) {
                Id procedureCodeId = ensureCodeSetBundle(procedureName.trim());
                if (procedureCodeId != null) {
                    PatientMedicalProcedure procedureRecord = new PatientMedicalProcedure();
                    procedureRecord.PatientId = appointment.AccountId;
                    procedureRecord.CodeId = procedureCodeId;
                    procedureRecord.Status = 'Completed';
                    insert procedureRecord;
                    createdCount++;
                } else {
                    warnings.add('Procedure code not found for "' + procedureName + '"');
                }
            }

            if (String.isNotBlank(carePlanSubject) || String.isNotBlank(carePlanNotes)) {
                Case carePlan = new Case();
                carePlan.AccountId = appointment.AccountId;
                carePlan.Subject = String.isBlank(carePlanSubject) ? 'Doctor care plan update' : carePlanSubject.trim();
                carePlan.Description = carePlanNotes;
                carePlan.Status = 'New';
                insert carePlan;
                createdCount++;
            }

            if (createdCount == 0) {
                throw new AuraHandledException('Please enter at least one clinical update before saving.');
            }

            ClinicalUpdateResult result = new ClinicalUpdateResult();
            result.success = true;
            result.recordsCreated = createdCount;
            result.patientId = appointment.AccountId;
            result.patientName = appointment.Account != null ? appointment.Account.Name : null;
            result.warningMessage = warnings.isEmpty() ? null : String.join(warnings, '; ');
            return result;
        } catch (DmlException ex) {
            String message = 'Could not save clinical update.';
            if (ex.getNumDml() > 0) {
                message = ex.getDmlMessage(0);
            } else if (String.isNotBlank(ex.getMessage())) {
                message = ex.getMessage();
            }
            throw new AuraHandledException(message);
        }
    }
    
    @AuraEnabled
    public static List<CarePractnFacilityAppt> fetchContact(String conId,String status){
        List<CarePractnFacilityAppt>  createfac=new List<CarePractnFacilityAppt>();
        if(conId !=null && status !=null){
            if (status == 'Completed') {
                createfac =[
                    select HealthcarePractitionerFacility.Account.Name,
                           HealthcarePractitionerFacility.Practitioner.Name,
                           ServiceAppointment.Account.Name,
                           ServiceAppointment.AppointmentNumber,
                           ServiceAppointmentId,
                           ServiceAppointment.Status,
                           ServiceAppointment.DueDate,
                           ServiceAppointment.WorkType.name,
                           ServiceAppointment.SchedStartTime,
                           ServiceAppointment.LastModifiedDate
                    from CarePractnFacilityAppt
                    where HealthcarePractitionerFacility.PractitionerId =:conId
                    AND ServiceAppointment.Status=:status
                    WITH SECURITY_ENFORCED
                    ORDER BY ServiceAppointment.LastModifiedDate DESC, ServiceAppointment.SchedStartTime DESC
                ];
            } else {
                createfac =[
                    select HealthcarePractitionerFacility.Account.Name,
                           HealthcarePractitionerFacility.Practitioner.Name,
                           ServiceAppointment.Account.Name,
                           ServiceAppointment.AppointmentNumber,
                           ServiceAppointmentId,
                           ServiceAppointment.Status,
                           ServiceAppointment.DueDate,
                           ServiceAppointment.WorkType.name,
                           ServiceAppointment.SchedStartTime
                    from CarePractnFacilityAppt
                    where HealthcarePractitionerFacility.PractitionerId =:conId
                    AND ServiceAppointment.Status=:status
                    WITH SECURITY_ENFORCED
                    ORDER BY ServiceAppointment.SchedStartTime DESC
                ];
            }
        }
        return createfac;
    }
    
   @AuraEnabled
    public static ServiceAppointment updateCancel(String serviceAppointmentIds){
        ServiceAppointment updateapp=new ServiceAppointment();
         updateapp=[SELECT Id,Status FROM ServiceAppointment WHERE Id=:serviceAppointmentIds];
        if(updateapp.Status == 'Scheduled'){
            updateapp.Status ='Canceled';
        }
        if (ServiceAppointment.SObjectType.getDescribe().isAccessible() && Schema.sObjectType.ServiceAppointment.fields.Status.isUpdateable()) {
            update updateapp;
        }
       return updateapp;
    }

    @AuraEnabled
    public static ServiceAppointment updateAppointmentStatus(String serviceAppointmentId, String newStatus){
        if (String.isBlank(serviceAppointmentId) || String.isBlank(newStatus)) {
            throw new AuraHandledException('Appointment id and status are required.');
        }

        ServiceAppointment updateApp = [
            SELECT Id, Status
            FROM ServiceAppointment
            WHERE Id = :serviceAppointmentId
        ];

        if (updateApp.Status == newStatus) {
            return updateApp;
        }

        updateApp.Status = newStatus;
        try {
            update updateApp;
        } catch (DmlException ex) {
            String errorMessage = 'Could not update appointment status.';
            if (ex.getNumDml() > 0) {
                errorMessage = ex.getDmlMessage(0);
            } else if (String.isNotBlank(ex.getMessage())) {
                errorMessage = ex.getMessage();
            }
            throw new AuraHandledException(errorMessage);
        }
        return updateApp;
    }
    
    @AuraEnabled
    public static List<CarePractnFacilityAppt> fetchContactByDate(String selectedCon,DateTime selectedDate,String status){
        DateTime endTime=selectedDate.addHours(23);
        List<CarePractnFacilityAppt> createfaces=new List<CarePractnFacilityAppt>();
        try{
            if (status == 'Completed') {
                createfaces =[
                    select HealthcarePractitionerFacility.Account.Name,
                           HealthcarePractitionerFacility.Practitioner.Name,
                           ServiceAppointment.Account.Name,
                           ServiceAppointment.AppointmentNumber,
                           ServiceAppointmentId,
                           ServiceAppointment.SchedStartTime,
                           ServiceAppointment.Status,
                           ServiceAppointment.DueDate,
                           ServiceAppointment.WorkType.name,
                           ServiceAppointment.LastModifiedDate
                    from CarePractnFacilityAppt
                    WHERE HealthcarePractitionerFacility.PractitionerId=:selectedCon
                    AND ServiceAppointment.SchedStartTime>=:selectedDate
                    AND ServiceAppointment.SchedEndTime<=:endTime
                    AND ServiceAppointment.Status=:status
                    WITH SECURITY_ENFORCED
                    ORDER BY ServiceAppointment.LastModifiedDate DESC, ServiceAppointment.SchedStartTime DESC
                ];
            } else {
                createfaces =[
                    select HealthcarePractitionerFacility.Account.Name,
                           HealthcarePractitionerFacility.Practitioner.Name,
                           ServiceAppointment.Account.Name,
                           ServiceAppointment.AppointmentNumber,
                           ServiceAppointmentId,
                           ServiceAppointment.SchedStartTime,
                           ServiceAppointment.Status,
                           ServiceAppointment.DueDate,
                           ServiceAppointment.WorkType.name
                    from CarePractnFacilityAppt
                    WHERE HealthcarePractitionerFacility.PractitionerId=:selectedCon
                    AND ServiceAppointment.SchedStartTime>=:selectedDate
                    AND ServiceAppointment.SchedEndTime<=:endTime
                    AND ServiceAppointment.Status=:status
                    WITH SECURITY_ENFORCED
                    ORDER BY ServiceAppointment.SchedStartTime DESC
                ];
            }
        }
         catch(Exception e){
             System.debug('Exception>>'+ e);
        }
            return createfaces;
    }
    
    @AuraEnabled
    public static List<ServiceAppointment> cancelRecord(List<CarePractnFacilityAppt> cancelIds) {
        list<string> receverIds = new list<string>();
        for(CarePractnFacilityAppt a:cancelIds){
            receverIds.add(a.ServiceAppointmentId);
        }
        List<ServiceAppointment> delacccon=new List<ServiceAppointment>();
        try{
        delacccon =[SELECT Id,Status FROM ServiceAppointment WHERE Id IN : receverIds WITH SECURITY_ENFORCED];
        system.debug('delacccon>>'+delacccon);
       if(delacccon.size() > 0){
           system.debug('size>>'+delacccon.size());
           for(ServiceAppointment app:delacccon){
               if(app.Status=='Scheduled'){
                   app.Status='Canceled';
               }
           }
          update delacccon;
        }
        }
         catch(Exception e){
             System.debug('Exception>>'+ e);
        }
        return delacccon;
    }

    private static Id ensureCodeSetBundle(String recordName) {
        if (String.isBlank(recordName)) {
            return null;
        }

        String likeValue = '%' + recordName + '%';
        List<CodeSetBundle> existingCodes = [
            SELECT Id, Name
            FROM CodeSetBundle
            WHERE Name = :recordName
            OR Name LIKE :likeValue
            LIMIT 1
        ];
        if (!existingCodes.isEmpty()) {
            return existingCodes[0].Id;
        }
        return null;
    }

    private static Id ensureMedication(String medicationName) {
        if (String.isBlank(medicationName)) {
            return null;
        }

        List<Medication> existingMedications = [
            SELECT Id, Name
            FROM Medication
            WHERE Name = :medicationName
            LIMIT 1
        ];
        if (!existingMedications.isEmpty()) {
            return existingMedications[0].Id;
        }

        Medication medication = new Medication();
        medication.Name = medicationName;
        insert medication;
        return medication.Id;
    }
}
