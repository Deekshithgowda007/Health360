public with sharing class ServiceAppointmentCreation {
    
    @AuraEnabled
    public static void getServicetype(String services,list<JF_SF_Field_Mapping__c> jsonData, Boolean jsonedit){
        if(jsonedit==false){
        Service_Type__c newService = new Service_Type__c(Name=services);
        system.debug('services>>'+services);
      //  if(newService.Name!=null){
        Service_Type__c newServices = new Service_Type__c();
        if(Service_Type__c.sObjectType.getDescribe().isAccessible() && Schema.sObjectType.Service_Type__c.isCreateable()){
        insert newService;
        }
        
        List<JF_SF_Field_Mapping__c> data=new List<JF_SF_Field_Mapping__c>();
        for(JF_SF_Field_Mapping__c jsonvalue:jsonData){
            jsonvalue.Service_Type__c=newService.id;
            data.add(jsonvalue);
        }
        system.debug('data>>'+data);
        if(JF_SF_Field_Mapping__c.sObjectType.getDescribe().isAccessible() && Schema.sObjectType.JF_SF_Field_Mapping__c.isCreateable()){ 
        insert data;
        }
    }
        
        else{
            List<JF_SF_Field_Mapping__c> fetching=[SELECT Name,SF_Object_Field_Name__c,ObjectNames__c,Service_Type__c FROM JF_SF_Field_Mapping__c WITH SECURITY_ENFORCED];
            
            for(Integer i=0;i<fetching.size();i++){
                fetching[i].SF_Object_Field_Name__c=jsonData[i].SF_Object_Field_Name__c;
                fetching[i].ObjectNames__c=jsonData[i].ObjectNames__c;
            }
            if(JF_SF_Field_Mapping__c.sObjectType.getDescribe().isAccessible() && Schema.sObjectType.JF_SF_Field_Mapping__c.isUpdateable()){ 
            update fetching;
            }
        }
    }
    
    @AuraEnabled
    public static List<Service_Type__c> featchService() {
        List<Service_Type__c> getService = new  List<Service_Type__c>();
        getService = [SELECT Id, Name FROM Service_Type__c];

        return getService;
    }
    
    
    @AuraEnabled
    public static void deleteRecord(List<Service_Type__c> deleteIds) {
        List<Service_Type__c> delacccon = new List<Service_Type__c>();
        for(Service_Type__c con : [SELECT Id, Name FROM Service_Type__c WHERE Id IN : deleteIds]){
            delacccon.add(con);
        }
        if(delacccon.size() > 0){
            if(Service_Type__c.sObjectType.getDescribe().isAccessible() && Schema.sObjectType.Service_Type__c.isDeletable()){ 
            Delete  delacccon;
            }
        }

    }
    
    @AuraEnabled
    public static Boolean servicetypeToast(String objects){
        Boolean siuPresent=false;
        Service_Type__c jsonType =[SELECT Name FROM Service_Type__c WHERE Name =:objects];
    if(jsonType.Name == objects){
        siuPresent=true;
    }
    else{
         siuPresent=false;
    }
       return siuPresent;
    }

    @AuraEnabled
    public static List<JF_SF_Field_Mapping__c> getRecord(){
        List<JF_SF_Field_Mapping__c> fetchrecord= [SELECT Name,SF_Object_Field_Name__c,ObjectNames__c FROM JF_SF_Field_Mapping__c];
        system.debug('fetchrecord>>'+fetchrecord);
        return fetchrecord;
    }
    

    @AuraEnabled//Method to get the List of All Objects
    public static Map<String, String> getAllObject(){
        Map<String,String> returnObjectMap = new Map<String,String>();
        Map<String, Schema.SObjectType> objectMap = Schema.getGlobalDescribe();
        List<Schema.SObjectType> objectMapValues = objectMap.Values();
        System.debug('All Objects '+ objectMapValues);
        
        for(Schema.SObjectType objType : objectMapValues){
            String key = objType.getDescribe().getName();
            String value = objType.getDescribe().getLabel();
            returnObjectMap.put(key,value);
        }
        System.debug(returnObjectMap);
        if(returnObjectMap != null && returnObjectMap.size() > 0){
            return returnObjectMap;
        }else{
            return null;
        }
    }
    
    @AuraEnabled
    public static List<String> getAllfields(String objectName){
        system.debug('objectName>>'+objectName);
        List<String> allFields = new List<String>();
        
        Map<String, Schema.SObjectType> objectMap = Schema.getGlobalDescribe();
        SObjectType objType = objectMap.get(objectName);
        
        Map<String,Schema.SObjectField> objTypeFields = objType.getDescribe().fields.getMap();
        if(!objTypeFields.isEmpty()){
            for (String fieldName: objTypeFields.keySet()) {
                String fieldLabel = objTypeFields.get(fieldName).getDescribe().getLabel();
                allFields.add(fieldName);
            }
        }
        System.debug(allFields);
        return allFields;
    }
    
    @AuraEnabled
    public static ObjectListWrap getAllfieldss(){
        // system.debug('objectName>>'+objectName);
        Object_Type__mdt objectlist=Object_Type__mdt.getInstance('Object_List');
        system.debug('objectlist>>'+objectlist);
        List<String> objTypes=objectlist.Object_List__c.split(',');
        
        Map<String,List<String>> objFields = new Map<String,List<String>>();
        
        Map<String, Schema.SObjectType> objectMap = Schema.getGlobalDescribe();
        for(Integer i=0;i<objTypes.size();i++){
            List<String> allFields = new List<String>();
            system.debug('inside for>>'+i);
            SObjectType objType = objectMap.get(objTypes[i]);
            system.debug('objType'+objType);
            Map<String,Schema.SObjectField> objTypeFields = objType.getDescribe().fields.getMap();
            if(!objTypeFields.isEmpty()){
                system.debug('objTypeFields>>'+objTypeFields);
                for (String fieldName: objTypeFields.keySet()) {
                    system.debug('inside 2for>>'+fieldName);
                    String fieldLabel = objTypeFields.get(fieldName).getDescribe().getLabel();
                    allFields.add(fieldName);
                }
                objFields.put(objTypes[i], allFields);
                system.debug('objFields>>'+objFields);
            }
        }
        ObjectListWrap objWrap=new ObjectListWrap();
        objWrap.objectfieldmap=objFields;
        objWrap.objectList=objTypes;
        System.debug('objWrap>>'+objWrap);
        return ObjWrap;
        
    }
    public class ObjectListWrap{
        @AuraEnabled
        public  Map<String,List<String>> objectfieldmap;
        @AuraEnabled
        public List<String> objectList;
        
    }
   
     public static void upsertRecord(String value){
         System.debug(value);
       //fetch records
       List<JF_SF_Fields_Mapping__mdt> metaList = [Select DeveloperName,MasterLabel,SF_Object_Field_Name__c,ObjectNames__c,Json_Field_Name__c From JF_SF_Fields_Mapping__mdt];
       
       //instance of the record
       Metadata.CustomMetadata mdata = new Metadata.CustomMetadata();
   mdata.fullName = 'Admin User.JF_SF_Fields_Mapping__mdt'+metaList[0].DeveloperName;
       
         mdata.label=metaList[0].MasterLabel;
         System.debug(mdata);
       
       //instance of the value
       Metadata.CustomMetadataValue instance = new Metadata.CustomMetadataValue();
  
         instance.field = 'Json_Field_Name__c';
         
       instance.value = value;
       
       //adding the value to the record
       mdata.values.add(instance);
       
       //instance of the container
       Metadata.DeployContainer container = new Metadata.DeployContainer();
       container.addMetadata(mdata);
       System.debug(container);
         
       
       //enqueue deployment to the salesforce org
     String getName =  Metadata.Operations.enqueueDeployment(container, null);
         System.debug(getName);
       
    }
    
    
    
    
    
}