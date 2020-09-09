global class batchAccount implements Database.Batchable<SObject>, Database.Stateful {
    
    public Map<Id, Account> accountsToUpsert;
    
    //Сonstructor for initializing a map with a zeroed Totat_Amount__c
    public batchAccount(){
        accountsToUpsert = new Map<Id, Account>();
        List<Account> allAccounts  = [SELECT Id, Total_Amount__c, ParentId, 
                                      (SELECT Amount, StageName FROM Opportunities WHERE StageName = 'Closed Won') FROM Account];
        for(Account acc: allAccounts){
            acc.Total_Amount__c = 0;
            accountsToUpsert.put(acc.Id, acc);
        }
    }
    
    //Sends a list of accounts with a nullified Total_Amount__c
    global List<Account> start(Database.BatchableContext bc) {
        return accountsToUpsert.values();
    }
    
    //Recalculates Total_Amount__c values for each account
    global void execute(Database.BatchableContext bc, List<Account> accounts){
        
        for (Account account : accounts) {
            Decimal amount = 0;
            Account currAcc = accountsToUpsert.get(account.Id);
            
            for(Opportunity opportunity : currAcc.Opportunities) {
                amount += opportunity.Amount;
            }
            
            currAcc.Total_Amount__c += amount; 
            updateParentAmount(currAcc, amount);
            accountsToUpsert.put(account.Id, currAcc); 
        }
    }
    
    //Upsert summary data
    global void finish(Database.BatchableContext bc){
        upsert accountsToUpsert.values();
    } 
    
    //Recalculates "parent" value by "child" value
    public void updateParentAmount(Account account, Decimal amount) {
        if(account.ParentId != null) {
            Account parentAccount = accountsToUpsert.get(account.ParentId);
            parentAccount.Total_Amount__c += amount;
            updateParentAmount(parentAccount, amount);
            accountsToUpsert.put(account.ParentId, parentAccount); 
        }
        accountsToUpsert.put(account.Id, account); 
    }
    
}