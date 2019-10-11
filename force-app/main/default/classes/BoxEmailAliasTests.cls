@IsTest
public class BoxEmailAliasTests {
	public static testmethod void testParseMember() {
        BoxApiConnection api = new BoxApiConnection('accesstoken');
		BoxEmailAlias boxEmailAlias = new BoxEmailAlias(api,'10543463');
		BoxEmailAlias.Info emailAliasInfo = new BoxEmailAlias.Info();
		emailAliasInfo.addValue('email', 'test@box.com');
        String mockResponseBody = '{"chunk_size": 3,"next_stream_position": "28893355","entries": [{"source": null,"created_by": {"type": "user","id": "181216415","name": "sean rose","login": "sean+awesome@box.com"},"created_at": "2012-12-12T10:53:43-08:00","event_id": "28893270","event_type": "ADD_LOGIN_ACTIVITY_DEVICE","ip_address": "67.218.117.3","type": "event","session_id": null},{"source": null,"created_by": {"type": "user","id": "181216415","name": "sean rose","login": "sean+awesome@box.com"},"created_at": "2012-12-12T10:53:43-08:00","event_id": "28893272","event_type": "LOGIN","ip_address": "67.218.117.3","type": "event","session_id": null},{"source": {"type": "folder","id": "387630341","sequence_id": "0","name": "A BNE"},"created_by": {"type": "user","id": "181216415","name": "sean rose","login": "sean+awesome@box.com"},"created_at": "2012-12-12T10:53:43-08:00","event_id": "28893354","event_type": "UPLOAD","ip_address": "67.218.117.3","type": "event","session_id": null}]}';
    	BoxGenericJsonObject responseObject = new BoxGenericJsonObject(mockResponseBody);
        emailAliasInfo.addValue('name', responseObject); 
        BoxEmailAlias.Info emailAliasInfo2 = new BoxEmailAlias.Info(responseObject);
        //emailAliasInfo.addValue('email', (BoxJsonObject)JSON.deserialize('{"email": "test@box.com"}', BoxJsonObject.class));
        
		Test.startTest();
		emailAliasInfo.parseMember('is_confirmed', 'true');
		emailAliasInfo.parseMember('email','testEmail@box.com');
        Test.stopTest();

        System.assertEquals('emailalias', boxEmailAlias.getObjectType());
		System.assertEquals(true, emailAliasInfo.isConfirmed);
		System.assertEquals('testEmail@box.com', emailAliasInfo.email);
     }
}