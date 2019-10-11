@isTest
public class AttachmentTrgTest 
{
	@isTest
    static void createAttachmentTest()
    {
    	Test.startTest();
        Blob blb = Blob.valueOf('Test data for attachment');
        
        Asset acc1 = UtilityTest.CreateAsset();
        
        Attachment att = new Attachment();
        att.ParentId = acc1.Id;
        att.Body = blb;
        att.Name = 'Test Attachment';
        insert att;
        
        Test.stopTest();
    }
}