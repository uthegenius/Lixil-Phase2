/************************
Author:         Muhammad Kashif Ali
Created Date:   20/Nov/2018 
Purpose:        This Trigger will be used to copy brands of wholeselers from Account to Project Brand field.

************************MODIFICATION HISTORY**************************************
Added on             Added By               Description
**********************************************************************************
20/Nov/2018          Muhammad Kashif Ali          Initial Development 
***********************************************************************************/

trigger WholesalersTrg on Wholesalers__c (after insert, after delete, before insert, before update,after update) {
    
    List<Wholesalers__c> WholesalersList = new List<Wholesalers__c>();
    set<String> brands = new set<String>();
    set<id> setProjectId = new set<id>();
    Project__c proj;
    List<Project__c> projectList = new List<Project__c>();
    Set<Id> setwholeSalerID = new Set<Id>();
    id projectID;
    String brandsList;
    
    Set<Id> setAccountId = new Set<Id>();
    if ((Trigger.isbefore) && ( Trigger.isInsert  ||Trigger.isUpdate )){
        map<string,Wholesalers__c> mapWhole = new map<string,Wholesalers__c>();
        for (Wholesalers__c wholeSaler : Trigger.New)
        {
            if( string.isnotblank(wholeSaler.Wholesaler__c) &&
               (
                   Trigger.oldMap==null ||
                   wholeSaler.Wholesaler__c != Trigger.oldMap.get(wholeSaler.Id).Wholesaler__c
               )
              )
                setProjectId.add(wholeSaler.Project__c);
        }
        
        if(!setProjectId.isEmpty()){
            
            Wholesalers__c[] wlsList = [select id,Wholesaler__c,Wholesaler__r.Name,Project__c from Wholesalers__c where Project__c= :setProjectId ];
            
            for (Wholesalers__c wholeSaler : wlsList)
            {
                if(string.isnotBlank( wholeSaler.Wholesaler__c)){
                    mapWhole.put(string.valueof(wholeSaler.Project__c)+string.valueof(wholeSaler.Wholesaler__c), wholeSaler) ;
                }
            }
            
            for (Wholesalers__c wholeSaler : Trigger.New)
            {
                if(mapWhole.containsKey(string.valueof(wholeSaler.Project__c)+string.valueof(wholeSaler.Wholesaler__c)) ){
                    wholeSaler.addError('You can\'t enter wholesale duplicates.');
                }
            }
            
        }
    }
    
    
    else if (Trigger.isAfter){
        /// after insertion of wholesaler
        if(!Trigger.isDelete)
        {
            for (Wholesalers__c wholeSaler : Trigger.New)
            {
                setProjectId.add(wholeSaler.project__c);
                System.debug('KA:: WLS ID: '+ wholeSaler.project__c);
            }  
        }
        else if(Trigger.isDelete)
        {  
            for (Wholesalers__c wholeSaler : Trigger.Old)
            {   
                setProjectId.add(wholeSaler.project__c);
            }  
        }
        ProjectTrgHandler.UpdateWholeSalers(setProjectId);
    }
}