//This class is used for notifying the section 8 applicants via pdf with cover letter or email

global class RAD_PubHsgPrintLblBatch implements Database.batchable<sObject>,Database.Stateful{
    String query;
    String wlsIdd;
      
    public  Static string todayp {get;set;}
    
    global  RAD_PubHsgPrintLblBatch(String wlsId)
    {
        wlsIdd = wlsId;

        query='Select name from Wait_List_Selection__c where id =:wlsIdd';              
              system.debug('RAD_Sec8SelctdNtfyBatch strQuery------->'+query);               
       
    }

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Wait_List_Selection__c> scope)
    {
        List<Document> docList = new List<Document>();
        Document doc = new Document();

        Blob b = null;
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
        List<Messaging.SingleEmailMessage> emailLst = new List<Messaging.SingleEmailMessage>();
        Id PHlabelId = [select id from folder where name ='Public Housing Label'].Id;     
     
     
               
        PageReference pdf = null; 
            
        
        List<RAD_Exception_Log__c> excpLogs = new List<RAD_Exception_Log__c>();
        RAD_Exception_Log__c eLog = new RAD_Exception_Log__c();                               
 
          
           for(Wait_List_Selection__c sr :scope)    
           {
           
            pdf = Page.RAD_Public_Housing_Labels;           
            pdf.setRedirect(true);
            pdf.getParameters().put('id', sr.id);

            if(!Test.isRunningTest()){ 
            b = pdf.getContent();
            }                 
            doc = new Document();
            doc.name=Date.today().format() +'_'+ sr.Name +'.pdf';                 
            doc.body = b;
            doc.FolderId =PHlabelId;
            docList.add(doc);
            List<Database.SaveResult> docResultList   =  Database.insert(docList, false);   
            
                
               
    
    }
    }
    
    global void finish(Database.BatchableContext BC)
    {
        // Set Application Trigger on during run.
        SwitchTrigger__c AppTrigger = SwitchTrigger__c.getInstance('Applications__c');
        if(AppTrigger != Null) {
            AppTrigger.Active__c = true;
            update AppTrigger;
        }
            
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,
            TotalJobItems, CreatedBy.Email
            from AsyncApexJob where Id =
            :BC.getJobId()];
         // Send an email to the Apex job's submitter notifying of job completion.  
          
         Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
         String[] toAddresses = new String[] {a.CreatedBy.Email};
         mail.setToAddresses(toAddresses);
    
    
        mail.setSubject('Public Housing Label Printing Completed.');
        mail.setPlainTextBody(
        'Batch Process has completed.'
      
        );
        
        try {
          Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        } catch(System.EmailException sme) {
          //DO NOTHING...
        }
    }            
}