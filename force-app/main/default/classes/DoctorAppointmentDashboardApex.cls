public with sharing class DoctorAppointmentDashboardApex {
    public class PractitionerContext {
        @AuraEnabled public String practitionerId;
        @AuraEnabled public String practitionerName;
        @AuraEnabled public String doctorEmail;
        @AuraEnabled public Boolean found;
    }

    @AuraEnabled
    public static PractitionerContext getLoggedInPractitionerContext() {
        PractitionerContext context = new PractitionerContext();
        context.found = false;

        List<HealthcareProvider> providers = [
            SELECT PractitionerId, Practitioner.Name, User__r.Email
            FROM HealthcareProvider
            WHERE User__c = :UserInfo.getUserId()
            AND PractitionerId != null
            LIMIT 1
        ];

        if (!providers.isEmpty()) {
            context.practitionerId = providers[0].PractitionerId;
            context.practitionerName = providers[0].Practitioner != null ? providers[0].Practitioner.Name : null;
            context.doctorEmail = providers[0].User__r != null ? providers[0].User__r.Email : null;
            context.found = true;
        }

        return context;
    }

    @AuraEnabled
    public static PractitionerContext getPractitionerContextByEmail(String emailAddress) {
        PractitionerContext context = new PractitionerContext();
        context.found = false;

        if (String.isBlank(emailAddress)) {
            return context;
        }

        emailAddress = emailAddress.trim();

        List<HealthcareProvider> providers = [
            SELECT PractitionerId, Practitioner.Name, Practitioner.Email, User__r.Email
            FROM HealthcareProvider
            WHERE PractitionerId != null
            AND (User__r.Email = :emailAddress OR Practitioner.Email = :emailAddress)
            LIMIT 1
        ];

        if (!providers.isEmpty()) {
            context.practitionerId = providers[0].PractitionerId;
            context.practitionerName = providers[0].Practitioner != null ? providers[0].Practitioner.Name : null;
            if (providers[0].User__r != null && !String.isBlank(providers[0].User__r.Email)) {
                context.doctorEmail = providers[0].User__r.Email;
            } else if (providers[0].Practitioner != null) {
                context.doctorEmail = providers[0].Practitioner.Email;
            } else {
                context.doctorEmail = emailAddress;
            }
            context.found = true;
        }

        return context;
    }

    @AuraEnabled
    public static Boolean sendDoctorOtpToLoggedInUser(String otp) {
        if (String.isBlank(otp)) {
            return false;
        }

        User currentUser = [
            SELECT Id, Email, Name
            FROM User
            WHERE Id = :UserInfo.getUserId()
            LIMIT 1
        ];

        if (String.isBlank(currentUser.Email)) {
            return false;
        }

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] { currentUser.Email });
        mail.setSenderDisplayName('Salesforce Support');
        mail.setSubject('Doctor Dashboard Verification Code');
        mail.setBccSender(false);
        mail.setUseSignature(true);
        mail.setHtmlBody('Hello ' + currentUser.Name + ',<br/><br/>Your doctor dashboard verification code is <b>' + otp + '</b>.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        return true;
    }

    @AuraEnabled
    public static Boolean sendDoctorOtpByEmail(String emailAddress, String doctorName, String otp) {
        if (String.isBlank(emailAddress) || String.isBlank(otp)) {
            return false;
        }

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] { emailAddress.trim() });
        mail.setSenderDisplayName('Salesforce Support');
        mail.setSubject('Doctor Dashboard Verification Code');
        mail.setBccSender(false);
        mail.setUseSignature(true);
        mail.setHtmlBody('Hello ' + (String.isBlank(doctorName) ? 'Doctor' : doctorName) + ',<br/><br/>Your doctor dashboard verification code is <b>' + otp + '</b>.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        return true;
    }

    @AuraEnabled
    public static DoctorAppointmentController.AppointmentReminderResult sendAppointmentReminder(String serviceAppointmentId) {
        return DoctorAppointmentController.sendAppointmentReminder(serviceAppointmentId);
    }
    
    @AuraEnabled
    public static List<CarePractnFacilityAppt> fetchContact(String conId,String status){
        List<CarePractnFacilityAppt>  createfac=new List<CarePractnFacilityAppt>();
        if(conId !=null && status !=null){
         createfac =[select HealthcarePractitionerFacility.Account.Name,HealthcarePractitionerFacility.Practitioner.Name,ServiceAppointment.AppointmentNumber,ServiceAppointmentId,ServiceAppointment.Status,ServiceAppointment.DueDate,ServiceAppointment.WorkType.name,ServiceAppointment.SchedStartTime from CarePractnFacilityAppt where HealthcarePractitionerFacility.PractitionerId =:conId AND ServiceAppointment.Status=:status WITH SECURITY_ENFORCED ];
    }
            return createfac;
    }
    
   @AuraEnabled
    public static ServiceAppointment updateCancel(String serviceAppointmentIds){
        ServiceAppointment updateapp=new ServiceAppointment();
         updateapp=[SELECT Id,Status FROM ServiceAppointment WHERE Id=:serviceAppointmentIds WITH SECURITY_ENFORCED];
        if(updateapp.Status == 'Scheduled'){
            updateapp.Status ='Canceled';
        }
        if (ServiceAppointment.SObjectType.getDescribe().isAccessible() && !Schema.sObjectType.ServiceAppointment.fields.Status.isUpdateable()) {
            update updateapp;
        }
       return updateapp;
    }

    @AuraEnabled
    public static ServiceAppointment updateAppointmentStatus(String serviceAppointmentId, String newStatus){
        if (String.isBlank(serviceAppointmentId) || String.isBlank(newStatus)) {
            throw new AuraHandledException('Appointment id and status are required.');
        }

        ServiceAppointment updateApp = [
            SELECT Id, Status
            FROM ServiceAppointment
            WHERE Id = :serviceAppointmentId
            WITH SECURITY_ENFORCED
        ];

        if (updateApp.Status == newStatus) {
            return updateApp;
        }

        updateApp.Status = newStatus;
        update updateApp;
        return updateApp;
    }
    
    @AuraEnabled
    public static List<CarePractnFacilityAppt> fetchContactByDate(String selectedCon,DateTime selectedDate,String status){
        DateTime endTime=selectedDate.addHours(23);
        List<CarePractnFacilityAppt> createfaces=new List<CarePractnFacilityAppt>();
        try{
         createfaces =[select HealthcarePractitionerFacility.Account.Name,HealthcarePractitionerFacility.Practitioner.Name,ServiceAppointment.AppointmentNumber,ServiceAppointmentId,ServiceAppointment.SchedStartTime,ServiceAppointment.Status,ServiceAppointment.DueDate,ServiceAppointment.WorkType.name from CarePractnFacilityAppt WHERE HealthcarePractitionerFacility.PractitionerId=:selectedCon AND ServiceAppointment.SchedStartTime>=:selectedDate AND ServiceAppointment.SchedEndTime<=:endTime AND ServiceAppointment.Status=:status WITH SECURITY_ENFORCED];
        }
         catch(Exception e){
             System.debug('Exception>>'+ e);
        }
            return createfaces;
    }
    
    @AuraEnabled
    public static List<ServiceAppointment> cancelRecord(List<CarePractnFacilityAppt> cancelIds) {
        list<string> receverIds = new list<string>();
        for(CarePractnFacilityAppt a:cancelIds){
            receverIds.add(a.ServiceAppointmentId);
        }
        List<ServiceAppointment> delacccon=new List<ServiceAppointment>();
        try{
        delacccon =[SELECT Id,Status FROM ServiceAppointment WHERE Id IN : receverIds WITH SECURITY_ENFORCED];
        system.debug('delacccon>>'+delacccon);
       if(delacccon.size() > 0){
           system.debug('size>>'+delacccon.size());
           for(ServiceAppointment app:delacccon){
               if(app.Status=='Scheduled'){
                   app.Status='Canceled';
               }
           }
          update delacccon;
        }
        }
         catch(Exception e){
             System.debug('Exception>>'+ e);
        }
        return delacccon;
    }
}
