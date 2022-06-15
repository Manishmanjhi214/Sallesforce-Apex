trigger LeadTrigger on Lead (after insert) {
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            if(CheckRecursive.runOnce()){
            LeadTriggerHandler.createDuplicateLead(Trigger.new);
            LeadTriggerHandler.sendEmailWithAttachedPDF(Trigger.new);
            }
        }
    }

}