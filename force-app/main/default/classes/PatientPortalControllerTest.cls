@IsTest
private class PatientPortalControllerTest {
    @IsTest
    static void portalDiscoveryAndAppointmentsWork() {
        Account hospital = new Account(Name = 'Apollo Group');
        insert hospital;

        Account branch = new Account(
            Name = 'Apollo Bangalore',
            ParentId = hospital.Id,
            ShippingCity = 'Bangalore',
            ShippingCountry = 'India'
        );
        insert branch;

        Contact doctor = new Contact(
            LastName = 'Mehta',
            AccountId = branch.Id,
            Overview__c = 'Senior consultant',
            Area_of_Expertise__c = 'Cardiology, Diabetes',
            Awards_and_Regonitions__c = 'Best Doctor',
            Available_Appointment_Type__c = 'Virtual'
        );
        insert doctor;

        CareSpecialty specialty = new CareSpecialty(Name = 'Cardiology');
        insert specialty;

        HealthcareProviderSpecialty providerSpecialty = new HealthcareProviderSpecialty(
            Name = 'Apollo Cardiology Mapping',
            AccountId = branch.Id,
            PractitionerId = doctor.Id,
            SpecialtyId = specialty.Id
        );
        insert providerSpecialty;

        Account patient = new Account(
            LastName = 'Patient',
            PersonEmail = 'portal.patient@example.com',
            Phone = '9876543210'
        );
        insert patient;

        ServiceAppointment appointment = new ServiceAppointment(
            ParentRecordId = patient.Id,
            Status = 'Scheduled'
        );
        insert appointment;

        Test.startTest();
        List<PatientPortalController.HospitalOption> hospitals = PatientPortalController.getHospitals();
        List<PatientPortalController.BranchOption> branches = PatientPortalController.getBranches(hospital.Id);
        List<PatientPortalController.SpecialtyOption> specialties = PatientPortalController.getSpecialties(hospital.Id, branch.Id);
        List<PatientPortalController.DoctorCard> doctors = PatientPortalController.getDoctors(hospital.Id, branch.Id, specialty.Id, 'Mehta', 'recommended');
        PatientPortalController.DoctorDetail detail = PatientPortalController.getDoctorDetail(doctor.Id, branch.Id);
        PatientPortalController.PatientSummary patientSummary = PatientPortalController.lookupPatient('portal.patient@example.com');
        PatientPortalController.AppointmentDashboard dashboard = PatientPortalController.getPatientAppointments(patient.Id);
        Test.stopTest();

        System.assert(!hospitals.isEmpty(), 'Hospitals should be returned.');
        System.assertEquals(branch.Id, branches[0].id, 'Expected branch should be returned.');
        System.assertEquals(specialty.Id, specialties[0].id, 'Expected specialty should be returned.');
        System.assertEquals(doctor.Id, doctors[0].doctorId, 'Expected doctor should be returned.');
        System.assertNotEquals(null, detail, 'Doctor detail should load.');
        System.assertEquals(patient.Id, patientSummary.id, 'Patient lookup should return the patient.');
        System.assertEquals(1, dashboard.upcoming.size(), 'Upcoming appointments should contain the created appointment.');
    }
}
