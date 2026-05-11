public class ZoomMetingSchedule {
    
    @InvocableMethod(label='Zoommeeting Invivation')
    public static List<Results> scheduleMeeting(List<Requests> req){
        
        system.debug('timeDate>>>>'+req);
        String timeDate=req[0].timeDate;
        system.debug('timeDate>>'+timeDate);
        String appId=req[0].AppoId;
        system.debug('AppId>>'+AppId);
        
        system.debug('Inside Zoom class');
        HttpRequest request = new HttpRequest();
        request.setMethod('POST');
        request.setEndpoint('callout:ZoomMeetingHealth360/');
        request.setHeader('Content-type', 'application/json');
        request.setBody(jsonGenerator(timeDate));
        System.debug('jsonGenerator(timeDate)>>'+jsonGenerator(timeDate));
        Http http = new Http();
        System.debug('jsonGenerator(Request)>>'+request);
        HTTPResponse res = http.send(request);
        System.debug('Request Sent');
        system.debug('Body'+res.getBody());
        System.debug('response1 ==>>'+res.getHeaderKeys());
        System.debug('response1 ==>>'+res.getStatus());
        System.debug('response1 ==>>'+res.getStatusCode());
        JSONParser parser = JSON.createParser(res.getBody());
        JSONParser parser1 = JSON.createParser(res.getBody());
        String hostURL='';
        String joinUrl='';
        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&
                (parser.getText() == 'start_url')) {
                    // Get the value.
                    parser.nextToken();
                    
                    // Compute the grand total price for all invoices.
                    hostURL += parser.getText();
                }
        }
        while (parser1.nextToken() != null) {
            if ((parser1.getCurrentToken() == JSONToken.FIELD_NAME) &&
                (parser1.getText() == 'join_url')) {
                    // Get the value.
                    parser1.nextToken();
                    
                    // Compute the grand total price for all invoices.
                    joinUrl += parser1.getText();
                }
        }
        
        system.debug('hostURL>>>>'+hostURL);
        system.debug('joinurl>>>'+joinUrl);
       
        List<Results> responses = new List<Results>();
        Results response = new Results();
        response.hostURL = hostURL;
        response.joinURL = joinUrl;
        responses.add(response);
        system.debug('responses>>>'+responses);
        return responses; 
      
    }
    
    public static string jsonGenerator(String timeDate){
        System.debug('timeDate>>'+timeDate);
        
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeObjectField('agenda','Meeting Agenda Introduction');
        gen.writeObjectField('default_password','false');
        gen.writeObjectField('duration','60');
        gen.writeObjectField('password','123456');
        
        // gen.writeObjectField('schedule_for','sdkulkarni15@gmail.com'); //
        gen.writeFieldName('settings');
        gen.writeStartObject();
        gen.writeObjectField('host_video',false);
        gen.writeObjectField('allow_multiple_devices',false);
        gen.writeObjectField('participant_video',false);
        gen.writeObjectField('join_before_host',false);
        gen.writeObjectField('mute_upon_entry',true);
        gen.writeObjectField('use_pmi',false);
        gen.writeObjectField('approval_type',0);
        gen.writeEndObject();
        gen.writeObjectField('start_time','2022-06-01T18:30:00Z'); // '2022-06-01T18:30:00Z'= 2022-07-06T13:30:00.000Z
        
        gen.writeObjectField('timezone','Asia/Calcutta'); // Time Zone
        gen.writeObjectField('topic','Intrview with Sony');
        gen.writeObjectField('type','2');
        gen.writeEndObject();
        string payload=gen.getAsString();
        System.debug('payload body'+payload);
        return payload;
    }
    
    
    public class Requests {
        @InvocableVariable(label='TimeDateFiels')
        public String timeDate;
        
        @InvocableVariable(label='AppointmentId')
        public String appoId;
    }
    
    public class Results {
        @InvocableVariable(label='Records for hostURL')
        public String hostURL;
        
        @InvocableVariable(label='Records for JoinUrl')
        public String joinURL;
    }
    
}