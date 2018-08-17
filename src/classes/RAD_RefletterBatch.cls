global class RAD_RefletterBatch implements Database.batchable<sObject>,Database.Stateful{
    String query;
    String wlsIdd;
    global string respdate;
    global string casewoker1;
    global string bedsize1;
    global string unitaddrs1;
    global string ownername1;
    global string owneraddress1;
    global String cmdates1; 
    global Set<id> finalSelIds;
    
    public  Static string todayp {get;set;}
    
    global RAD_RefletterBatch(String wlsId,string resdate,string caseworker,string bedsize,string unitaddress, string ownername,string owneraddress,string cmndate,Set<id> finalSelIds)
    {
        wlsIdd = wlsId;
        respdate=resdate;
        casewoker1=caseworker;
        bedsize1=bedsize;
        unitaddrs1=unitaddress;
        ownername1=ownername;
        owneraddress1=owneraddress;
        cmdates1=cmndate;
        this.finalSelIds = finalSelIds;
        
        
        query='Select name,Wait_List_Type__c,Wait_List_Type__r.Name from Wait_List_Selection__c where id =:wlsIdd';              
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
        Id folderPBSRefId = [select id from folder where name ='Notice of Owner Referral - PBS'].Id; 
        Id folderMRRefId = [select id from folder where name ='Notice of Owner Referral - MR'].Id;
        Id folderPBRefId = [select id from folder where name ='Notice of Owner Referral - PBV'].Id;
        
        
        
        PageReference pdf = null; 
        
        
        List<RAD_Exception_Log__c> excpLogs = new List<RAD_Exception_Log__c>();
        RAD_Exception_Log__c eLog = new RAD_Exception_Log__c();                               
        
        
        for(Wait_List_Selection__c sr :scope)    
        {
            if(sr.Wait_List_Type__r.Name=='Project Based Single')
            {
                String str='/apex/RAD_PBS_Ref_Letter_Ravi?&ownrNmPh='+ownername1+'&owneraddress='+ owneraddress1+'&unitaddres='+unitaddrs1+'&resdate='+respdate+'&caseworkert='+ casewoker1+'&bsize='+ bedsize1+'&cmdat='+ cmdates1+'&selrecs='+finalSelIds;
                system.debug('Url'+ str); 
                pdf = new PageReference('/apex/RAD_PBS_Ref_Letter?&ownrNmPh='+ownername1+'&owneraddress='+ owneraddress1+'&unitaddres='+unitaddrs1+'&resdate='+respdate+'&caseworkert='+ casewoker1+'&bsize='+ bedsize1+'&cmdat='+ cmdates1+'&selrecs='+finalSelIds);
                
                pdf.setRedirect(true);
                pdf.getParameters().put('id', sr.id);
                
                if(!Test.isRunningTest()){ 
                    b = pdf.getContent();
                }                 
                doc = new Document();
                doc.name=Date.today().format() +'_'+ sr.Name +'.pdf';                 
                doc.body = b;
                doc.FolderId =folderPBSRefId;
                docList.add(doc);
                List<Database.SaveResult> docResultList   =  Database.insert(docList, false);   
                
            }  
            else if(sr.Wait_List_Type__r.Name=='Mod Rehab')
            {
                
                pdf = new PageReference('/apex/RAD_ModRehab_RefLetter?&ownrNmPh='+ownername1+'&owneraddress='+ owneraddress1+'&unitaddres='+unitaddrs1+'&resdate='+respdate+'&caseworkert='+ casewoker1+'&bsize='+ bedsize1+'&cmdat='+ cmdates1+'&selrecs='+finalSelIds);
                
                pdf.setRedirect(true);
                pdf.getParameters().put('id', sr.id);
                
                if(!Test.isRunningTest()){ 
                    b = pdf.getContent();
                }                 
                doc = new Document();
                doc.name=Date.today().format() +'_'+ sr.Name +'.pdf';                 
                doc.body = b;
                doc.FolderId =folderMRRefId;
                docList.add(doc);
                List<Database.SaveResult> docResultList   =  Database.insert(docList, false);   
                
                
            }
            else if(sr.Wait_List_Type__r.Name=='project Based')
            {
                
                pdf = new PageReference('/apex/RAD_PB_Ref_Letter?&ownrNmPh='+ownername1+'&owneraddress='+ owneraddress1+'&unitaddres='+unitaddrs1+'&resdate='+respdate+'&caseworkert='+ casewoker1+'&bsize='+ bedsize1+'&cmdat='+ cmdates1+'&selrecs='+finalSelIds);
                
                pdf.setRedirect(true);
                pdf.getParameters().put('id', sr.id);
                
                if(!Test.isRunningTest()){ 
                    b = pdf.getContent();
                }                 
                doc = new Document();
                doc.name=Date.today().format() +'_'+ sr.Name +'.pdf';                 
                doc.body = b;
                doc.FolderId =folderPBRefId;
                docList.add(doc);
                List<Database.SaveResult> docResultList   =  Database.insert(docList, false);   
                
                
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
        
        
        mail.setSubject('Referral Letter Generation Batch has Completed.');
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