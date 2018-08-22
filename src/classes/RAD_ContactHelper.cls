public class RAD_ContactHelper{

    public static void processCntBeforeInsert(List<Contact> conts){
    
        setSendToBoomiOnContacts(conts);
  
    }

    public static void processCntAfterInsert(){
    
        List<Applications__c> applnLst = new List<Applications__c>();
        
        List<Contact> contact_list = [Select id, lastmodifiedby.name, name, SSN_TaxID__c, Date_of_Birth__c, Gender__c, Prospect_Number_YARDI__c, Tenant_Number_YARDI__c ,
                                        Yardi_ID__C,
                                    (Select name,SSN__c,DOB__c, Gender__c, Prospect_Name__c, Tenant__c 
                                        from Applications_WL_00000001__r 
                                        WHERE Application_status__c <> 'Closed'
                                        ORDER BY CREATEDDATE DESC )
                                  from Contact where id in: Trigger.New];
                                  
        for(Contact ct : contact_list ){
                 Applications__c  app_newrec = null;
                 if(ct.Applications_WL_00000001__r.size() > 0){
                     app_newrec = ct.Applications_WL_00000001__r[0];
                     app_newrec.Contact_Last_Modified_By__c = ct.LastModifiedBy.Name;
                     app_newrec.HMY__c = ct.Yardi_ID__C;
                     applnLst.add(app_newrec);
                 }
        }
        if(!applnLst.IsEmpty()) {
        
            Database.update(applnLst, false);        
        }                         

    }

    public static void processCntBeforeUpdate(List<Contact> conts){
       /* System.debug('DLS--in before update');
        for(Contact ct : conts){
            System.debug('DLS--iterating through contacts: '+ ct);
            System.debug('DLS--user name is : '+ UserInfo.getName());
            if(!(UserInfo.getName() =='Dell Boomi'))
            {   System.debug('DLS--Send to boomi is: '+ ct.Send_To_Boomi__c);
               // ct.Send_To_Boomi__c=true;
                System.debug('DLS--now contact checkbox is: '+ ct.Send_To_Boomi__c);
            }
        } */
         setSendToBoomiOnContacts(conts);

    }
    public static void processCntAfterUpdate(){
        if(!System.isBatch() || !System.isScheduled() || !System.isQueueable())
        {
            Set<Id> ctInList_set = new Set<Id>();
            List<Applications__c> applnLst = new List<Applications__c>();
            Applications__c tAppln = null;
            
            List<Contact> contact_list = [Select id, lastmodifiedby.name, name, SSN_TaxID__c, Date_of_Birth__c, Gender__c, Prospect_Number_YARDI__c, Tenant_Number_YARDI__c ,
                                                Yardi_ID__C,RAD_Homeless__c,
                                (Select name,SSN__c,DOB__c, Gender__c, Prospect_Name__c, Tenant__c, Homeless__c  
                                    from Applications_WL_00000001__r 
                                    WHERE Application_status__c <> 'Closed'
                                    ORDER BY CREATEDDATE DESC )
                              from Contact where id in: Trigger.New];
    
            for(Contact ct : contact_list ){
                                         
    
                if( ct.SSN_TaxID__c != ((Contact)Trigger.oldMap.get(ct.id)).SSN_TaxID__c ||
                    ct.Date_of_Birth__c!= ((Contact)Trigger.oldMap.get(ct.id)).Date_of_Birth__c ||
                    ct.Gender__c != ((Contact)Trigger.oldMap.get(ct.id)).Gender__c ||
                    ct.Prospect_Number_YARDI__c != ((Contact)Trigger.oldMap.get(ct.id)).Prospect_Number_YARDI__c ||
                    ct.Tenant_Number_YARDI__c != ((Contact)Trigger.oldMap.get(ct.id)).Tenant_Number_YARDI__c ||
                    ct.RAD_Homeless__c!= ((Contact)Trigger.oldMap.get(ct.id)).RAD_Homeless__c                                                  
                     ){
                     
                     if(ct.Applications_WL_00000001__r.size() > 0){
                         tAppln = ct.Applications_WL_00000001__r[0];
                         tAppln.SSN__c = ct.SSN_TaxID__c;
                         tAppln.DOB__c = ct.Date_of_Birth__c;
                         tAppln.Gender__c = ct.Gender__c;
                         tAppln.Prospect_Name__c = ct.Prospect_Number_YARDI__c;
                         tAppln.Tenant__c = ct.Tenant_Number_YARDI__c;
                         tAppln.Contact_Last_Modified_By__c = ct.LastModifiedBy.Name;
                         system.debug(ct.RAD_Homeless__c);
                         tAppln.Homeless__c = ct.RAD_Homeless__c;
                         applnLst.add(tAppln);
                         
                         if (!ctInList_set.contains(ct.Id)) {
                             ctInList_set.add(ct.Id);
                         }           
                     }
                        
                }                     
                                             
            }//for
            
            for(Contact ct : contact_list ){
                 if (!ctInList_set.contains(ct.Id)) {
                     Applications__c  app_newrec = null;
                     if(ct.Applications_WL_00000001__r.size() > 0){
                         app_newrec = ct.Applications_WL_00000001__r[0];
                         app_newrec.Contact_Last_Modified_By__c = ct.LastModifiedBy.Name;
                         app_newrec.HMY__c = ct.Yardi_ID__C;
                        
                         applnLst.add(app_newrec);
                     }
                 } 
            }
            if(HandleRecursiveTriggers.isFirstTime)
            {
                HandleRecursiveTriggers.isFirstTime = false;
                Database.update(applnLst, false);
            }
        }
        
    }
    
    /*
        Set 'Send to Boomi flag' on contacts if the Application corresponding to the contact is in Submitted Status
    */

    public static void setSendToBoomiOnContacts(List<Contact> lstContacts)
    {
        if(!(UserInfo.getName() == 'Dell Boomi'))
        {
            //Retrieve all submitted applications related to the list of contacts
            List<Applications__c> lstApplications = [SELECT Id, Application_Status__c, Applicant__c FROM Applications__c WHERE Applicant__c IN :lstContacts AND Application_Status__c = 'Submitted' LIMIT 1000];
            
            //Generate a map of Contact ID to the submitted application
            Map<Id, Applications__c> mapContactIdToApplication = new Map<Id, Applications__c>();
            for(Applications__c appln : lstApplications)
                mapContactIdToApplication.put(appln.Applicant__c, appln);
            
            //Set Contact.Send_To_Boomi__c as TRUE only for submitted applications
            for(Contact c : lstContacts)
                if(mapContactIdToApplication.containsKey(c.Id))
                    c.Send_To_Boomi__c = true;
        }
    }


}