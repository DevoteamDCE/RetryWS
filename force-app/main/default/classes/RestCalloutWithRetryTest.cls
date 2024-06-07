@isTest
public class RestCalloutWithRetryTest {
@isTest static void testCalloutSuccess() {
        Test.setMock(HttpCalloutMock.class, new MockHttpCallout());
        Map<String, String> header = new Map<String, String>();
		header.put('Content-Type', 'application/json;charset=UTF-8');
        HttpResponse res=RestCalloutWithRetry.sendCalloutWithRetry(header,'https://example.com/example/test','GET', null,   null);
        
        
        // Verify response received contains fake values
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        String expectedValue = '{"example":"test"}';
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, res.getStatusCode());
    }
    
    @isTest static void testCalloutFailed() {
        Test.setMock(HttpCalloutMock.class, new MockHttpCallout()); 
        Map<String, String> header = new Map<String, String>();
		header.put('Content-Type', 'application/json;charset=UTF-8');
        HttpResponse res=RestCalloutWithRetry.sendCalloutWithRetry(header,'https://example.com/example/test/failed','GET', null,   null);
          
        // Verify response received contains fake values
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValuef = res.getBody();
        String expectedValuef = '{"example":"failed"}';
        System.assertEquals(actualValuef, expectedValuef);
        System.assertEquals(404, res.getStatusCode());
    }
}