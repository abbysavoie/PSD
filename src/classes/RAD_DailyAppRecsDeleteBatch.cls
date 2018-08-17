//Purpose of this Batch is to Delete All Application Records whose Status is Closed on a daily basis.

global class RAD_DailyAppRecsDeleteBatch implements Database.Batchable<sObject> {
    public String query;
    
    
    global RAD_DailyAppRecsDeleteBatch (){
    }
    
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        query = 'select id, name from Applications__c '+
                ' where Application_Status__c in (\'Closed\',\'Removed\') ';
            
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Applications__c> scope){
        delete scope;
    }
    
    global void finish(Database.BatchableContext BC){
        
        Email_Id_s__mdt e = [select id, Name__c, Email_Id__c from Email_Id_s__mdt where DeveloperName = 'Developer2_Email_ID' limit 1];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[]{e.Email_Id__c};
            mail.setToAddresses(toAddresses);
        mail.setSubject('Status Update: Daily Application Records Delete Batch Completed');
        mail.setPlainTextBody(
            'Daily Application Records Delete Batch Process has completed, All Application Records which are in Closed status are deleted sucessfully.' 
        );        
        try {
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        } catch(System.EmailException sme) {
            
        }
        
        
    }
}