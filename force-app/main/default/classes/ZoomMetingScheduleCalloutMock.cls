// public with sharing class ZoomMetingScheduleCalloutMock {
//     public ZoomMetingScheduleCalloutMock() {
//   global class ZoomMetingScheduleCalloutMock implements HttpCalloutMock{
//             global HttpResponse respond(HttpRequest req){
//                 HttpResponse res = new HttpResponse();
//                 res.setHeader('Content-Type','application/json');
//                 res.setBody('{"Animals":["Horse","Dog","Tiger","Lion","Cat","Mouse"]}');
//                 res.setStatusCode(200);
//                 return res;
//             }
//     }
public class ZoomMetingScheduleCalloutMock implements HttpCalloutMock {
    public HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"animal": {"id":2, "name":"Test"}}');
        response.setStatusCode(200);
        return response; 
    }
}