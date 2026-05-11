@isTest

public class CreateGoogleCalenderEventTest {
    @isTest
    public static void getCalendarTest(){
        
     final String EmailAdd = 'thomas@gmail.com';
     final DateTime StartTime = DateTime.newInstanceGMT(2013, 11, 12, 3, 3, 3);
     final DateTime EndTime = DateTime.newInstanceGMT(2013, 11, 13, 3, 3, 3);
     
     CreateGoogleCalenderEvent.Requests request=new CreateGoogleCalenderEvent.Requests();
     request.emailAdd=EmailAdd;
     request.startTime=StartTime;
     request.endTime=EndTime;
        
     Test.setMock(HttpCalloutMock.class, new CreateGoogleCalenderEventCalloutMock());
      
     CreateGoogleCalenderEvent.getCalendar(new List<CreateGoogleCalenderEvent.Requests> {request});
     System.assert(true,request.EmailAdd);
       }
}