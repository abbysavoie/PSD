//This class generates random number for lottery selection for onlist Mod Rehab WL for the given bedroom count and 
//counts the wl records for processing.

global class RAD_MODRBSeln_Batch implements Database.batchable<sObject>,Database.Stateful{
    
    String query;
    Decimal bedroomsz;
    global Set<String> ranNumSet; 
    global String wlsidd;
    global Decimal totalRecordCount;
    
    
    
    global RAD_MODRBSeln_Batch(String wlsId, Decimal bedroomsize)
    {
       
        system.debug('wlsid  is-----'+ wlsId); 
         
        wlsidd=wlsid;
        ranNumSet = new Set<String>(); 
        bedroomsz = bedroomsize;
        totalRecordCount = 0;

         
        query = 'Select ID, Lottery__c ' +
            ' from Enrolled_Wait_List__c where CreatedDate >= 2018-07-19T19:12:41.000+0000 and Current_Status__c = \'Onlist\' and Wait_List_Type__r.Name =\'Mod Rehab\' and Bed_size__c =: bedroomsz'+
            ' order by Prefernce_Point__c desc,Applications__r.Applied_Date_time__c asc';                               
        /*
        //Query with createddate filter(manuallycreated data) 
        query = 'Select ID, Lottery__c ' +
            ' from Enrolled_Wait_List__c where CreatedDate >= 2018-07-19T19:12:41.000+0000 and Current_Status__c = \'Onlist\' and Wait_List_Type__r.Name =\'Mod Rehab\' and Bed_size__c =: bedroomsz'+
            ' order by Prefernce_Point__c desc,Applications__r.Applied_Date_time__c asc';
            */
            
        system.debug('Query is-----'+ query); 
        
    }
    
    
    
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List< Enrolled_Wait_List__c > scope)
    {
        
        
        List<RAD_Exception_Log__c> excpLogs = new List<RAD_Exception_Log__c>();
        RAD_Exception_Log__c eLog = new RAD_Exception_Log__c();
        
        
        
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
            
            wl.Lottery__c = Decimal.valueOf(randomNumber);
            ranNumSet.add(randomNumber);
            
            
        } 
        
        
        if(!scope.isEmpty()){
            
            totalRecordCount += scope.size(); 
            
            List<Database.SaveResult> wlResultList = Database.update(scope, false);
            for(Integer i=0;i<wlResultList.size();i++){
            
                if(!wlResultList[i].isSuccess()){
                     eLog = new RAD_Exception_Log__c();
                     eLog.RAD_Error_Source__c = 'Error when updating lottery number on WL-Mod Rehab: '+ scope[i].id ;
                     eLog.RAD_Error_Message__c = 'Lottery Number Generation -MRHB: '+wlResultList[i].getErrors();
    
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
       
        Wait_List_Selection__c  wls = [Select RAD_Scheduler_Count__c, Number_to_Select_from_List__c, RAD_Current_Scheduler_Count__c, RAD_Temp_Number_to_Select__c
                                       from Wait_List_Selection__c where id =:wlsidd limit 1];
        
        wls.RAD_Temp_Number_to_Select__c = wls.Number_to_Select_from_List__c==null?0:wls.Number_to_Select_from_List__c;
        wls.RAD_Scheduler_Count__c = totalRecordCount.divide(1000, 0, System.RoundingMode.UP);
        wls.RAD_Current_Scheduler_Count__c = 0;
        
        Database.update(wls,false);
        
    }            
    
    
    
}