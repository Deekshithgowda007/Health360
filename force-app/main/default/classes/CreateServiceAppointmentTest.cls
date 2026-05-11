@IsTest(SeeAllData=true)
public class CreateServiceAppointmentTest {
    
    @IsTest
    static void testDoPostMethod(){ 
        RestRequest req = new RestRequest(); 
      RestResponse res = new RestResponse();
     
      ServiceApptJSON wrapper =new ServiceApptJSON();
      wrapper.Sending_Application='ApplicationNET';
      wrapper.Sending_Facility='90009';
      wrapper.Receiving_Application='TestInterface';
      wrapper.Context_ID='';
      wrapper.Context_Name='';  
      wrapper.Message_Timestamp='201505181411'; 
      wrapper.Message_Category='SIU';  
      wrapper.Message_Type='SIU-S12';  
      wrapper.Message_ID='185M90009';   
      wrapper.Processing_ID='T';  
      wrapper.HL7_Version='2.3.1';   
      wrapper.Appointment_ID_from_Sending_System='33910';  
      wrapper.Appointment_ID='33910';  
      wrapper.Appointment_Cancel_Reason_ID='';  
      wrapper.Appointment_Cancel_Reason_Info='';
      wrapper.Appointment_Notes='Test Appointment';
      wrapper.Appointment_Type='RWFU';  
      wrapper.Appointment_Type_Full_Name_External_Name='';  
      wrapper.Appointment_Duration='15'; 
      wrapper.Appointment_Duration_Units='Minutes';  
      wrapper.Appointment_start_Date_Time='20220921090000';  
      wrapper.Appointment_End_Date_Time='20220921100000';  
      wrapper.Filler_Contact_Person='aforrest2';  
      wrapper.Appointment_Status='Booked';  
      wrapper.Application_Enterprise_ID='';  
      wrapper.External_Patient_ID='3';  
      wrapper.Patient_ID_Assigning_Authority='';  
      wrapper.ApplicationNet_Patient_ID='105613';  
      wrapper.Patient_Last_Name='LASTNAME';  
      wrapper.Patient_First_Name='FIRSTNAME'; 
      wrapper.Patient_Middle_Initial='MIDDLENAME'; 
      wrapper.Patient_Name_Suffix='Suffix';
      wrapper.Patient_Date_of_Birth='19880601';
      wrapper.Patient_Sex='M';  
      wrapper.Patient_Race_Code='2028-9'; 
      wrapper.Patient_Race_Name='Asian'; 
      wrapper.Address_Line_1='ADDRESS';  
      wrapper.Address_Line_2='ADDRESS(CTD)';  
      wrapper.Patient_Address_City='BRIGHTON';  
      wrapper.Patient_Address_State='MA';
      wrapper.Patient_Address_Zip='02135';  
      wrapper.Patient_Address_Country_Name='UNITED STATES';  
      wrapper.Patient_Phone_Number_Email='Patientemail@email.com'; 
      wrapper.Patient_Phone_Number_Mobile='';
      wrapper.Patient_Phone_Number_Work='';
      wrapper.Patient_Primary_Language_Code='english';
      wrapper.Patient_Primary_Language_Name='eng';
      wrapper.Patient_Marital_Status_Code='S'; 
      wrapper.Patient_Marital_Status_Information='';
      wrapper.Patient_SSN='000000000';
      wrapper.Patient_Ethnic_Group_ID='2186-5';
      wrapper.Patient_Ethnic_Group_Name='Not Hispanic or Latin';
      wrapper.Patient_Class='';
      wrapper.Patient_Primary_Department_Name='1';
      wrapper.Department_Description='';
      wrapper.Primary_Provider_ID='c009';
      wrapper.Primary_Provider_LastName='';
      wrapper.Primary_Provider_FirstName='CHARLA';
      wrapper.Primary_Provider_MiddleInitial='';
      wrapper.Referring_Provider_ID='';
      wrapper.Referring_Provider_LastName='';
      wrapper.Referring_Provider_FirstName='';
      wrapper.Referring_Provider_MiddleInitial='';
      wrapper.Visit_Number='5';
      wrapper.Appointment_DateTime='20220915050000';
      wrapper.Appointment_Video_Visit_Reminder='';
      wrapper.Messages_System_Messages_System='';
      wrapper.Health_PrescriptionReady='';
      wrapper.Health_TestReady='';
      wrapper.Billing_PaymentReminder='';
      wrapper.Appt_day_of_the_week='';
      wrapper.DepartmentPhone='1234567890';
      wrapper.DepartmentAddress='';
        
      system.assertEquals(wrapper.DepartmentAddress,'','success');
    
      req.requestURI='/services/apexrest/createServiceAppointment/*';
      req.httpMethod='POST';
      req.requestBody = Blob.valueOf(JSON.serializePretty(wrapper));
      
           RestContext.request = req;
           RestContext.response= res;
  
        Account acc=new Account();
          acc.Name='Columbia Asia(Account)';
          acc.SourceSystemIdentifier='6';
        insert acc;
       
        Contact con=new Contact();
          con.LastName='Gregor Clegane';
          con.HealthCloudGA__SourceSystemId__c='c002';
        insert con;
        
        Profile pro = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
         User u = new User(
                  alias = 'jliv', 
                  email='jason.liveston@asdf.com', 
                   emailencodingkey='UTF-8',  
                   lastname='Gregor Clegane', 
                   languagelocalekey='en_US', 
                   localesidkey='en_US', 
                   profileId = pro.Id, 
                   timezonesidkey='America/Los_Angeles', 
                   username='deekshi123@gmail.com',
                   isActive = true 
              );
                   insert u;
                                  
        HealthcareProvider provide=new HealthcareProvider();
          provide.Name='Gregor Clegane provider';
          provide.User__c=u.id;
          provide.PractitionerId=con.id;
          provide.SourceSystemIdentifier='3';
        insert provide;
        
        ServiceResource resource=new ServiceResource();
          resource.Name='Raghu';
          resource.RelatedRecordId=u.Id;
          resource.IsActive=true;
        insert resource;
        
        OperatingHours hours=new OperatingHours();
          hours.Name='Hospital Working Hours';
          hours.TimeZone='Asia/Kolkata';
        insert hours;
        
        ServiceTerritory service=new ServiceTerritory();
          service.Name='Banglore';
          service.IsActive=true;
          service.OperatingHoursId=hours.Id;
        insert service;
        
        ServiceTerritoryMember member=new ServiceTerritoryMember();
          member.ServiceTerritoryId=service.Id;
          member.ServiceResourceId=resource.Id;
          member.EffectiveStartDate=Date.newInstance(2022, 09, 15);
          member.EffectiveEndDate=Date.newInstance(2022, 09, 18);
          member.TerritoryType='P';
        insert member;
         
        WorkType type=new WorkType();
          type.id=type.Id;
          type.Name='Dental Care Visit';
          type.Source_System_Id__c='5';
          type.EstimatedDuration=1.00;
        insert type;
          
        WorkOrder order=new WorkOrder();
          order.AccountId=acc.Id;
          order.ContactId=con.Id;
          order.WorkTypeId=type.Id;
          order.ServiceTerritoryId=service.Id;
        insert order;
          
        ServiceAppointment appointment =new ServiceAppointment();
          appointment.SchedStartTime=DateTime.valueOf('2022-09-21 03:30:00');
          appointment.SchedEndTime=DateTime.valueOf('2022-09-21 04:30:00');
          appointment.ContactId=con.Id;
          appointment.ParentRecordId=order.Id;
        insert appointment;
        
        HealthcareProviderSpecialty specialist=new HealthcareProviderSpecialty();
           specialist.SourceSystemIdentifier='2';
           specialist.Name='Dental Care Speciality';
        insert specialist;   
        
        CreateServiceAppoinment.createServiceAppointments(wrapper);
    
        
    }
}