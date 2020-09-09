global class scheduleAccounts implements Schedulable{
    
    //At 20:00:00 pm, on every Friday, every month
    //scheduleAccounts reminder = new scheduleAccounts();
    //String sch = '0 0 20 ? * 6 *';
    //String jobID = System.schedule('update total amount', sch, reminder);
    
    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new batchAccount());
    }
}