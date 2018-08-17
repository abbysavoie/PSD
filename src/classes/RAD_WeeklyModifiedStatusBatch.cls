//Status update email for applicants living /working in City of San Diego

global class RAD_WeeklyModifiedStatusBatch implements Database.batchable<sObject>,Database.Stateful{
    String query;
    global Integer unprocessedCount;
    
    
    global RAD_WeeklyModifiedStatusBatch()
    {
        query = 'select Id, Name, Live_Work_in_City_of_San_Diego__c,Applicant__r.Email, Applicant__r.Paperless_Email_only__c ,Applicant__c '+
            ' from Applications__c where lastmodifieddate >= LAST_N_DAYS:7  AND Application_Status__c = \'Submitted\' Limit 30';
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Applications__c > scope)
    {    
        
        String docCreatedDate = system.now().format('MM/dd/YYYY') ;//Today's date in MM/dd/YYYY
        List<Document> docList = new List<Document>();
        Document doc = new Document();
        Blob b = null;
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
        List<Messaging.SingleEmailMessage> emailLst = new List<Messaging.SingleEmailMessage>();
        Id folderWeeklyStatusId = [select id from folder where name ='RAD Wait List - Status Letter'].Id;
        
        
        EmailTemplate templateId_SD = [Select id from EmailTemplate 
                                       where name ='Status update email for applicants living /working in City of San Diego'];
        EmailTemplate templateId_NSD = [Select id from EmailTemplate 
                                        where name ='Status update email for applicants not living/working in City of San Diego'];
        PageReference pdf = null;            
        
        //Narasimha start 18/07/2017
        for(Applications__c appl :scope)    
        {
            //System.debug('appl is '+appl);
            if(appl.Applicant__c == null){
                continue;
            }
            
            if(appl.Live_Work_in_City_of_San_Diego__c==true ){
                
                if( String.isBlank(appl.Applicant__r.Email) && appl.Applicant__r.Paperless_Email_only__c == false  ){  
                    
                    pdf = Page.RAD_WeeklyUpdatePDF_SD; 
                    
                    pdf.setRedirect(true);
                    pdf.getParameters().put('id', appl.id);
                    if (!Test.IsRunningTest()) 
                    {
                        b = pdf.getContent(); 
                    }                  
                    doc = new Document();
                    
                    
                    doc.name = appl.name+'_'+docCreatedDate+'.pdf';
                    doc.body = b;
                    
                    doc.FolderId =folderWeeklyStatusId;
                    docList.add(doc);               
                    
                    
                } 
                
                else if( String.isNotBlank(appl.Applicant__r.Email) ){
                    email = new Messaging.SingleEmailMessage(); 
                    email.setTemplateID(templateId_SD.Id);
                    
                    email.setTargetObjectId (appl.Applicant__c);//sending to applicant
                    
                    emailLst.add(email);
                    
                    
                }
                //DO NOTHING   
            }
            
            else if(appl.Live_Work_in_City_of_San_Diego__c == false ){
                
                if( String.isBlank(appl.Applicant__r.Email) && appl.Applicant__r.Paperless_Email_only__c == false  ){  
                    
                    pdf = Page.RAD_WeeklyUpdatePDF_NONSD;     
                    pdf.setRedirect(true);
                    pdf.getParameters().put('id', appl.id);
                    if (!Test.IsRunningTest()) 
                    {
                        b = pdf.getContent(); 
                    }    
                    
                    
                    doc = new Document();
                    
                    doc.name = appl.name+'_'+docCreatedDate+'.pdf';
                    doc.body = b;
                    
                    doc.FolderId =folderWeeklyStatusId;
                    docList.add(doc);               
                    
                }   
                else if( String.isNotBlank(appl.Applicant__r.Email) ){
                    email = new Messaging.SingleEmailMessage(); 
                    email.setTemplateID(templateId_NSD.Id);
                    
                    email.setTargetObjectId (appl.Applicant__c);//sending to applicant
                    
                    emailLst.add(email); 
                } 
            }
            
        } 
        
        // send these count to the batch submitter
        
        List<Database.SaveResult> docResultList   =  Database.insert(docList, false);
        
        Messaging.SendEmailResult [] results = Messaging.sendEmail(emailLst, false);
        //TODO find out how many failed/email bounced, and put them
        
        /*if (!results.get(0).isSuccess()) {
System.StatusCode statusCode = results.get(0).getErrors()[0].getStatusCode();
String errorMessage = results.get(0).getErrors()[0].getMessage();
System.debug('error message '+errorMessage);
}   
*/
        
        //CHK FOR BOUNCED MESSAGE
        
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