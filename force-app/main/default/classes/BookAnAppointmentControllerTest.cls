@isTest 
     public class BookAnAppointmentControllerTest{

        @isTest
           public static void fetchAcctsTest(){
            List<Account> accList = new List<Account>();
            
               Account acc = new Account();
               acc.Name = 'Apollo Hospital';       
              // accList.add(acc);
              insert acc;
             
               Contact con = new Contact();    
               con.AccountId = acc.Id;        
               con.LastName = 'Stellar';       
               insert con;
           
               CareSpecialty care = new CareSpecialty();    
               care.Name = 'CareSpecialty';                           
               insert care;                       
        Test.startTest();
          BookAnAppointmentController.fetchAccts(con.Id, care.Id);               
       Test.stopTest();
        }        
     }