public with sharing class TwilioMessageHelper {
    @future(callout=true)
    public static void sendCEOMessages(Set<Id> opportunityIdsToSend){
        Twilio_Config__c twilioConfig = Twilio_Config__c.getInstance();
        // Method sends each message to CEO
        List<Opportunity> opportunities = [SELECT Name, Amount, CloseDate, Account.Name FROM Opportunity WHERE Id IN : opportunityIdsToSend];
        for (Opportunity opp : [SELECT Name, Amount, CloseDate, Account.Name FROM Opportunity WHERE Id IN : opportunityIdsToSend]){
            // note as this is a single currency org for now, have hard coded currency as £, if were a multi currency org would have implemented differently
            String amountFormatted = '£' + (opp.Amount).format();
            String messageBody = opp.Account.Name + ' closed on ' + opp.Name + ' for ' + amountFormatted+ ' at ' + (opp.CloseDate).format();
            TwilioMessageSender.sendMessage(twilioConfig.CEO_Number__c, messageBody); 
        } 
    }

    @AuraEnabled 
    public static void sendAccountMessage(String accId, String messageBody){
        try{
            Account acc = [SELECT Phone FROM Account WHERE Id = :accId LIMIT 1];
            TwilioMessageSender.sendMessage(acc.Phone, messageBody);
        } catch(TwilioMessageSender.TwilioMessageSenderException e){
            throw new AuraException(e.getMessage());
        }
    }
}
