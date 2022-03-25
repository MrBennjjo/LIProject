trigger OpportunityTrigger on Opportunity (after update) {
    if (trigger.isAfter && trigger.isUpdate){
        OpportunityTriggerHandler.handleAfterUpdate(Trigger.oldMap, Trigger.newMap);
    }
}