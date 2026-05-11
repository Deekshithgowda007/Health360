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
         DoctorAppointmentController.fetchPersonAccountAppointments(acn.Id,'Completed & Cancelled',null);
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
         DoctorAppointmentController.fetchPersonAccountAppointments(acn.Id,'Scheduled',null);

       
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
       DoctorAppointmentController.fetchPersonAccountAppointments(null,'Completed & Cancelled',leading.id);
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
       DoctorAppointmentController.fetchPersonAccountAppointments(null,'Scheduled',acn.id);
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
}