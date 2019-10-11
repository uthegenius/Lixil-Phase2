/*
* Created by: Tectonic (MB) on 7/30/18
* Description: (LCN-2 | Create consumer type contacts via website) - (AM-3) -  system should be able to create the Contact if the Contact does not exists on submission of web-to-case form
* Updated by        Updated on      Reason 
*/


trigger CaseTrg on Case (before insert,after insert,before update,after update) 
{
    System.debug('Trigger Fired top String');
    if(Trigger.isBefore && Trigger.isInsert)
    {         //Contact Us Form
        List<Case> warrantyCases = new List<Case>();
        CaseExtension.addContactToContactUs(Trigger.new);        
        for(Case cs:Trigger.new)
        { 
            if(cs.RecordTypeId==Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Warranty_Registration').getRecordTypeId()&& cs.Origin=='Web')
            {
                warrantyCases.add(cs);
            }           
        }
        if(warrantyCases.size()>0)
        {
            caseTrgHandler.addcon(warrantyCases);
        }
        
        
        caseExtension.addContactToContactUsemail(Trigger.new);
        
    }
    
    
    
    if((Trigger.isBefore&&Trigger.isUpdate))
    {
        List<Case> ccList = new List<Case>();
        List<Case> NonccList = new List<Case>();
        List<Id> ContactIds = new List<Id>();
        for(case cs:Trigger.new)
        {
            if(!string.isBlank(cs.ContactId)){
                ContactIds.add(cs.ContactId);
            }
            if(cs.Team__c!=null && cs.Sub_Team__c!=null && cs.Send_ODMS_email__c==true&&(cs.RecordTypeId==Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Technical_Support').getRecordTypeId()||cs.RecordTypeId==Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Customer_Success').getRecordTypeId()))
            {
                cs.Send_ODMS_email__c=false;
                ccList.add(cs);
            }
            
            if(cs.Additional_Email_to_be_Included__c!=null &&cs.Send_email__c==true &&(cs.RecordTypeId==Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Technical_Support').getRecordTypeId()||cs.RecordTypeId==Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Customer_Success').getRecordTypeId()))
            {
                cs.Send_email__c=false;
                NonccList.add(cs);
                
            }
        }        
        
        if(NonccList.size()>0)
        {    
            
            if(checkRecursive.runOnce())
            {
                CaseExtension.multipleemailstobesend(NonccList);
                
            }
            
            
        }
        
        if(ccList.size()>0)
        {
            if(checkRecursive.runonceforodms())
            {
                CaseExtension.odmsTeam(ccList);
                system.debug('ODMS Team Method ');
                
            }
            
            
        }
        
        caseTrgHandler.queueAssignement(Trigger.new);
        
    }
    
    List<id> sourceIdlist = new List<id>();
    if(Trigger.isAfter && Trigger.isInsert)
    {
        System.debug('After Insert Called 1');
        List<Case> caseTrgList = new List<Case>();
        for(Case cs:Trigger.new)
        {
            if(cs.RecordTypeId!=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Defect_Return').getRecordTypeId() &&cs.origin!='Email')
            {
                caseTrgList.add(cs);
                sourceIdlist.add(cs.sourceid);
            }
        }
        
        if(caseTrgList!=null &&caseTrgList.size()>0)
        {
            caseTrgHandler.createFolderinBox(caseTrgList);
        }
        /*
        ///////////////////////////// Code Added By Kashif ///////////////
         System.debug('After Insert Called');
        set<id> setCaseID = new set<id>();
     	set<id> setCaseSourceId = new set<id>();
     	List<String> listCaseSubject = new List<String>();
     	String TrimmedSubject='';
     	List<String> soqlLikeStr = new List<String>();
     	List<case> listExistingCase;
     	id caseId =null;
        String sourceID;
        for(Case cs:Trigger.new)
        { 
            setCaseSourceId.add(cs.SourceId);
            setCaseID.add(cs.id);
            sourceID = cs.SourceId;
            caseId= cs.id;
            TrimmedSubject = cs.Subject;
            TrimmedSubject = TrimmedSubject.replace('RE:','');
            TrimmedSubject = TrimmedSubject.replace('FW:','');
            TrimmedSubject.trim();
            soqlLikeStr.add('%'+TrimmedSubject+'%');
            listCaseSubject.add(TrimmedSubject);
            listExistingCase = [select id,SourceId,origin, Subject from case where sourceid =: cs.SourceId AND origin='Email' and Subject like: soqlLikeStr LIMIT 2];     
        }  
     	if(listExistingCase.size() > 0)
        {
            List<Messaging.SingleEmailMessage> masterListMails = new List<Messaging.SingleEmailMessage>();
             Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
				email.setSubject('TEST' );
				email.setToAddresses(new String[] {'kashif.ali@gettectonic.com'});
				email.setPlainTextBody('Body: ' +listExistingCase+'<br> TrimmedSubject->'+TrimmedSubject+' setCaseSourceId->'+ sourceID+' '+sourceID);
               masterListMails.add(email);
             
            listExistingCase[0].ParentId =caseId;
            
            if(masterListMails.size() > 0)
    		{
        
       		 Messaging.sendEmail(masterListMails);
       		 System.debug('Email Sent');
    		}
            
        }
		/////////////////////////// Code Added By Kashif///////////////
		*/
        
    }
 
    if(Trigger.isAfter && Trigger.isInsert)
    {   
       
    }    
    
}