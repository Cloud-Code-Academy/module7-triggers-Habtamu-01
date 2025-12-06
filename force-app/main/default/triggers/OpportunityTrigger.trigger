trigger OpportunityTrigger on Opportunity (before update, after update, before delete) {
    if(Trigger.isBefore && Trigger.isUpdate){
        OpportunityTriggerHandler.beforeUpdate(Trigger.new, Trigger.oldMap);
        OpportunityTriggerHandler.beforeUpdatePrimaryContact(Trigger.new);
    }
    if(Trigger.isBefore && Trigger.isDelete){
        OpportunityTriggerHandler.beforeDelete(Trigger.old);
    }
    // if(Trigger.isAfter && Trigger.isUpdate){
    //     OpportunityTriggerHandler.afterUpdate(Trigger.new);
    // }

}