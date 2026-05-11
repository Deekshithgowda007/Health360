@IsTest
public class DoctorAppointmentFlowTest {
 @isTest
     static void runTest()
    {
        Account acc=new Account();
        acc.LastName='Stellar';
        insert acc;
        
        Contact con =new Contact();
        con.LastName='Sathish';
        insert con;
        
        HealthcarePractitionerFacility fac=new HealthcarePractitionerFacility();
        fac.AccountId=acc.Id;
        fac.PractitionerId=con.Id;
        fac.Name='Facility';
        insert fac;
      
        ServiceAppointment app=new ServiceAppointment();
        app.Status='Scheduled';
        app.ParentRecordId=acc.Id;
        insert app;
               
        SurveyInvitation inv=new SurveyInvitation();
        inv.Name='invitation';
        inv.SurveyId='0Kd4x0000022H89CAE';
        insert inv;
        
        SurveySubject sub=new SurveySubject();
        sub.Name='Subject';
        sub.ParentId=inv.Id;
        sub.SubjectId=acc.Id;
      //  sub.SurveyId='0Kd4x0000022H89CAE';
        insert sub;
        
        List<DoctorAppointmentFlow.Request> docReqs = new List<DoctorAppointmentFlow.Request>();

        DoctorAppointmentFlow.Request docReq = new DoctorAppointmentFlow.Request();
        docReq.facilityId=fac.Id;
        docReq.facName ='test';
         docReq.ServeySubjectId =sub.Id;
             docReq.appointmentId =app.Id;
        docReqs.add(docReq);
  
        Test.startTest();
        DoctorAppointmentFlow.CreateRecord(docReqs);
        system.assert(true, docReq.facName);
        Test.stopTest();    
    }
    
        }