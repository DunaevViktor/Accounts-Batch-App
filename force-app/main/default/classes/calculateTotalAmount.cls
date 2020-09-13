public class calculateTotalAmount {
    
    //Calculates the Total_Amount__c value for each member of the hierarchy
    //If the value has already been calculated, returns it
    public Decimal calculateTotalAmountFunc(AccountHierarchy accHier) {
        if(accHier.account.Total_Amount__c == 0) {
            for(Opportunity opportunity : accHier.account.Opportunities) {
                accHier.account.Total_Amount__c += opportunity.Amount;
            }
            for(AccountHierarchy children: accHier.childrens) {
                accHier.account.Total_Amount__c += calculateTotalAmountFunc(children);
            }
        } 
        return accHier.account.Total_Amount__c;
    }
    
}