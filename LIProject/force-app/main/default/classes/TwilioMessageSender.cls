public with sharing class TwilioMessageSender {
    public static void sendMessage(String mobileNumber, String messageBody){
        HttpRequest req = new HttpRequest();
        // get user specific config (contains the "from" phone number)
        Twilio_Config__c twilioConfig = Twilio_Config__c.getInstance();
        req.setEndpoint('callout:Twilio');
        req.setMethod('POST');
        // make sure to URL Encode the components of the request body which aren't adjacent to the To, From and Body keywords
        String toNumber = EncodingUtil.urlEncode(mobileNumber, 'UTF-8');
        String fromNumber = EncodingUtil.urlEncode(twilioConfig.From_Number__c, 'UTF-8');
        req.setBody('To=' + toNumber + '&From=' + fromNumber + '&Body=' + EncodingUtil.urlEncode(messageBody, 'UTF-8'));
        Http http = new Http();
        HTTPResponse res = http.send(req);
        // throw exception on non 201 response code
        if (res.getStatusCode() != 201){
            throw new TwilioMessageSenderException(res.getBody());
        }
    }

    public class TwilioMessageSenderException extends Exception{}
}
