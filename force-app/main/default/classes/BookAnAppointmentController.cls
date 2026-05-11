public class BookAnAppointmentController {
    
    @AuraEnabled
     public static List<Account> fetchAccts(String ConId,String SpecId) {
        List<Account> accList = new List<Account>();
       
            accList = [ SELECT Id, (select id from Contacts),Name FROM Account ];
        
        return accList;
    }
    

}