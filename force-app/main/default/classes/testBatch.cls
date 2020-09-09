@isTest public class testBatch {
    
    @TestSetup static void addData(){
        
        //add accounts
        List<Account> accounts = new List<Account>();
        for(Integer i=0; i<6; i++) {
            Account account = new Account(Name = 'Test Acc ' + i);
            accounts.add(account);
        } 
        insert accounts;
        
        for(Integer i=0; i<5; i++){
            accounts[i+1].ParentId = accounts[i].Id;
        }
        upsert accounts;
        
        //add opportunities
        List<Opportunity> opportunities = new List<Opportunity>();
        for(Account account : accounts) {
            for(Integer i = 0; i < 4; i++) {
                Opportunity opportunity = new Opportunity(Name = 'Test Opp ' + i, 
                                                          StageName = 'Closed Won',
                                                          CloseDate = Date.today().addDays(1),
                                                          Amount = 5,
                                                          AccountId = account.Id);
                opportunities.add(opportunity);
            }  
        }
        insert opportunities;
        
    }
    
    @IsTest public static void test() {
        
        Test.startTest();
        batchAccount batchA = new batchAccount();
        Id batchId = Database.executeBatch(batchA);
        Test.stopTest();
        
        List<Account> accounts = [SELECT Id, Total_Amount__c FROM Account];
        
        //checks all level
        System.assertEquals(120, accounts[0].Total_Amount__c);
        System.assertEquals(100, accounts[1].Total_Amount__c);
        System.assertEquals(80, accounts[2].Total_Amount__c);
        System.assertEquals(60, accounts[3].Total_Amount__c);
        System.assertEquals(40, accounts[4].Total_Amount__c);
        System.assertEquals(20, accounts[5].Total_Amount__c);
    }
    
}