//This class generates random number for lottery selection for onlist Proj Based Single WL for the default bedroom count of 1 and 
//counts the wl records for processing.

global class RAD_PBSSeln_Batch implements Database.batchable<sObject>,Database.Stateful{
    String query;
     global Set<String> rannumset; 
     global String wlsidd;
     global Decimal totalRecordCount;
     global Decimal eli;
     global Decimal vli;
     global Decimal li;
     global Decimal schrcount;
    
    
    global RAD_PBSSeln_Batch(string wlsid){
    
    wlsidd=wlsid;
    rannumset=new Set<String>(); 

    totalRecordCount = 0;
        
        query = 'Select ID, Lottery__c ' +
                ' from Enrolled_Wait_List__c where CreatedDate >= 2018-07-19T19:12:41.000+0000 and Bed_size__c=1 and  Current_Status__c = \'Onlist\' and Wait_List_Type__r.Name =\'Project Based Single\' '+
                ' order by Prefernce_Point__c desc,Applications__r.Applied_Date_time__c asc' ;                               
        
        
        system.debug('Query is-----'+ query); 
    
    }
    
    
    global  Database.QueryLocator start(Database.BatchableContext BC)
        
    {
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Enrolled_Wait_List__c> scope)    
    {
    
     List<RAD_Exception_Log__c> excpLogs = new List<RAD_Exception_Log__c>();
        RAD_Exception_Log__c eLog = new RAD_Exception_Log__c();
        
        System.debug('chk scope '+scope.size());
        
        String str ='';
        String randomNumber = '';
        for(Enrolled_Wait_List__c wl : scope )    
        {
            
            
            str = String.valueof(Math.abs(Crypto.getRandomLong()));
            randomNumber = str.substring(0,6);
            

            while(ranNumSet.contains(randomNumber) == true ){

            str = String.valueof(Math.abs(Crypto.getRandomLong()));
            randomNumber = str.substring(0,6);
            
            }
            
            wl.Lottery__c =Integer.valueof(randomNumber);
            ranNumSet.add(randomNumber);
            
            
            
        } 
        
        
        if(!scope.isEmpty()){
        
            totalRecordCount += scope.size(); 
            
            List<Database.SaveResult> wlResultList = Database.update(scope, false);
            for(Integer i=0;i<wlResultList.size();i++){
            
                if(!wlResultList[i].isSuccess()){
                     eLog = new RAD_Exception_Log__c();
                     eLog.RAD_Error_Source__c = 'Error when updating lottery number on WL-Project Based Single: '+ scope[i].id ;
                     eLog.RAD_Error_Message__c = 'Lottery Number Generation -PBV: '+wlResultList[i].getErrors();
    
                     excpLogs.add(eLog);
                }
            
            }
        }
        
        
        
        if(!excpLogs.isEmpty()){
            Database.insert(excpLogs, false);
        }    
    


        //system.debug(totalRecordCount); 
        //system.debug('set size is--->'+rannumset.size());
        //system.debug(rannumset);
        

    } 
    
        
       
    global void finish(Database.BatchableContext BC)     
    {    
        // Set Application Trigger on during run.
        SwitchTrigger__c AppTrigger = SwitchTrigger__c.getInstance('Applications__c');
        if(AppTrigger != Null) {
            AppTrigger.Active__c = false;
            update AppTrigger;
        }    
        Wait_List_Selection__c  wls = [Select Applicant_at_eli_30_75__c, Applicant_at_vli_50_25__c, Applicant_at_LI_80__c, Bedroom_Size__c, RAD_Temp_Number_to_Select__c,
                                     Number_of_vacancies_to_fill__c,RAD_Scheduler_Count__c,RAD_Temp_Eli_Count__c,RAD_Temp_Vli_Count__c,RAD_Current_Scheduler_Count__c, RAD_Temp_Li_Count__c, Number_to_Select_from_List__c, Wait_List_Type__r.Id, Wait_List_Type__r.Name 
                                     from Wait_List_Selection__c where id =:wlsidd limit 1];
                                     
        
        wls.RAD_Temp_Eli_Count__c = wls.Applicant_at_eli_30_75__c==null?0:wls.Applicant_at_eli_30_75__c;
        wls.RAD_Temp_Vli_Count__c = wls.Applicant_at_vli_50_25__c==null?0:wls.Applicant_at_vli_50_25__c;
        wls.RAD_Temp_Li_Count__c  = wls.Applicant_at_LI_80__c==null?0:wls.Applicant_at_LI_80__c; 
        
        wls.RAD_Scheduler_Count__c = totalRecordCount.divide(1000, 0, System.RoundingMode.UP);
        wls.RAD_Current_Scheduler_Count__c = 0; 
        

        system.debug('schedular count is'+wls.RAD_Scheduler_Count__c); 
        
        Database.update(wls, false);
                                                                                   
          
    }            
    
}