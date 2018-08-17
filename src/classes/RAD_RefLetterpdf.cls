public class RAD_RefLetterpdf{
    public Wait_List_Selection__c  wlcon {get;set;}
    
    public list<Selection_Records__c>  selList;
    
    public String wlsId {get;set;}
    
    public  RAD_RefLetterpdf(ApexPages.StandardController stdController ) {
        this.wlcon = (Wait_List_Selection__c)stdController.getRecord(); 
        
    }  
    
    public List<Selection_Records__c> getSelList()     
    {
        wlsId=wlcon.id;
        
        List<Selection_Records__c> selList=[select Name ,Selection_ID__c,Selection_ID__r.Name,RAD_Wait_List__c,RAD_Wait_List__r.Wait_List_Type__r.Name,Status__c,
            RAD_Wait_List__r.Applications__c,RAD_Wait_List__r.Applications__r.Name,RAD_Wait_List__r.Applications__r.Applicant__c,
            RAD_Wait_List__r.Applications__r.Applicant__r.Name,RAD_Wait_List__r.Applications__r.Applicant__r.Email,RAD_Wait_List__r.Applications__r.Applicant__r.Phone,
            RAD_Wait_List__r.Applications__r.Applicant__r.MailingStreet, RAD_Wait_List__r.Applications__r.Applicant__r.Mailingcity,
            RAD_Wait_List__r.Applications__r.Applicant__r.MailingState,RAD_Wait_List__r.Applications__r.Applicant__r.Mailingpostalcode,
            RAD_Wait_List__r.Applications__r.Applicant__r.Residential_Street__c,RAD_Wait_List__r.Applications__r.Applicant__r.Residential_City__c,
            RAD_Wait_List__r.Applications__r.Applicant__r.Residential_State__c,RAD_Wait_List__r.Applications__r.Applicant__r.Residential_Zipcode__c,
            RAD_Wait_List__r.Applications__r.Applicant__r.MobilePhone from Selection_Records__c 
                 where Status__c='Selected' and Selection_ID__c=:wlsId ];
        
        
        return selList;
    }
    
    
}