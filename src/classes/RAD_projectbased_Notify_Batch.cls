global class RAD_projectbased_Notify_Batch implements Database.batchable<sObject>,Database.Stateful{
    global String selRunId;
    global String query;
    global string letter;
    global string addrs;
    global string ownersph;
    global string bedsize;
    global Date cmdates;
    global String owneraddr;
    global String newdate;
    global Date respdate;
    global string newresdate;
    global string casewoker;
    global string todaydate;
    global list<Selection_Records__c> finalSelIds;
    global string ownerPhoneNo;
    
    
    
    global RAD_projectbased_Notify_Batch( String s, string le,string addr, string owner,string bedroom,Date cmdate,string owneradd,Date resdate,string casework,string todaydat,list<Selection_Records__c> finalSelIds,string ownerPhone)
    {      
        
        selRunId=s;
        letter=le;
        addrs=addr;
        ownersph=owner;
        bedsize=bedroom;
        cmdates=cmdate;
        this.finalSelIds = finalSelIds;
        ownerPhoneNo = ownerPhone;
        
        
        if(cmdates!=Null)
        {
            newdate=cmdates.format();
        }
        owneraddr=owneradd;  
        respdate=resdate;
        if(newresdate!=null)
        {
            newresdate=resdate.format();
        }
        casewoker=casework;
        todaydate=todaydat;
        
        system.debug('strQuery------->'+ s);
        system.debug('selected letter is------->'+ letter);                
        
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        
        query= 'select Name,Status__c,Selection_ID__c,Selection_ID__r.Name,RAD_Wait_List__c,RAD_Wait_List__r.Wait_List_Type__c,RAD_Wait_List__r.Wait_List_Type__r.Name, RAD_Wait_List__r.Name,RAD_Wait_List__r.Applications__c,RAD_Wait_List__r.Applications__r.Name,RAD_Wait_List__r.Applications__r.Applicant__c,RAD_Wait_List__r.Applications__r.Applicant__r.Name,RAD_Wait_List__r.Applications__r.Applicant__r.Email,RAD_Wait_List__r.Applications__r.Applicant__r.Person_Email__c ,RAD_Wait_List__r.Applications__r.Applicant__r.Paperless_Email_only__c from Selection_Records__c where id=:finalSelIds and Status__c=\'Selected\' ';
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Selection_Records__c > scope)
        
    {
        PageReference pdf = null;
        
        Id folderReApplyId = [select id from folder where name ='Notice of Opportunity - MR'].Id; 
        Id folderProjectbasedId = [select id from folder where name ='Notice of Opportunity - PBV'].Id; 
        Id folderPbsId = [select id from folder where name ='Notice of Opportunity - PBS'].Id;
        Id folderMRRefId = [select id from folder where name ='Notice of Owner Referral - MR'].Id;
        Id folderPBRefId = [select id from folder where name ='Notice of Owner Referral - PBV'].Id;
        Id folderPBSRefId = [select id from folder where name ='Notice of Owner Referral - PBS'].Id;
        
        
        List<Document> docList = new List<Document>();
        Document doc = new Document();
        Blob b = null;
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
        List<Messaging.SingleEmailMessage> emailLst = new List<Messaging.SingleEmailMessage>();
        
        
        for(Selection_Records__c sr:scope )    
        {
            
            
            list<Selection_Records__c> cust=new List<Selection_Records__c>();
            
            
            
            
            if( sr.RAD_Wait_List__r.Wait_List_Type__r.Name =='Mod Rehab' && (letter=='NOletter'|| letter=='NORLetter'))
            {
                
                pdf = new PageReference('/apex/RAD_Mod_Rehab_Notice_opp_Letter?&urlparm='+ownersph + '&unitaddres=' + addrs + '&bsize=' + bedsize+ '&cmdat=' + newdate+'&owneraddress='+owneraddr+ '&caseworkert='+casewoker+ '&ownPhNo='+ownerPhoneNo);     
               
                system.debug('$$$$ url ownersph value ' +ownersph );
                system.debug('$$$$ url unitaddres value ' +addrs );
                system.debug('$$$$ url bsize value ' +bedsize );
                system.debug('$$$$ url cmdat value ' +newdate);
                system.debug('$$$$ url owneraddress value ' +owneraddr);
                system.debug('$$$$ url caseworkert value ' +casewoker);
                system.debug('$$$$ url caseowner phonenumber value ' +ownerPhoneNo);
                
                
                pdf.setRedirect(true);
                pdf.getParameters().put('id', sr.id);
                if(!Test.isRunningTest()){ 
                    b = pdf.getContent(); 
                }
                doc = new Document();         
                
                doc.name=sr.RAD_Wait_List__r.Applications__r.Name+'_'+sr.Name+'_ '+ todaydate+'.pdf'; 
                doc.body = b;
                doc.FolderId =folderReApplyId;
                docList.add(doc);
            } 
            
            
            else if( sr.RAD_Wait_List__r.Wait_List_Type__r.Name =='project Based' && (letter=='NOletter'|| letter=='NORLetter')) {
                
                
                
                
                pdf = new PageReference('/apex/RAD_Projectbased_Noti_Opp_Letter?&urlparm='+ownersph + '&unitaddres=' + addrs + '&bsize=' + bedsize+ '&cmdat=' + newdate+'&owneraddress='+owneraddr+ '&caseworkert='+casewoker+ '&ownPhNo ='+ownerPhoneNo);               
                
                pdf.setRedirect(true);
                pdf.getParameters().put('id', sr.id);
                if(!Test.isRunningTest()){ 
                    b = pdf.getContent(); 
                }
                doc = new Document();         
                
                doc.name=sr.RAD_Wait_List__r.Applications__r.Name+'_'+sr.Name+'_ '+ todaydate+'.pdf'; 
                doc.body = b;
                doc.FolderId =folderProjectbasedId;
                docList.add(doc); 
            } 
            
            else if( sr.RAD_Wait_List__r.Wait_List_Type__r.Name =='Project Based Single' && (letter=='NOletter'|| letter=='NORLetter'))  {
                
                
                
                pdf = new PageReference('/apex/RAD_PBS_Notice_Letter?&urlparm='+ownersph + '&unitaddres=' + addrs + '&bsize=' + bedsize+ '&cmdat=' + newdate+'&owneraddress='+owneraddr+ '&caseworkert='+casewoker+ '&ownPhNo ='+ownerPhoneNo);               
                
                pdf.setRedirect(true);
                pdf.getParameters().put('id', sr.id);
                if(!Test.isRunningTest()){ 
                    b = pdf.getContent();
                }
                doc = new Document();         
                
                doc.name=sr.RAD_Wait_List__r.Applications__r.Name+'_'+sr.Name+'_ '+ todaydate+'.pdf'; 
                doc.body = b;
                doc.FolderId =folderPbsId ;
                docList.add(doc); 
            } 
            
            
            
        }  
        List<Database.SaveResult> docResultList   =  Database.insert(docList, false);
        Messaging.SendEmailResult [] results = Messaging.sendEmail(emailLst, false);
        
    }
    global void finish(Database.BatchableContext BC)
    {
        
     /*   // Set Application Trigger on during run.
        SwitchTrigger__c AppTrigger = SwitchTrigger__c.getInstance('Applications__c');
        if(AppTrigger != Null) {
            AppTrigger.Active__c = false;
            update AppTrigger;
        }    */    
        
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,
                          TotalJobItems, CreatedBy.Email
                          from AsyncApexJob where Id =
                          :BC.getJobId()];
        // Send an email to the Apex job's submitter notifying of job completion.  
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[]{a.CreatedBy.Email};
            mail.setToAddresses(toAddresses);
        
        
        mail.setSubject('Project Based Notification Batch Completed.');
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