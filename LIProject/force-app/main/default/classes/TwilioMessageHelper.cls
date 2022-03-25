public with sharing class TwilioMessageHelper {
    public static void sendCEOMessages(List<Opportunity> opportunitiesToNotify){
        Twilio_Config__c twilioConfig = Twilio_Config__c.getInstance();
        // Method sends each message to CEO
        for (Opportunity opportunity : opportunitiesToNotify){
            String messageBody = opportunity.Account.Name + ' closed on ' + opportunity.Name + ' for ' + opportunity.Amount + ' at ' + opportunity.CloseDate;
            TwilioMessageSender.sendMessage(twilioConfig.CEO_Number__c, messageBody); 
        }
    }
}
