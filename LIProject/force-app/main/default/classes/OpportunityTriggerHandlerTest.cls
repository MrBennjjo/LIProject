@isTest
public with sharing class OpportunityTriggerHandlerTest {
    @TestSetup
    static void makeData(){
        Account goldAccount = TestDataFactory.goldAccount('Golden');
        Account bronzeAccount = TestDataFactory.bronzeAccount('Bronze');
        Twilio_Config__c twilioConfig = TestDataFactory.twilioConfig();
    }

    @IsTest
    static void testBadRequestBronze(){
        // when sending a bad request for a bronze account we won't receive an exception as we will not attempt to make a request
        Account bronzeAccount = [SELECT Id FROM Account WHERE Name = 'Bronze'];
        Opportunity newOpp = new Opportunity(Name = 'FAIL', Amount=12111, AccountId = bronzeAccount.Id, StageName='Needs Analysis', CloseDate = Date.today());
        Boolean exceptionOccured = false;
        insert newOpp;
        Test.startTest();         
        try{
            newOpp.StageName = 'Closed Won';
            newOpp.CloseDate = Date.today();
            update newOpp;
        } catch(TwilioMessageSender.TwilioMessageSenderException e){
            exceptionOccured = true;
        }
        Test.stopTest();
        System.assertEquals(false, exceptionOccured);
    }

    @IsTest
    static void testGoodRequestBronze(){
        // when sending a good request for a bronze account we won't receive an exception as we will not attempt to make a request
        Account bronzeAccount = [SELECT Id FROM Account WHERE Name = 'Bronze'];
        Opportunity newOpp = new Opportunity(Name = 'pass', Amount=12111, AccountId = bronzeAccount.Id, StageName='Needs Analysis', CloseDate = Date.today());
        Boolean exceptionOccured = false;
        insert newOpp;
        Test.startTest();         
        try{
            newOpp.StageName = 'Closed Won';
            newOpp.CloseDate = Date.today();
            update newOpp;
        } catch(TwilioMessageSender.TwilioMessageSenderException e){
            exceptionOccured = true;
        }
        Test.stopTest();
        System.assertEquals(false, exceptionOccured);
    }

    @IsTest
    static void testBadRequestGold(){
        // when we send a bad request for a gold account we should receive an exception as we will have attempted to make a request but failed 
        Account goldAccount = [SELECT Id FROM Account WHERE Name = 'Golden'];
        Opportunity newOpp = new Opportunity(Name = 'FAIL', Amount=12111, AccountId = goldAccount.Id, StageName='Needs Analysis', CloseDate = Date.today());
        Boolean exceptionOccured = false;
        insert newOpp;
        Test.startTest();         
        try{
            newOpp.StageName = 'Closed Won';
            newOpp.CloseDate = Date.today();
        } catch(TwilioMessageSender.TwilioMessageSenderException e){
            exceptionOccured = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionOccured);
    }

    @IsTest
    static void testGoodRequestGold(){
        // when we send a good request for a gold account we should receive no exception as the request was made successfully
        Account goldAccount = [SELECT Id FROM Account WHERE Name = 'Golden'];
        Opportunity newOpp = new Opportunity(Name = 'FAIL', Amount=12111, AccountId = goldAccount.Id, StageName='Needs Analysis', CloseDate = Date.today());
        Boolean exceptionOccured = false;
        insert newOpp;
        Test.startTest();         
        try{
            newOpp.StageName = 'Closed Won';
            newOpp.CloseDate = Date.today();
            update newOpp;
        } catch(TwilioMessageSender.TwilioMessageSenderException e){
            exceptionOccured = true;
        }
        Test.stopTest();
        System.assertEquals(false, exceptionOccured);
    }
}
