public with sharing class OpportunityTriggerHandler {
    public static void handleAfterUpdate(Map<Id, Opportunity> oldMap, Map<Id, Opportunity> newMap){
        // message data to send CEO
        Set<Id> opportunitiesToSend = new Set<Id>();
        Set<Id> accountIds = new Set<Id>();
        for (Id oppId : newMap.keySet()){
            accountIds.add(newMap.get(oppId).AccountId);
        }
        // populate a map of account IDs to accounts, so we can access annual revenue spend medal data
        Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Id, Annual_Revenue_Spend_Medal__c FROM Account WHERE Id IN :accountIds]);
        for (Id oppId : oldMap.keySet()){
            Opportunity oldOpp = oldMap.get(oppId);
            Opportunity newOpp = newMap.get(oppId);
            Account account = accountMap.get(newOpp.AccountId);
            System.debug(newOpp.Account.Annual_Revenue_Spend_Medal__c);
            // We are interested in opportunities which have entered a Closed-Won Stage for Accounts which are GOLD
            if (oldOpp.StageName != 'Closed Won' && newOpp.StageName == 'Closed Won' && account.Annual_Revenue_Spend_Medal__c == 'GOLD'){
                opportunitiesToSend.add(newOpp.Id);
            }
        }
        // only invoke if there are any opportunities to send
        if (opportunitiesToSend.size() > 0){
            TwilioMessageHelper.sendCEOMessages(opportunitiesToSend);
        }
    }
}
