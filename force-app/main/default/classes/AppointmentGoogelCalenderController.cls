public class AppointmentGoogelCalenderController {
    
     public static final string CLIENT_SECRET='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';//Fill as per your registered app settings in google console
    public static final string CLIENT_ID='546624016432-0cgj6lfd3eudcohc5267d7cij1a103lt.apps.googleusercontent.com';//Fill as per your registered app settings in google console
    public static final string REDIRECT_URL='https://tech-kasetti-healthcloud.my.salesforce.com/services/authcallback/Health360GoogleCalender';

    public static final string OAUTH_TOKEN_URL='https://oauth2.googleapis.com/token';
    public static final string OAUTH_CODE_END_POINT_URL='https://accounts.google.com/o/oauth2/auth?';

    public static final string GRANT_TYPE='grant_type=authorization_code';
        //Scope URL as per oauth 2.0 guide of the google
    public static final string SCOPE='https://www.googleapis.com/auth/calendar';
    public static final string STATE='/profile';
    public static string timeformet='';
    public static string timeformetend='';
    //Approval Prompt Constant
 public static final string APPROVAL_PROMPT='force';
    
    public static void getaccToken(){
      
        Http h = new Http();

        String body='redirect_uri=https://tech-kasetti-healthcloud.my.salesforce.com/services/authcallback/Health360GoogleCalender&prompt=consent&response_type=code&client_id=546624016432-0cgj6lfd3eudcohc5267d7cij1a103lt.apps.googleusercontent.com&scope=https://www.googleapis.com/auth/calendar&access_type=offline';
        

        // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
        HttpRequest req = new HttpRequest();
        req.setEndpoint(OAUTH_CODE_END_POINT_URL);
        req.setHeader('Content-Type','application/json');
        req.setHeader('Accept','application/json');
        req.setMethod('GET');
        req.setBody(body);

        system.debug('REQUEST BODY'+body);

        // Send the request, and return a response
        HttpResponse res = h.send(req);

        system.debug('body'+res.getbody());
        JSONParser parser = JSON.createParser(res.getBody());
         system.debug('parser>>'+parser);
        String Acctoken='';

      
        system.debug('acctoken'+Acctoken);
    }
}