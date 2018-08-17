//Transfer update email for applicants living /working in City of San Diego

global class RAD_WeeklyModifiedTransferBatch implements Database.batchable<sObject>,Database.Stateful{
    String query;
    global Integer unprocessedCount;
    
    
    global RAD_WeeklyModifiedTransferBatch()
    {
       query = 'select Id, Name, Status__c, Result__c, Applications__r.Applicant__r.Email, Applications__r.Applicant__r.Paperless_Email_only__c  '+
            ' from Memo__c where lastmodifieddate >= LAST_N_DAYS:7  AND Status__c = \'Scheduled\' AND (Result__c = \'D- App Trans to County\' OR Result__c = \'D1-App National City\' OR Result__c = \'D2- App Oceanside\' OR Result__c = \'D3-App Carlsbad\' OR Result__c = \'D4-App Encinitas\') ';

    }
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Memo__c> scope)
    {    
        
        String docCreatedDate = system.now().format('MM/dd/YYYY') ;//Today's date in MM/dd/YYYY
        List<Document> docList = new List<Document>();
        Document doc = new Document();
        Blob b = null;
        //Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
        //List<Messaging.SingleEmailMessage> emailLst = new List<Messaging.SingleEmailMessage>();
        Id folderWeeklyTransferLettersId = [select id from folder where name ='Transfer Letters'].Id;
        
        
       /* EmailTemplate templateId_SD = [Select id from EmailTemplate 
                                       where name ='Status update email for applicants living /working in City of San Diego'];
        //EmailTemplate templateId_NSD = [Select id from EmailTemplate 
                                        where name ='Status update email for applicants not living/working in City of San Diego']; */
        PageReference pdf = null;            
        
        //Narasimha start 18/07/2017
        for(Memo__c m:scope)    
        {
           
                
                if( (m.Applications__r.Applicant__r.email ==''|| m.Applications__r.Applicant__r.Paperless_Email_only__c==False) && (m.Result__c == 'D- App Trans to County'|| m.Result__c == 'D1-App National City'|| m.Result__c == 'D2- App Oceanside'|| m.Result__c == 'D3-App Carlsbad'|| m.Result__c == 'D4-App Encinitass')){  
                    
                    pdf = Page.RAD_TransferLetters; 
                    
                    pdf.setRedirect(true);
                    pdf.getParameters().put('id', m.id);
                    if (!Test.IsRunningTest()) 
                    {
                        b = pdf.getContent(); 
                    }                  
                    doc = new Document();
                    
                    
                    doc.name = m.name+'_'+docCreatedDate+'.pdf';
                    doc.body = b;
                    
                    doc.FolderId =folderWeeklyTransferLettersId;
                    docList.add(doc);               
                    
                    
               }
                
              /*  else if( String.isNotBlank(m.Applications__r.Applicant__r.email) && m.Result__c!=null){
                    email = new Messaging.SingleEmailMessage(); 
                    email.setTemplateID(templateId_SD.Id);
                    
                    email.setTargetObjectId (m.id);//sending to applicant
                    
                  //  emailLst.add(email);
                    
                    
                } */
                //DO NOTHING   
            
         
            
        } 
        
        // send these count to the batch submitter
        
        List<Database.SaveResult> docResultList   =  Database.insert(docList, false);
        
       // Messaging.SendEmailResult [] results = Messaging.sendEmail(emailLst, false);
       
        
    }
    
    
    
    global void finish(Database.BatchableContext BC)
    {
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,
                          TotalJobItems, CreatedBy.Email
                          from AsyncApexJob where Id =
                          :BC.getJobId()];
        // Send an email to the Apex job's submitter notifying of job completion.  
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[]{a.CreatedBy.Email};
            mail.setToAddresses(toAddresses);
        
        
        mail.setSubject('Weekly Update Status ');
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