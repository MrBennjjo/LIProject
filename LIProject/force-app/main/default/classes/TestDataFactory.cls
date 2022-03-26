public with sharing class TestDataFactory {
    public static Account goldAccount(String name){
        Account gold = new Account(Name = name, Phone='+447999506611');
        insert gold;
        Opportunity o = new Opportunity(Name = name + ' opportunity', Amount=50001, AccountId = gold.Id, StageName='Closed Won', CloseDate = Date.today());
        insert o;
        return gold;
    }

    public static Account bronzeAccount(String name){
        Account gold = new Account(Name = name, Phone='+447999506611');
        insert gold;
        Opportunity o = new Opportunity(Name = name + ' opportunity', Amount=12111, AccountId = gold.Id, StageName='Closed Won', CloseDate = Date.today());
        insert o;
        return gold;
    }

    public static Twilio_Config__c twilioConfig(){
        Twilio_Config__c twilioConfig = new Twilio_Config__c(CEO_Number__c = 'testnum', From_Number__c = 'testnum');
        insert twilioConfig;
        return twilioConfig;
    }
}
