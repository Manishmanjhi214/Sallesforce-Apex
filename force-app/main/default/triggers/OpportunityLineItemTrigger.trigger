trigger OpportunityLineItemTrigger on OpportunityLineItem (after insert,after update,after delete) {

    if(Trigger.isAfter){
        if(Trigger.isInsert){
            OpportunityLineItemTriggerHandler.updateProductListOnOpporutnity(Trigger.new);
            OpportunityLineItemTriggerHandler.updateProductQuantityOnAccount(Trigger.new);
            OpportunityLineItemTriggerHandler.insertQuotationOnLineItemCreation(Trigger.new);
            OpportunityLineItemTriggerHandler.insertAssetOnLineItemCreation(Trigger.new);
        }
        if(Trigger.isUpdate){
            OpportunityLineItemTriggerHandler.updateProductListOnOpporutnity(Trigger.new);
            OpportunityLineItemTriggerHandler.updateProductQuantityOnAccount(Trigger.new);
        }
        if(Trigger.isDelete){
           OpportunityLineItemTriggerHandler.updateProductListOnOpporutnity(Trigger.old);
           OpportunityLineItemTriggerHandler.updateProductQuantityOnAccount(Trigger.old);
            OpportunityLineItemTriggerHandler.deleteOpportunityOnLineItemDeletion(Trigger.old);
        }
    }
}