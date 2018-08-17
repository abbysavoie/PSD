@isTest
public class RAD_PubHsgScheduler_Test
{
    public static testMethod void PB_Scheduletest()
    {
    
        list<SwitchTrigger__c> sw_list = new List<SwitchTrigger__c>();
        SwitchTrigger__c sw = new SwitchTrigger__c(Name='Applications__c',Active__c=True);
        sw_list.add(sw);
        SwitchTrigger__c swWL = new SwitchTrigger__c(Name='Enrolled_Wait_List__c',Active__c=True);
        sw_list.add(swWL);
        insert sw_list;
            
        TestSuiteHelper.setupCustomSettings();  
        //TestSuiteHelper.setupPortalRequiredData();
        Account A1 = TestSuiteHelper.setupTestAccount();
        Id idd = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Applicant').getRecordTypeId();
        
        Contact con=new  Contact();
        //con.Name='test@cgi.com';
        con.FirstName='test';
        con.LastName='testLast';
        con.accountId = A1.id;
        con.Contact_Type__c  = 'Community Global User';
        con.Do_not_Have__c  = true;
        con.RecordTypeId = idd;
        con.Active__c='Yes';
        insert con;
        
        
        Applications__c app=new Applications__c();
        app.Applicant__c=con.id;
        app.Ethnicity__c = 'Hispanic or Latino';
        app.Family_Annual_Income__c=Decimal.valueof('1000');
        app.White__c=true;
        app.Asian__c=  true;
        app.Black__c = true;
        app.American_Indian__c=true;
        app.Pacific_Islander__c=true;
        
        app.of_people_in_the_H_H_Adults__c = 1;
        app.Dependents_Children_under_age_of_18__c = 0;
        app.Application_Status__c = 'Submitted';
        
        insert app;
        //clearing WL to work for mig and normal mode        
        List<Enrolled_Wait_List__c> wlst = [Select id from Enrolled_Wait_List__c where Applications__c =: app.id ];
        Database.delete(wlst, false);
        
        Wait_List_Type__c wltype =[Select id from Wait_List_Type__c where name ='Public Housing' limit 1];
        
        Enrolled_Wait_List__c en=new Enrolled_Wait_List__c();
        en.Applications__c=app.id;
        en.Current_Status__c='Onlist';
        en.Wait_List_Type__c=wltype.id;
        en.Bed_size__c=1;
        en.Prefernce_Point__c=3;
        en.Lottery__c=45673;
        en.Limit__c='eli-30';
        en.Reason__c ='Active';  
        
        insert en;
        
        
        
        Wait_List_Selection__c wls = new Wait_List_Selection__c();
        wls.Wait_List_Type__c = wltype.id;
        wls.Scheduled_Date__c = Date.Today()+1;
        wls.Schedule_Time__c = '4:00 PM';
        wls.Number_of_vacancies_to_fill__c=5;
        wls.Bedroom_Size__c=1;
        wls.Pull_Rank__c=45673;
        wls.RAD_Current_Scheduler_Count__c = 1;
        
        
        insert wls;
        
        wls.Applicant_at_eli_30_75__c = 2;
        wls.Applicant_at_vli_50_25__c = 1;
        wls.Applicant_at_LI_80__c     = 1;
        update wls;
        Test.startTest(); 
        
        wls.Status__c = 'Scheduled';
        update wls;
        
        Datetime dt = Datetime.now();
        Integer tempMin = dt.minute() + 1 ;  //dont use current min, 
        if(tempMin >= 59){
            tempMin = 0;
        }
        System.assertEquals(en.Current_Status__c, 'Onlist');
        String cronExpr = '0 ' + tempMin + ' * * * ? *';
        RAD_PubHsgScheduler rabpbs=new RAD_PubHsgScheduler(wls.id);
        system.schedule('Test Password Reminder', cronExpr, rabpbs);
        Test.stopTest();
        
        
        
    }
    public static testMethod void PB_Scheduletest2vli()
    {
        list<SwitchTrigger__c> sw_list = new List<SwitchTrigger__c>();
        SwitchTrigger__c sw = new SwitchTrigger__c(Name='Applications__c',Active__c=True);
        sw_list.add(sw);
        SwitchTrigger__c swWL = new SwitchTrigger__c(Name='Enrolled_Wait_List__c',Active__c=True);
        sw_list.add(swWL);
        insert sw_list;
               
        TestSuiteHelper.setupCustomSettings();  
        Account A1 = TestSuiteHelper.setupTestAccount();
        Id idd = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Applicant').getRecordTypeId();
        
        
        Contact con1=new  Contact();
        //con.Name='test@cgi.com';
        con1.FirstName='testtest';
        con1.LastName='testLa';
        con1.accountId = A1.id;
        con1.Contact_Type__c  = 'Community Global User';
        con1.Do_not_Have__c  = true;
        con1.Date_of_Birth__c  = Date.Today().addMonths(-400);
        con1.Gender__c = 'Female';
        
        con1.Residential_Street__c=  'Residency Street'; 
        con1.Residential_City__c = 'San Diego';
        con1.Residential_State__c = 'CA';
        con1.Residential_Zipcode__c ='71117';
        
        con1.MailingStreet = 'EastMail Street'; 
        con1.MailingCity = 'San Diego';
        con1.MailingState = 'CA';
        con1.MailingPostalCode ='71119';
        
        con1.RecordTypeId = idd;
        con1.Active__c='Yes';
        insert con1;
        
        
        Applications__c app1=new Applications__c();
        app1.Applicant__c=con1.id;
        
        app1.Ethnicity__c = 'Hispanic or Latino';
        //app1.Public_Housing__c = true;
        app1.Application_Status__c = 'Submitted';
        app1.of_people_in_the_H_H_Adults__c = 1;
        app1.Dependents_Children_under_age_of_18__c = 1;
        app1.Family_Annual_Income__c = 10000;
        app1.White__c =  true;
        app1.Black__c = true;
        app1.Citizenship__c = 'Eligible Citizen';
        app1.RAD_Next_Purge_Request_Date__c=Date.today();
        app1.Family__c=true;
        app1.Homeless_with_disability__c=true;
        app1.Live_Work_in_City_of_San_Diego__c=true;
        app1.Non_Elderly_Disabled__c=true;
        app1.Veteran_Family_of__c=true;
        
        insert app1;
        //clearing WL to work for mig and normal mode        
        List<Enrolled_Wait_List__c> wlst = [Select id from Enrolled_Wait_List__c where Applications__c =: app1.id ];
        Database.delete(wlst, false);
        
        Wait_List_Type__c wltype1 =[Select id from Wait_List_Type__c where name ='Public Housing' limit 1];
        
        Enrolled_Wait_List__c en1=new Enrolled_Wait_List__c();
        en1.Applications__c=app1.id;
        en1.Current_Status__c='Onlist';
        en1.Wait_List_Type__c=wltype1.id;
        en1.Bed_size__c=1;
        en1.Prefernce_Point__c=12;
        en1.Lottery__c=67856;
        en1.Limit__c='vli-50';
        en1.Reason__c ='Active';  
        insert en1;
        
        
        Test.startTest();
        Wait_List_Selection__c wls1 = new Wait_List_Selection__c();
        wls1.Wait_List_Type__c = wltype1.id;
        wls1.Scheduled_Date__c = Date.Today()+1;
        wls1.Schedule_Time__c = '4:00 PM';
        wls1.Number_of_vacancies_to_fill__c=5;
        wls1.Bedroom_Size__c=1;
        wls1.Pull_Rank__c=67856;
        wls1.RAD_Current_Scheduler_Count__c = 1;
        
        
        insert wls1;
        
        wls1.Applicant_at_eli_30_75__c = 1;
        wls1.Applicant_at_vli_50_25__c = 2;
        wls1.Applicant_at_LI_80__c     = 1;
        update wls1;
        
        
        wls1.Status__c = 'Scheduled';
        update wls1;
        
        Datetime dt = Datetime.now();
        Integer tempMin = dt.minute() + 1 ;  //dont use current min, 
        if(tempMin >= 59){
            tempMin = 0;
        }
        System.assertEquals(en1.Current_Status__c, 'Onlist');
        String cronExpr = '0 ' + tempMin + ' * * * ? *';
        RAD_PubHsgScheduler rabpbs=new RAD_PubHsgScheduler(wls1.id);
        system.schedule('Test Password Reminder', cronExpr, rabpbs);
        Test.stopTest();
        
        
        
    }
    public static testMethod void PB_Scheduletest3li()
    {

        list<SwitchTrigger__c> sw_list = new List<SwitchTrigger__c>();
        SwitchTrigger__c sw = new SwitchTrigger__c(Name='Applications__c',Active__c=True);
        sw_list.add(sw);
        SwitchTrigger__c swWL = new SwitchTrigger__c(Name='Enrolled_Wait_List__c',Active__c=True);
        sw_list.add(swWL);
        insert sw_list;
        
        TestSuiteHelper.setupCustomSettings();
        Account A1 = TestSuiteHelper.setupTestAccount();
        
        Id idd = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Applicant').getRecordTypeId(); 
        Contact con1=new  Contact();
        con1.FirstName='testtest';
        con1.LastName='testLa';
        con1.accountId = A1.id;
        con1.Contact_Type__c  = 'Community Global User';
        
        con1.RecordTypeId = idd;
        con1.Active__c='Yes';
        insert con1;
        
        
        Applications__c app1=new Applications__c();
        
        app1.Applicant__c=con1.id;
        app1.Ethnicity__c = 'Hispanic or Latino';
        app1.Family_Annual_Income__c=40000;
        app1.White__c=true;
        app1.Asian__c=  true;
        app1.Black__c = true;
        app1.American_Indian__c=true;
        app1.Pacific_Islander__c=true;
        
        app1.of_people_in_the_H_H_Adults__c = 1;
        app1.Dependents_Children_under_age_of_18__c = 0;
        app1.Application_Status__c = 'Submitted';
        
        insert app1;
        
        //clearing WL to work for mig and normal mode        
        List<Enrolled_Wait_List__c> wlst = [Select id from Enrolled_Wait_List__c where Applications__c =: app1.id ];
        Database.delete(wlst, false);
        
        Wait_List_Type__c wltype1 =[Select id from Wait_List_Type__c where name ='Public Housing' limit 1];
        
        
        Enrolled_Wait_List__c en1=new Enrolled_Wait_List__c();
        //en.Name='test';
        en1.Applications__c=app1.id;
        en1.Current_Status__c='Onlist';
        en1.Wait_List_Type__c=wltype1.id;
        en1.Bed_size__c=4;
        en1.Prefernce_Point__c=3;
        en1.Lottery__c=67856;
        en1.Limit__c='li-80';
        en1.Reason__c ='Active';
        
        insert en1;
        
        
        
        Wait_List_Selection__c wls1 = new Wait_List_Selection__c();
        wls1.Wait_List_Type__c = wltype1.id;
        wls1.Scheduled_Date__c = Date.Today()+1;
        wls1.Schedule_Time__c = '4:00 PM';
        wls1.Number_of_vacancies_to_fill__c=5;
        wls1.Bedroom_Size__c=4;
        wls1.Pull_Rank__c=67856;
        wls1.RAD_Current_Scheduler_Count__c = 1;
        
        
        
        insert wls1;
        
        wls1.Applicant_at_eli_30_75__c = 1;
        wls1.Applicant_at_vli_50_25__c = 0;
        wls1.Applicant_at_LI_80__c     = 2;
        update wls1;
        
        Test.startTest();
        wls1.Status__c = 'Scheduled';
        update wls1;
        
        Datetime dt = Datetime.now();
        Integer tempMin = dt.minute() + 1 ;  //dont use current min, 
        if(tempMin >= 59){
            tempMin = 0;
        }
        System.assertEquals(en1.Current_Status__c, 'Onlist');
        String cronExpr = '0 ' + tempMin + ' * * * ? *';
        RAD_PubHsgScheduler rabpbs=new RAD_PubHsgScheduler(wls1.id);
        system.schedule('Test Password Reminder', cronExpr, rabpbs);
        Test.stopTest();
        
        
        
    }
    public static testMethod void PB_Scheduletestallzeros()
    {

        list<SwitchTrigger__c> sw_list = new List<SwitchTrigger__c>();
        SwitchTrigger__c sw = new SwitchTrigger__c(Name='Applications__c',Active__c=True);
        sw_list.add(sw);
        SwitchTrigger__c swWL = new SwitchTrigger__c(Name='Enrolled_Wait_List__c',Active__c=True);
        sw_list.add(swWL);
        insert sw_list;
        
        TestSuiteHelper.setupCustomSettings();
        Account A1 = TestSuiteHelper.setupTestAccount();
        
        Id idd = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Applicant').getRecordTypeId(); 
        Contact con1=new  Contact();
        con1.FirstName='testtest';
        con1.LastName='testLa';
        con1.accountId = A1.id;
        con1.Contact_Type__c  = 'Community Global User';
        
        con1.RecordTypeId = idd;
        con1.Active__c='Yes';
        insert con1;
        
        
        Applications__c app1=new Applications__c();
        
        app1.Applicant__c=con1.id;
        app1.Ethnicity__c = 'Hispanic or Latino';
        app1.Family_Annual_Income__c=40000;
        app1.White__c=true;
        app1.Asian__c=  true;
        app1.Black__c = true;
        app1.American_Indian__c=true;
        app1.Pacific_Islander__c=true;
        
        app1.of_people_in_the_H_H_Adults__c = 1;
        app1.Dependents_Children_under_age_of_18__c = 0;
        app1.Application_Status__c = 'Submitted';
        
        insert app1;
        
        //clearing WL to work for mig and normal mode        
        List<Enrolled_Wait_List__c> wlst = [Select id from Enrolled_Wait_List__c where Applications__c =: app1.id ];
        Database.delete(wlst, false);
        
        Wait_List_Type__c wltype1 =[Select id from Wait_List_Type__c where name ='Public Housing' limit 1];
        
        
        Enrolled_Wait_List__c en1=new Enrolled_Wait_List__c();
        //en.Name='test';
        en1.Applications__c=app1.id;
        en1.Current_Status__c='Onlist';
        en1.Wait_List_Type__c=wltype1.id;
        en1.Bed_size__c=4;
        en1.Prefernce_Point__c=3;
        en1.Lottery__c=67856;
        en1.Limit__c='li-80';
        en1.Reason__c ='Active';
        
        insert en1;
        
        
        
        Wait_List_Selection__c wls1 = new Wait_List_Selection__c();
        wls1.Wait_List_Type__c = wltype1.id;
        wls1.Scheduled_Date__c = Date.Today()+1;
        wls1.Schedule_Time__c = '4:00 PM';
        wls1.Number_of_vacancies_to_fill__c=3;
        wls1.Bedroom_Size__c=4;
        wls1.Pull_Rank__c=67856;
        wls1.RAD_Current_Scheduler_Count__c = 1;
        
        
        
        insert wls1;
        
        wls1.Applicant_at_eli_30_75__c = 0;
        wls1.Applicant_at_vli_50_25__c = 0;
        wls1.Applicant_at_LI_80__c     = 0;
        update wls1;
        
        Test.startTest();
        wls1.Status__c = 'Scheduled';
        update wls1;
        
        Datetime dt = Datetime.now();
        Integer tempMin = dt.minute() + 1 ;  //dont use current min, 
        if(tempMin >= 59){
            tempMin = 0;
        }
        System.assertEquals(en1.Current_Status__c, 'Onlist');
        String cronExpr = '0 ' + tempMin + ' * * * ? *';
        RAD_PubHsgScheduler rabpbs=new RAD_PubHsgScheduler(wls1.id);
        system.schedule('Test Password Reminder', cronExpr, rabpbs);
        Test.stopTest();
        
        
        
    }
    
    
}