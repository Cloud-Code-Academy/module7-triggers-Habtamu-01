public with sharing class OpportunityTriggerHandler {
    //1. Validate that amount > 5000
   public static void beforeUpdate(List<Opportunity> oppList, Map<Id, Opportunity> oldMap){
    for(Opportunity opp : oppList){
        Opportunity oldOpp = oldMap.get(opp.Id); //for each record retrieve old version from oldMap 
        if(opp.Amount <= 5000 && opp.Amount != oldOpp.Amount){
            opp.addError('Amount must be greater than 5000.');
        }
    }

   } 
   // 2. Prevent the deletion of a closed won opportunity for a banking account.
   public static void beforeDelete(List<Opportunity> oldList){
   
    Set<Id> accountIds = new Set<Id>();  //Collect accound Ids from opportunities being deleted
    for(Opportunity opp : oldList){
       if(opp.StageName == 'Closed Won' && opp.AccountId !=null){
              accountIds.add(opp.AccountId);
       }
    }
    //Query accounts to check for Banking type
    Map<Id, Account> accMap = new Map<Id, Account>(
        [SELECT Id, Type FROM Account WHERE Id IN :accountIds]
        );

   //Validation
   for(opportunity opp : oldList){
    if(opp.StageName == 'Closed Won' && opp.AccountId != null){
        Account acc = accMap.get(opp.AccountId);
        if(acc != null && acc.Type == 'Banking'){
            opp.addError('Cannot delete Closed Won opportunities for Banking accounts.');
        }
    }
   }
   }
   //Set primary contact = CEO contact of account
public static void beforeUpdatePrimaryContact(List<Opportunity> newList){
    
    Set<Id> accIds = new Set<Id>();
    for(Opportunity opp : newList){
        if(opp.AccountId != null){
            accIds.add(opp.AccountId);
        }
    }

    Map<Id, Contact> ceoContactsMap = new Map<Id, Contact>();
    for(Contact con : [
        SELECT Id, Title, AccountId 
        FROM Contact 
        WHERE AccountId IN :accIds AND Title = 'CEO'
    ]){
        ceoContactsMap.put(con.AccountId, con);
    }

    for (Opportunity opp : newList) {
        if (opp.AccountId != null && ceoContactsMap.containsKey(opp.AccountId)) {
            opp.Primary_Cont__c = ceoContactsMap.get(opp.AccountId).Id;
        }
    }
}

}   