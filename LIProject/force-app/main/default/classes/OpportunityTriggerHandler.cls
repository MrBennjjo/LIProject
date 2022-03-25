public with sharing class OpportunityTriggerHandler {
    public static void handleAfterUpdate(Map<Id, Opportunity> oldMap, Map<Id, Opportunity> newMap){
        // Opportunities we're going to notify the CEO about
        List<Opportunity> opportunitiesToNotify = new List<Opportunity>();
        for (Id oppId : oldMap.keySet()){
            Opportunity oldOpp = oldMap.get(oppId);
            Opportunity newOpp = newMap.get(oppId);
            // We are interested in opportunities which have entered a Closed-Won Stage for Accounts which are GOLD
            if (oldOpp.StageName != 'Closed Won' && newOpp.StageName == 'Closed Won' && newOpp.Account.Annual_Revenue_Spend_Medal__c == 'GOLD'){
                opportunitiesToNotify.add(newOpp);
            }
        }
        // only invoke if there are any opportunities to send
        if (opportunitiesToNotify.size() > 0){
            TwilioMessageHelper.sendCEOMessages(opportunitiesToNotify);
        }
    }
}
