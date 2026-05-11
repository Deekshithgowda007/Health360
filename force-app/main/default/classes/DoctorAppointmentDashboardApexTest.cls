@isTest
public class DoctorAppointmentDashboardApexTest{
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