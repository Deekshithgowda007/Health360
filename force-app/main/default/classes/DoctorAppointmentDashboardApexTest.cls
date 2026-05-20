@isTest
public class DoctorAppointmentDashboardApexTest{
    @isTest
    static void getLoggedInPractitionerContextTest(){
        Contact con = new Contact(LastName = 'Doctor User', Email = 'doctor.contact@example.com');
        insert con;

        Profile pro = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        User u = new User(
            alias = 'drctx',
            email='doctor.context@example.com',
            emailencodingkey='UTF-8',
            lastname='Doctor User',
            languagelocalekey='en_US',
            localesidkey='en_US',
            profileId = pro.Id,
            timezonesidkey='America/Los_Angeles',
            username='doctor.context.' + System.now().getTime() + '@example.com',
            isActive = true
        );
        insert u;

        insert new HealthcareProvider(
            Name = 'Doctor Provider Context',
            User__c = u.Id,
            PractitionerId = con.Id,
            SourceSystemIdentifier = 'ctx-' + System.now().getTime()
        );

        System.runAs(u){
            Test.startTest();
            DoctorAppointmentDashboardApex.PractitionerContext context = DoctorAppointmentDashboardApex.getLoggedInPractitionerContext();
            Test.stopTest();

            System.assertEquals(true, context.found, 'The logged in doctor should resolve.');
            System.assertEquals(con.Id, context.practitionerId, 'The practitioner id should match the mapped contact.');
        }
    }

    @isTest
    static void getPractitionerContextByEmailTest(){
        Contact con = new Contact(
            LastName = 'Email Doctor',
            Email = 'email.doctor@example.com'
        );
        insert con;

        insert new HealthcareProvider(
            Name = 'Doctor Provider Email',
            PractitionerId = con.Id,
            SourceSystemIdentifier = 'email-' + System.now().getTime()
        );

        Test.startTest();
        DoctorAppointmentDashboardApex.PractitionerContext context =
            DoctorAppointmentDashboardApex.getPractitionerContextByEmail('email.doctor@example.com');
        Test.stopTest();

        System.assertEquals(true, context.found, 'The doctor email should resolve through a healthcare provider mapping.');
        System.assertEquals(con.Id, context.practitionerId, 'The practitioner id should match the doctor contact.');
        System.assertEquals('email.doctor@example.com', context.doctorEmail, 'The doctor email should be returned.');
    }

    @isTest 
    static void fetchContactTest(){
        contact con =new contact();
        con.LastName='sathish';
        insert con;

        String conId=con.id;
        String status='closed';
        system.assertEquals(con.LastName,'sathish','success');
        Test.startTest();
        DoctorAppointmentDashboardApex.fetchContact(conId,status);
        System.assert(true,con.LastName);
        Test.stopTest();
    }
    @isTest static void updateCancelTest(){
        Account acc=new Account();
        acc.Name='Bill Stellar';
        insert acc;

        ServiceAppointment s=new ServiceAppointment();
        s.Status ='Scheduled';
        s.ParentRecordId=acc.Id;
        insert s;
        s=[SELECT Id,Status FROM ServiceAppointment WHERE Id=:s.Id];
       
        update s;

        system.assertEquals(s.status,'Scheduled','success');
        Test.startTest();
       DoctorAppointmentDashboardApex.updateCancel(s.Id);
        Test.stopTest();
    }

    @isTest
    static void updateAppointmentStatusTest(){
        Account acc = new Account(Name='Status Update Patient');
        insert acc;

        ServiceAppointment appointment = new ServiceAppointment();
        appointment.Status = 'Scheduled';
        appointment.ParentRecordId = acc.Id;
        insert appointment;

        Test.startTest();
        ServiceAppointment updated = DoctorAppointmentDashboardApex.updateAppointmentStatus(appointment.Id, 'Completed');
        Test.stopTest();

        System.assertEquals('Completed', updated.Status, 'The appointment should be updated to completed.');
    }

    @isTest
    static void sendAppointmentReminderProxyTest(){
        Account patient = new Account();
        patient.LastName = 'Dashboard Reminder Patient';
        patient.PersonEmail = 'dashboard.patient@example.com';
        patient.Phone = '9000000009';
        insert patient;

        Account facility = new Account(Name='Dashboard Reminder Facility');
        insert facility;

        Contact doctor = new Contact(
            LastName = 'Dashboard Reminder Doctor',
            Email = 'dashboard.doctor@example.com',
            AccountId = facility.Id
        );
        insert doctor;

        insert new HealthcarePractitionerFacility(
            Name = 'Dashboard Reminder Mapping',
            AccountId = facility.Id,
            PractitionerId = doctor.Id
        );

        ServiceAppointment appointment = new ServiceAppointment(
            AccountId = patient.Id,
            ParentRecordId = patient.Id,
            Status = 'Scheduled',
            AppointmentType = 'Visit Hospital',
            SchedStartTime = System.now().addDays(2),
            SchedEndTime = System.now().addDays(2).addHours(1)
        );
        insert appointment;

        HealthcarePractitionerFacility mapping = [
            SELECT Id
            FROM HealthcarePractitionerFacility
            WHERE AccountId = :facility.Id AND PractitionerId = :doctor.Id
            LIMIT 1
        ];

        insert new CarePractnFacilityAppt(
            Name = 'Dashboard Reminder Care Mapping',
            HealthcarePractitionerFacilityId = mapping.Id,
            ServiceAppointmentId = appointment.Id
        );

        Test.startTest();
        DoctorAppointmentController.AppointmentReminderResult result =
            DoctorAppointmentDashboardApex.sendAppointmentReminder(appointment.Id);
        Test.stopTest();

        System.assertEquals(true, result.patientReminderSent, 'Patient reminder should be sent through the dashboard proxy.');
        System.assertEquals(true, result.doctorReminderSent, 'Doctor reminder should be sent through the dashboard proxy.');
    }
    @isTest static void fetchContactByDateTest(){
        Contact c=new Contact();
        c.LastName='Test';
        insert c;
        String selectedCon=c.Id;
        DateTime selectedDate=System.today();
        String status='Closed';

        system.assertEquals(c.LastName,'Test','success');
        Test.startTest();
        DoctorAppointmentDashboardApex.fetchContactByDate(selectedCon,selectedDate,status);
        Test.stopTest();
    }
    @isTest static void cancelRecordTest(){
        Account acc=new Account();
        acc.Name='Billdf';
        insert acc;
        ServiceAppointment a=new ServiceAppointment();
        a.Status ='Scheduled';
        a.ParentRecordId=acc.Id;
        insert a;
        CarePractnFacilityAppt cpf=new CarePractnFacilityAppt();
        cpf.ServiceAppointmentId=a.Id;
        List<CarePractnFacilityAppt> cancelIds=new  List<CarePractnFacilityAppt>();
        cancelIds.add(cpf);

        system.assertEquals(a.status,'Scheduled','success');
        Test.startTest();
        DoctorAppointmentDashboardApex.cancelRecord(cancelIds);
        Test.stopTest();
    }
}
