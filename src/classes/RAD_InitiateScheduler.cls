global class RAD_InitiateScheduler implements Schedulable{

    global String  wlsidd;   
        
    public RAD_InitiateScheduler(String wlsId){
        
        System.debug('rhathi in RAD_InitiateScheduler wlsid is '+wlsId);
        this.wlsidd =  wlsId;

        
        
    }           

    
    global void execute(SchedulableContext sc){
    
        Wait_List_Selection__c wls = [Select Wait_List_Type__r.name, RAD_Scheduler_Count__c, RAD_Current_Scheduler_Count__c from Wait_List_Selection__c where id =: wlsidd limit 1];           
        wls.RAD_Scheduler_Count__c = 0;
        update wls;
        
        
    }
    
}