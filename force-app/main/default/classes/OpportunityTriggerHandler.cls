public with sharing class OpportunityTriggerHandler {
   public static void createOpportunityLineItem(List<Opportunity> newOpportunities) {
       List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();
       List<PriceBookEntry> priceBookList = [SELECT Id, Product2Id, Product2.Id, Product2.Name FROM PriceBookEntry 
                                                WHERE Product2Id='01t5j000003SRSaAAO'  
                                                AND PriceBook2.isStandard=true LIMIT 1];
       for(Opportunity opp: newOpportunities){
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.OpportunityId=opp.Id;
        oli.Quantity = 1;
        Oli.TotalPrice = 100;
        oli.PricebookEntryId=priceBookList[0].Id ;
        oliList.add(oli);
       }
       insert oliList;
   }

   //code working but not of single org with all triggers due to conflict/dependency issue
   /*public static void updateAssociatedAccountClientContact(List<Opportunity> newOpportunities) {
    Set<Id> accIdWithOpp = new Set<Id>();
    for(Opportunity opp:newOpportunities) {
        accIdWithOpp.add(opp.AccountId);
    }
    List<Account> accTobeUpdated = new List<Account>();
    List<Account> accWithOpp =[SELECT Id, Name, Client_Contact_lookup_to_Contact__c,(Select Id,Name,Opportunity_Client_Contact__c FROM Opportunities) FROM Account 
                            WHERE Id IN: accIdWithOpp];
    for(Account acc:accWithOpp){
        List<Opportunity> opp = acc.Opportunities;
        for(Opportunity op:opp){
            if(op.Opportunity_Client_Contact__c !=null){
                acc.Client_Contact_lookup_to_Contact__c = op.Opportunity_Client_Contact__c;
            }
        }
        accTobeUpdated.add(acc);
    }
    if(accTobeUpdated.size()>0){
        update accTobeUpdated;
    }
   }

   
   public static void updateAccountMultiSelectValue(List<Opportunity> newOpportunities) {
    Set<Id> accIdWithOpp = new Set<Id>();
    for(Opportunity opp:newOpportunities) {
        accIdWithOpp.add(opp.AccountId);
    }
    List<Account> accTobeUpdated = new List<Account>();
    List<Account> accWithOpp =[SELECT Id, Name, Selected_Me_Value__c,(Select Id,Name,Select_Me__c FROM Opportunities) FROM Account 
                            WHERE Id IN: accIdWithOpp];
    for(Account acc:accWithOpp){
        List<Opportunity> opp = acc.Opportunities;
        for(Opportunity op:opp){
            if(op.Select_Me__c !=null){
                acc.Selected_Me_Value__c = op.Select_Me__c;
            }
        }
        accTobeUpdated.add(acc);
    }
    if(accTobeUpdated.size()>0){
        update accTobeUpdated;
    }
   }*/
   
   public static void emailAlertOnOpportunityStageChange(List<Opportunity> newOpportunities,Map<Id,Opportunity> mapOfOpportunities) {
    List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
    Set<Id> accIds = new Set<Id>();
    for(Opportunity opp:newOpportunities) {
       if(opp.StageName !=mapOfOpportunities.get(opp.Id).StageName){
        accIds.add(opp.AccountId);
       }
    }
    List<Account> updatedAccountWithContacts = [SELECT Id,Name,Client_Contact_lookup_to_Contact__c FROM Account
                                                WHERE Id IN: accIds];
    if(updatedAccountWithContacts.size()>0){
        for(Account acc:updatedAccountWithContacts){
            if( acc.Client_Contact_lookup_to_Contact__c!=null){
                Contact con = [Select Id,Name,Email FROM Contact WHERE Id =: acc.Client_Contact_lookup_to_Contact__c];
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setSenderDisplayName('System Administrator');
                email.setUseSignature(false);
                email.setBccSender(false);
                email.setSaveAsActivity(false);
                email.ToAddresses= new String[] {con.Email};
                email.Subject = 'Account Update Info';
                email.setHtmlBody('<html><body>Hi, Your account information has been updated successfully with new Type '+'</body> </html>');
                emailList.add(email);
            }
        }
    }
    Messaging.sendEmail(emailList);
   }
}