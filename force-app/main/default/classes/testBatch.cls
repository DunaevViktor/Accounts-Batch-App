@isTest public class testBatch {
    
    @TestSetup static void addData(){
        
        //add accounts
        List<Account> accounts = new List<Account>();
        for(Integer i=0; i<10; i++) {
            Account account = new Account(Name = 'Test Acc ' + i);
            accounts.add(account);
        } 
        insert accounts;
        
        accounts[1].ParentId = accounts[0].Id;
        accounts[2].ParentId = accounts[0].Id;
        accounts[3].ParentId = accounts[1].Id;
        accounts[4].ParentId = accounts[1].Id;
        accounts[5].ParentId = accounts[4].Id;
        accounts[6].ParentId = accounts[5].Id;
        accounts[7].ParentId = accounts[6].Id;
        accounts[8].ParentId = accounts[5].Id;
        accounts[9].ParentId = accounts[2].Id;
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
        batchHierarchy batchH = new batchHierarchy();
        Id batchId = Database.executeBatch(batchH);
        Test.stopTest();
        
        List<Account> accounts = [SELECT Id, Total_Amount__c FROM Account];
        
        //checks all level
        System.assertEquals(200, accounts[0].Total_Amount__c);
        System.assertEquals(140, accounts[1].Total_Amount__c);
        System.assertEquals(40, accounts[2].Total_Amount__c);
        System.assertEquals(20, accounts[3].Total_Amount__c);
        System.assertEquals(100, accounts[4].Total_Amount__c);
        System.assertEquals(80, accounts[5].Total_Amount__c);
        System.assertEquals(40, accounts[6].Total_Amount__c);
        System.assertEquals(20, accounts[7].Total_Amount__c);
        System.assertEquals(20, accounts[8].Total_Amount__c);
        System.assertEquals(20, accounts[9].Total_Amount__c);
    }
    
}