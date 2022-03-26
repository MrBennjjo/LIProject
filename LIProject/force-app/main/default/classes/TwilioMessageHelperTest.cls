@isTest
public with sharing class TwilioMessageHelperTest {
    @TestSetup
    static void makeData(){
        Account goldAccount = TestDataFactory.goldAccount('Golden');
        Twilio_Config__c twilioConfig = TestDataFactory.twilioConfig();
    }

    @isTest
    static void testSendSuccess() {
        // on success everything should go fine, no exception raised
        Boolean exceptionOccurred = false;
        Account acc = [SELECT Id FROM Account WHERE Name = 'Golden' LIMIT 1];
        Test.setMock(HttpCalloutMock.class, new TwilioMessageSenderMock());
        try{
            Test.startTest();
            TwilioMessageHelper.sendAccountMessage(acc.Id, 'success');
            Test.stopTest();
        } catch(AuraException e){
            exceptionOccurred = true;
        }
        System.assert(exceptionOccurred == false);
    }

    @isTest
    static void testSendFail() {
        // on failure a custom exception will be raised
        Boolean exceptionOccurred = false;
        Account acc = [SELECT Id FROM Account WHERE Name = 'Golden' LIMIT 1];
        Test.setMock(HttpCalloutMock.class, new TwilioMessageSenderMock());
        try{
            Test.startTest();
            TwilioMessageHelper.sendAccountMessage(String.valueOf(acc.Id), 'FAIL');
            Test.stopTest();
        } catch(AuraException e){
            exceptionOccurred = true;
        }
        System.assert(exceptionOccurred == true);
    }

    @isTest 
    static void testSendCEOMessage(){
        // we're going to send a failing message so we can verify the body of the message matches the expected format
        Boolean exceptionOccured = false;
        Account acc = [SELECT Id FROM Account WHERE Name = 'Golden' LIMIT 1];
        Opportunity opp = new Opportunity(Amount=1000, StageName='Closed Won', CloseDate = Date.Today(), Name='FAIL', AccountId=acc.Id);
        insert opp;
        // expected output - needs url encoded to make sure it matches
        String expectedOutput = EncodingUtil.urlEncode('Golden closed on FAIL for £1,000 at ' + (Date.today()).format(), 'UTF-8');
        Test.setMock(HttpCalloutMock.class, new TwilioMessageSenderMock());
        try{
            Test.startTest();
            TwilioMessageHelper.sendCEOMessages(new Set<Id>{opp.Id});
            Test.stopTest();
        } catch(TwilioMessageSender.TwilioMessageSenderException e){
            exceptionOccured = true; 
            // check that the message was formatted as expected
            System.assert(e.getMessage().contains(expectedOutput));
        }
        System.assert(exceptionOccured == true);
    }
}
