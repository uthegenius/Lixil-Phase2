@IsTest
public class AgentWork_BeforeCreate_Test {
    
    static String mdmTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Technical Support').getRecordTypeId();
    
    @isTest
    private static void agentHandlerTest(){
        Case caseRec = new Case();
        caseRec.RecordTypeId = mdmTypeId;
        caseRec.Subject = 'testCase';
        caseRec.Description = 'TTB0333333';
        caseRec.OwnerId =  UserInfo.getUserId(); 
        caseRec.Status = 'Open';
        
        insert caseRec;
        ServiceChannel sc = new ServiceChannel();
        
        //Trigger_Active_Inactive_Flag__mdt objTrgActive = [Select Flag__c from Trigger_Active_Inactive_Flag__mdt where MasterLabel = 'AgentWorkTrg'];
        //objTrgActive.Flag__c = true;
        //update objTrgActive;
        
        ID SChannelId= [SELECT Id FROM ServiceChannel Limit 1].Id;
        system.debug('Service Channel:'+SChannelId);
        User user1 = new User();
        user1.id = UserInfo.getUserId();
        System.runAs(user1){              
            AgentWork awork = new AgentWork();
            awork.UserId = UserInfo.getUserId(); 
            awork.ServiceChannelId = SChannelId;
            awork.WorkItemId = caseRec.Id;
            system.debug(awork);
            insert awork;
            
            update awork;
        }
    }
}