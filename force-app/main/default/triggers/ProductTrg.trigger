trigger ProductTrg on Product2 (after Update, before insert, after insert) 
{
    ProductTrgHandler ProductTrgHandlerObj = new ProductTrgHandler(); 
    if(trigger.IsAfter && Trigger.IsUpdate)
    {    
        set<Id> SetProductIds = new set<Id>();
        List<Product2> ListOFWarrantyProducts = new List<Product2>();
        
        for(Product2 prod: Trigger.New)
        {
            if(prod.Discontinue_date__c != null && prod.Discontinue_date__c >= Date.Today() && prod.Discontinue_date__c != Trigger.OldMap.get(prod.Id).Discontinue_date__c)
            {
                SetProductIds.add(prod.Id);
            }
            
        /*    if(prod.Warranty_years__c != null && !string.isBlank(prod.Warranty_years_description__c))
            {
                ListOFWarrantyProducts.add(prod);
            } */
        }
        
        system.Debug('SetProductIds::'+SetProductIds);
        
        if(SetProductIds.size() > 0)
        {
            Database.executeBatch(new ProductDiscontinuationEmailBatch(SetProductIds));
        }
        
   /*     system.Debug('ListOFWarrantyProducts::'+ListOFWarrantyProducts);
        
        if(ListOFWarrantyProducts.size() > 0)
        {
            ProductTrgHandlerObj.CreateEntitlements(ListOFWarrantyProducts);
        } */
    }

    if(trigger.isBefore && trigger.isInsert){
        ProductTrgHandlerObj.OnBeforeInsert( Trigger.new, Trigger.newMap );
    }else if(trigger.isAfter && trigger.isInsert){
        ProductTrgHandlerObj.OnAfterInsert( Trigger.new, Trigger.newMap );
        
        
    }
}