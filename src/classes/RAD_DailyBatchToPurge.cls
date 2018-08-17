//ENSURE FOLDER EXIST BEFORE EXECUTING THE BATCH
//System assumes 
global class RAD_DailyBatchToPurge implements Database.batchable<sObject>,Database.Stateful{
    String query;
    global Integer totalPurgeCount;
    global Integer unprocessedCount;
    global Integer totalPurgeReqDocCnt;
    global String updateFolderId;
    global String reminderFolderId;
    


    global RAD_DailyBatchToPurge ()
    {

        
        query = 'Select ID,Name, RAD_Next_Purge_Request_Date__c , RAD_Next_Purge_Date__c, '+ 
                    ' Applicant__c, applicant__r.EmailBouncedDate, Applicant__r.Email, Applicant__r.Paperless_Email_only__c, Applicant__r.Age1__c, '+
                    ' Application_Status__c, (Select ID, Current_Status__c  From Enrolled_Wait_Lists__r  where Current_Status__c =\'Onlist\' ) from Applications__c '+ 
                    ' where RAD_Next_Purge_Request_Date__c < = TODAY and '+
                    ' Application_Status__c in (\'Update Required\',\'Submitted\') '+
                    ' limit 29 ' ;
        system.debug(' Purge query ' +query );
        
        //removed ,\'Update Required\' from the query
                    
        updateFolderId = null;
        reminderFolderId = null;
        
        for(Folder fldr : [select id,name  from folder where name in ('Update Letter', 'Reminder Letter') ]){
            if( fldr.name == 'Update Letter' ){
                updateFolderId = fldr.id;
            }
            if(fldr.name == 'Reminder Letter'){
                reminderFolderId = fldr.id;
            }
        }
        
        totalPurgeCount = 0;
        unprocessedCount = 0;
        totalPurgeReqDocCnt = 0;
       
        
    }

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Applications__c> scope)
    {
        List<Document> docList = new List<Document>();
        Document doc = new Document();
        Blob b = null;
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
        List<Messaging.SingleEmailMessage> emailLst = new List<Messaging.SingleEmailMessage>();
        //Id folderReApplyId = [select id from folder where name ='Re-Apply Notification'].Id;
        

       
        EmailTemplate templateId = [Select id from EmailTemplate where name = 'Re-ApplyUpdateNotification'];
        
        PageReference pdf = null;        
        
        RAD_Configuration__c cnfg = [select Update_Duration_Months__c, RAD_Purge_Extension_Months__c from  RAD_Configuration__c where name = 'Main Configurations' limit 1];
        Integer extnMonths = Integer.valueOf(cnfg.RAD_Purge_Extension_Months__c);
        
        List<Memo__c> memoLst = new List<Memo__c>();
        Memo__c mmo = new Memo__c();
        
        List<Enrolled_Wait_List__c> wls2Updt = new List<Enrolled_Wait_List__c>();
        Map<Id,Applications__c> appMap = new Map<Id, Applications__c>();
        for(Applications__c appl :scope){
            appMap.put(appl.id, appl);
            //if appl has wl with onlist
            List<Enrolled_Wait_List__c> wls = appl.Enrolled_Wait_Lists__r;
            
            if(appl.Applicant__c == null){
                continue;
            }
            System.debug('appplication is '+appl);
            //if exceeding the final purge date, make appl +wl status Removed, clear off the next purge and next purge req date
            
            
            if( Datetime.Now() > (appl.RAD_Next_Purge_Request_Date__c.addMonths(extnMonths))){
                appl.Application_Status__c = 'Removed';
                appl.RAD_Next_Purge_Request_Date__c = null;
                appl.RAD_Next_Purge_Date__c = null;
                
                for(Enrolled_Wait_List__c wl : wls){
                    wl.Current_Status__c = 'Removed';
                    wls2Updt.add(wl);
                }

                
             //else today has just crossed purge request date, update Submitted application, keep the WL as is   
            }else if( Datetime.Now() >= (appl.RAD_Next_Purge_Request_Date__c ) && appl.Application_Status__c == 'Submitted' ){
                system.debug(' $$$$ Condition 2' +appl.id   +( Datetime.Now() >= (appl.RAD_Next_Purge_Request_Date__c ) && appl.Application_Status__c == 'Submitted' ) );
                appl.Application_Status__c = 'Update Required';
                
                //CREATE MEMO 
                
                
                if( String.isBlank(appl.Applicant__r.Email) && appl.Applicant__r.Paperless_Email_only__c == false ){
                
                    //pdf = Page.RAD_PDF_ReApplyUpdateNotification;           
                    if(appl.Applicant__r.Age1__c > 62){
                        pdf = Page.RAD_PurgeUpdtReqEld;           
                    }else{
                        pdf = Page.RAD_PurgeUpdtReqNonEld;           
                    }
                    pdf.setRedirect(true);
                    pdf.getParameters().put('id', appl.id);
                    if (!Test.IsRunningTest()) 
                    {
                      b = pdf.getContent();
                    }
                    doc = new Document();
                    doc.name = 'ReApply before '+ appl.RAD_Next_Purge_Request_Date__c.addMonths(extnMonths) +': '+ appl.Name +'.pdf';
                    doc.body = b;
                    doc.FolderId = updateFolderId ;
                    docList.add(doc);
                    
                    mmo = new Memo__c();
                    //mmo.Subject__c = 'Update letter sent';
                    mmo.Name = 'Update letter sent';
                    mmo.Type__c = 'Wait List';
                    mmo.Notes__c = 'System Generated Memo';
                    mmo.Applications__c = appl.id;
                    memoLst.add(mmo);
                
                }else if(  String.isNotBlank(appl.Applicant__r.Email) ){
                    if(appl.applicant__r.EmailBouncedDate==null){    
                        email = new Messaging.SingleEmailMessage(); 
                        
                        if(appl.Applicant__r.Age1__c > 62){
                            email.setTemplateID(templateId.Id);
                        }else{
                            email.setTemplateID(templateId.Id);
                        }
                        String [] toAddresses = new String[] {appl.Applicant__r.Email};
                        System.debug('rhathi sending to '+appl.Applicant__r.Email);
                        //email.setSubject('ReApply Notification');
                        //email.setToAddresses(toAddresses);
                        //email.setTargetObjectId ('003r0000006B9yw');//sending to myself...should be applicant
                        
                        email.setTargetObjectId (appl.Applicant__c);//sending to applicant
                        //email.setWhatId(appl.id); //Your Record Id if applicable
                        //email.setorgWideEmailAddressId('0D2r00000004Cr5');
    
    
                        emailLst.add(email);
                        
                        mmo = new Memo__c();
                        //mmo.Subject__c = 'Update email sent';
                        mmo.Name = 'Update email sent';
                        mmo.Type__c = 'Wait List';
                        mmo.Notes__c = 'System Generated Memo';
                        mmo.Applications__c = appl.id;
                        memoLst.add(mmo);
                	}
                    else{
                        //Bounced email -- so create memo that sends letter
                    	
                        memoLst.add(createMemo(appl, 'BounceUpdate'));
                    }
                }else{
                    //DO NOTHING
                }
            }else if( (Date.Today() == (appl.RAD_Next_Purge_Date__c).addDays(-10).date() ) && appl.Application_Status__c == 'Update Required' ){
                
                //CREATE MEMO ???check with Ajay for reminder

                
                if( String.isBlank(appl.Applicant__r.Email) && appl.Applicant__r.Paperless_Email_only__c == false ){
                    
                    System.debug('rhathi sending reminder');                
                    
                    //pdf = Page.RAD_PDF_ReApplyUpdateNotification;           
                    if(appl.Applicant__r.Age1__c > 62){
                        pdf = Page.RAD_PurgeFinlRemndrEld;           
                    }else{
                        pdf = Page.RAD_PurgeFinlRemndrNonEld;           
                    }
                    pdf.setRedirect(true);
                    pdf.getParameters().put('id', appl.id);
                    if (!Test.IsRunningTest()) 
                    {
                      b = pdf.getContent();
                    }
                    
                    doc = new Document();
                    doc.name = 'Final Reminder : '+ appl.Name +'.pdf';
                    doc.body = b;
                    doc.FolderId = reminderFolderId;
                    docList.add(doc);
                    
                    mmo = new Memo__c();
                    //mmo.Subject__c = 'Update letter sent';
                    mmo.Name = 'Update letter sent';
                    mmo.Type__c = 'Wait List';
                    mmo.Notes__c = 'System Generated Memo';
                    mmo.Applications__c = appl.id;
                    memoLst.add(mmo);
                
                }else if(  String.isNotBlank(appl.Applicant__r.Email) ){
                    if(appl.applicant__r.EmailBouncedDate==null){
                        email = new Messaging.SingleEmailMessage(); 
                        
                        if(appl.Applicant__r.Age1__c > 62){
                            email.setTemplateID(templateId.Id);
                        }else{
                            email.setTemplateID(templateId.Id);
                        }
                        String [] toAddresses = new String[] {appl.Applicant__r.Email};
                        System.debug('rhathi sending to '+appl.Applicant__r.Email);
                        //email.setSubject('ReApply Notification');
                        //email.setToAddresses(toAddresses);
                        //email.setTargetObjectId ('003r0000006B9yw');//sending to myself...should be applicant
                        
                        email.setTargetObjectId (appl.Applicant__c);//sending to applicant
                        //email.setWhatId(appl.id); //Your Record Id if applicable
                        //email.setorgWideEmailAddressId('0D2r00000004Cr5');
    
    
                        emailLst.add(email);
                        
                        mmo = new Memo__c();
                        //mmo.Subject__c = 'Update email sent';
                        mmo.Name = 'Update email sent';
                        mmo.Type__c = 'Wait List';
                        mmo.Notes__c = 'System Generated Memo';
                        mmo.Applications__c = appl.id;
                        memoLst.add(mmo);
                    }
                    else{
                        
                        //Bounced email -- so create memo
                    	
                        memoLst.add(createMemo(appl, 'BounceReminder'));
                       
                    }
                }else{
                    //DO NOTHING
                }
            }
        }//for        
       totalPurgeCount += scope.size(); 
       totalPurgeReqDocCnt += docList.size();
        List<Database.SaveResult> applnResultList =  Database.update(scope, false);
        system.debug('$$$$ updating ApplicationRecords ' +scope );
        List<Database.SaveResult> wlResultList =  Database.update(wls2Updt, false);
        List<Database.SaveResult> docResultList   =  Database.insert(docList, false);
        Messaging.SendEmailResult [] results = Messaging.sendEmail(emailLst, false);
        List<Database.SaveResult> memoResultLst =  Database.insert(memoLst, false);
        
        if (!results.isEmpty() && !results.get(0).isSuccess()) {
            System.StatusCode statusCode = results.get(0).getErrors()[0].getStatusCode();
            String errorMessage = results.get(0).getErrors()[0].getMessage();
            System.debug('error message '+errorMessage);
             RAD_Exception_Log__c eLog = new RAD_Exception_Log__c();
            eLog.RAD_Error_Source__c = 'email error';
            eLog.RAD_Error_Message__c = errorMessage ;
            insert elog;
            //Iterate through results here and create memos for failure
            for(Messaging.SendEmailResult res:results){
            	if (!res.success) 
                {   //Go through the results and set up memos for failed emails
                    if(appMap.get(res.getErrors()[0].getTargetObjectId()).Application_Status__c=='Submitted')
                        createMemo((appMap.get(res.getErrors()[0].getTargetObjectId())), 'PurgeReminderFailure ');
                    else if(appMap.get(res.getErrors()[0].getTargetObjectId()).Application_Status__c=='Update Required')
                        createMemo(appMap.get(res.getErrors()[0].getTargetObjectId()), 'PurgeUpdateFailure ');
                }
            }
        }   
 
        
        
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
    
    
        mail.setSubject('Rental Assistance Purge Batch Completed');
        mail.setPlainTextBody(
        'Batch Process has completed.'+
        '\nTotal Application(s) for Processing: '+totalPurgeCount+
        '\nTotal Purge Document loaded: '+totalPurgeReqDocCnt 
        
        );
        
        try {
          Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        } catch(System.EmailException sme) {
          //DO NOTHING...
        }
    }            
    public static Memo__c createMemo(applications__c app, String type){
        Memo__c mmo = new Memo__c();
        if(type=='BounceUpdate'){
            mmo.Subject__c = 'Email bounce from Purge Update';
            mmo.Name = 'Email bounce from Purge Update';
			mmo.ErrorMemoType__c='PurgeUpdateFailure';
        }
        else if (type=='BounceReminder'){
            mmo.Subject__c = 'Email bounce from Purge Reminder';
            mmo.Name = 'Email bounce from Purge Reminder';
            mmo.ErrorMemoType__c='PurgeReminderFailure';
        }
        else if (type=='PurgeReminderEmail'){
            mmo.Subject__c = 'Email failure from Purge Reminder';
            mmo.Name = 'Email failure from Purge Reminder';
            mmo.ErrorMemoType__c='PurgeReminderFailure';
        }
        else if (type=='PurgeUpdateEmail'){
            mmo.Subject__c = 'Email failure from Purge Update';
            mmo.Name = 'Email failure from Purge Update';
            mmo.ErrorMemoType__c='PurgeUpdateFailure';
        }
        mmo.Type__c = 'Wait List';
        mmo.Notes__c = 'System Generated Memo';
        mmo.Applications__c = app.id;
        
        return mmo;
    }

}