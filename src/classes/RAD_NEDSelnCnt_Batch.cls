// This class will get the count of records for NED onlist WL and update the WLS. Default bed size selection is 1


global class RAD_NEDSelnCnt_Batch implements Database.batchable<sObject>,Database.Stateful{
    String query;
    global String wlsidd;
    global Decimal totalRecordCount;
    
     
    
    global RAD_NEDSelnCnt_Batch (string wlsid){
    
        wlsidd=wlsid;
        totalRecordCount = 0;

        query = 'Select Name from Enrolled_Wait_List__c '+
                ' where CreatedDate >= 2018-07-19T19:12:41.000+0000 and Current_Status__c = \'Onlist\' and Wait_List_Type__r.Name =\'NED\' and Bed_size__c = 0 ';
      
    }
    
    
    global  Database.QueryLocator start(Database.BatchableContext BC)
        
    {
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Enrolled_Wait_List__c> scope)    
    {
    
        if(!scope.isEmpty()){
           
            totalRecordCount += scope.size(); 
            
        }

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
        
        wls.RAD_Current_Scheduler_Count__c = 0;
        
        wls.RAD_Scheduler_Count__c = totalRecordCount.divide(1000, 0, System.RoundingMode.UP); 
        

        Database.update(wls, false);
        system.debug('$$$$ updating eli vli li values '+wls);
        
        System.debug('rhathi the total count is totalRecordCount' + totalRecordCount);
                                                                                   

    }            
    
}