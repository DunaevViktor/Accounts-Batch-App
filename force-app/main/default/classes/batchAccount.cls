global class batchAccount implements Database.Batchable<SObject>, Database.Stateful {
    
    public Map<Id, AccountHierarchy> hierarchy;
    public calculateTotalAmount amountCalculator;
    
    //Сonstructor
    public batchAccount(Map<Id, AccountHierarchy> hierarchyMap){
        hierarchy = hierarchyMap;
        amountCalculator = new calculateTotalAmount();
    }
    
    //Sends a list of accounts with a nullified Total_Amount__c
    global List<Account> start(Database.BatchableContext bc) {
        List<Account> accounts = new List<Account>();
        for(AccountHierarchy accountHierarchy: hierarchy.values()) {
            accounts.add(accountHierarchy.account);
        }
        return accounts;
    }
    
    //Recalculates Total_Amount__c values for each account and updates it
    global void execute(Database.BatchableContext bc, List<Account> accounts){
        List<Account> results = new List<Account>();
        
        for (Account account : accounts) {
            AccountHierarchy accHier = hierarchy.get(account.Id);
            amountCalculator.calculateTotalAmountFunc(accHier);
            results.add(accHier.account);
            results.addAll(accHier.getChildrens());
            hierarchy.remove(account.Id);
        }
        
        update results;
    }
    
    global void finish(Database.BatchableContext bc){
        System.debug('All good!');
    }
    
}