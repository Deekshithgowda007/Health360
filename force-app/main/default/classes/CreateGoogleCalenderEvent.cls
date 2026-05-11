public class CreateGoogleCalenderEvent {
    @InvocableMethod(label='Google Calender Event')
    Public static void getCalendar(List<Requests> req){ 
        
        String emailAdd=req[0].emailAdd;
        DateTime startTime=req[0].startTime;
        DateTime endTime=req[0].endTime;
        String myStartDate = startTime.format('yyyy-MM-dd\'T\'HH:mm:ss.SSSXXX');
        String myEndDate = endTime.format('yyyy-MM-dd\'T\'HH:mm:ss.SSSXXX');
        String nameOfTheevent='Meeting';
        
        Datetime dateAndTime = datetime.newInstance(2023,04,22,12,00,00);
        String eventSummury = NameOfTheevent;
        String eventies = EmailAdd;
        
        String googleAccount =EmailAdd;
        String createEventEndPoint = 'callout:GoogleCalenderHealth360/calendar/v3/calendars/'+googleAccount+'/events/';
        
        String createEventBody = ' {"end": { "timeZone": "Asia/Kolkata", "dateTime": "'+myEndDate+'"}, "start": {  "timeZone": "Asia/Kolkata",  "dateTime": "'+myStartDate+'"},"attendees": [{"email": "'+eventies+'"}], "summary": "'+eventSummury+'", "title": "'+nameOfTheevent+'"} ';
        System.debug('#### createEventBody  '+createEventBody);
        Http http = new Http();
        HttpRequest httpReq = new HttpRequest();
        httpReq.setEndpoint(createEventEndPoint);
        httpReq.setMethod('POST');
        httpReq.setBody(createEventBody );
        httpReq.setHeader('Content-Type', 'application/json');
        System.debug('httpReq   '+httpReq);
        HttpResponse httpRes =http.send(httpReq);
        System.debug('HttpRes   '+httpRes);
        System.debug('Request Sent');
        
        System.debug('response ==>>'+httpRes.getHeaderKeys());
        System.debug('response ==>>'+httpRes.getStatus());
        System.debug('response ==>>'+httpRes.getStatusCode());
        
    }
    public class Requests {
        @InvocableVariable(label='EmailAdressToSend')
        public String emailAdd;
        
        @InvocableVariable(label='StartTimeOfEvent')
        public DateTime startTime;
        
        @InvocableVariable(label='EndTimeOfEvent')
        public DateTime endTime;
    }
}