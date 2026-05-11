public with sharing class ServiceAppointmentCreating {
    
    public static string patientId;
    
    public static Boolean doesPateintExists(Map<String,String> jsons){
        Boolean patientExists = false;
        if(jsons != null){
            Account patientData = new Account();
            try{
                patientData = [select SourceSystemIdentifier from account where SourceSystemIdentifier =:jsons.get('External_Patient_ID') WITH SECURITY_ENFORCED];
                patientExists = true;
                patientId = patientData.Id;
            }
            catch(exception e){
                JSONGenerator gen = JSON.createGenerator(true);
                gen.writeStartObject();
                gen.writeStringField('code','E1002');
                gen.writeStringField('message', 'Patient Does not Exist');
                gen.writeEndObject();
                String jsonData = gen.getAsString();
                throw new ServiceApptException(jsonData);
            }
        }
        return patientExists;
    }
    
    
    public static JsonWrapper createServiceAppointments(Map<String,String> jsons){
        
        Account facility = new Account();
        try{
            facility = [select Name,SourceSystemIdentifier from account where SourceSystemIdentifier =:jsons.get('Department_Id') WITH SECURITY_ENFORCED];
        }
        catch(exception e){
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            gen.writeStringField('code','E1003');
            gen.writeStringField('message', 'Department Does not Exist');
            gen.writeEndObject();
            String jsonData = gen.getAsString();
            throw new ServiceApptException(jsonData);
        }
        
        contact practitioner = new contact();
        try{
            practitioner = [select name,HealthCloudGA__SourceSystemId__c from contact where HealthCloudGA__SourceSystemId__c=:jsons.get('Primary_Provider_ID') WITH SECURITY_ENFORCED];
        }
        catch(exception ex){
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            gen.writeStringField('code','E1004');
            gen.writeStringField('message', 'Provider Does not Exist');
            gen.writeEndObject();
            String jsonData = gen.getAsString();
            throw new ServiceApptException(jsonData);
        }
        
        HealthcarePractitionerFacility practitonerFacility = new HealthcarePractitionerFacility();
        try{
            practitonerFacility = [select Id,Name,AccountId,PractitionerId,ServiceTerritoryMember.ServiceTerritoryId,ServiceTerritoryMember.ServiceResourceId from HealthcarePractitionerFacility where AccountId=:facility.Id and PractitionerId=:practitioner.Id WITH SECURITY_ENFORCED];
        }catch(exception ex){
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            gen.writeStringField('code','E1005');
            gen.writeStringField('message', 'Healthcare Provider Department Does not Exist');
            gen.writeEndObject();
            String jsonData = gen.getAsString();
            throw new ServiceApptException(jsonData);
        }
        
        if(practitonerFacility.ServiceTerritoryMember == null){
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            gen.writeStringField('code','E1006');
            gen.writeStringField('message', 'Service Territory member missng in Healthcare Provider Department');
            gen.writeEndObject();
            String jsonData = gen.getAsString();
            throw new ServiceApptException(jsonData);
        }
        
        WorkType workTypes = new WorkType();
        try{
            workTypes = [select Id,Name,Source_System_Id__c from WorkType where Source_System_Id__c=:jsons.get('Appointment_Type') WITH SECURITY_ENFORCED ];
        }
        catch(exception ex){
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            gen.writeStringField('code','E1007');
            gen.writeStringField('message', 'Work Type does not exists');
            gen.writeEndObject();
            String jsonData = gen.getAsString();
            throw new ServiceApptException(jsonData);
        }
        
        String startDate = jsons.get('Appointment_start_Date_Time');
        String startDateTimes = startDate.substring(0,4)+'-'+
            startDate.substring(4,6)+'-'+
            startDate.substring(6,8)+' '+
            startDate.substring(8,10)+':'+
            startDate.substring(10,12)+ ':'+
            startDate.substring(12,14);
        DateTime schedstartDate = datetime.valueOf(startDateTimes);
        
        String endDate = jsons.get('Appointment_End_Date_Time');
        String endDateTimes = endDate.substring(0,4)+'-'+
            endDate.substring(4,6)+'-'+
            endDate.substring(6,8)+' '+
            endDate.substring(8,10)+':'+
            endDate.substring(10,12)+ ':'+
            endDate.substring(12,14);
        DateTime schedEndDate = DateTime.valueOf(endDateTimes);
        
        String appDate = jsons.get('Appointment_DateTime');
        String appDateTimes = endDate.substring(0,4)+'-'+
            endDate.substring(4,6)+'-'+
            endDate.substring(6,8)+' '+
            endDate.substring(8,10)+':'+
            endDate.substring(10,12)+ ':'+
            endDate.substring(12,14);
        DateTime appEndDate = DateTime.valueOf(appDateTimes);
        system.debug('appEndDate....'+appEndDate);
        
        List<ServiceAppointment> serviceAppt = [select SchedStartTime,SchedEndTime,(select Id,HealthcarePractitionerFacility.PractitionerId from CarePractnFacilityAppts where HealthcarePractitionerFacility.PractitionerId=:practitioner.Id),ContactId from ServiceAppointment where SchedStartTime=:schedstartDate and SchedEndTime=:schedEndDate WITH SECURITY_ENFORCED ]; //end 2022-09-08T12:30:00+0530 start 2022-09-08T11:30:00+0530
        if(serviceAppt.size() > 0){
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            gen.writeStringField('code','E1008');
            gen.writeStringField('message', 'Service Appointment already exist for this time slot');
            gen.writeEndObject();
            String jsonData = gen.getAsString();
            throw new ServiceApptException(jsonData);
        }
        
        List<JF_SF_Field_Mapping__c> jsonValue =[SELECT Name,SF_Object_Field_Name__c,Json_Value__c,Required_Fields__c,ObjectNames__c FROM JF_SF_Field_Mapping__c];
        system.debug('jsonValue>>'+jsonValue);
        List<ConnectApi.ExtendedFieldInput> extendedFieldList = new List<ConnectApi.ExtendedFieldInput>();
        for(JF_SF_Field_Mapping__c jsonfields:jsonValue){
            system.debug('');
            if(jsonfields.ObjectNames__c=='ServiceAppointment'&&jsonfields.SF_Object_Field_Name__c!='SchedStartTime'&&jsonfields.SF_Object_Field_Name__c!='SchedEndTime'){
                system.debug('jsonfields>>'+jsonfields);
                ConnectApi.ExtendedFieldInput fieldinput = new ConnectApi.ExtendedFieldInput();
                fieldinput.Name=jsonfields.SF_Object_Field_Name__c;
                if(jsonfields.SF_Object_Field_Name__c=='DueDate'){
                    
                    system.debug('appEndDate>>'+appEndDate);
                    fieldinput.value=appEndDate.format('yyyy-MM-dd\'T\'HH:mm:ssZ');
                    
                }
                else{
                    fieldinput.value=jsons.get(jsonfields.Name);
                }
                extendedFieldList.add(fieldinput);
            }
        }
        
        system.debug('extendedFieldList>>'+extendedFieldList);
        
        ConnectApi.ServiceAppointmentInput serviceAppInput = new ConnectApi.ServiceAppointmentInput();
        serviceAppInput.extendedFields = extendedFieldList;
        serviceAppInput.serviceTerritoryId = practitonerFacility.ServiceTerritoryMember.ServiceTerritoryId ;
        serviceAppInput.ParentRecordId = patientId;
        serviceAppInput.workTypeId =workTypes.Id;
        system.debug('schedstartDate>'+schedstartDate);
        system.debug('schedEndDate>>'+schedEndDate);
        serviceAppInput.schedStartTime =schedstartDate;
        serviceAppInput.schedEndTime = schedEndDate;
        
        ConnectApi.CreateServiceAppointmentInput createInput = new ConnectApi.CreateServiceAppointmentInput();
        createInput.serviceAppointment = serviceAppInput;
        
        String serviceAppointmentId = '';
        ConnectApi.ServiceAppointmentOutput appointmentResult;
        try{
            appointmentResult = ConnectApi.LightningScheduler.createServiceAppointment(createInput);
            serviceAppointmentId = appointmentResult.result.serviceAppointmentId;
            List<String> assignedResourceIds = appointmentResult.result.assignedResourceIds; 
            
            AssignedResource assignedResources = new AssignedResource();
            assignedResources.ServiceResourceId =practitonerFacility.ServiceTerritoryMember.ServiceResourceId;
            assignedResources.ServiceAppointmentId = serviceAppointmentId;
            if(Schema.sObjectType.AssignedResource.isCreateable()){  //This condition checking if the user has the Persmission to insert for this object
                insert assignedResources;
            }
            
            CarePractnFacilityAppt practnFacilityAppt = new CarePractnFacilityAppt();
            practnFacilityAppt.HealthcarePractitionerFacilityId = practitonerFacility.Id;
            practnFacilityAppt.ServiceAppointmentId = serviceAppointmentId;
            practnFacilityAppt.Name = 'SA-'+practitonerFacility.Name;
            if(Schema.sObjectType.CarePractnFacilityAppt.isCreateable()){  //This condition checking if the user has the Persmission to insert for this object
                insert practnFacilityAppt;
            }
            
        }catch(ConnectApi.ConnectApiException ex){
            system.debug('exception:'+ex);
            system.debug('ex.getLineNumber()>>'+ex.getLineNumber()+ ex.getMessage()+':'+'Cause:'+ex.getCause());
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            gen.writeStringField('code','E1009');
            gen.writeStringField('message', 'Error while creating Service Appointment:'+ex);
            gen.writeEndObject();
            String jsonData = gen.getAsString();
            throw new ServiceApptException(jsonData);
        }
        JsonWrapper serviceApptDetail = new JsonWrapper();
        serviceApptDetail.serviceAppointment_Id = serviceAppointmentId;
        serviceApptDetail.Appointment_ID = jsons.get('Appointment_ID');
        serviceApptDetail.Patient_ID = jsons.get('External_Patient_ID');
        serviceApptDetail.Appointment_Status = jsons.get('Appointment_Status');
        serviceApptDetail.exceptionOccured = 'false';
        serviceApptDetail.Appointment_Date_and_Time = jsons.get('Appointment_DateTime');
        return serviceApptDetail;
    }
    
    
    public class JsonWrapper{  
        public String serviceAppointment_Id;
        public string Appointment_ID;
        public string Patient_ID;
        public string Appointment_Status;
        public string Appointment_Date_and_Time;
        public String exceptionOccured;
    }
    
    public class ExceptionDetails{
        public string code;
        public string field;
        public string message;
    }
    
    
}