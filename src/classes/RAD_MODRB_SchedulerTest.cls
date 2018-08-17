@isTest
public class RAD_MODRB_SchedulerTest
{
    public static testMethod void MODRB_Scheduletest()
    {
     SwitchTrigger__c  st=new SwitchTrigger__c();
        st.Name='Enrolled_Wait_List__c';
        st.Active__c=true;
        insert st;
        Test.startTest();
        TestSuiteHelper.setupCustomSettings();
        TestSuiteHelper.setupPortalRequiredData();        
        
        Wait_List_Type__c wlt = [Select name from Wait_List_Type__c where name = 'Mod Rehab' limit 1];
        
        Wait_List_Selection__c wls = new Wait_List_Selection__c();
        wls.Wait_List_Type__c = wlt.id;
        wls.Scheduled_Date__c = Date.Today()+1;
        wls.Schedule_Time__c = '4:00 PM';
        wls.Number_of_vacancies_to_fill__c = 3;
        wls.RAD_Current_Scheduler_Count__c=1; 
        wls.Bedroom_Size__c=2;
        
        insert wls;
        
        wls.Applicant_at_eli_30_75__c = 2;
        wls.Applicant_at_vli_50_25__c = 1;
        wls.Applicant_at_LI_80__c     = 0;
        update wls;
        
        
        wls.Status__c = 'Scheduled';
        update wls;
        
        
        RAD_MODRB_Scheduler mdre=new RAD_MODRB_Scheduler(wls.id);
        
        //system.schedule('Test Password Reminder', cronExpr, mdre);
        Test.stopTest();
        
        
        
    }
}