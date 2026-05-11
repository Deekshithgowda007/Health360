@isTest
public  class SendZoomLinkTest {
    //@isTest
    @isTest(SeeAllData=true) 
    static void sendZoomLinkTestmethod() {
        Account acc=new Account();
        acc.LastName='Stellar';
        insert acc;
        
        Contact con =new Contact();
        con.LastName='Sathish';
        
        string mobileno='7238881913';
        string message='Hello';
        insert con;
       
       
        HealthcarePractitionerFacility fac=new HealthcarePractitionerFacility();
        fac.Name='Facility';
        // String messages ='Hospital';
        // String MobNo='3274693262';
        fac.AccountId=acc.Id;
        fac.PractitionerId=con.Id;
        insert fac;
        
      
        ServiceAppointment app=new ServiceAppointment();
        app.Status='Scheduled';
        app.ParentRecordId=acc.Id;
        app.SchedStartTime=DateTime.newInstance(2023,07,15,11,00,00);
        app.SchedEndTime=DateTime.newInstance(2023,07,15,12,00,00);
        insert app;
             
        CarePractnFacilityAppt st=new CarePractnFacilityAppt();
        st.HealthcarePractitionerFacilityId=fac.Id;
        st.ServiceAppointmentId=app.Id;
        st.Name='Gayatri Sathish Facility';
        insert st;

        SurveyInvitation inv=new SurveyInvitation();
        inv.Name='Invitation';
        inv.SurveyId='0Kd4x0000022HHNCA2';
        insert inv;
        SurveySubject sub=new SurveySubject();
        sub.Name='Subject';
        sub.ParentId=inv.Id;
        sub.SubjectId=acc.Id;
        insert sub;
       
        system.assertEquals(sub.Name,'Subject','success');
        
        List<SendZoomLink.ConvertLeadActionRequest> docReqs = new List<SendZoomLink.ConvertLeadActionRequest>();

         
        SendZoomLink.ConvertLeadActionRequest docReq = new SendZoomLink.ConvertLeadActionRequest();
        docReq.AppointmentId=app.id;
        docReq.JoinUrl='https://hdhd.com';
        docReq.AppointmentType='DirectToHospital';
         
        docReqs.add(docReq);
        SendZoomLink.smsConfirmation(docReqs);

   
    }
    @isTest(SeeAllData=true) 
    static void sendZoomLinkTest1() {
        Account acc=new Account();
        acc.LastName='Stellar';
        insert acc;
        
        Contact con =new Contact();
        con.LastName='Sathish';
        
        string mobileno='7238881913';
        string message='Hello';
        insert con;
       
       
        HealthcarePractitionerFacility fac=new HealthcarePractitionerFacility();
        fac.Name='Facility';
        // String messages ='Hospital';
        // String MobNo='3274693262';
        fac.AccountId=acc.Id;
        fac.PractitionerId=con.Id;
        insert fac;
        
      
        ServiceAppointment app=new ServiceAppointment();
        app.Status='Scheduled';
        app.ParentRecordId=acc.Id;
         app.SchedStartTime=DateTime.newInstance(2023,07,15,11,00,00);
         app.SchedEndTime=DateTime.newInstance(2023,07,15,12,00,00);
        insert app;
             
        CarePractnFacilityAppt st=new CarePractnFacilityAppt();
        st.HealthcarePractitionerFacilityId=fac.Id;
        st.ServiceAppointmentId=app.Id;
        st.Name='Gayatri Sathish Facility';
        insert st;
        
        SurveyInvitation inv=new SurveyInvitation();
        inv.Name='Invitation';
        inv.SurveyId='0Kd4x0000022HHNCA2';
        insert inv;
        SurveySubject sub=new SurveySubject();
        sub.Name='Subject';
        sub.ParentId=inv.Id;
        sub.SubjectId=acc.Id;
        insert sub;

        system.assertEquals(sub.Name,'Subject','success');
        
        List<SendZoomLink.ConvertLeadActionRequest> docReqs = new List<SendZoomLink.ConvertLeadActionRequest>();

         
        SendZoomLink.ConvertLeadActionRequest docReq = new SendZoomLink.ConvertLeadActionRequest();
        docReq.AppointmentId=app.id;
        docReq.JoinUrl='https://hdhd.com';
        docReq.AppointmentType='Direct';
         
        docReqs.add(docReq);
        SendZoomLink.smsConfirmation(docReqs);
   
    }
    }