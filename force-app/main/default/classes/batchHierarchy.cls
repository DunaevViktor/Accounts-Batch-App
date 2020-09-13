global class batchHierarchy implements Database.Batchable<SObject>, Database.Stateful {
    
    public Map<Id, AccountHierarchy> hierarchy = new Map<Id, AccountHierarchy>();
    
    //Gets all records
    global Database.QueryLocator start(Database.BatchableContext bc) {
        Database.QueryLocator query = Database.getQueryLocator('SELECT Id, Total_Amount__c, ParentId, ' +
                                                               + '(SELECT Amount, StageName FROM Opportunities WHERE StageName = \'Closed Won\') ' +
                                                               + 'FROM Account');
        return query;
    }
    
    //Forms a hierarchy of accounts
    global void execute(Database.BatchableContext bc, List<Account> accounts){
        
        for (Account account : accounts) {
            account.Total_Amount__c = 0;
            AccountHierarchy accountHierarchy = new AccountHierarchy(account);
            Boolean findedPosition = false;
            
            if(account.ParentId != null) {
                for(AccountHierarchy parent: hierarchy.values()) {
                    if(parent.isChild(accountHierarchy)) {
                        findedPosition = true;
                        break;
                    }
                }
            }
            
            if(!findedPosition) {
                hierarchy.put(account.Id, accountHierarchy);
            }
            
            for(AccountHierarchy accHier: hierarchy.values()) {
                if(accHier.account.ParentId == account.Id) {
                    accountHierarchy.childrens.add(accHier);
                    hierarchy.remove(accHier.account.Id);
                }
            }
        }
        
    }
    
    //Calls the second batch with the parameter
    global void finish(Database.BatchableContext bc){
        Database.executeBatch(new batchAccount(hierarchy));
    } 
    
}