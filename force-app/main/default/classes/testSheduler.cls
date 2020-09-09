@isTest public class testSheduler {
    
    public static String CRON_EXP = '0 0 20 ? * 6 *';
  
    @isTest public static void test(){
        List<AsyncApexJob> jobsBefore = [Select Id From AsyncApexJob];
        System.assertEquals(0, jobsBefore.size());
        
        Test.startTest();
        String jobId = System.schedule('scheduleAccounts', CRON_EXP, new scheduleAccounts());
        Test.stopTest();
        
        //test schedule job
        List<AsyncApexJob> jobsScheduled = [SELECT Id, ApexClass.Name, JobType FROM AsyncApexJob WHERE JobType = 'ScheduledApex'];
        System.assertEquals(1, jobsScheduled.size());
        System.assertEquals('scheduleAccounts', jobsScheduled[0].ApexClass.Name);
        
        //test batch job
        List<AsyncApexJob> jobsApexBatch = [SELECT Id, JobType FROM AsyncApexJob WHERE JobType = 'BatchApex'];
        System.assertEquals(1, jobsApexBatch.size());  
    }
}