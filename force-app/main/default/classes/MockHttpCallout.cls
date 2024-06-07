@isTest
global class MockHttpCallout implements HttpCalloutMock {
	global HTTPResponse respond(HTTPRequest req) {
        if(req.getEndpoint() == 'https://example.com/example/test'){
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"example":"test"}');
            res.setStatusCode(200);
            return res;
        } else{
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"example":"failed"}');
            res.setStatusCode(404);
            return res;
        }
        
    }
}