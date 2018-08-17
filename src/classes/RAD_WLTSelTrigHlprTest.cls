@isTest
public class RAD_WLTSelTrigHlprTest{

     public static testmethod void testWLS_Sec8(){
     
        list<SwitchTrigger__c> sw_list = new List<SwitchTrigger__c>();
        SwitchTrigger__c sw = new SwitchTrigger__c(Name='Applications__c',Active__c=True);
        sw_list.add(sw);
        SwitchTrigger__c swWL = new SwitchTrigger__c(Name='Enrolled_Wait_List__c',Active__c=True);
        sw_list.add(swWL);
        insert sw_list;
     
        TestSuiteHelper.setupCustomSettings();
        Wait_List_Type__c wlt = [Select name from Wait_List_Type__c where name ='Section 8' limit 1];
        Test.startTest();
        Wait_List_Selection__c wls = new Wait_List_Selection__c();
        
        wls.Wait_List_Type__c = wlt.id;
        wls.Scheduled_Date__c = Date.Today()+1;
        wls.Schedule_Time__c = '4:00 PM';
        wls.Number_of_vacancies_to_fill__c=3;
        
        wls.RAD_Temp_Eli_Count__c = 0;
        wls.RAD_Temp_Vli_Count__c = 0;
        wls.RAD_Temp_Li_Count__c = 0;
        wls.RAD_Current_Scheduler_Count__c =0;
        wls.RAD_Scheduler_Count__c =2;
        
        
        insert wls;
        
        wls.Applicant_at_eli_30_75__c = 2;
        wls.Applicant_at_vli_50_25__c = 1;
        wls.Applicant_at_LI_80__c     = 0;
        update wls;
        
        
        wls.Status__c = 'Scheduled';
        update wls;
        
        wls.RAD_Scheduler_Count__c = 1;
        update wls;
        
        
        Test.stopTest();
        
     }
     
     
     public static testmethod void testWLS_ModRhb(){
     
        list<SwitchTrigger__c> sw_list = new List<SwitchTrigger__c>();
        SwitchTrigger__c sw = new SwitchTrigger__c(Name='Applications__c',Active__c=True);
        sw_list.add(sw);
        SwitchTrigger__c swWL = new SwitchTrigger__c(Name='Enrolled_Wait_List__c',Active__c=True);
        sw_list.add(swWL);
        insert sw_list;     
        TestSuiteHelper.setupCustomSettings();
        Wait_List_Type__c wlt = [Select name from Wait_List_Type__c where name ='Mod Rehab' limit 1];
        Test.startTest();
        Wait_List_Selection__c wls = new Wait_List_Selection__c();
        
        wls.Wait_List_Type__c = wlt.id;
        wls.Bedroom_Size__c = 1;
        wls.Scheduled_Date__c = Date.Today()+1;
        wls.Schedule_Time__c = '4:00 PM';
        wls.Number_of_vacancies_to_fill__c=3;
        
        wls.RAD_Temp_Number_to_Select__c = 0;
        wls.RAD_Current_Scheduler_Count__c =0;
        wls.RAD_Scheduler_Count__c =2;
        
        
        
        
        insert wls;
        
        wls.Applicant_at_eli_30_75__c = 0;
        wls.Applicant_at_vli_50_25__c = 0;
        wls.Applicant_at_LI_80__c     = 0;
        update wls;
        
        
        wls.Status__c = 'Scheduled';
        update wls;
        
        wls.RAD_Temp_Number_to_Select__c = 3;
        wls.RAD_Scheduler_Count__c = 1;
        update wls;
        
        
        Test.stopTest();
        
     }
     
     public static testmethod void testWLS_PubHsg(){
     
        list<SwitchTrigger__c> sw_list = new List<SwitchTrigger__c>();
        SwitchTrigger__c sw = new SwitchTrigger__c(Name='Applications__c',Active__c=True);
        sw_list.add(sw);
        SwitchTrigger__c swWL = new SwitchTrigger__c(Name='Enrolled_Wait_List__c',Active__c=True);
        sw_list.add(swWL);
        insert sw_list;
             
        TestSuiteHelper.setupCustomSettings();
        Wait_List_Type__c wlt = [Select name from Wait_List_Type__c where name ='Public Housing' limit 1];
        Test.startTest();
        Wait_List_Selection__c wls = new Wait_List_Selection__c();
        
        wls.Wait_List_Type__c = wlt.id;
        wls.Bedroom_Size__c = 1;
        wls.Scheduled_Date__c = Date.Today()+1;
        wls.Schedule_Time__c = '4:00 PM';
        wls.Number_of_vacancies_to_fill__c=3;
        
        wls.RAD_Temp_Eli_Count__c = 0;
        wls.RAD_Temp_Vli_Count__c = 0;
        wls.RAD_Temp_Li_Count__c = 0;
        wls.RAD_Current_Scheduler_Count__c =0;
        wls.RAD_Scheduler_Count__c =2;
        
        
        insert wls;
        
        wls.Applicant_at_eli_30_75__c = 2;
        wls.Applicant_at_vli_50_25__c = 1;
        wls.Applicant_at_LI_80__c     = 0;
        update wls;
        
        
        wls.Status__c = 'Scheduled';
        update wls;
        
        wls.RAD_Scheduler_Count__c = 1;
        update wls;
        
        
        Test.stopTest();
        
     }
     
     public static testmethod void testWLS_ProjBsd(){

        list<SwitchTrigger__c> sw_list = new List<SwitchTrigger__c>();
        SwitchTrigger__c sw = new SwitchTrigger__c(Name='Applications__c',Active__c=True);
        sw_list.add(sw);
        SwitchTrigger__c swWL = new SwitchTrigger__c(Name='Enrolled_Wait_List__c',Active__c=True);
        sw_list.add(swWL);
        insert sw_list;
        
        TestSuiteHelper.setupCustomSettings();
        Wait_List_Type__c wlt = [Select name from Wait_List_Type__c where name ='Project Based' limit 1];
        Test.startTest();
        Wait_List_Selection__c wls = new Wait_List_Selection__c();
        
        wls.Wait_List_Type__c = wlt.id;
        wls.Bedroom_Size__c = 1;
        wls.Scheduled_Date__c = Date.Today()+1;
        wls.Schedule_Time__c = '4:00 PM';
        wls.Number_of_vacancies_to_fill__c=3;
        
        wls.RAD_Temp_Eli_Count__c = 0;
        wls.RAD_Temp_Vli_Count__c = 0;
        wls.RAD_Temp_Li_Count__c = 0;
        wls.RAD_Current_Scheduler_Count__c =0;
        wls.RAD_Scheduler_Count__c =2;
        
        
        insert wls;
        
        wls.Applicant_at_eli_30_75__c = 2;
        wls.Applicant_at_vli_50_25__c = 1;
        wls.Applicant_at_LI_80__c     = 0;
        update wls;
        
        
        wls.Status__c = 'Scheduled';
        update wls;
        
        wls.RAD_Scheduler_Count__c = 1;
        update wls;
        
        
        Test.stopTest();
        
     }
     
     public static testmethod void testWLS_ProjSngl(){

        list<SwitchTrigger__c> sw_list = new List<SwitchTrigger__c>();
        SwitchTrigger__c sw = new SwitchTrigger__c(Name='Applications__c',Active__c=True);
        sw_list.add(sw);
        SwitchTrigger__c swWL = new SwitchTrigger__c(Name='Enrolled_Wait_List__c',Active__c=True);
        sw_list.add(swWL);
        insert sw_list;

        TestSuiteHelper.setupCustomSettings();
        Wait_List_Type__c wlt = [Select name from Wait_List_Type__c where name ='Project Based Single' limit 1];
        Test.startTest();
        Wait_List_Selection__c wls = new Wait_List_Selection__c();
        
        wls.Wait_List_Type__c = wlt.id;
        wls.Bedroom_Size__c = 1;
        wls.Scheduled_Date__c = Date.Today()+1;
        wls.Schedule_Time__c = '4:00 PM';
        wls.Number_of_vacancies_to_fill__c=3;
        
        wls.RAD_Temp_Eli_Count__c = 0;
        wls.RAD_Temp_Vli_Count__c = 0;
        wls.RAD_Temp_Li_Count__c = 0;
        wls.RAD_Current_Scheduler_Count__c =0;
        wls.RAD_Scheduler_Count__c =2;
        
        
        insert wls;
        
        wls.Applicant_at_eli_30_75__c = 2;
        wls.Applicant_at_vli_50_25__c = 1;
        wls.Applicant_at_LI_80__c     = 0;
        update wls;
        
        
        wls.Status__c = 'Scheduled';
        update wls;
        
        wls.RAD_Scheduler_Count__c = 1;
        update wls;
        
        
        Test.stopTest();
        
     }
     
    public static testmethod void testWLS_Others(){

        list<SwitchTrigger__c> sw_list = new List<SwitchTrigger__c>();
        SwitchTrigger__c sw = new SwitchTrigger__c(Name='Applications__c',Active__c=True);
        sw_list.add(sw);
        SwitchTrigger__c swWL = new SwitchTrigger__c(Name='Enrolled_Wait_List__c',Active__c=True);
        sw_list.add(swWL);
        insert sw_list;

        TestSuiteHelper.setupCustomSettings();
        Wait_List_Type__c wlt = [Select name from Wait_List_Type__c where name ='Section 8' limit 1];
        Test.startTest();

        Wait_List_Selection__c wls = new Wait_List_Selection__c();
        
        wls.Wait_List_Type__c = wlt.id;
        
        wls.Scheduled_Date__c = Date.Today()+1;
        wls.Schedule_Time__c = '4:00 PM';
        wls.Number_of_vacancies_to_fill__c=3;
        
        wls.RAD_Temp_Eli_Count__c = 0;
        wls.RAD_Temp_Vli_Count__c = 0;
        wls.RAD_Temp_Li_Count__c = 0;
        wls.RAD_Current_Scheduler_Count__c =0;
        wls.RAD_Scheduler_Count__c =null;
        wls.Cancel_Run__c =false;
        wls.Status__c = 'New';
        
        insert wls;
        wls.RAD_Scheduler_Count__c = Null;
        wls.Status__c = 'Scheduled';
        wls.Wait_List_Type__c = wlt.id;
        wls.Cancel_Run__c =true;
        update wls;
        
        
        
        
        Test.stopTest();
    }
      public static testmethod void NED(){

        list<SwitchTrigger__c> sw_list = new List<SwitchTrigger__c>();
        SwitchTrigger__c sw = new SwitchTrigger__c(Name='Applications__c',Active__c=True);
        sw_list.add(sw);
        SwitchTrigger__c swWL = new SwitchTrigger__c(Name='Enrolled_Wait_List__c',Active__c=True);
        sw_list.add(swWL);
        insert sw_list;
      
        TestSuiteHelper.setupCustomSettings();
        Wait_List_Type__c wlt = [Select name from Wait_List_Type__c where name ='NED' limit 1];
        Test.startTest();
        Wait_List_Selection__c wls = new Wait_List_Selection__c();
        
        wls.Wait_List_Type__c = wlt.id;
        wls.Scheduled_Date__c = Date.Today()+1;
        wls.Schedule_Time__c = '4:00 PM';
        wls.Number_of_vacancies_to_fill__c=3;
        //wls.Bedroom_Size__c = 1;
        wls.RAD_Temp_Eli_Count__c = 0;
        wls.RAD_Temp_Vli_Count__c = 0;
        wls.RAD_Temp_Li_Count__c = 0;
        wls.RAD_Current_Scheduler_Count__c =0;
        wls.RAD_Scheduler_Count__c =2;
        
        
        insert wls;
        
        wls.Applicant_at_eli_30_75__c = 2;
        wls.Applicant_at_vli_50_25__c = 1;
        wls.Applicant_at_LI_80__c     = 0;
        update wls;
        
        
        wls.Cancel_Run__c =false;
        wls.Status__c = 'Scheduled';
        update wls;
        
        wls.RAD_Scheduler_Count__c = 1;
        update wls;
        
        
        Test.stopTest();
        
     }
      public static testmethod void testWLS_Others_NED(){

        list<SwitchTrigger__c> sw_list = new List<SwitchTrigger__c>();
        SwitchTrigger__c sw = new SwitchTrigger__c(Name='Applications__c',Active__c=True);
        sw_list.add(sw);
        SwitchTrigger__c swWL = new SwitchTrigger__c(Name='Enrolled_Wait_List__c',Active__c=True);
        sw_list.add(swWL);
        insert sw_list; 

        TestSuiteHelper.setupCustomSettings();
        Wait_List_Type__c wlt = [Select name from Wait_List_Type__c where name ='NED' limit 1];
        Test.startTest();

        Wait_List_Selection__c wls = new Wait_List_Selection__c();
        
        wls.Wait_List_Type__c = wlt.id;
        
        wls.Scheduled_Date__c = Date.Today()+1;
        wls.Schedule_Time__c = '4:00 PM';
        wls.Number_of_vacancies_to_fill__c=3;
        //wls.Bedroom_Size__c = 1;
        wls.RAD_Temp_Eli_Count__c = 0;
        wls.RAD_Temp_Vli_Count__c = 0;
        wls.RAD_Temp_Li_Count__c = 0;
        wls.RAD_Current_Scheduler_Count__c =0;
        wls.RAD_Scheduler_Count__c =null;
       wls.Status__c = 'scheduled';
        
        
        insert wls;
       
        
        wls.Wait_List_Type__c = wlt.id;
        wls.Cancel_Run__c =true;
        update wls;
        
        wls.Cancel_Run__c =false;
        wls.Status__c = 'Scheduled';
        update wls;
        
        
        Test.stopTest();
    }
    public static testmethod void testWLS_Others_Public_Housing(){

        list<SwitchTrigger__c> sw_list = new List<SwitchTrigger__c>();
        SwitchTrigger__c sw = new SwitchTrigger__c(Name='Applications__c',Active__c=True);
        sw_list.add(sw);
        SwitchTrigger__c swWL = new SwitchTrigger__c(Name='Enrolled_Wait_List__c',Active__c=True);
        sw_list.add(swWL);
        insert sw_list;
        
        TestSuiteHelper.setupCustomSettings();
        Wait_List_Type__c wlt = [Select name from Wait_List_Type__c where name ='Public Housing' limit 1];
        Test.startTest();

        Wait_List_Selection__c wls = new Wait_List_Selection__c();
        
        wls.Wait_List_Type__c = wlt.id;
        
        wls.Scheduled_Date__c = Date.Today()+1;
        wls.Schedule_Time__c = '4:00 PM';
        wls.Number_of_vacancies_to_fill__c=3;
        wls.Bedroom_Size__c = 2;
        wls.RAD_Temp_Eli_Count__c = 0;
        wls.RAD_Temp_Vli_Count__c = 0;
        wls.RAD_Temp_Li_Count__c = 0;
        wls.RAD_Current_Scheduler_Count__c =0;
        wls.RAD_Scheduler_Count__c =null;
       wls.Status__c = 'scheduled';
        
        
        insert wls;
       
        
        wls.Wait_List_Type__c = wlt.id;
        wls.Cancel_Run__c =true;
        update wls;
        
        wls.Cancel_Run__c =false;
        wls.Status__c = 'Scheduled';
        update wls;
        
        
        Test.stopTest();
    }
      public static testmethod void testWLS_Others_Project_Based(){

        list<SwitchTrigger__c> sw_list = new List<SwitchTrigger__c>();
        SwitchTrigger__c sw = new SwitchTrigger__c(Name='Applications__c',Active__c=True);
        sw_list.add(sw);
        SwitchTrigger__c swWL = new SwitchTrigger__c(Name='Enrolled_Wait_List__c',Active__c=True);
        sw_list.add(swWL);
        insert sw_list;
        
        TestSuiteHelper.setupCustomSettings();
        Wait_List_Type__c wlt = [Select name from Wait_List_Type__c where name ='Project Based' limit 1];
        Test.startTest();

        Wait_List_Selection__c wls = new Wait_List_Selection__c();
        
        wls.Wait_List_Type__c = wlt.id;
        
        wls.Scheduled_Date__c = Date.Today()+1;
        wls.Schedule_Time__c = '4:00 PM';
        wls.Number_of_vacancies_to_fill__c=3;
        wls.Bedroom_Size__c = 2;
        wls.RAD_Temp_Eli_Count__c = 0;
        wls.RAD_Temp_Vli_Count__c = 0;
        wls.RAD_Temp_Li_Count__c = 0;
        wls.RAD_Current_Scheduler_Count__c =0;
        wls.RAD_Scheduler_Count__c =null;
       wls.Status__c = 'scheduled';
        
        
        insert wls;
       
        
        wls.Wait_List_Type__c = wlt.id;
        wls.Cancel_Run__c =true;
        update wls;
        
        wls.Cancel_Run__c =false;
        wls.Status__c = 'Scheduled';
        update wls;
        
        
        Test.stopTest();
    }
    public static testmethod void testWLS_Others_Project_Based_Single(){

        list<SwitchTrigger__c> sw_list = new List<SwitchTrigger__c>();
        SwitchTrigger__c sw = new SwitchTrigger__c(Name='Applications__c',Active__c=True);
        sw_list.add(sw);
        SwitchTrigger__c swWL = new SwitchTrigger__c(Name='Enrolled_Wait_List__c',Active__c=True);
        sw_list.add(swWL);
        insert sw_list;
        TestSuiteHelper.setupCustomSettings();
        Wait_List_Type__c wlt = [Select name from Wait_List_Type__c where name ='Project Based Single' limit 1];
        Test.startTest();

        Wait_List_Selection__c wls = new Wait_List_Selection__c();
        
        wls.Wait_List_Type__c = wlt.id;
        
        wls.Scheduled_Date__c = Date.Today()+1;
        wls.Schedule_Time__c = '4:00 PM';
        wls.Number_of_vacancies_to_fill__c=3;
        wls.Bedroom_Size__c = 2;
        wls.RAD_Temp_Eli_Count__c = 0;
        wls.RAD_Temp_Vli_Count__c = 0;
        wls.RAD_Temp_Li_Count__c = 0;
        wls.RAD_Current_Scheduler_Count__c =0;
        wls.RAD_Scheduler_Count__c =null;
       wls.Status__c = 'scheduled';
        
        
        insert wls;
       
        
        wls.Wait_List_Type__c = wlt.id;
        wls.Cancel_Run__c =true;
        update wls;
        
        wls.Cancel_Run__c =false;
        wls.Status__c = 'Scheduled';
        update wls;
        
        
        Test.stopTest();
    }
     public static testmethod void testWLS_Others_Mod_Rehab(){

        list<SwitchTrigger__c> sw_list = new List<SwitchTrigger__c>();
        SwitchTrigger__c sw = new SwitchTrigger__c(Name='Applications__c',Active__c=True);
        sw_list.add(sw);
        SwitchTrigger__c swWL = new SwitchTrigger__c(Name='Enrolled_Wait_List__c',Active__c=True);
        sw_list.add(swWL);
        insert sw_list;
        
        TestSuiteHelper.setupCustomSettings();
        Wait_List_Type__c wlt = [Select name from Wait_List_Type__c where name ='Mod Rehab' limit 1];
        Test.startTest();

        Wait_List_Selection__c wls = new Wait_List_Selection__c();
        
        wls.Wait_List_Type__c = wlt.id;
        
        wls.Scheduled_Date__c = Date.Today()+1;
        wls.Schedule_Time__c = '1:00 PM';
        wls.Number_of_vacancies_to_fill__c=3;
        wls.Bedroom_Size__c = 2;
        wls.RAD_Temp_Eli_Count__c = 0;
        wls.RAD_Temp_Vli_Count__c = 0;
        wls.RAD_Temp_Li_Count__c = 0;
        wls.RAD_Current_Scheduler_Count__c =0;
        wls.RAD_Scheduler_Count__c =null;
       wls.Status__c = 'scheduled';
        
        
        insert wls;
       
        
        wls.Wait_List_Type__c = wlt.id;
        wls.Cancel_Run__c =true;
        update wls;
        
        wls.Cancel_Run__c =false;
        wls.Status__c = 'Scheduled';
        update wls;
        
        
        Test.stopTest();
    }
}