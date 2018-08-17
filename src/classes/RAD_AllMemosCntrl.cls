/****
Class Name : RAD_AllMemosCntrl
Purpose : This Class will display All Memos for each Application.
****/


public class RAD_AllMemosCntrl {
    
    public id appid{get;set;}
    public list<Memo__c> memoRecords{get;set;}
    
    
    public RAD_AllMemosCntrl(){
        appid = ApexPages.currentPage().getParameters().get('id');
        system.debug('Application Id' +appid);
        if(appid!=null)
        memoRecords = [select id, name,Applications__r.Name, Date_and_Time__c, Notes__c from Memo__c
                        where 
                        Applications__c = :appid];
        system.debug(memoRecords);
        
    }
    
}