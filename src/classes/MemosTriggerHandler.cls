public class MemosTriggerHandler extends TriggerHandler 
{	
    public MemosTriggerHandler() 
    {
      //this.setMaxLoopCount(1);
    }

    public override void beforeUpdate() 
    {
      for(Memo__c memo:(List<Memo__c>) Trigger.new)
        {
          if(!(UserInfo.getName() =='Dell Boomi'))
            memo.Send_To_Boomi__c=true;
        }
    }
    public override void afterUpdate()
    {
    
    }
    public override void beforeInsert() 
    {
      for(Memo__c memo:(List<Memo__c>) Trigger.new)
        {
          memo.DateTimeMilliseconds__c=String.valueOf(memo.Date_and_Time__c.getTime());
            if(!(UserInfo.getName() =='Dell Boomi'))
            memo.Send_To_Boomi__c=true;
        }
    
    }
    public override void afterInsert() 
    {
      List<Memo__c> lstMemos = [Select Id, Name, Result__c,Applications__r.Applicant__c, ErrorMemoType__c, Applications__r.Applicant__r.MailingAddress, Applications__r.Applicant__r.Email, Applications__r.Applicant__r.Paperless_Email_only__c from Memo__c where id  in : trigger.new];
       List<Messaging.SingleEmailMessage> emailLst = new List<Messaging.SingleEmailMessage>();
        EmailTemplate templateId_transfLett = [Select id from EmailTemplate where name ='Transfer Letters' LIMIT 1];
        if(lstMemos != NULL)
        { List<ID> letterList=new List<ID>();
          for(Memo__c memo: lstMemos)
          {
            if(memo.Applications__r.Applicant__r.Email!='' && memo.Applications__r.Applicant__r.Paperless_Email_only__c == True && (memo.Result__c == 'D1-App National City' || memo.Result__c == 'D2- App Oceanside') )
              {
          		  Messaging.SingleEmailMessage mail = Messaging.renderStoredEmailTemplate(templateId_transfLett.Id, memo.Applications__r.Applicant__c, memo.Id);
                  String[] toAddresses = new String[] {memo.Applications__r.Applicant__r.Email};
                  mail.setToAddresses(toAddresses);
                  
                    Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEMailMessage[] {mail});
                }
              if((memo.ErrorMemoType__c =='FieldUpdateEmailFailure')||(memo.ErrorMemoType__c =='PurgeReminderFailure')||(memo.ErrorMemoType__c =='PurgeUpdateFailure')){
                  letterList.add(memo.id);
              }  
              
          
      }
         if(letterList.size()>0){
             createLetters(letterList);
         }      
    }
    }
    
    public override void beforeDelete() 
    {
    
    }
    public override void afterDelete() 
    {
    
    }
    public override void afterUndelete()
    {
    
    }
    @future(callout=true)
    public static void createLetters(List<ID> memoIDList){
        //This takes a list of memos, and creates letters for those clients
        List<Document> docList = new List<Document>();
        List<memo__c> memoList = new List<Memo__c>([SELECT Id, ErrorMemoType__c, Applications__r.RAD_Next_Purge_Request_Date__c, Applications__r.Applicant__r.age1__c, Applications__r.id, Applications__r.name, Applications__r.Live_Work_in_City_of_San_Diego__c FROM Memo__c WHERE id in :memoIDList]);
        Document doc = new Document();
        Blob b = null;
        Id folderWeeklyStatusId;
        Id folderWeeklyUpdateId;
        for(Folder f:[select id, name from folder where name IN ('RAD Wait List - Status Letter','Update Letter')]){
            if(f.name == 'RAD Wait List - Status Letter')
                folderWeeklyStatusId = f.Id;
            else if (f.name == 'Update Letter')
            	folderWeeklyUpdateId = f.Id;
        }                               
        
        PageReference pdf = null;  
        RAD_Configuration__c cnfg = [select Update_Duration_Months__c, RAD_Purge_Extension_Months__c from  RAD_Configuration__c where name = 'Main Configurations' limit 1];        
        Integer extnMonths = Integer.valueOf(cnfg.RAD_Purge_Extension_Months__c);
        for(Memo__c memo:memoList){
            if(memo.ErrorMemoType__c=='FieldUpdateEmailFailure'){
                if(memo.Applications__r.Live_Work_in_City_of_San_Diego__c){
                    pdf = Page.RAD_WeeklyUpdatePDF_SD;                                             
                }
                else{
                    pdf = Page.RAD_WeeklyUpdatePDF_NONSD;     
                }
                pdf.setRedirect(true);
                pdf.getParameters().put('id', memo.Applications__r.id);
                if (!Test.IsRunningTest()) 
                {
                    b = pdf.getContent(); 
                }    
                
                
                doc = new Document();
                
                doc.name = memo.Applications__r.name+'_'+Date.Today()+'.pdf';
                doc.body = b;
                
                doc.FolderId =folderWeeklyStatusId;
                docList.add(doc); 
        	}
        	else if (memo.ErrorMemoType__c=='PurgeUpdateFailure'){
                if(memo.Applications__r.Applicant__r.age1__c>62){
                    pdf = Page.RAD_PurgeUpdtReqEld;                                             
                }
                else{
                    pdf = Page.RAD_PurgeUpdtReqNonEld;     
                }
                pdf.setRedirect(true);
                pdf.getParameters().put('id', memo.Applications__r.id);
                if (!Test.IsRunningTest()) 
                {
                    b = pdf.getContent(); 
                }    
                
                
                doc = new Document();
                
                doc.name = 'ReApply before '+ memo.applications__r.RAD_Next_Purge_Request_Date__c.addMonths(extnMonths) +': '+ memo.applications__r.Name +'.pdf';
                doc.body = b;
                
                doc.FolderId =folderWeeklyStatusId;
                docList.add(doc); 
            
        	}
        	else if (memo.ErrorMemoType__c=='PurgeReminderFailure'){
                if(memo.Applications__r.Applicant__r.age1__c>62){
                    pdf = Page.RAD_PurgeFinlRemndrEld;                                             
                }
                else{
                    pdf = Page.RAD_PurgeFinlRemndrNonEld;     
                }
                pdf.setRedirect(true);
                pdf.getParameters().put('id', memo.Applications__r.id);
                if (!Test.IsRunningTest()) 
                {
                    b = pdf.getContent(); 
                }    
                
                
                doc = new Document();
                
                doc.name = 'ReApply before '+ memo.applications__r.RAD_Next_Purge_Request_Date__c.addMonths(extnMonths) +': '+ memo.applications__r.Name +'.pdf';
                doc.body = b;
                
                doc.FolderId =folderWeeklyStatusId;
                docList.add(doc); 
            
        	}
        }
        try{
        	List<Database.SaveResult> docResultList   =  Database.insert(docList, false);
        }
        catch(Exception e)
        {
            System.debug('Failed to insert memo documents: '+ e);
        }
    }
}