@isTest
global class TwilioMessageSenderMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        if (req.getBody().contains('FAIL')){
            res.setBody('FAILURE');
            res.setStatusCode(400);
        } else{
            res.setBody('SUCCESS');
            res.setStatusCode(201);
        }
        return res;
    }
}
