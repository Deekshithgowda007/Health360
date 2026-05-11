public without sharing class DoctorAppointmentFlow {
    @InvocableMethod(label='Create Record Through Flow')
    public static void createRecord(List<Request> req){
        
        String facId= null;
        String faName=null;
        String appId=null;
        String subjId=null;
        
        for(Request re:req){
            facId = re.facilityId;
            faName=re.facName;
            appId=re.appointmentId;
            subjId=re.serveySubjectId;
        }
        
        CarePractnFacilityAppt apt=new CarePractnFacilityAppt();
        apt.HealthcarePractitionerFacilityId=facId;
        apt.Name=faName;
        apt.ServiceAppointmentId=appId;
       // if(CarePractnFacilityAppt.sObjectType.getDescribe().isAccessible() && Schema.sObjectType.CarePractnFacilityAppt.isCreateable()) {
        insert apt;
       // }
       // SurveySubject fetchSubject = [SELECT Id,Name,SubjectId FROM SurveySubject WHERE Id=:subjId];
        //fetchSubject.SubjectId=appId;
       // if(SurveySubject.sObjectType.getDescribe().isAccessible() && Schema.sObjectType.SurveySubject.isUpdateable()) {
       // update fetchSubject;
        
        List<Attachment> attachmentsToInsert = new List<Attachment>();

         List<Attachment> attachmentsToDelete = new List<Attachment>();
        
        Attachment tempAtt;
        
        for(Attachment attachment: [
        SELECT SystemModstamp, ParentId, OwnerId, Name, 
            LastModifiedDate, LastModifiedById, IsPrivate, IsDeleted, 
            Id, Description, CreatedDate, CreatedById, 
            ContentType, BodyLength, Body 
        FROM Attachment 
        WHERE Id=:subjId]) {

    tempAtt=attachment.clone(false,false);
    tempAtt.parentId = appId;

    attachmentstoInsert.add(tempAtt);
    attachmentsToDelete.add(attachment);

}

insert attachmentsToInsert;
delete attachmentsToDelete;
        
        // Attachment attachment = new Attachment();
       // attachment = [SELECT Id, Name,parentId, Body, ContentType FROM Attachment WHERE Id =: subjId];
        // System.debug('attachment>>'+attachment);
        //attachment.ParentId = appId;
       // update attachment;
       // }
    }
    public class Request {
        @InvocableVariable(label='Facility Id')
        public String facilityId;
        @InvocableVariable(label='Facility Name')
        public String facName;
        @InvocableVariable(label='Appointment Id')
        public String appointmentId;
        @InvocableVariable(label='SubjectId Id')
        public String serveySubjectId;
    }
    
}