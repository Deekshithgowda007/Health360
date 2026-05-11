public with sharing class SendZoomLink {
 @InvocableMethod(label='zoomLink')
    public static  void  smsConfirmation(List<ConvertLeadActionRequest> reqServiceId){
        String appointmentId =reqServiceId[0].AppointmentId;
         String joinUrl =reqServiceId[0].joinUrl;
         String appointmentType =reqServiceId[0].appointmentType;
         String SurveyInvitaion =reqServiceId[0].SurveyInvitaion;
         
         
         ServiceAppointment getNumber =[SELECT Account.Name,SchedStartTime,SchedEndTime,AppointmentType,Zoom_Meeting_Url__c,Account.Phone,Status,Account.IsPersonAccount,Account.BillingCity,Account.ShippingCountry,Account.BillingState,Account.Billingpostalcode   from ServiceAppointment Where Id = :AppointmentId];
       
      System.debug(getNumber.Zoom_Meeting_Url__c);
         /*
          Id communityId = [select Id from Network where Name = 'Book an Appointment'].Id;
           
           
          Survey surveyrec = [Select Id,Name from Survey where Id ='0Kd4x0000022HIGCA2'];
        
        system.debug('surveyrec>>'+surveyrec.Id);
          
          SurveyInvitation sInv = New SurveyInvitation();
          SInv.Name = Surveyrec.Name+'Invitation';
          Sinv.CommunityId = communityId;
          SInv.OptionsCollectAnonymousResponse = false;
        SInv.OptionsAllowGuestUserResponse = true;
           SInv.SurveyId = Surveyrec.Id;
          insert SInv;
          system.debug('invitation url>>'+SInv.InvitationLink);
          SurveySubject sS = new SurveySubject();
        SS.SubjectId =getNumber.Id ;
        SS.ParentId = SInv.Id;
        SS.Name = SInv.Name+' '+'Subject';
        insert SS;
           SurveyInvitation sInvRecord = [Select id, InvitationLink from SurveyInvitation where id = :SInv.id];
          system.debug('invitation url>>'+sInvRecord.InvitationLink);
        SurveySubject fetchSubject = [SELECT Id,Name FROM SurveySubject WHERE ParentId=:SInv.Id];
        */
         if(AppointmentType == 'DirectToHospital'){
      CarePractnFacilityAppt getHospitalName =[SELECT HealthcarePractitionerFacility.Practitioner.Name,HealthcarePractitionerFacility.Account.Name,HealthcarePractitionerFacility.Account.ShippingCity,HealthcarePractitionerFacility.Account.ShippingStreet,HealthcarePractitionerFacility.Account.ShippingPostalCode from CarePractnFacilityAppt Where ServiceAppointmentId =:AppointmentId];
          System.debug(getHospitalName);
         string mobNo ='+91'+getNumber.Account.Phone;
        //  String myStartDate = getNumber.SchedStartTime.format('yyyy-MM-dd\'T\'HH:mm:ss.SSSXXX');
         //    String endTime = getNumber.SchedEndTime.format('yyyy-MM-dd\'T\'HH:mm:ss.SSSXXX');
              DateTime getStrtTimes=getNumber.SchedStartTime;
               String getExactStartTimes =getStrtTimes.format('dd/MM/yyyy h:mm a');
             
           //  String getStartTime =getStrtTime.format('yyyy-MM-dd h:mm a');
              DateTime getendTimes=getNumber.SchedEndTime;
              String getExactEndtTimes =getendTimes.format('dd/MM/yyyy h:mm a');
           // String getendTimes =getendTime.format('yyyy-MM-dd h:mm a');
        // if(getNumber.AppointmentType='DirectToHospital'){
             //String Link ='<a href="' +sInvRecord.InvitationLink+ '">Click Here</a>';
            String messages =+'Name : '+getNumber.Account.Name+'\n'+'Doctor : '+ getHospitalName.HealthcarePractitionerFacility.Practitioner.Name+'\n'+'Hospital :  '+ getHospitalName.HealthcarePractitionerFacility.Account.Name +'\n'+'Appointment confirmed at :'+ ' '+ getExactStartTimes +'  '+'to'+' '+getExactEndtTimes +'\n'+'Branch : '+getNumber.Account.BillingCity+'\n'+'Branch Adress : '+getNumber.Account.BillingCity+','+getNumber.Account.BillingState+','+getNumber.Account.Billingpostalcode+'\n'+'\n'+'Hospital location:'+'\n'+'http://maps.google.com/maps?f=d&saddr='+getHospitalName.HealthcarePractitionerFacility.Account.ShippingStreet+','+getHospitalName.HealthcarePractitionerFacility.Account.ShippingCity+','+getHospitalName.HealthcarePractitionerFacility.Account.ShippingPostalCode+'&hl=en&ie=UTF8&z=13'+'\n'+'\n'+'Please help Us improve Your experience'+'\n'+SurveyInvitaion ;
 
         SmsTriggerSupporterController.sendMessage(MobNo, messages);
         }
         else{
            CarePractnFacilityAppt getHospitalName =[SELECT HealthcarePractitionerFacility.Practitioner.Name,HealthcarePractitionerFacility.Account.Name,HealthcarePractitionerFacility.Account.ShippingCity,HealthcarePractitionerFacility.Account.ShippingStreet,HealthcarePractitionerFacility.Account.ShippingPostalCode from CarePractnFacilityAppt Where ServiceAppointmentId =:AppointmentId];
          System.debug(getHospitalName);
         string mobNo ='+91'+getNumber.Account.Phone;
       
       
             DateTime getStrtTime=getNumber.SchedStartTime;
            // String getStartTime =getStrtTime.format('dd-MM-yyyy h:mm a');
        String getExactStartTime =getStrtTime.format('dd/MM/yyyy h:mm a');
              DateTime getendTime=getNumber.SchedEndTime;
            // String getendTimes =getendTime.format('yyyy-MM-dd h:mm a');
        String getExactEndtTime =getendTime.format('dd/MM/yyyy h:mm a');
        // if(getNumber.AppointmentType='DirectToHospital'){
             
             String messages =+'Name : '+getNumber.Account.Name+'\n'+'Doctor : '+ getHospitalName.HealthcarePractitionerFacility.Practitioner.Name+'\n'+'Hospital :  '+ getHospitalName.HealthcarePractitionerFacility.Account.Name +'\n'+'Appointment confirmed at :'+'  '+ ' '+getExactStartTime +' to '+' '+getExactEndtTime +'\n'+'Branch : '+getNumber.Account.BillingCity +'\n'+'Branch Adress : '+getNumber.Account.BillingCity+','+getNumber.Account.BillingState+','+getNumber.Account.Billingpostalcode+'\n'+'\n'+'Please Click on Below Link to Join Zoom Meeting'+'\n'+JoinUrl+'\n'+'\n'+'Please help Us improve Your experience'+'\n'+SurveyInvitaion ;
            //String messages ='Doctor :'+ getHospitalName.HealthcarePractitionerFacility.Practitioner.Name+'\n'+'Hospital :  '+ getHospitalName.HealthcarePractitionerFacility.Account.Name +'\n'+'Name : '+getNumber.Account.Name+'\n'+'Branch : '+getNumber.Account.BillingCity+','+getNumber.Account.ShippingCountry +'\n'+'Appointment Confirmed At :'+getNumber.SchedStartTime +'  '+'to'+' '+getNumber.SchedEndTime +'\n'+'Please help Us improve Your experience'+'\n'+sInvRecord.InvitationLink+'\n'+'Please Click on Below Link to Join Zoom Meeting'+'\n'+JoinUrl+'\n'+' Hospital Location:'+'\n'+'http://maps.google.com/maps?f=d&saddr='+getHospitalName.HealthcarePractitionerFacility.Account.ShippingStreet+','+getHospitalName.HealthcarePractitionerFacility.Account.ShippingCity+','+getHospitalName.HealthcarePractitionerFacility.Account.ShippingPostalCode+'&hl=en&ie=UTF8&z=13' ;
 
         SmsTriggerSupporterController.sendMessage(MobNo, messages); 
         }
    }
     public class ConvertLeadActionRequest {
    @InvocableVariable(label='passLink')
   public String appointmentId;
       @InvocableVariable(label='JoinUrl')
   public String joinUrl;
       @InvocableVariable(label='AppointmentType')
   public String appointmentType;
          @InvocableVariable(label='SurveyInvitationId')
   public String SurveyInvitaion;
     }
}