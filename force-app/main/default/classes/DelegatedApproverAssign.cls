public class DelegatedApproverAssign {
    static Set<id> setQuoteID = new Set<ID>();
    static set<id> setProcInstID = new Set<id>();
    static set<id> setUserId = new set<id>();
    static Integer approvelLevel, approvelStep;
    static boolean isProcess = false;
    @InvocableMethod
    public static void printQuoteID(List<ID> quoteID)
    {
        
        for(Integer i = 0 ; i<quoteID.size(); i++ )
        {
            setQuoteID.add(quoteID.get(i));  
        }
        
        System.debug('Quote ID: ' + setQuoteID);
        updateDelegatedApprover(setQuoteID);
    }
    private static void updateDelegatedApprover(set<ID> quoteId)
    {
        List<ProcessInstance> ProcessInstanceList = [ SELECT id, TargetObjectId,   Status FROM ProcessInstance where TargetObjectId =:quoteId];
            
            System.debug('KA:: Process Inst List SIze : ' + ProcessInstanceList.size());
            for(ProcessInstance procInst : ProcessInstanceList)
            {
                setProcInstID.add(procInst.id);
                
            }
            System.debug('KA:: Process Inst ID : ' + setProcInstID);
            List<ProcessInstanceStep> procInstStep = [select id, stepStatus, ActorID, ProcessInstanceId From ProcessInstanceStep where ProcessInstanceid=:setProcInstID and StepStatus='Started'];
            for(ProcessInstanceStep procStep: procInstStep)
            {
                setUserId.add(procStep.ActorID);   
            }
            System.debug('KA:: Actual User ID : ' + setUserId);
            ID delegatedUserID ;
            List<User> userList =[select DelegatedApproverId from User where ID=:setUserId];
            for(user usr : userList)
            {
              delegatedUserID = usr.DelegatedApproverId ;  
            }
            System.debug('KA:: Delegated User ID : ' + delegatedUserID);
            List<Quote> updatedPosList = new List<Quote>();
            for(Quote positionLst : [Select id, name, Delegated_Owner__c from Quote where id=:setQuoteId])
            {
                positionLst.Delegated_Owner__c = delegatedUserID;
                positionLst.Delegated_Process__c = 'Delegated';
                updatedPosList.add(positionLst);
            }
            System.debug('KA:: Delegated User ID: '+ delegatedUserID);
            update updatedPosList;    
    }
}