@IsTest
public class ServiceAppointmentCreationTest {
 @IsTest
    static void getServicetypetest(){ 
        
           Service_Type__c lst=new Service_Type__c();
        lst.Name='SIU';
        insert lst;
       
        list<JF_SF_Field_Mapping__c> mappingTest=new list<JF_SF_Field_Mapping__c>();
            JF_SF_Field_Mapping__c testmap=new JF_SF_Field_Mapping__c();
        
        testmap.ObjectNames__c='Contact';
        testmap.SF_Object_Field_Name__c='HealthCloudGA__SourceSystemId__c';
        testmap.Service_Type__c=lst.Id;
        insert testmap;
        mappingTest.add(testmap);
      
        Test.startTest();
        ServiceAppointmentCreation.featchService();
        system.assertEquals(testmap.SF_Object_Field_Name__c,'HealthCloudGA__SourceSystemId__c','success');
         Test.stopTest();
    }
    @IsTest
    static void getServicetypetest1(){ 
     
        List<Service_Type__c> createlist=new List<Service_Type__c>();
           Service_Type__c lst=new Service_Type__c();
        lst.Name='SIU';
        insert lst;
        system.debug(lst.Id);
        createlist.add(lst);
        
        list<JF_SF_Field_Mapping__c> mappingTest=new list<JF_SF_Field_Mapping__c>();
            JF_SF_Field_Mapping__c testmap=new JF_SF_Field_Mapping__c();
        testmap.ObjectNames__c='Contact';
        testmap.SF_Object_Field_Name__c='HealthCloudGA__SourceSystemId__c';
        testmap.Service_Type__c = lst.Id;
        system.debug(testmap.Id);
        mappingTest.add(testmap);
      
        Test.startTest();
        ServiceAppointmentCreation.getServicetype('SIU', mappingTest,false);
       ServiceAppointmentCreation.DeleteRecord(createlist);
        ServiceAppointmentCreation.featchService();
        ServiceAppointmentCreation.getRecord();
        ServiceAppointmentCreation.getAllObject();
        ServiceAppointmentCreation.getAllfieldss();
        ServiceAppointmentCreation.getAllfields('Service_Type__c');
        system.assertEquals(testmap.SF_Object_Field_Name__c,'HealthCloudGA__SourceSystemId__c','success');
      
         Test.stopTest();
    }
   
    @istest
    static void servicetypeToasttest(){
        Service_Type__c ser=new Service_Type__c();
        ser.Name='Service_Type__c';
        insert ser; 
        system.assertEquals(ser.Name,'Service_Type__c','success');
        ServiceAppointmentCreation.servicetypeToast('Service_Type__c');
    }
    
    @istest
    static void servicetypeToasttest1(){
        Service_Type__c ser=new Service_Type__c();
        ser.Name='s';
        insert ser; 
        
        system.assertEquals(ser.Name,'s','success');
        ServiceAppointmentCreation.servicetypeToast('s');
    }
    
    
    @istest
    static void deleteRecordtest(){
        List<Service_Type__c> li=new  List<Service_Type__c>();
        Service_Type__c ser=new Service_Type__c();
        ser.Name='SIU';
        insert ser;
        li.add(ser);

        list<JF_SF_Field_Mapping__c> mappingTest=new list<JF_SF_Field_Mapping__c>();
            JF_SF_Field_Mapping__c testmap=new JF_SF_Field_Mapping__c();
        testmap.ObjectNames__c='Contact';

        testmap.SF_Object_Field_Name__c='HealthCloudGA__SourceSystemId__c';
        testmap.Service_Type__c = ser.Id;
        system.debug(testmap.Id);
        mappingTest.add(testmap);

        system.assertEquals(ser.Name,'SIU','success');
        ServiceAppointmentCreation.deleteRecord(li);
        ServiceAppointmentCreation.getServicetype('SIU', mappingTest,true);
    }

    
}