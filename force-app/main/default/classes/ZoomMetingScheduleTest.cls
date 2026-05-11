@istest
public with sharing class ZoomMetingScheduleTest {
    @istest
     public  static void zoomMetingScheduleTestmethod() {
        final String timeDate = '2022-06-01T18:30:00Z';
        final String appoId = userinfo.getuserID();//08p4x0000012deTAAQ
        
        ZoomMetingSchedule.Requests request = new ZoomMetingSchedule.Requests();
        request.timeDate=timeDate;
        request.appoId=appoId;
    
            Test.setMock(HttpCalloutMock.class, new ZoomMetingScheduleCalloutMock());
          ZoomMetingSchedule.scheduleMeeting(new List<ZoomMetingSchedule.Requests> {request});

          System.assertEquals('2022-06-01T18:30:00Z', timeDate,'ZoomMetingScheduleTest');

       
        
     }
    
          
           
        
     }