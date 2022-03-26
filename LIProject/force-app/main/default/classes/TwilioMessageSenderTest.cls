@isTest
public with sharing class TwilioMessageSenderTest {
    @TestSetup
    static void makeData(){
        Twilio_Config__c twilioConfig = TestDataFactory.twilioConfig();
    }

    @isTest
    static void testSendSuccess() {
        // on success everything should go fine, no exception raised
        Boolean exceptionOccurred = false;
        Test.setMock(HttpCalloutMock.class, new TwilioMessageSenderMock());
        try{
            Test.startTest();
            TwilioMessageSender.sendMessage('+441111111111', 'success');
            Test.stopTest();
        } catch(TwilioMessageSender.TwilioMessageSenderException e){
            exceptionOccurred = true;
        }
        System.assert(exceptionOccurred == false);
    }

    @isTest
    static void testSendFail() {
        // on failure a custom exception will be raised
        Boolean exceptionOccurred = false;
        Test.setMock(HttpCalloutMock.class, new TwilioMessageSenderMock());
        try{
            Test.startTest();
            TwilioMessageSender.sendMessage('+441111111111', 'FAIL');
            Test.stopTest();
        } catch(TwilioMessageSender.TwilioMessageSenderException e){
            exceptionOccurred = true;
        }
        System.assert(exceptionOccurred == true);
    }
}
