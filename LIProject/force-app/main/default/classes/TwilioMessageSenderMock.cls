@isTest
global class TwilioMessageSenderMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        if (req.getBody().contains('FAIL')){
            // return request body in response body on failure to verify contents of what was sent
            res.setBody('FAILURE to send: ' + req.getBody());
            res.setStatusCode(400);
        } else{
            res.setBody('SUCCESS');
            res.setStatusCode(201);
        }
        return res;
    }
}
