trigger Informatica_Job_OnCreateRecord on Informatica_Job__c (before insert, after insert) {
    
    if(Trigger.isInsert && Trigger.isBefore){
        
    }

}