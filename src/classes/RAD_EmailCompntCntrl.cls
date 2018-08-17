public class RAD_EmailCompntCntrl {
    public Id contactId {get;set;}

    public RAD_EmailCompntCntrl(){
    
    }
    
    public List<Enrolled_Wait_List__c> getwaitlistCollections()
    {

        List<Enrolled_Wait_List__c> waitlistCollection;
        waitlistCollection = [select Id ,Name,RAD_Date_and_Time_with_Seconds__c, Current_Status__c ,SFDC_Original_Datetime__c, Wait_List_Type__r.Name,
                              Applications__r.Applicant__r.Name,Applications__r.Applicant__r.Id, Original_Date_Time_with_seconds__c 
                              FROM Enrolled_Wait_List__c 
                              where  Applications__r.Applicant__r.Id =:contactId 
                            ];
        return waitlistCollection;
    }



}//class