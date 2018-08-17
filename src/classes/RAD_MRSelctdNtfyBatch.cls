//This class is used for notifying the MRapplicants via pdf with cover letter or email

global class RAD_MRSelctdNtfyBatch implements Database.batchable<sObject>,Database.Stateful{
    String query;
    String wlsIdd;
    
    global RAD_MRSelctdNtfyBatch(String wlsId)
    {

        wlsIdd = wlsId;

        query  = 'Select RAD_Wait_List__c, RAD_Wait_List__r.Name, '+
                 ' RAD_Wait_List__r.Applications__c,RAD_Wait_List__r.Applications__r.Name,RAD_Wait_List__r.Applications__r.Applicant__c, '+
                 ' RAD_Wait_List__r.Applications__r.Applicant__r.Name,RAD_Wait_List__r.Applications__r.Applicant__r.Email, '+
                 ' RAD_Wait_List__r.Applications__r.Applicant__r.Paperless_Email_only__c'+
                 ' from Selection_Records__c where Selection_ID__c =:wlsIdd and Status__c=\'Selected\' and RAD_Wait_List__r.Wait_List_Type__r.Name =\'Mod Rehab\'';

                system.debug('RAD_MRSelctdNtfyBatch strQuery------->'+query);               
       
    }

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Selection_Records__c> scope)
    {
        List<Document> docList = new List<Document>();
        Document doc = new Document();
        Document doc1 = new Document();
        Blob b = null;
        /*Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
        List<Messaging.SingleEmailMessage> emailLst = new List<Messaging.SingleEmailMessage>(); */
        Id sec8FolderId;
        if(!Test.isRunningTest()){
            sec8FolderId = [select id from folder where name ='Intake Appointment - MR'].Id;
        }
        String fName= '';
               
       /* EmailTemplate templateId = [Select id from EmailTemplate where name ='NEDNotification']; */
               
        PageReference pdf = null; 
              
        
        List<RAD_Exception_Log__c> excpLogs = new List<RAD_Exception_Log__c>();
        RAD_Exception_Log__c eLog = new RAD_Exception_Log__c();                               
 
          
           for(Selection_Records__c sr :scope)    
           {
                
                if(sr.RAD_Wait_List__r.Applications__r.Applicant__c == null){
                    continue;
                }
                
               /* if( String.isBlank(sr.RAD_Wait_List__r.Applications__r.Applicant__r.Email) && sr.RAD_Wait_List__r.Applications__r.Applicant__r.Paperless_Email_only__c == false ){ */ 
            
                    pdf = Page.RAD_PDF_MRNotification;           
                    pdf.setRedirect(true);
                    pdf.getParameters().put('id', sr.RAD_Wait_List__r.id);
                    if(!Test.isRunningTest()){ 
                        b = pdf.getContent();
                    }   

                    
                    doc = new Document();
                    fName = sr.RAD_Wait_List__r.Applications__r.Name + '_Intake Appointment - MR.pdf';
                    //System.debug('The file name is '+ fName);
                    doc.name = fName;
                   
                    doc.body = b;
                    if(!Test.isRunningTest()){
                        doc.FolderId =sec8FolderId ;
                    }
                    docList.add(doc);
                    
                
           /*} */
            
               /*else if( String.isNotBlank(sr.RAD_Wait_List__r.Applications__r.Applicant__r.Email) ){
                    email = new Messaging.SingleEmailMessage(); 
                    email.setTemplateID(templateId.Id);
                    email.setTargetObjectId (sr.RAD_Wait_List__r.Applications__r.Applicant__c);//sending to applicant
                    emailLst.add(email);
                } */
                //DO NOTHING
     
       } 

        //totalNEDCount += scope.size(); 
        //totalsection8DocCnt += docList.size();
        // send these count to the batch submitter
    
    
        if(!docList.isEmpty()){
            List<Database.SaveResult> docResultList   =  Database.insert(docList, false);
            for(Integer i=0;i<docResultList.size();i++){
                
                    if(!docResultList[i].isSuccess()){
                         eLog = new RAD_Exception_Log__c();
                         eLog.RAD_Error_Source__c = 'Batch Error when processing MR selection letter';
                         eLog.RAD_Error_Message__c = 'Creating Selection Record: '+docResultList[i].getErrors();
        
                         excpLogs.add(eLog);
                    }
                
            }
        }
            
        if(!excpLogs.isEmpty()){
                Database.insert(excpLogs, false);
        }

  /*  Messaging.SendEmailResult [] results = Messaging.sendEmail(emailLst, false); */
   //TODO find out how many failed/email bounced, and put them
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
         String[] toAddresses = new String[] {a.CreatedBy.Email};
         mail.setToAddresses(toAddresses);
    
    
        mail.setSubject('Rental Assistance MR Notification Completed');
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