trigger NotesSharingToCommunity on ContentDocumentLink (after insert) {
    
    set<id> setCDLid = new set<id>();
    if(Trigger.isInsert && Trigger.isAfter)
    {
        System.debug('KA:: ContentDocumentLink Trigger Called');
        for(ContentDocumentLink cdl:Trigger.new)
        { 
        	System.debug('KA:: '+ cdl.id);    
        }
    }
    

}