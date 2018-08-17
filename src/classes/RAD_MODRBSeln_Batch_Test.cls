@isTest
public class RAD_MODRBSeln_Batch_Test
{
    public static testMethod void MODRB_Scheduletest()
    {
    list<SwitchTrigger__c> sw_list = new List<SwitchTrigger__c>();
        SwitchTrigger__c sw = new SwitchTrigger__c(Name='Applications__c',Active__c=True);
        sw_list.add(sw);
        SwitchTrigger__c swWL = new SwitchTrigger__c(Name='Enrolled_Wait_List__c',Active__c=True);
        sw_list.add(swWL);
        insert sw_list;

        Account acc = TestSuiteHelper.setupTestAccount();
        TestSuiteHelper.setupCustomSettings();
        
        Id idd = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Applicant').getRecordTypeId();
        
        
        Contact con=new  Contact();
        con.FirstName='test';
        con.LastName='testLast';
        con.Contact_Type__c  = 'Community Global User';
        con.RecordTypeId = idd;
        con.Active__c='Yes';
        con.RecordTypeId = idd;
        
        insert con;
        
        
        Applications__c app=new Applications__c();
        
        app.Applicant__c=con.id;
        app.Ethnicity__c = 'Hispanic or Latino';
        app.Family_Annual_Income__c=1000;
        app.White__c=true;
        app.American_Indian__c=true;
        app.Pacific_Islander__c=true;
        app.Black__c=true;
        app.Asian__c=true;
        app.of_people_in_the_H_H_Adults__c = 1;
        app.Dependents_Children_under_age_of_18__c = 0;
        app.Application_Status__c = 'Submitted';
        app.total_people__c = 3;
        insert app;
        
        //clearing WL to work for mig and normal mode        
        List<Enrolled_Wait_List__c> wlst = [Select id from Enrolled_Wait_List__c where Applications__c =: app.id ];
        Database.delete(wlst, false);
        
        Wait_List_Type__c wltype =[Select id from Wait_List_Type__c where name ='Mod Rehab' limit 1];
        
        Enrolled_Wait_List__c en=new Enrolled_Wait_List__c();
        en.Applications__c=app.id;
        en.Current_Status__c='Onlist';
        en.Reason__c ='Active';   
        en.Wait_List_Type__c=wltype.id;
        en.Bed_size__c=1;
        en.Prefernce_Point__c=1;
        en.Limit__c='eli-30';
        en.RAD_Applied_Date_and_Time__c = datetime.now();
        insert en;
        
        
        
        Wait_List_Selection__c wls = new Wait_List_Selection__c();
        wls.Wait_List_Type__c = wltype.id;
        wls.Scheduled_Date__c = Date.Today()+1;
        wls.Schedule_Time__c = '4:00 PM';
        wls.Number_of_vacancies_to_fill__c=3;
        wls.Bedroom_Size__c=1;
        wls.RAD_Temp_Number_to_Select__c = 3;
        wls.Application__c=app.id;
        
        insert wls;
        wls.Applicant_at_eli_30_75__c = 2;
        wls.Applicant_at_vli_50_25__c = 1;
        wls.Applicant_at_LI_80__c     = 0;
        
        
        
        wls.Status__c = 'Scheduled';
        update wls;
        
        RAD_MODRBSeln_Batch radm=new RAD_MODRBSeln_Batch(wls.id,1 );
        DataBase.executeBatch(radm);
        
        
        
        
    }
    
}