public class PlatformEventsDemo 
{
    public static void PublishDemoEvent(String message)
    {
        New_Email__e event = new New_Email__e(Message__c=message);
                Database.SaveResult result = EventBus.publish(event);
                if (!result.isSuccess()) 
        {
            for (Database.Error error : result.getErrors()) 
            {
                System.debug('Error returned: ' +
                             error.getStatusCode() +' - '+
                             error.getMessage());
            }
        }
    }
}