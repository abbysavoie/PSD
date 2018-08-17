/**
 * An apex page controller that exposes the change password functionality
 */
//public with sharing class ChangePwdCntrl {
public class   ChangePwdCntrl {
    public Boolean userLoggedIn{get;set;}{userLoggedIn = false;}
    public String loggedInUserName{get;set;}{loggedInUserName = '';}
    public String loggedInUser{get;set;}{loggedInUser = '';}


    public String oldPassword {get; set;}
    public String newPassword {get; set;}
    public String verifyNewPassword {get; set;}        
    public Boolean isSaved{get;set;}
    public String fromSSNSrch{get;set;}
    public Boolean allowUsnChange{get;set;}
    public String inpUsrName{get;set;}
    
    public PageReference changePassword() {
        System.debug('rhathi inpUsrName '+ inpUsrName);
        if(String.isNotBlank(inpUsrName)){
        
        Schema.DescribeFieldResult dfr = Schema.sObjectType.User.fields.username;
        system.debug('rhathi dfr '+ dfr.isUpdateable());
if(dfr.isUpdateable()){
            User usr=[select id,username,contact.SNN_DUP__c, RAD_Migrated_User__c from User where id =: UserInfo.getUserId() ];
            usr.username = inpUsrName;
            usr.RAD_Migrated_User__c =false;
            try{
                update usr;
            }catch( Exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.info, e.getMessage())); 
                System.debug('rhathi found exception ' + e.getMessage());
                return null;
            }
     }       
        }
        return Site.changePassword(newPassword, verifyNewPassword, oldpassword);    
    }     
    
    public ChangePwdcntrl() {
        System.debug('rhathi in constructor of change password');
        System.debug('rhathi param const '+ ApexPages.currentPage().getParameters());
        System.debug('rhathi param const '+ System.currentPagereference().getParameters());
    }

    public PageReference init() {
        System.debug('rhathi in init of change password');
    
        String[] str = ApexPages.currentPage().getParameters().get('returl').split('\\?');
        if(str.size() > 1){
            fromSSNSrch = str[1].split('=')[1];
            System.debug('rhathi param is '+ fromSSNSrch );
            allowUsnChange = false;
        }

        if(UserInfo.getUserType() == 'Guest' || UserInfo.getUserId() == null){
            System.debug('rhathi guest or null found');
            String startUrl = System.currentPageReference().getParameters().get('startURL');
             return new pagereference(Site.getPathPrefix()+'/RADNewLand');           
            //return new PageReference(Network.getLoginUrl(comid));
            //return new PageReference('https://waitlist-sdhcportal.cs32.force.com/RADWL/RADNewLand');
        }
        else{

            userLoggedIn = true;
            System.debug('rhathi FOUND USER');
            //PageReference pr = new PageReference('RADNewLand');
            loggedInUserName = UserInfo.getName();
            loggedInUser=UserInfo.getUsername();
            isSaved = true;
            
            if(fromSSNSrch != null && fromSSNSrch == '1'){
                Boolean bln = [Select RAD_Migrated_User__c from User where id =: UserInfo.getUserId()].RAD_Migrated_User__c;
                if(bln == true){
                    allowUsnChange = true;
                }
            }
            return null;
        }
    }     
        
        
      /*   
      public PageReference OLD_init() {
        string comid = Network.getNetworkId();
        if(UserInfo.getUserType() == 'Guest' || UserInfo.getUserId() == null){
            String startUrl = System.currentPageReference().getParameters().get('startURL');
             return new pagereference(Site.getPathPrefix()+'/RADNewLand');           
            //return new PageReference(Network.getLoginUrl(comid));
            //return new PageReference('https://waitlist-sdhcportal.cs32.force.com/RADWL/RADNewLand');
        }
        else{
            userLoggedIn = true;
            //PageReference pr = new PageReference('RADNewLand');
            loggedInUserName = UserInfo.getName();
            loggedInUser=UserInfo.getUsername();
            isSaved = true;
             return null;
        }
    }
    */
}