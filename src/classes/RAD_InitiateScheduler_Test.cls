@isTest
public class RAD_InitiateScheduler_Test
{
    
    public static testMethod void Insch()
    {
        Wait_List_Type__c wlt = new Wait_List_Type__c();
        wlt.Name = 'Public Housing';
        wlt.YARDI_HMY__c = 10.0;
        insert wlt;
        Wait_List_Selection__c  wls= new Wait_List_Selection__c( );
        wls.Wait_List_Type__c =wlt.id;
        wls.RAD_Scheduler_Count__c =0;
        
        wls.Scheduled_Date__c = date.today();
        wls.Schedule_Time__c = '12:00 AM';
        wls.Number_of_vacancies_to_fill__c =10;
        wls.Reason_for_Selection_Out_of_Order__c = 'Income Targeting';
        wls.Unit__c = 'pending';
        wls.Bedroom_Size__c=3;
        insert wls;                     
        
        test.StartTest();
        RAD_InitiateScheduler is = new RAD_InitiateScheduler(wls.id);
        test.StopTest();
        
        String CRON_EXP = '0 0 0 3 9 ? 2022';
        system.schedule('test', CRON_EXP, is);
        
    }
    
}