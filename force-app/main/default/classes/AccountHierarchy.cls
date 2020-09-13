public class AccountHierarchy {
    
    public Account account;
    public List<AccountHierarchy> childrens;
    
    //Constructor
    public AccountHierarchy(Account account) {
        this.account = account;
        this.childrens = new List<AccountHierarchy>();
    }
    
    //Gets a list of children for an item in the hierarchy
    public List<Account> getChildrens() {
        List<Account> accounts = new List<Account>();
        for(AccountHierarchy accountHierarchy: childrens) {
            accounts.add(accountHierarchy.account);
            accounts.addAll(accountHierarchy.getChildrens());
        }
        return accounts;
    }
    
    //Checks an element of the hierarchy "is child?"
    public Boolean isChild(AccountHierarchy accHierarchy) {
        if(account.Id == accHierarchy.account.ParentId) {
            childrens.add(accHierarchy);
            return true;
        } else {
            for (AccountHierarchy child : childrens) {
                if(child.isChild(accHierarchy)) {
                    return true;
                }
            }
        }
        return false;
    }
}