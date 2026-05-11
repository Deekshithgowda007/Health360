public with sharing class DoctorAppointmentDashboardApex {
    
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