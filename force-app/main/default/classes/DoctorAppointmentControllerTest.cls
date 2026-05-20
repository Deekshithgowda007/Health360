@IsTest 
public class DoctorAppointmentControllerTest {
    
    @istest
    static void fetchAcctsTest(){ 
        Account acc=new Account();
        acc.Name='Apollo  Hospital';
        insert acc;
        List<Contact> accList = new List<Contact>();
        Contact con=new Contact();
        con.LastName='Practitioner';
        con.AccountId=acc.Id;
        insert con;
        system.assertEquals(con.LastName,'Practitioner','success');
        DoctorAppointmentController.fetchAccts(con.Id);  
    }
    
    @istest
    static void sendotptest(){
        Account acc=new Account();
        acc.LastName='Stellar';
        acc.PersonEmail='deekshithgowda977@gmail.com';
        insert acc;
        system.assertEquals(acc.LastName,'Stellar','success');
        SelectRecord.getRecord(acc.Id,'PersonEmail') ;      
        DoctorAppointmentController.sendOTP(acc.Id, '1234');
        DoctorAppointmentController.sendOTPs(acc.Id, '1234');
    }
    
    @istest
    static void sendotptest1(){
        Account acc=new Account();
        acc.LastName='Stellar';
        acc.PersonEmail='';
        insert acc;
        system.assertEquals(acc.LastName,'Stellar','success');
        DoctorAppointmentController.sendOTP(acc.Id, '1234');
        DoctorAppointmentController.sendOTPs(acc.Id, '1234');
    }
    
    @istest
    static void sendotpstests(){
        Account acc=new Account();
        acc.Name='Bi';
        acc.Phone='9880878007';
        insert acc;
        system.assertEquals(acc.Name,'Bi','success');
        DoctorAppointmentController.sendOTPs(acc.Id, '1345');  
    }
    
    @istest
    static void subspecialityDoctorstest(){  
        List<HealthcareProviderTaxonomy> licont=new List<HealthcareProviderTaxonomy>();
        HealthcareProviderTaxonomy health=new HealthcareProviderTaxonomy();
        health.Name='dental';
        insert health;
         system.assertEquals(health.Name,'dental','success');
        DoctorAppointmentController.subspecialityDoctors(health.Id);
    }
    

    @istest 
    static void getRequiredSpecialityByHospiatalstest(){
        Account accn=new Account();
        accn.Name='Apollo  Hospital';
        insert accn;
        List<Contact> accList = new List<Contact>();
        Contact cont=new Contact();
        cont.LastName='Practitioner';
        cont.AccountId=accn.Id;
        insert cont;
        List<HealthcareProviderSpecialty> sp=new  List<HealthcareProviderSpecialty>();       
        HealthcareProviderSpecialty spe=new HealthcareProviderSpecialty();        
        spe.Name='Gayathri Practitioner Facility';
        insert spe;
        system.assertEquals(cont.LastName,'Practitioner','success');
        DoctorAppointmentController.getRequiredSpecialityByHospiatals(accn.Id);  
    }
    
    @istest
    static void fetchHospitalByDoctorIdtest(){
        Account ac=new Account();
        ac.Name='tellar';
        insert ac;
        List<Contact>   getAccountId=new  List<Contact>();
        Contact cont=new Contact();
        cont.LastName='Satish';
        insert cont;
         system.assertEquals(cont.LastName,'Satish','success');
        DoctorAppointmentController.fetchHospitalByDoctorId(cont.Id);   
    }
    
    @istest
    static void getSpecialityHospiatalByDoctorstest(){
        Account acnts=new Account();
        acnts.Name='John';
        insert acnts;
        List<Contact>   getAccoun=new  List<Contact>();
        Contact cntcs=new Contact();
        cntcs.LastName='Satish';
        insert cntcs;
        HealthcareProviderSpecialty doc=new HealthcareProviderSpecialty();
        doc.Name='Gayathri Practitioner Facility';
        doc.PractitionerId=cntcs.Id;
        doc.AccountId=acnts.Id;
        //doc.SpecialtyId=acnts.Id;
        insert doc;
        system.assertEquals(cntcs.LastName,'Satish','success');
        DoctorAppointmentController.getSpecialityHospiatalByDoctors(acnts.Id, cntcs.Id);
    }
    
    @istest
    static void getPatienttest(){  
        Account act=new Account();
        act.LastName='Stellar';
        act.Phone='9880778007';
        act.PersonEmail='deekshithgowda977@gmail.com';
        insert act;
        system.assertEquals(act.LastName,'Stellar','success');
        DoctorAppointmentController.getPatient(act.PersonEmail);
    }
    
    @istest
    static void getPatienttests(){
        Account act=new Account();
        act.LastName='Stellar';
        act.Phone='9880778007';
        act.PersonEmail='deekshithgowda977@gmail.com';
        insert act;
        system.assertEquals(act.LastName,'Stellar','success');
        DoctorAppointmentController.getPatient(act.Phone);
    }

    @isTest
    static void sendAppointmentReminderTest(){
        Account patient = new Account();
        patient.LastName = 'Reminder Patient';
        patient.PersonEmail = 'patient.reminder@example.com';
        patient.Phone = '9999999999';
        insert patient;

        Account facility = new Account(Name = 'Apollo Reminder Facility');
        insert facility;

        Contact doctor = new Contact(
            LastName = 'Reminder Doctor',
            Email = 'doctor.reminder@example.com',
            AccountId = facility.Id
        );
        insert doctor;

        HealthcarePractitionerFacility practitionerFacility = new HealthcarePractitionerFacility(
            Name = 'Reminder Facility Mapping',
            AccountId = facility.Id,
            PractitionerId = doctor.Id
        );
        insert practitionerFacility;

        ServiceAppointment appointment = new ServiceAppointment();
        appointment.AccountId = patient.Id;
        appointment.ParentRecordId = patient.Id;
        appointment.Status = 'Scheduled';
        appointment.AppointmentType = 'Visit Hospital';
        appointment.SchedStartTime = System.now().addDays(1);
        appointment.SchedEndTime = System.now().addDays(1).addHours(1);
        insert appointment;

        insert new CarePractnFacilityAppt(
            Name = 'Reminder Mapping',
            HealthcarePractitionerFacilityId = practitionerFacility.Id,
            ServiceAppointmentId = appointment.Id
        );

        Test.startTest();
        DoctorAppointmentController.AppointmentReminderResult result =
            DoctorAppointmentController.sendAppointmentReminder(appointment.Id);
        Test.stopTest();

        System.assertEquals(true, result.patientReminderSent, 'Patient reminder should be sent when patient email is present.');
        System.assertEquals(true, result.doctorReminderSent, 'Doctor reminder should be sent when doctor email is present.');
    }
    
    @istest
    static void fetchHospitalByHospitalstest(){
        Account acnte=new Account();
        acnte.Name='John';
        insert acnte;
        Contact cntc=new Contact();
        cntc.LastName='Satish';
        cntc.AccountId=acnte.id;        
        insert cntc;
        HealthcareProviderSpecialty newSpecialty = new HealthcareProviderSpecialty();
        newSpecialty.Name='DentalCare Specialty';
        newSpecialty.PractitionerId=cntc.Id;
        newSpecialty.AccountId=acnte.Id;
        insert newSpecialty;
        HealthcarePractitionerFacility hlth = new HealthcarePractitionerFacility();
        hlth.Name='specialty';
        hlth.PractitionerId=cntc.Id;
        hlth.AccountId=acnte.Id;
        insert hlth;
        
        system.assertEquals(cntc.LastName,'Satish','success');
        DoctorAppointmentController.getTimeSlots(cntc.Id,acnte.Id);
        DoctorAppointmentController.fetchSpecialityHospiatalByDoctor(cntc.Id,acnte.Id);
        DoctorAppointmentController.fetchHospitalByHospitals(acnte.Id); 
    }
    
    @istest
    static void getHospitalsByCareSpecialitytest(){
        List<HealthcareProviderSpecialty> providerspec=new  List<HealthcareProviderSpecialty>();
        HealthcareProviderSpecialty specia=new HealthcareProviderSpecialty();
        specia.Name='Gayathri Practitioner Facility';
        specia.SpecialtyId=specia.Id;
        insert specia;
        system.assertEquals(specia.Name,'Gayathri Practitioner Facility','success');
        DoctorAppointmentController.getHospitalsByCareSpeciality(specia.Id);
    }
    @istest
    static void createLeadtest(){
        Lead leading=new Lead();
        leading.Email='smith@reply.com';
        leading.LastName='smith';
        leading.Phone='8765482138';
        insert leading;
        
        Lead leadings=new Lead();
        leadings.LastName='smith';
        leadings.Email='smith@noreply.com';
        leadings.Phone='8765432132';
        insert leadings;
        system.assertEquals(leadings.LastName,'smith','success');
        DoctorAppointmentController.createLead(leadings);
                
    }
    
    @istest
    static void createLeadtest1(){
        Lead leading=new Lead();
        leading.Email='ramesh@reply.com';
        leading.LastName='smithr';
        leading.Phone='8765482138';
        insert leading;
        
        Lead leadings=new Lead();
        leadings.LastName='smith';
        leadings.Email='smith@noreply.com';
        leadings.Phone='8765482138';
        insert leadings;
        system.assertEquals(leadings.LastName,'smith','success');
        DoctorAppointmentController.createLead(leadings);
                
    }
  
    @istest
    static void fetchDoctortest(){
        Account acn=new Account();
        acn.LastName='Stellar';
        insert acn;
        List<Contact>   locnt=new  List<Contact>();
        Contact conat=new Contact();
        conat.LastName='Practitioner';
        insert conat;
        List<HealthcareProviderSpecialty> getId = new  List<HealthcareProviderSpecialty>();
        HealthcareProviderSpecialty speciali=new HealthcareProviderSpecialty();
        speciali.Name='Gayathri Practitioner Facility';
        speciali.SpecialtyId=speciali.Id;
        speciali.AccountId=acn.Id;
        insert speciali;
        system.assertEquals(conat.LastName,'Practitioner','success');
        DoctorAppointmentController.fetchDoctor(speciali.Id, acn.Id,conat.id);        
    }
    
    @istest
    static void fetchDoctortest1(){
        Account acn=new Account();
        acn.LastName='Stellar';
        insert acn;
        List<Contact>   locnt=new  List<Contact>();
        Contact conat=new Contact();
        conat.LastName='Practitioner';
        insert conat;
        List<HealthcareProviderSpecialty> getId = new  List<HealthcareProviderSpecialty>();
        HealthcareProviderSpecialty speciali=new HealthcareProviderSpecialty();
        speciali.Name='Gayathri Practitioner Facility';
        speciali.SpecialtyId=speciali.Id;
        speciali.AccountId=acn.Id;
        insert speciali;
        system.assertEquals(conat.LastName,'Practitioner','success');
        DoctorAppointmentController.fetchDoctor(speciali.Id, acn.Id,null);
    }
    
    @istest
    static void createfacilitiestest(){
        Date myDate = date.newinstance(1960, 2, 17);
        Account acnte=new Account();
        acnte.LastName='Stellar';
        insert acnte;
        Contact cntc=new Contact();
        cntc.LastName='Satish';
        // cntc.AccountId=acnte.id;        
        insert cntc;
        OperatingHours hour=new OperatingHours();
        hour.Name='Weekly visit';
        insert hour;
        ServiceTerritory terr=new ServiceTerritory();
        terr.Name='SahakarNagar';
        terr.IsActive=true;
        terr.OperatingHoursId=hour.Id;
        insert terr;
        ServiceResource resource=new ServiceResource();
        resource.Name='Gayathri Sathish';
        resource.IsActive=true;
        resource.RelatedRecordId='0054x000006luXJAAY';
        insert resource;
        ServiceTerritoryMember mem=new ServiceTerritoryMember();
        mem.ServiceTerritoryId=terr.id;
        mem.OperatingHoursId=hour.Id;
        mem.ServiceResourceId=resource.Id;
        mem.EffectiveStartDate=myDate;
        insert mem;
        HealthcarePractitionerFacility health=new HealthcarePractitionerFacility();
        health.Name='Gayathri Practitioner Facility';
        health.AccountId=acnte.id;
        health.PractitionerId=cntc.id;
        health.IsActive=true;
        health.ServiceTerritoryMemberId=mem.Id;
        insert health;
        WorkType wrk=new WorkType();
        wrk.Name='Weekly visit';
        wrk.EstimatedDuration=1.00;
        insert wrk;
        WorkTypeGroup grp=new WorkTypeGroup();
        grp.Name='weekly visit';
        grp.IsActive=true;
        insert grp;
        ServiceTerritoryWorkType worktype=new ServiceTerritoryWorkType();
        worktype.ServiceTerritoryId=terr.id;
        worktype.WorkTypeId=wrk.Id;  
        insert worktype;
        WorkTypeGroupMember groupmember=new WorkTypeGroupMember();
        groupmember.WorkTypeId=wrk.id;
        groupmember.WorkTypeGroupId=grp.Id;
        insert groupmember;
        system.assertEquals(cntc.LastName,'Satish','success');
        test.startTest();
        DoctorAppointmentController.createfacilities(acnte.id,cntc.id);
        test.stopTest();
    }

    @istest
    static void createfacilitiesHandlesCombinedSelectionIds(){
        Date myDate = date.newinstance(1960, 2, 17);
        Account acnte=new Account();
        acnte.LastName='Portal';
        insert acnte;

        Contact cntc=new Contact();
        cntc.LastName='Doctor';
        insert cntc;

        OperatingHours hour=new OperatingHours(Name='Visit Hours');
        insert hour;

        ServiceTerritory terr=new ServiceTerritory();
        terr.Name='Portal Territory';
        terr.IsActive=true;
        terr.OperatingHoursId=hour.Id;
        insert terr;

        ServiceResource resource=new ServiceResource();
        resource.Name='Portal Resource';
        resource.IsActive=true;
        resource.RelatedRecordId='0054x000006luXJAAY';
        insert resource;

        ServiceTerritoryMember mem=new ServiceTerritoryMember();
        mem.ServiceTerritoryId=terr.id;
        mem.OperatingHoursId=hour.Id;
        mem.ServiceResourceId=resource.Id;
        mem.EffectiveStartDate=myDate;
        insert mem;

        insert new HealthcarePractitionerFacility(
            Name='Portal Facility',
            AccountId=acnte.id,
            PractitionerId=cntc.id,
            IsActive=true,
            ServiceTerritoryMemberId=mem.Id
        );

        WorkType wrk=new WorkType();
        wrk.Name='Visit Type';
        wrk.EstimatedDuration=1.00;
        insert wrk;

        WorkTypeGroup grp=new WorkTypeGroup();
        grp.Name='Visit Group';
        grp.IsActive=true;
        insert grp;

        insert new ServiceTerritoryWorkType(
            ServiceTerritoryId=terr.id,
            WorkTypeId=wrk.Id
        );

        insert new WorkTypeGroupMember(
            WorkTypeId=wrk.id,
            WorkTypeGroupId=grp.Id
        );

        Test.startTest();
        DoctorAppointmentController.TimePreview preview = DoctorAppointmentController.createfacilities(acnte.Id, acnte.Id + '|' + cntc.Id);
        List<TimeSlot> slots = DoctorAppointmentController.getTimeSlots(acnte.Id + '|' + cntc.Id, acnte.Id);
        Test.stopTest();

        System.assertNotEquals(null, preview.practitionerfacility, 'Combined selection ids should still resolve the practitioner facility.');
        System.assertEquals(cntc.Id, preview.practitionerfacility.PractitionerId, 'The doctor id should be parsed correctly from the combined value.');
        System.assertNotEquals(null, slots, 'Time slot lookup should safely return a list for combined ids.');
    }

    @istest
    static void createfacilitiesReturnsEmptyPreviewWhenNoFacilityExists(){
        Account acnte=new Account();
        acnte.LastName='Portal Empty';
        insert acnte;

        Contact cntc=new Contact();
        cntc.LastName='Doctor Empty';
        insert cntc;

        Test.startTest();
        DoctorAppointmentController.TimePreview preview = DoctorAppointmentController.createfacilities(acnte.Id, cntc.Id);
        List<TimeSlot> slots = DoctorAppointmentController.getTimeSlots(cntc.Id, acnte.Id);
        Test.stopTest();

        System.assertEquals(null, preview.practitionerfacility, 'Missing facility setup should not throw and should return an empty preview.');
        System.assertEquals(0, slots.size(), 'Missing facility setup should return an empty slot list.');
    }
    
    @istest
    static void fetchPersonAccountAppointmentstest(){
        Account acn=new Account();
        acn.LastName='Stellar';
        insert acn;
        CareSpecialty care = new CareSpecialty() ;
        care.Name='DentalCare Specialty';
        insert care;
        Contact conat=new Contact();
        conat.LastName='Practitioner';
        insert conat;
         Lead leading=new Lead();
        leading.Email='smith@noreply.comm';
        leading.LastName='smith';
        leading.Phone='8765432132';
        insert leading;
        ServiceAppointment serv = new ServiceAppointment();
        serv.ParentRecordId=acn.Id;
        serv.Status ='Completed & Cancelled';
        insert serv;
        HealthcareProviderSpecialty special=new HealthcareProviderSpecialty();
        special.Name='Denatal Care Speciality Saideep';
        insert special;
        system.assertEquals(conat.LastName,'Practitioner','success');
        // DoctorAppointmentController.fetchPersonAccountAppointments(acn.Id,'Completed & Cancelled',null);
        DoctorAppointmentController.getHospitalsByCareSpecialiyAndDoctor(special.Id,conat.Id);
    }
    
    @istest
    static void fetchPersonAccountAppointmentstest3(){
        Account acn=new Account();
        acn.LastName='Stellar';
        insert acn;
        CareSpecialty care = new CareSpecialty() ;
        care.Name='DentalCare Specialty';
        insert care;
        Contact conat=new Contact();
        conat.LastName='Practitioner';
        insert conat;
         Lead leading=new Lead();
        leading.Email='smith@noreply.comm';
        leading.LastName='smith';
        leading.Phone='8765432132';
        insert leading;
        ServiceAppointment serv = new ServiceAppointment();
        serv.ParentRecordId=acn.Id;
        serv.Status ='Completed & Cancelled';
        insert serv;
        HealthcareProviderSpecialty special=new HealthcareProviderSpecialty();
        special.Name='Denatal Care Speciality Saideep';
        insert special;
        system.assertEquals(conat.LastName,'Practitioner','success');
        // DoctorAppointmentController.fetchPersonAccountAppointments(acn.Id,'Scheduled',null);

       
    }
    
    @istest
    static void fetchPersonAccountAppointmentstest1(){
        Account acn=new Account();
        acn.LastName='Stellar';
        insert acn;
        CareSpecialty care = new CareSpecialty() ;
        care.Name='DentalCare Specialty';
        insert care;
        Contact conat=new Contact();
        conat.LastName='Practitioner';
        insert conat;
        Lead leading=new Lead();
        leading.Email='smith@noreply.comm';
        leading.LastName='smith';
        leading.Phone='8765432132';
        insert leading;
        ServiceAppointment serv = new ServiceAppointment();
        serv.ParentRecordId=acn.Id;
        serv.Status ='Completed & Cancelled';
        insert serv;
        system.assertEquals(conat.LastName,'Practitioner','success');
     //  DoctorAppointmentController.fetchPersonAccountAppointments(null,'Completed & Cancelled',leading.id);
        //DoctorAppointmentController.createInvite(care.Id,acn.id);
    }
    @istest
    static void fetchPersonAccountAppointmentstest2(){
        Account acn=new Account();
        acn.LastName='Stellar';
        insert acn;
        CareSpecialty care = new CareSpecialty() ;
        care.Name='DentalCare Specialty';
        insert care;
        Contact conat=new Contact();
        conat.LastName='Practitioner';
        insert conat;
        Lead leading=new Lead();
        leading.Email='smith@noreply.comm';
        leading.LastName='smith';
        leading.Phone='8765432132';
        insert leading;
        ServiceAppointment serv = new ServiceAppointment();
        serv.ParentRecordId=acn.Id;
        serv.Status ='Completed & Cancelled';
        insert serv;
        system.assertEquals(conat.LastName,'Practitioner','success');
     //  DoctorAppointmentController.fetchPersonAccountAppointments(null,'Scheduled',acn.id);
        // DoctorAppointmentController.createInvite(care.Id,acn.id);
    }
    
    @istest
    static void cancelRecordtest(){
        Account acn=new Account();
        acn.LastName='Stellar';
        insert acn;
        List<ServiceAppointment> serv = new List<ServiceAppointment>();  
        ServiceAppointment fvdh=new ServiceAppointment();
        fvdh.Status='Scheduled';
        fvdh.ParentRecordId=acn.Id;
        insert fvdh;
        serv.add(fvdh);
        system.assertEquals(fvdh.Status,'Scheduled','success');
        DoctorAppointmentController.getSpecialityHospiatalByMismatchDoctorsAndHospitals(acn.Id);
    }
    
    @istest
    static void fetchallergyTest(){    
        Account acc=new Account();
        acc.Name='Apollo  Hospital';
        insert acc;
        List<Contact> accList = new List<Contact>();
        Contact con=new Contact();
        con.LastName='Practitioner';
        con.AccountId=acc.Id;
        insert con;
        system.assertEquals(con.LastName,'Practitioner','success');
        DoctorAppointmentController.fetchallergy(con.Id);
    }
    
    @istest
    static void healthconditionTest(){
        Account acc=new Account();
        acc.Name='Apollo  Hospital';
        insert acc;
        List<Contact> accList = new List<Contact>();
        Contact con=new Contact();
        con.LastName='Practitioner';
        con.AccountId=acc.Id;
        insert con;
        system.assertEquals(con.LastName,'Practitioner','success');
        DoctorAppointmentController.healthcondition(con.Id);
    }
    
    @istest
    static void medicationmethodTest(){
        Account acc=new Account();
        acc.Name='Apollo  Hospital';
        insert acc;        
        List<Contact> accList = new List<Contact>();
        Contact con=new Contact();
        con.LastName='Practitioner';
        con.AccountId=acc.Id;
        insert con;
        system.assertEquals(con.LastName,'Practitioner','success');
        DoctorAppointmentController.medicationmethod(con.Id);   
    }
    
    @istest
    static void immunizationmethodTest(){
        Account acc=new Account();
        acc.Name='Apollo  Hospital';
        insert acc;
        List<Contact> accList = new List<Contact>();
        Contact con=new Contact();
        con.LastName='Practitioner';
        con.AccountId=acc.Id;
        insert con;
        system.assertEquals(con.LastName,'Practitioner','success');
        DoctorAppointmentController.immunizationmethod(con.Id);        
    }
    
    @istest
    static void medicalproceduremethodTest(){
        Account acc=new Account();        
        acc.Name='Apollo  Hospital';
        insert acc;
        List<Contact> accList = new List<Contact>();
        Contact con=new Contact();
        con.LastName='Practitioner';
        con.AccountId=acc.Id;
        insert con;
        system.assertEquals(con.LastName,'Practitioner','success');
        DoctorAppointmentController.medicalproceduremethod(con.Id);
    }
    
    @istest
    static void getSurveyResponceTest(){
        Account acc=new Account();
        acc.Name='Apollo  Hospital';
        insert acc;
        List<Contact> accList = new List<Contact>();
        Contact con=new Contact();
        con.LastName='Practitioner';
        con.AccountId=acc.Id;
        insert con;
        system.assertEquals(con.LastName,'Practitioner','success');
        DoctorAppointmentController.getSurveyResponce(con.Id);  
    }
    
    @istest
    static void changeLanguageDataTest(){
        Account acc=new Account();
        acc.Name='Apollo  Hospital';
        insert acc;
        List<Contact> accList = new List<Contact>();
        Contact con=new Contact();
        con.LastName='Practitioner';
        con.AccountId=acc.Id;
        insert con;
        system.assertEquals(con.LastName,'Practitioner','success');
        DoctorAppointmentController.changeLanguageData('en_US');
    }
    
    @istest
    static void latestencounterTest(){
        Account acc=new Account();
        acc.Name='Apollo  Hospital';
        insert acc;        
        List<Contact> accList = new List<Contact>();
        Contact con=new Contact();
        con.LastName='Practitioner';
        con.AccountId=acc.Id;
        insert con;
        system.assertEquals(con.LastName,'Practitioner','success');
        DoctorAppointmentController.latestencounter(con.Id);
    }
    
    @istest
    static void fetchDoctorByHospitalsssstest(){   
        Account acnte=new Account();
        acnte.Name='John';
        insert acnte;
        Contact cntc=new Contact();
        cntc.LastName='Satish';
        cntc.AccountId=acnte.id;        
        insert cntc;
        HealthcareProviderSpecialty newSpecialty = new HealthcareProviderSpecialty();
        newSpecialty.Name='DentalCare Specialty';
        newSpecialty.PractitionerId=cntc.Id;
        newSpecialty.AccountId=acnte.Id;
        insert newSpecialty;
        HealthcarePractitionerFacility hlth = new HealthcarePractitionerFacility();
        hlth.Name='specialty';
        hlth.PractitionerId=cntc.Id;
        hlth.AccountId=acnte.Id;
        insert hlth;
        system.assertEquals(cntc.LastName,'Satish','success');
        DoctorAppointmentController.getTimeSlots(cntc.Id,acnte.Id);
    }
    
    @istest
    static void careplanmethodTest(){ 
        Account acc=new Account();
        acc.Name='Apollo  Hospital';
        insert acc;
        List<Contact> accList = new List<Contact>();
        Contact con=new Contact();
        con.LastName='Practitioner';
        con.AccountId=acc.Id;
        insert con;
        system.assertEquals(con.LastName,'Practitioner','success');
        DoctorAppointmentController.careplanmethod(con.Id);
    }
    
    @istest
    static void deleteSurveyResponceTest(){
        Account acc=new Account();
        acc.Name='Apollo  Hospital';
        insert acc;
        List<Contact> accList = new List<Contact>();
        Contact con=new Contact();
        con.LastName='Practitioner';
        con.AccountId=acc.Id;
        insert con;
        system.assertEquals(con.LastName,'Practitioner','success');
        DoctorAppointmentController.deleteSurveyResponce(con.Id);
    }
    @istest
    static void  convertLeadToPersonAccountTest(){
      Lead leading=new Lead();
      leading.Email='smith@noreply.comm';
      leading.LastName='smith';
      leading.Phone='8765432132';
      insert leading;
          system.assertEquals(leading.LastName,'smith','success');
        DoctorAppointmentController.convertLeadToPersonAccount(leading.Id);
    }

    @isTest
    static void portalSpecialtyOnlySearchReturnsApolloBranchDoctors(){
        Account hospital = new Account(Name = 'Apollo Hospital');
        insert hospital;

        Account branch = new Account(
            Name = 'Apollo Bangalore Dental Center',
            ParentId = hospital.Id,
            BillingCity = 'Bangalore',
            BillingState = 'Karnataka',
            BillingPostalCode = '560025',
            BillingCountry = 'India'
        );
        insert branch;

        CareSpecialty specialty = new CareSpecialty(Name = 'Dental Care');
        insert specialty;

        Contact doctor = new Contact(
            FirstName = 'Asha',
            LastName = 'Nair',
            AccountId = branch.Id,
            Available_Appointment_Type__c = 'In Person',
            Doctor_Rating__c = 4.8,
            Years_of_Experience__c = 11,
            Review_Count__c = 186,
            Priority_Doctor__c = true
        );
        insert doctor;

        insert new HealthcareProviderSpecialty(
            Name = 'Apollo Bangalore Dental Center - Nair - Dental Care',
            AccountId = branch.Id,
            PractitionerId = doctor.Id,
            SpecialtyId = specialty.Id
        );

        Test.startTest();
        List<DoctorAppointmentController.LocationOption> locations = DoctorAppointmentController.getPortalLocations('Apollo Hospital', specialty.Id);
        List<HealthcareProviderSpecialty> doctors = DoctorAppointmentController.getPortalDoctors('Apollo Hospital', specialty.Id, null, null, null);
        Test.stopTest();

        System.assertEquals(1, locations.size(), 'The specialty should surface at least one Apollo location.');
        System.assertEquals(1, doctors.size(), 'Specialty-only search should return the Apollo branch doctor.');
        System.assertEquals(doctor.Id, doctors[0].PractitionerId, 'The expected Apollo doctor should be returned.');
    }

    @isTest
    static void portalLocationOnlySearchReturnsDoctorsForThatLocation(){
        Account hospital = new Account(Name = 'Apollo Hospital');
        insert hospital;

        Account bangaloreBranch = new Account(
            Name = 'Apollo Bangalore Center',
            ParentId = hospital.Id,
            BillingCity = 'Bangalore',
            BillingState = 'Karnataka',
            BillingPostalCode = '560001',
            BillingCountry = 'India'
        );
        Account delhiBranch = new Account(
            Name = 'Apollo Delhi Center',
            ParentId = hospital.Id,
            BillingCity = 'Delhi',
            BillingState = 'Delhi',
            BillingPostalCode = '110001',
            BillingCountry = 'India'
        );
        insert new List<Account>{ bangaloreBranch, delhiBranch };

        CareSpecialty dental = new CareSpecialty(Name = 'Dental Care');
        CareSpecialty cardio = new CareSpecialty(Name = 'Cardiology');
        insert new List<CareSpecialty>{ dental, cardio };

        Contact bangaloreDoctor = new Contact(FirstName = 'Asha', LastName = 'Nair', AccountId = bangaloreBranch.Id);
        Contact delhiDoctor = new Contact(FirstName = 'Vikram', LastName = 'Suri', AccountId = delhiBranch.Id);
        insert new List<Contact>{ bangaloreDoctor, delhiDoctor };

        insert new List<HealthcareProviderSpecialty>{
            new HealthcareProviderSpecialty(
                Name = 'Apollo Bangalore Center - Nair - Dental Care',
                AccountId = bangaloreBranch.Id,
                PractitionerId = bangaloreDoctor.Id,
                SpecialtyId = dental.Id
            ),
            new HealthcareProviderSpecialty(
                Name = 'Apollo Delhi Center - Suri - Cardiology',
                AccountId = delhiBranch.Id,
                PractitionerId = delhiDoctor.Id,
                SpecialtyId = cardio.Id
            )
        };

        Test.startTest();
        List<DoctorAppointmentController.LocationOption> locations = DoctorAppointmentController.getPortalLocations('Apollo Hospital', null);
        List<HealthcareProviderSpecialty> bangaloreDoctors = DoctorAppointmentController.getPortalDoctors('Apollo Hospital', null, 'bangalore|karnataka', null, null);
        Test.stopTest();

        System.assertEquals(2, locations.size(), 'All Apollo locations with doctors should be available for location-only search.');
        System.assertEquals(1, bangaloreDoctors.size(), 'Location-only search should return only doctors from the selected location.');
        System.assertEquals(bangaloreDoctor.Id, bangaloreDoctors[0].PractitionerId, 'The Bangalore doctor should be returned.');
    }

    @isTest
    static void registerPortalPatientCreatesPersonAccountDirectly(){
        Test.startTest();
        DoctorAppointmentController.PortalPatientRegistrationResult result = DoctorAppointmentController.registerPortalPatient(
            'Riya',
            'Sharma',
            'riya.sharma.portal@example.com',
            '9876543210',
            '12 Apollo Street',
            'Bangalore',
            'Karnataka',
            'India',
            '560001'
        );
        Test.stopTest();

        Account patient = [
            SELECT Id, FirstName, LastName, PersonEmail, Phone, PersonMailingCity, IsPersonAccount
            FROM Account
            WHERE Id = :result.patientId
        ];

        System.assertEquals('Riya Sharma', result.patientName, 'The response should include the patient name.');
        System.assertEquals(request.email, result.patientEmail, 'The response should include the patient email.');
        System.assertEquals(true, patient.IsPersonAccount, 'Registration should create a person account directly.');
        System.assertEquals('riya.sharma.portal@example.com', patient.PersonEmail, 'The person account email should match.');
        System.assertEquals('Bangalore', patient.PersonMailingCity, 'The person account mailing city should match.');
    }

    @isTest
    static void registerPortalPatientRejectsDuplicateEmail(){
        insert new Account(
            FirstName = 'Existing',
            LastName = 'Patient',
            PersonEmail = 'existing.portal@example.com',
            Phone = '9000000001'
        );

        try {
            DoctorAppointmentController.registerPortalPatient(
                'New',
                'Patient',
                'existing.portal@example.com',
                '9000000002',
                '22 New Street',
                'Delhi',
                'Delhi',
                'India',
                '110001'
            );
            System.assert(false, 'Duplicate patient email should raise an exception.');
        } catch (AuraHandledException ex) {
            System.assert(ex.getMessage().contains('email'), 'The duplicate-email message should mention email.');
        }
    }
}
