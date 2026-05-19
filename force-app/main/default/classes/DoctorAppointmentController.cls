public without sharing class DoctorAppointmentController {
    @AuraEnabled		
    public static List<Contact> fetchAccts(String conId) {
        List<Contact> accList = new List<Contact>();
        if(Contact.SObjectType.getDescribe().isAccessible()&&
        Schema.SObjectType.Contact.fields.Id.isAccessible()
      ){
            
          if(conId != null){
            accList = [ SELECT Id,Name,AccountId,Account.Name,Account.ShippingCity,Account.ShippingCountry,Account.IsPersonAccount,Account.Image_URL__c,Overview__c,Awards_and_Regonitions__c,Available_Appointment_Type__c,Area_of_Expertise__c,Doctor_Rating__c,Years_of_Experience__c,Review_Count__c,Priority_Doctor__c  from Contact Where Id=:conId  ];
            
        }  
       
    }
    return accList;
    }
    
    @AuraEnabled
    public static CareWrap fetchDoctor(String csId,String accId,String docId) {
        List<HealthcareProviderSpecialty> getId = new  List<HealthcareProviderSpecialty>();
        List<CareSpecialtyTaxonomy> getsubSpeciality = new  List<CareSpecialtyTaxonomy>();
        List<careSpecialty> getSpecialityName = new  List<careSpecialty>();
        CareWrap wrapList =  new  CareWrap();
        
          //  getsubSpeciality=[SELECT CareTaxonomyId,CareTaxonomy.Name from CareSpecialtyTaxonomy where CareSpecialtyId =:csId  WITH SECURITY_ENFORCED];
          if(HealthcareProviderSpecialty.SObjectType.getDescribe().isAccessible()&&
        Schema.SObjectType.HealthcareProviderSpecialty.fields.Id.isAccessible()
      ){
          if(accId != null && csId !=null && docId == null){
                getId = [ SELECT Name,Practitioner.Name , Practitioner.Id,Practitioner.Available_Appointment_Type__c,Practitioner.Image_URL__c,Specialty.Name,Account.Name,Practitioner.AccountId,PractitionerId, Practitioner.Area_of_Expertise__c,Practitioner.Awards_and_Regonitions__c,Practitioner.Overview__c,Practitioner.Doctor_Rating__c,Practitioner.Years_of_Experience__c,Practitioner.Review_Count__c,Practitioner.Priority_Doctor__c,Account.Phone,Account.Website,Account.BillingCity,Account.BillingState,Account.BillingPostalCode,Account.BillingCountry,SpecialtyId  FROM HealthcareProviderSpecialty WHERE SpecialtyId =:csId AND Practitioner.AccountId=:accId ];/*( AND Practitioner.AccountId =:getHospitalName)*/
            }
            else if(accId != null && csId !=null && docId != null)
             {
                getId = [ SELECT Name,Practitioner.Name , Practitioner.Id,Practitioner.Available_Appointment_Type__c,Practitioner.Image_URL__c,Specialty.Name,Account.Name,Practitioner.AccountId,PractitionerId, Practitioner.Area_of_Expertise__c,Practitioner.Awards_and_Regonitions__c,Practitioner.Overview__c,Practitioner.Doctor_Rating__c,Practitioner.Years_of_Experience__c,Practitioner.Review_Count__c,Practitioner.Priority_Doctor__c,Account.BillingCity,Account.BillingState,Account.BillingPostalCode,Account.BillingCountry,SpecialtyId  FROM HealthcareProviderSpecialty WHERE SpecialtyId =:csId AND Practitioner.AccountId=:accId AND PractitionerId=:docId ];  
            }
          //  getSpecialityName = [ SELECT Name FROM careSpecialty where Id =:csId  ];
            wrapList.practitioners =getId;
         //   wrapList.subSpeciality=getsubSpeciality;
      }
        return wrapList;
    }
    
    @AuraEnabled 
    public static List<HealthcareProviderTaxonomy> subspecialityDoctors(String taxId){
        List<HealthcareProviderTaxonomy> subDoc=new List<HealthcareProviderTaxonomy>();
        if(HealthcareProviderTaxonomy.SObjectType.getDescribe().isAccessible()&&
        Schema.SObjectType.HealthcareProviderTaxonomy.fields.Id.isAccessible())
      {
       if(taxId != null){
            subDoc =[SELECT Id,Practitioner.Name, Taxonomy.Name,TaxonomyId ,Account.Name  FROM HealthcareProviderTaxonomy WHERE TaxonomyId =:taxId  ];
       }
    }
        return subDoc;
    }
    
    @AuraEnabled 
    public static TimePreview createfacilities(String accntId,String contctId){
        TimePreview timeList =  new  TimePreview();
        if(HealthcarePractitionerFacility.SObjectType.getDescribe().isAccessible()&&
        Schema.SObjectType.HealthcarePractitionerFacility.fields.Id.isAccessible() &&
        ServiceTerritoryWorkType.SObjectType.getDescribe().isAccessible()&&
        Schema.SObjectType.ServiceTerritoryWorkType.fields.Id.isAccessible() &&
        WorkTypeGroupMember.SObjectType.getDescribe().isAccessible()&&
        Schema.SObjectType.WorkTypeGroupMember.fields.Id.isAccessible())
      {
        if(contctId != null && accntId !=null){
            HealthcarePractitionerFacility createfac =[select Id,Name,AccountId,PractitionerId,ServiceTerritoryMember.ServiceTerritory.OperatingHours.TimeZone,ServiceTerritoryMember.ServiceResourceId,ServiceTerritoryMember.ServiceTerritoryId from HealthcarePractitionerFacility where AccountId=:accntId and PractitionerId=:contctId  ];
            ServiceTerritoryWorkType timesl= [SELECT Id, WorkType.Name FROM ServiceTerritoryWorkType WHERE ServiceTerritoryId =: createfac.ServiceTerritoryMember.ServiceTerritoryId  ];
            WorkTypeGroupMember timesls=[SELECT Id, WorkTypeGroup.Name FROM WorkTypeGroupMember WHERE WorkTypeId =: timesl.WorkType.Id  ];
            
            timeList.practitionerfacility=createfac;
            timeList.workTypeName=timesl;
            timeList.workTypeGroupName=timesls;
        }
    }
        return timeList;
    }
    
    @AuraEnabled
    public static List<Contact> fetchHospitalByDoctorId(String doCid) {
        List<Contact> getAccountId=new List<Contact>();
       if(doCid != null){
            getAccountId = [ SELECT Account.Id,Account.Name,Account.Image_URL__c,Account.ShippingCity,Account.ShippingCountry,Account.Phone,Account.BillingAddress,Account.Website  FROM Contact WHERE Id=:doCid  ];/*( AND Practitioner.AccountId =:getHospitalName)*/
       
       }
        return getAccountId;
    }
    
    @AuraEnabled
    public static HealthcareProviderSpecialty fetchSpecialityHospiatalByDoctor(String doctId,String hospId) {
        HealthcareProviderSpecialty getAccountId=new HealthcareProviderSpecialty();
      if(doctId !=null && hospId!=null){
            getAccountId = [SELECT  Practitioner.Name ,Practitioner.Image_URL__c,Specialty.Name,Account.Name,Practitioner.AccountId,PractitionerId,SpecialtyId,Practitioner.Available_Appointment_Type__c,Practitioner.Doctor_Rating__c,Practitioner.Years_of_Experience__c,Practitioner.Review_Count__c,Practitioner.Priority_Doctor__c  FROM HealthcareProviderSpecialty WHERE PractitionerId=:doctId AND AccountId=:hospId  ];
      }
        return getAccountId;
    }
    
    @AuraEnabled
    public static List<HealthcareProviderSpecialty> getSpecialityHospiatalByDoctors(String doctId,String hospId) {
        List<HealthcareProviderSpecialty> getAccountId=new List<HealthcareProviderSpecialty>();
        if(doctId != null && hospId != null){
            getAccountId = [SELECT  Practitioner.Name ,Practitioner.Image_URL__c,Specialty.Name,Account.Name,Practitioner.AccountId,PractitionerId,Practitioner.Overview__c,Practitioner.Awards_and_Regonitions__c,Practitioner.Area_of_Expertise__c,Practitioner.Available_Appointment_Type__c,Practitioner.Doctor_Rating__c,Practitioner.Years_of_Experience__c,Practitioner.Review_Count__c,Practitioner.Priority_Doctor__c,Account.BillingCity,Account.BillingState,Account.BillingPostalCode,Account.BillingCountry  FROM HealthcareProviderSpecialty WHERE PractitionerId=:doctId AND AccountId=:hospId  ];
        }
        return getAccountId;
    }
    
    @AuraEnabled
    public static List<HealthcareProviderSpecialty> getRequiredSpecialityByHospiatals(String hospId) {
       
        List<HealthcareProviderSpecialty>   getAccountId = [SELECT Specialty.Name FROM HealthcareProviderSpecialty WHERE  AccountId=:hospId  ];
        Set<Id> myset = new Set<Id>();
        List<HealthcareProviderSpecialty> result = new List<HealthcareProviderSpecialty>();
        if(hospId != null){
        for (HealthcareProviderSpecialty s : getAccountId) {
            if (myset.add(s.SpecialtyId)) {
                result.add(s);
            }
        }
        }
        return result;
    }
    
    @AuraEnabled
    public static List<HealthcareProviderSpecialty> getHospitalsByCareSpeciality(String careIds) {
        List<HealthcareProviderSpecialty> result = new List<HealthcareProviderSpecialty>();
        if(careIds !=null){
            
                List<HealthcareProviderSpecialty> accLists = [SELECT AccountId, Account.Name ,Account.Phone,Account.Website,Account.Image_URL__c,Account.ShippingCity,Account.ShippingCountry,Account.BillingAddress   FROM HealthcareProviderSpecialty WHERE SpecialtyId=:careIds  ];/*( AND Practitioner.AccountId =:getHospitalName)*/
                Set<Id> myset = new Set<Id>();
                for (HealthcareProviderSpecialty s : accLists) {
                    if (myset.add(s.AccountId)) {
                        result.add(s);
                    }
                }
           
        }
        return result;
    } 
    
    @AuraEnabled
    public static List<Contact> fetchHospitalByHospitals(String hospitalid) {
        List<Contact> getAccountId=new List<Contact>();
      if(hospitalid != null){
            getAccountId = [ SELECT Id,Name,AccountId,Account.Name,Account.ShippingCity,Account.ShippingCountry,Account.IsPersonAccount,Account.Image_URL__c,Account.BillingAddress,Account.Website,Account.Phone  from Contact Where AccountId=:hospitalid  limit 1];/*( AND Practitioner.AccountId =:getHospitalName)*/
      }
        
        return getAccountId;
    }
    
    @AuraEnabled(cacheable=false)
    public static boolean sendOTP(Id recordId,string otp) {
        SObject record = SelectRecord.getRecord(recordId,'PersonEmail');
        System.debug('record >>'+record);
        string emailId = String.valueOf(record.get('PersonEmail'));
        System.debug('emailId >>'+emailId);
        if(string.isNotBlank(emailId))
        {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {emailId}; 
                system.debug('toAddresses>>'+toAddresses);
            mail.setToAddresses(toAddresses);
            mail.setSenderDisplayName('Salesforce Support');
            mail.setSubject('Verification Code');
            mail.setBccSender(false);
            mail.setUseSignature(true);
            mail.setHtmlBody('Thanks for verifying your&nbsp;' + emailId + '&nbsp;account! <p>' + 
                             '<b> Your code is:</b>' +OTP );
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            return true;
        }
        return false;
    }
    
    @AuraEnabled
    public static OtpVerifying getPatient(String getEmail){
        Boolean verify=false;
        OtpVerifying verifyOtp=new OtpVerifying();
        Account accList = new Account();
        //if(Account.SObjectType.getDescribe().isAccessible()&&
       // Schema.SObjectType.Account.fields.Id.isAccessible())
     // {
        try{
            accList = [SELECT Id,Name,IsPersonAccount,PersonEmail,Phone FROM Account WHERE (PersonEmail=:getEmail OR Phone=:getEmail) AND IsPersonAccount = true  ];
            if(accList.PersonEmail==getEmail){
                verify=true;
            }
            else if(accList.Phone==getEmail){
                verify=false;
            }
            verifyOtp.patientOtp=accList;
            verifyOtp.confirming=verify;
        
        
    }
    catch(Exception e){
System.debug('Exception :'+ e);
    }
      //}
        return verifyOtp;
    }
    
    @AuraEnabled
    public static String createLead(Lead lead){
        String returnval='';
        Integer count=0;
        Integer phone=0;
        List<Lead> lstlead=new List<Lead>();
        
        try{
            lstlead=[SELECT Id,Name,Email,Phone,LastName,HealthCloudGA__Gender__c,HealthCloudGA__BirthDate__c FROM Lead WHERE Email=:lead.Email OR Phone=:lead.Phone  ];
            for(Lead leadvalue:lstlead){
                if(leadvalue.Email==lead.Email){
                    count++;
                }
                else if(leadvalue.Phone == lead.Phone){
                    phone++;
                }
            }
            if(count > 0){
                returnval='emailexits';
            }
            if(phone > 0){
                returnval='phoneexixts';
            }
            if(count <= 0 && phone <= 0){
                insert lead;
                returnval=lead.Id;
            }
        }
        catch(Exception e){
            System.debug('Exception>>'+ e);
        }
        return returnval;
    }
    
    @AuraEnabled(cacheable=false)
    public static boolean sendOTPs(Id recordId,string otp) {
        SObject record=RecordSelector.getRecord(recordId,'Phone');
        string mobile=String.valueOf(record.get('Phone'));
        system.debug('mobile>>'+mobile);
        if(string.isNotBlank(mobile))
        {
            WhatsAppMessageService.sendMessage('+91'+mobile, 'Your OTP for verifing login at SalesforceCodex.com is :'+OTP);
            return true;
        }
        return false;
    }
    
    @AuraEnabled
    public static List<TimeSlot> getTimeSlots(String contctId,String accntId){
        HealthcarePractitionerFacility createfac=new HealthcarePractitionerFacility();
        List<TimeSlot> getSlots=new List<TimeSlot>();
        if(TimeSlot.SObjectType.getDescribe().isAccessible()&&
        Schema.SObjectType.TimeSlot.fields.Id.isAccessible()&&
        HealthcarePractitionerFacility.SObjectType.getDescribe().isAccessible()&&
        Schema.SObjectType.HealthcarePractitionerFacility.fields.Id.isAccessible())
      {
        if(contctId != null && accntId !=null){
            createfac =[select Id,Name,AccountId,PractitionerId,ServiceTerritoryMember.ServiceTerritory.OperatingHours.TimeZone,ServiceTerritoryMember.ServiceResourceId from HealthcarePractitionerFacility where AccountId=:accntId and PractitionerId=:contctId  ];
            getSlots =[Select DayOfWeek,StartTime,EndTime from TimeSlot where OperatingHoursId=:createfac.ServiceTerritoryMember.ServiceTerritory.OperatingHours.Id  ];
        }
       
    }
        return getSlots;
    }
    
    @AuraEnabled
    public static serveySubject createInvite(String careId,String patientId){
        serveySubject fetchservey=new serveySubject();
        // if(CareSpecialty.SObjectType.getDescribe().isAccessible()&&
        // Schema.SObjectType.CareSpecialty.fields.Id.isAccessible()&&
        // Survey.SObjectType.getDescribe().isAccessible()&&
        // Schema.SObjectType.Survey.fields.Id.isAccessible()&&
        // SurveyInvitation.SObjectType.getDescribe().isAccessible()&&
        // Schema.SObjectType.SurveyInvitation.fields.Id.isAccessible()&&
        // SurveySubject.SObjectType.getDescribe().isAccessible()&&
        // Schema.SObjectType.SurveySubject.fields.Id.isAccessible()){
            Id communityId = [select Id from Network where Name = 'Book an Appointment'].Id;
            System.debug('Network'+communityId);
            CareSpecialty surveyrecId = [Select Id,Name,Survey__c from CareSpecialty where Id =:careId  ];
            System.debug('care'+surveyrecId);
            Survey surveyrec = [Select Id,Name from Survey where Id =:surveyrecId.Survey__c ];
              System.debug('surveyrec'+surveyrec);
            SurveyInvitation sInv = New SurveyInvitation();
            sInv.Name = surveyrec.Name+'Invitation';
            sInv.CommunityId = communityId;
            sInv.OptionsCollectAnonymousResponse = false;
            sInv.OptionsAllowGuestUserResponse = true;
            sInv.SurveyId = surveyrec.Id;
           // if(SurveyInvitation.SObjectType.getDescribe().isAccessible() && SurveyInvitation.SObject.sObjectType.getDescribe().isCreateable()) {
                insert sInv;
          // }
           
            
            SurveySubject sS = new SurveySubject();
            sS.SubjectId = patientId;
            sS.ParentId = sInv.Id;
            sS.Name = sInv.Name+' '+'Subject';
           // if(SurveySubject.SObjectType.getDescribe().isAccessible() && SurveySubject.SObject.sObjectType.getDescribe().isCreateable()) {
                insert sS;
          // }
           
            
            SurveyInvitation sInvRecord = [Select id, InvitationLink from SurveyInvitation where id = :sInv.id  ];
            SurveySubject fetchSubject = [SELECT Id,Name FROM SurveySubject WHERE ParentId=:sInv.Id  ];
            fetchservey.invitationFetch=sInvRecord;
            fetchservey.subjectFetch=fetchSubject;
      //  }
       
        return fetchservey;
    }
    
    @AuraEnabled
    public static patientAndApptData fetchPersonAccountAppointments(String patientId,String status) {
        List<ServiceAppointment>   getApptDetails = new List<ServiceAppointment>();
        Account patientData  = new Account();
        patientAndApptData patientapptDetails = new patientAndApptData();
        if(ServiceAppointment.SObjectType.getDescribe().isAccessible()&&
        Schema.SObjectType.ServiceAppointment.fields.Id.isAccessible()&&
        Account.SObjectType.getDescribe().isAccessible()&&
        Schema.SObjectType.Account.fields.Id.isAccessible()){
            if(PatientId != null && status != null ){
                if(status == 'Completed & Cancelled'){
                    getApptDetails = [SELECT Id,DueDate,AppointmentNumber,SchedEndTime,SchedStartTime,Status FROM ServiceAppointment WHERE AccountId=:patientId AND (Status='Completed' OR Status='Canceled') ];/*( AND Practitioner.AccountId =:getHospitalName)*/
                    patientapptDetails.patientApptDetails = getApptDetails;
                    System.debug('getApptDetails'+getApptDetails);
                }
                if(status == 'Scheduled'){
                    patientData=[Select Id,Name,HealthCloudGA__Gender__pc,PersonMaritalStatus,Phone,PersonMailingCity,PersonMailingCountry ,PersonMailingPostalCode,PersonMailingState,PersonMailingStreet,PersonEmail,PersonBirthdate FROM Account WHERE Id=:PatientId ];
                    getApptDetails = [SELECT Id,DueDate,AppointmentNumber,SchedEndTime,SchedStartTime,Status FROM ServiceAppointment WHERE AccountId=:PatientId AND Status=:status ];/*( AND Practitioner.AccountId =:getHospitalName)*/
                    patientapptDetails.patientDetails = patientData;
                    patientapptDetails.patientApptDetails = getApptDetails;
                                        System.debug('patientData'+patientData);

                }
            }  
            /*if(PatientId == null && status != null && leadId != null){
                if(status == 'Completed & Cancelled'){
                    getApptDetails = [SELECT Id,DueDate,AppointmentNumber,SchedEndTime,SchedStartTime,Status FROM ServiceAppointment WHERE AccountId=:leadId AND (Status='Completed' OR Status='Canceled') ];//( AND Practitioner.AccountId =:getHospitalName)
                    patientapptDetails.patientApptDetails = getApptDetails;
                }
                if(status == 'Scheduled'){
                    patientData=[Select Id,Name,HealthCloudGA__Gender__pc,Phone,BillingCity,BillingCountry ,BillingPostalCode,BillingState,BillingStreet,PersonEmail,PersonBirthdate FROM Account WHERE Id=:leadId ];
                    getApptDetails = [SELECT Id,DueDate,AppointmentNumber,SchedEndTime,SchedStartTime,Status FROM ServiceAppointment WHERE AccountId=:leadId AND Status=:status ];//( AND Practitioner.AccountId =:getHospitalName)
                    patientapptDetails.patientDetails = patientData;
                    patientapptDetails.patientApptDetails = getApptDetails;
                }
            }  */
        }
        return patientapptDetails;
    }
    
    @AuraEnabled
    public static List<HealthcareProviderSpecialty> getHospitalsByCareSpecialiyAndDoctor(String careIds,String doCid ) {
        List<HealthcareProviderSpecialty> getId=new List<HealthcareProviderSpecialty>();
        if(careIds !=null && doCid!= null ){
            getId = [SELECT Account.Id,Account.Website,Account.Phone,Account.BillingAddress,Account.Name ,Account.Image_URL__c,Account.ShippingCity,Account.ShippingCountry,PractitionerId,SpecialtyId    FROM HealthcareProviderSpecialty WHERE SpecialtyId=:careIds AND PractitionerId=:doCid ];
        }
        return getId;
    }

    @AuraEnabled
    public static List<LocationOption> getPortalLocations(String hospitalName, String careId) {
        List<HealthcareProviderSpecialty> mappings = getPortalProviderMappings(hospitalName, careId, null);
        Map<String, LocationOption> uniqueLocations = new Map<String, LocationOption>();

        for (HealthcareProviderSpecialty mapping : mappings) {
            String locationKey = buildPortalLocationKey(mapping.Account.BillingCity, mapping.Account.BillingState, mapping.Account.Name);
            if (!uniqueLocations.containsKey(locationKey)) {
                LocationOption location = new LocationOption();
                location.locationKey = locationKey;
                location.accountId = mapping.AccountId;
                location.accountName = mapping.Account.Name;
                location.city = mapping.Account.BillingCity;
                location.state = mapping.Account.BillingState;
                location.displayLabel = buildPortalLocationLabel(mapping.Account.BillingCity, mapping.Account.BillingState, mapping.Account.Name);
                uniqueLocations.put(locationKey, location);
            }
        }

        return uniqueLocations.values();
    }

    @AuraEnabled
    public static List<HealthcareProviderSpecialty> getPortalBranches(String hospitalName, String careId, String locationKey, String doctorId) {
        List<HealthcareProviderSpecialty> mappings = getPortalProviderMappings(hospitalName, careId, doctorId);
        Map<Id, HealthcareProviderSpecialty> uniqueBranches = new Map<Id, HealthcareProviderSpecialty>();

        for (HealthcareProviderSpecialty mapping : mappings) {
            if (!matchesPortalLocation(locationKey, mapping.Account.BillingCity, mapping.Account.BillingState, mapping.Account.Name)) {
                continue;
            }
            if (!uniqueBranches.containsKey(mapping.AccountId)) {
                uniqueBranches.put(mapping.AccountId, mapping);
            }
        }

        return uniqueBranches.values();
    }

    @AuraEnabled
    public static List<HealthcareProviderSpecialty> getPortalDoctors(String hospitalName, String careId, String locationKey, String doctorId, String branchAccountId) {
        List<HealthcareProviderSpecialty> mappings = getPortalProviderMappings(hospitalName, careId, doctorId);
        List<HealthcareProviderSpecialty> filteredDoctors = new List<HealthcareProviderSpecialty>();

        for (HealthcareProviderSpecialty mapping : mappings) {
            if (String.isNotBlank(branchAccountId) && mapping.AccountId != branchAccountId) {
                continue;
            }
            if (!matchesPortalLocation(locationKey, mapping.Account.BillingCity, mapping.Account.BillingState, mapping.Account.Name)) {
                continue;
            }
            filteredDoctors.add(mapping);
        }
        return filteredDoctors;
    }

    private static List<HealthcareProviderSpecialty> getPortalProviderMappings(String hospitalName, String careId, String doctorId) {
        List<HealthcareProviderSpecialty> mappings = [
            SELECT
                Name,
                Practitioner.Name,
                Practitioner.Id,
                Practitioner.Available_Appointment_Type__c,
                Practitioner.Image_URL__c,
                Practitioner.Doctor_Rating__c,
                Practitioner.Years_of_Experience__c,
                Practitioner.Review_Count__c,
                Practitioner.Priority_Doctor__c,
                Specialty.Name,
                Account.Name,
                Practitioner.AccountId,
                PractitionerId,
                Practitioner.Area_of_Expertise__c,
                Practitioner.Awards_and_Regonitions__c,
                Practitioner.Overview__c,
                Account.Phone,
                Account.Website,
                Account.BillingCity,
                Account.BillingState,
                Account.BillingPostalCode,
                Account.BillingCountry,
                SpecialtyId,
                AccountId,
                Account.Parent.Name
            FROM HealthcareProviderSpecialty
            WHERE AccountId != null
            AND (Account.Parent.Name = :hospitalName OR Account.Name LIKE :('%' + hospitalName + '%'))
        ];

        List<HealthcareProviderSpecialty> filteredMappings = new List<HealthcareProviderSpecialty>();
        for (HealthcareProviderSpecialty mapping : mappings) {
            if (String.isNotBlank(careId) && mapping.SpecialtyId != careId) {
                continue;
            }
            if (String.isNotBlank(doctorId) && mapping.PractitionerId != doctorId) {
                continue;
            }
            filteredMappings.add(mapping);
        }
        return filteredMappings;
    }
    
    @AuraEnabled
    public static List<HealthcareProviderSpecialty> getSpecialityHospiatalByMismatchDoctorsAndHospitals(String doctId) {
        List<HealthcareProviderSpecialty> getAccountId=new List<HealthcareProviderSpecialty>();
            getAccountId = [SELECT  Practitioner.Name ,Practitioner.Image_URL__c,Specialty.Name,Account.Name,Practitioner.AccountId,Practitioner.Available_Appointment_Type__c,PractitionerId,Practitioner.Doctor_Rating__c,Practitioner.Years_of_Experience__c,Practitioner.Review_Count__c,Practitioner.Priority_Doctor__c   FROM HealthcareProviderSpecialty WHERE PractitionerId=:doctId  ];
        return getAccountId;
    }
    
    @AuraEnabled
    Public static String changeLanguageData(String lang){
        String currentuserId = UserInfo.getUserId();
        User currentUserInfo=new User();
        if(User.SObjectType.getDescribe().isAccessible()&&
        Schema.SObjectType.User.isAccessible())
      {
            currentUserInfo = [select LanguageLocaleKey from User where Id = :currentuserId  ];
            currentUserInfo.LanguageLocaleKey =lang;
            if(User.sObjectType.getDescribe().isAccessible()&&
            Schema.sObjectType.User.isUpdateable())
            {
            update currentUserInfo;
            }
      }
        return currentUserInfo.LanguageLocaleKey;
    }
    
    @AuraEnabled
    Public static  List<AllergyIntolerance> fetchallergy(String patientId){
        List<AllergyIntolerance> allergy=new List<AllergyIntolerance>();
       
            allergy=[SELECT Name,Status,PatientId,Type,Category,Severity FROM AllergyIntolerance WHERE PatientId=:patientId ];
      
        return allergy;
    }
    
    @AuraEnabled
    Public static  List<HealthCondition> healthcondition(String patientId){
        List<HealthCondition> condition=new List<HealthCondition>();
       
            condition=[SELECT PatientId,ConditionCodeId,ConditionStatus,DiagnosticStatus,SiteId,ConditionCode.Name,Severity FROM HealthCondition WHERE PatientId=: patientId ];
      
        return condition;
    }
    
    @AuraEnabled
    Public static  List<MedicationRequest> medicationmethod(String patientId){
        System.debug('patientId '+patientId);
        List<MedicationRequest> medic=new List<MedicationRequest>();
       if(patientId!=null){
            medic=[SELECT Medication.Name , Status FROM MedicationRequest WHERE  PatientId=: patientId ];
       }
       
        return medic;
    }
    
    @AuraEnabled
    Public static  List<ClinicalEncounter> latestencounter(String patientId){
        List<ClinicalEncounter> encount=new  List<ClinicalEncounter>();
       
            encount=[SELECT StartDate,Category,Type.Name FROM ClinicalEncounter WHERE  PatientId=: patientId ];
      
        return encount;
    }
    
    @AuraEnabled
    Public static  List<PatientImmunization> immunizationmethod(String patientId){
        List<PatientImmunization> immunize=new List<PatientImmunization>();
        
            immunize=[SELECT VaccineCode.Name ,VaccinationDate,status  FROM PatientImmunization WHERE PatientId=: patientId ];
      
        return immunize;
    }
    
    @AuraEnabled
    Public static  List<PatientMedicalProcedure> medicalproceduremethod(String patientId){
        List<PatientMedicalProcedure> mediprocedure=new List<PatientMedicalProcedure>();
       
            mediprocedure=[SELECT Code.Name,Status FROM PatientMedicalProcedure WHERE PatientId=: patientId ];
      
        return mediprocedure;
    }
    
    @AuraEnabled
    Public static  List<Case> careplanmethod(String patientId){
        List<Case> caseobj=new List<Case>();
        
            caseobj=[SELECT CaseNumber,Subject,Status FROM Case WHERE AccountId=:patientId ];
      
        return caseobj;
    }
    
    @AuraEnabled
    public static List<SurveyQuestionResponse> getSurveyResponce(String invtId){
        List<SurveyQuestionResponse> responce=new List<SurveyQuestionResponse>();
        if(SurveyQuestionResponse.sObjectType.getDescribe().isAccessible()&&
        Schema.sObjectType.SurveyQuestionResponse.isAccessible())
      {
            responce =[Select ResponseValue,QuestionId,ResponseId,InvitationId from SurveyQuestionResponse where InvitationId=:invtId  ];
      }
        return responce;
    }
    
    @AuraEnabled

    public static void deleteSurveyResponce(String invtId){
       SurveyInvitation responce=new SurveyInvitation();
       
            responce =[Select Id from SurveyInvitation where Id=:invtId  ];
          system.debug(responce);
      

        delete responce;
        
    }
    
     @AuraEnabled
    public static String convertLeadToPersonAccount(String leadId) {
        Lead getLeadIds=new Lead();
        if(Lead.SObjectType.getDescribe().isAccessible()&&
        Schema.SObjectType.Lead.isAccessible())
      {
        getLeadIds = [SELECT Id,FirstName,LastName,Phone,Email,Street,City,PostalCode,State,Country,HealthCloudGA__BirthDate__c,HealthCloudGA__Gender__c from Lead where Id=:leadId];/*( AND Practitioner.AccountId =:getHospitalName)*/
        //Account getAccounts =[SELECT Id,FirstName,Phone,PersonEmail,LastName,PersonMailingStreet,PersonMailingState,PersonMailingCountry from Account where IsPersonAccount =true AND Id=:LeadId];      
      }
        Account getAccounts=new Account();
        getAccounts.LastName =  getLeadIds.LastName;
        getAccounts.FirstName =getLeadIds.FirstName;
       getAccounts.Phone = getLeadIds.Phone;
     getAccounts.PersonEmail =getLeadIds.Email;
        getAccounts.PersonMailingStreet =getLeadIds.Street;
          getAccounts.PersonMailingCity =  getLeadIds.City;
        getAccounts.PersonMailingState =  getLeadIds.State;
         getAccounts.PersonMailingCountry =getLeadIds.Country;
        getAccounts.PersonBirthdate	=getLeadIds.HealthCloudGA__BirthDate__c;
         getAccounts.HealthCloudGA__Gender__pc	=getLeadIds.HealthCloudGA__Gender__c;

         if(Account.sObjectType.getDescribe().isAccessible() && Schema.sObjectType.Account.isCreateable()){
         insert getAccounts;
         }
        System.debug('getAccounts >>'+getAccounts.Id);
      
return getAccounts.Id;
}
    
    @AuraEnabled
        public static string getDefaultLanguage() 
        {
            
            String currentuserId = UserInfo.getUserId();
            User currentUserInfo = [select LanguageLocaleKey from User where Id = :currentuserId];
            system.debug('currentUserInfo>>'+currentUserInfo);
            return currentUserInfo.LanguageLocaleKey;
        }
    
    public class CareWrap{
        @AuraEnabled
        public  List<HealthcareProviderSpecialty> practitioners;
        
        @AuraEnabled
        public List<CareSpecialtyTaxonomy> subSpeciality;
        
        @AuraEnabled
        public List<CareSpecialty> speciality;
        
        
    }
    
    public class TimePreview{
        @AuraEnabled
        public  HealthcarePractitionerFacility practitionerfacility;
        
        @AuraEnabled
        public ServiceTerritoryWorkType workTypeName;
        
        @AuraEnabled
        public workTypeGroupMember workTypeGroupName;
        
    }
    public class OtpVerifying{
        @AuraEnabled
        public Account patientOtp;
        
        @AuraEnabled
        public Boolean confirming;
        
    }
    
    public class ServeySubject{
        @AuraEnabled
        public SurveyInvitation invitationFetch;
        
        @AuraEnabled
        public SurveySubject subjectFetch;
        
    }
    public class PatientAndApptData {
        @AuraEnabled
        public Account patientDetails;
        
        @AuraEnabled
        public List<ServiceAppointment> patientApptDetails;
    }
    public class Hospitalss{
        @AuraEnabled
        public List<HealthcareProviderSpecialty> hospitals;
        
        @AuraEnabled
        public Boolean getHospitals;
        
    }

    public class LocationOption {
        @AuraEnabled public String locationKey;
        @AuraEnabled public String accountId;
        @AuraEnabled public String accountName;
        @AuraEnabled public String city;
        @AuraEnabled public String state;
        @AuraEnabled public String displayLabel;
    }

    private static String buildPortalLocationLabel(String city, String state, String accountName) {
        if (String.isNotBlank(city)) {
            return city;
        }
        if (String.isNotBlank(state)) {
            return state;
        }
        return accountName;
    }

    private static String buildPortalLocationKey(String city, String state, String accountName) {
        String cityPart = String.isBlank(city) ? '' : city.trim().toLowerCase();
        String statePart = String.isBlank(state) ? '' : state.trim().toLowerCase();
        if (String.isNotBlank(cityPart) || String.isNotBlank(statePart)) {
            return cityPart + '|' + statePart;
        }

        String accountPart = String.isBlank(accountName) ? '' : accountName.trim().toLowerCase();
        return '||' + accountPart;
    }

    private static Boolean matchesPortalLocation(String locationKey, String city, String state, String accountName) {
        if (String.isBlank(locationKey)) {
            return true;
        }

        List<String> locationParts = locationKey.split('\\|');
        String selectedCity = locationParts.size() > 0 ? locationParts[0] : '';
        String selectedState = locationParts.size() > 1 ? locationParts[1] : '';

        String currentCity = String.isBlank(city) ? '' : city.trim().toLowerCase();
        String currentState = String.isBlank(state) ? '' : state.trim().toLowerCase();
        if (locationKey == buildPortalLocationKey(city, state, accountName)) {
            return true;
        }

        if (String.isNotBlank(selectedCity) && selectedCity == currentCity) {
            return true;
        }

        if (String.isBlank(selectedCity) && String.isNotBlank(selectedState) && selectedState == currentState) {
            return true;
        }

        return false;
    }
      @AuraEnabled
    public static User getUserId( ) {
        String cont = UserInfo.getUserId();
                 System.debug('UserId '+cont);
       User  userId=[select id,name,AccountId from User where Id=:UserInfo.getUserId()];
        System.debug('UserId '+userId);
        return userId;
    } 
    
    @AuraEnabled
    public static String insertDummyAttachment(String PatientId) {
       System.debug('PatientId>>'+PatientId);
         String getAttchmentId = '';
        String searchData = 'data';
        List<String> selectedQuestions = new List<String>();
        selectedQuestions.add('Question 1');
         selectedQuestions.add('Question 2');
        
        // Render the VF page as a PDF
        PageReference pdfPage = Page.PatientTriageGenerativeAI; // Change to your VF page name
        pdfPage.getParameters().put('searchData', searchData);
        
        for (Integer i = 0; i < selectedQuestions.size(); i++) {
            pdfPage.getParameters().put('selectedQuestions[' + i + ']', selectedQuestions[i]);
        }
        
        Blob pdfBlob = pdfPage.getContentAsPDF();

        // Insert the PDF as a file in Salesforce
        if (pdfBlob != null) {
            getAttchmentId = insertPdfAsAttachment(pdfBlob, '0014x00001SkvDNAAZ', '0014x00001SkvDNAAZ');
        }

        return getAttchmentId;
    }

    public static String insertPdfAsAttachment(Blob pdfBlob, String fileName, String parentId) {
        Attachment attachment = new Attachment();
        attachment.ParentId = parentId; // ID of the record to attach the PDF to
        attachment.Name = fileName;
        attachment.Body = pdfBlob;
        attachment.ContentType = 'application/pdf';

        insert attachment;
       
        return attachment.Id;
                }
    @AuraEnabled
    // Method to send a POST request to Flask server
    public static void sendPostRequest(String attachmentId) {
        system.debug('attachmentId>>'+attachmentId);
        String jsonPayload = '{"attachmentId": "' + attachmentId + '"}';
        // Define your JSON payload
        // Define the endpoint URL
        String endpointUrl = 'https://generative-ai-patient-triage-1eba4a129000.herokuapp.com/getId'; // Adjust the URL as per your Flask server's address

        // Create an HTTP request
        HttpRequest httpRequest = new HttpRequest();
        httpRequest.setEndpoint(endpointUrl);
        httpRequest.setMethod('POST');
        httpRequest.setHeader('Content-Type', 'application/json');
        httpRequest.setBody(jsonPayload);

        // Send the HTTP request
        Http http = new Http();
        HttpResponse httpResponse = http.send(httpRequest);

        // Check the response
        if (httpResponse.getStatusCode() == 200) {
            // Successful response
            System.debug('Response: ' + httpResponse.getBody());
        } else {
            // Error handling
            System.debug('Error: ' + httpResponse.getStatus());
        }
    }
}
