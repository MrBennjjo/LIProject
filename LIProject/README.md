# LIProject
 
Lend Invest Programming Challenge. 

## Questions
- Annual Revenue Spend; ought this only be the previous years worth of closed-won opportunities or all closed-won opportunities? The description sounded like the latter but the field name would imply the former. 

## Assumptions
- All changes to only be viewed by system administrator for now.
- We send an SMS to the CEO if the Account has just become a GOLD member as a result of the most recent closed opportuntiy (assuming CEO would want notified about such transactions) 

## Implementation notes 
- New field on Account "Annual_Revenue_Spend__c", roll-up summary field which takes sum of amount value on closed-won opportunities associated with the account.
- New field on Account "Annual_Revenue_Spend_Medal__c", text formula field which converts the annual_revenue_spend__c value into either GOLD, SILVER, BRONZE or null following logic specified in challenge.
- Used named credentials to store twilio URL/username/token information as implements basic auth and encrypts token on org in non accessible manner.
- Used custom settings hierarchy to store from number, in case we want to have different groups of users be sent messages from different numbers.
- Added LWC to Account record page, with condition to only show if account is GOLD.

Code structured like 
- TwilioMessageSender: this is the base class which handles the sending of messages from Twilio
- TwilioMessageHelper: this is a helper class for sending messages, invokes TwilioMessageSender and others 
- OpportunityTriggerHandler: handles the opportunity trigger
- 

## General notes/observations
- Perhaps for the custom SMS sender we need to consider making a record of each of the SMS messages sent to the Account in some sort of object? Would massively help with testing/error handling etc...
- For production I would give more consideration to the possibility of hitting rate limit issues against the twilio API, depends on how many users 
- Couldn't work out any way to send multiple messages to the same number in a single request reading the API docs, this would be preferred for opportunities though
- At the moment the code only tracks whether or not the message was successfully sent to the API, but doesn't track whether or not the message was successfully sent to the intended user. Would need to set up a callback endpoint for Twilio to send confirmation of successful message in order to implement this: would be reliant on creating data to track messages sent
- Haven't fully considered a max length on the message sent from the front end. 