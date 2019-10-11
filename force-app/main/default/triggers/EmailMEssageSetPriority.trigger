trigger EmailMEssageSetPriority on EmailMessage (before insert, after insert)  {
	
    if(trigger.IsBefore && Trigger.IsInsert)
    {
        

		 
        for(EmailMessage em: Trigger.New)
        {
           em.headers = 'Importance: High';
        }
    }
}