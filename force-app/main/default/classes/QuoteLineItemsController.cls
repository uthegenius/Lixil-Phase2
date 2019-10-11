public class QuoteLineItemsController {
    @AuraEnabled    
    public static List < Account > fetchAccts() {    
        
        return [ SELECT Id, Name, Industry, Type, CreatedDate FROM Account LIMIT 100 ];    
        
    }    
    
    @AuraEnabled    
    public static boolean updateAccts( List < Account > updatedAccountList ) {    
        
        try {  
            
            update updatedAccountList;  
            return true;  
            
        } catch(Exception e) {  
            
            return false;  
            
        }  
        
    }    
}