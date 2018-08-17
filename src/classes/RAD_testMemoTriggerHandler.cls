@isTest
public class RAD_testMemoTriggerHandler {

    
    public static testmethod void testCreateMemo1(){
        list<SwitchTrigger__c> sw_list = new List<SwitchTrigger__c>();
        SwitchTrigger__c sw = new SwitchTrigger__c(Name='Applications__c',Active__c=True);
        sw_list.add(sw);
        SwitchTrigger__c swWL = new SwitchTrigger__c(Name='Enrolled_Wait_List__c',Active__c=True);
        sw_list.add(swWL);
        insert sw_list;

        TestSuiteHelper.setupCustomSettings();  
        Account A1 = TestSuiteHelper.setupTestAccount();
        Id idd = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Applicant').getRecordTypeId();

        List<Contact> ctLst = new List<Contact>();
           Contact  ct = new Contact();
            ct.FirstName = 'firstname';
            ct.LastName = 'lName';
            ct.email = 'test@cgi.com';
            ct.accountId = A1.id;
            ct.Contact_Type__c  = 'Community Global User';
            ct.Do_not_Have__c  = true;
            ct.Date_of_Birth__c  = Date.Today().addMonths(-400);
            ct.Gender__c = 'Female';
            
            ct.Residential_Street__c=  'Residency Street'; 
            ct.Residential_City__c = 'San Diego';
            ct.Residential_State__c = 'CA';
            ct.Residential_Zipcode__c ='71117';
            
            ct.MailingStreet = 'EastMail Street'; 
            ct.MailingCity = 'San Diego';
            ct.MailingState = 'CA';
            ct.MailingPostalCode ='71119';
        ct.RecordTypeId = idd;
    ct.Active__c='Yes';
    ctLst.add(ct);
    
    Contact ct1 = new Contact();
            ct1.FirstName = 'firstname';
            ct1.LastName = 'lName';
            //ct1.email = 'test@cgi.com';
            ct1.accountId = A1.id;
            ct1.Contact_Type__c  = 'Community Global User';
            ct1.Do_not_Have__c  = true;
            ct1.Date_of_Birth__c  = Date.Today().addMonths(-400);
            ct1.Gender__c = 'Female';
            
            ct1.Residential_Street__c=  'Residency Street'; 
            ct1.Residential_City__c = 'San Diego';
            ct1.Residential_State__c = 'CA';
            ct1.Residential_Zipcode__c ='71117';
            
            ct1.MailingStreet = 'EastMail Street'; 
            ct1.MailingCity = 'San Diego';
            ct1.MailingState = 'CA';
            ct1.MailingPostalCode ='71119';
        ct1.RecordTypeId = idd;
    ct1.Active__c='Yes';
    ctLst.add(ct1);
            insert ctLst;

           
            




List<Applications__c> applist=new List<Applications__c>();
 Applications__c app1 = new Applications__c(); 
            app1.Applicant__c = ct.id;
            app1.Ethnicity__c = 'Hispanic or Latino';
            //app1.Section_8__c =true;
            //app1.PBVS_Project_Based_Single__c = true;
            //app1.PBV_Project_Based__c =true;
            app1.Public_Housing__c = true;
            app1.Application_Status__c = 'Update Required';
            app1.of_people_in_the_H_H_Adults__c = 1;
            app1.Dependents_Children_under_age_of_18__c = 1;
            app1.Family_Annual_Income__c = Decimal.valueOf('1000');
            app1.White__c =  true;
            app1.Black__c = true;
            app1.Citizenship__c = 'Eligible Citizen';
            app1.RAD_Next_Purge_Request_Date__c=Date.today();
            app1.Family__c=true;
            app1.Homeless_with_disability__c=true;
            app1.Live_Work_in_City_of_San_Diego__c=true;
            app1.Non_Elderly_Disabled__c=true;
            app1.Veteran_Family_of__c=true;
             
            app1.RAD_Next_Purge_Request_Date__c=Datetime.Now().addMonths(-1);
            
            appList.add(app1);
           
           
           app1 = new Applications__c(); 
            app1.Applicant__c = ct1.id;
            app1.Ethnicity__c = 'Hispanic or Latino';
            //app1.Section_8__c =true;
            //app1.PBVS_Project_Based_Single__c = true;
            //app1.PBV_Project_Based__c =true;
            app1.Public_Housing__c = true;
            app1.Application_Status__c = 'Update Required';
            app1.of_people_in_the_H_H_Adults__c = 1;
            app1.Dependents_Children_under_age_of_18__c = 1;
            app1.Family_Annual_Income__c = Decimal.valueOf('1000');
            app1.White__c =  true;
            app1.Black__c = true;
            app1.Citizenship__c = 'Eligible Citizen';
            app1.RAD_Next_Purge_Request_Date__c=Date.today();
            app1.Family__c=true;
            app1.Homeless_with_disability__c=true;
            app1.Live_Work_in_City_of_San_Diego__c=true;
            app1.Non_Elderly_Disabled__c=true;
            app1.Veteran_Family_of__c=true;
             
           
            applist.add(app1);
           
           
            insert  appList;
                        
            
            for(Applications__c app: appList){            
                app.RAD_Next_Purge_Request_Date__c=Datetime.Now().addDays(-3);
                app.RAD_Next_Purge_Date__c = Datetime.now().addDays(10);

            }
            update appList;

		Test.startTest();
        
        RAD_DailyBatchToPurge.createMemo(appList[0], 'BounceUpdate');
        appList = [select id, (SELECT id, Name FROM Memos_Records__r) FROM Applications__c WHERE id = :appList[0].id];
        for(Memo__c a:appList[0].Memos_Records__r){
        	System.assertEquals(a.Name, 'Email bounce from Purge Update');
            }
        Test.stopTest();
    }
    public static testmethod void testCreateMemo2(){
        list<SwitchTrigger__c> sw_list = new List<SwitchTrigger__c>();
        SwitchTrigger__c sw = new SwitchTrigger__c(Name='Applications__c',Active__c=True);
        sw_list.add(sw);
        SwitchTrigger__c swWL = new SwitchTrigger__c(Name='Enrolled_Wait_List__c',Active__c=True);
        sw_list.add(swWL);
        insert sw_list;

        TestSuiteHelper.setupCustomSettings();  
        Account A1 = TestSuiteHelper.setupTestAccount();
        Id idd = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Applicant').getRecordTypeId();

        List<Contact> ctLst = new List<Contact>();
           Contact  ct = new Contact();
            ct.FirstName = 'firstname';
            ct.LastName = 'lName';
            ct.email = 'test@cgi.com';
            ct.accountId = A1.id;
            ct.Contact_Type__c  = 'Community Global User';
            ct.Do_not_Have__c  = true;
            ct.Date_of_Birth__c  = Date.Today().addMonths(-400);
            ct.Gender__c = 'Female';
            
            ct.Residential_Street__c=  'Residency Street'; 
            ct.Residential_City__c = 'San Diego';
            ct.Residential_State__c = 'CA';
            ct.Residential_Zipcode__c ='71117';
            
            ct.MailingStreet = 'EastMail Street'; 
            ct.MailingCity = 'San Diego';
            ct.MailingState = 'CA';
            ct.MailingPostalCode ='71119';
        ct.RecordTypeId = idd;
    ct.Active__c='Yes';
    ctLst.add(ct);
    
    Contact ct1 = new Contact();
            ct1.FirstName = 'firstname';
            ct1.LastName = 'lName';
            //ct1.email = 'test@cgi.com';
            ct1.accountId = A1.id;
            ct1.Contact_Type__c  = 'Community Global User';
            ct1.Do_not_Have__c  = true;
            ct1.Date_of_Birth__c  = Date.Today().addMonths(-400);
            ct1.Gender__c = 'Female';
            
            ct1.Residential_Street__c=  'Residency Street'; 
            ct1.Residential_City__c = 'San Diego';
            ct1.Residential_State__c = 'CA';
            ct1.Residential_Zipcode__c ='71117';
            
            ct1.MailingStreet = 'EastMail Street'; 
            ct1.MailingCity = 'San Diego';
            ct1.MailingState = 'CA';
            ct1.MailingPostalCode ='71119';
        ct1.RecordTypeId = idd;
    ct1.Active__c='Yes';
    ctLst.add(ct1);
            insert ctLst;

           
            




List<Applications__c> applist=new List<Applications__c>();
 Applications__c app1 = new Applications__c(); 
            app1.Applicant__c = ct.id;
            app1.Ethnicity__c = 'Hispanic or Latino';
            //app1.Section_8__c =true;
            //app1.PBVS_Project_Based_Single__c = true;
            //app1.PBV_Project_Based__c =true;
            app1.Public_Housing__c = true;
            app1.Application_Status__c = 'Update Required';
            app1.of_people_in_the_H_H_Adults__c = 1;
            app1.Dependents_Children_under_age_of_18__c = 1;
            app1.Family_Annual_Income__c = Decimal.valueOf('1000');
            app1.White__c =  true;
            app1.Black__c = true;
            app1.Citizenship__c = 'Eligible Citizen';
            app1.RAD_Next_Purge_Request_Date__c=Date.today();
            app1.Family__c=true;
            app1.Homeless_with_disability__c=true;
            app1.Live_Work_in_City_of_San_Diego__c=true;
            app1.Non_Elderly_Disabled__c=true;
            app1.Veteran_Family_of__c=true;
             
            app1.RAD_Next_Purge_Request_Date__c=Datetime.Now().addMonths(-1);
            
            appList.add(app1);
           
           
           app1 = new Applications__c(); 
            app1.Applicant__c = ct1.id;
            app1.Ethnicity__c = 'Hispanic or Latino';
            //app1.Section_8__c =true;
            //app1.PBVS_Project_Based_Single__c = true;
            //app1.PBV_Project_Based__c =true;
            app1.Public_Housing__c = true;
            app1.Application_Status__c = 'Update Required';
            app1.of_people_in_the_H_H_Adults__c = 1;
            app1.Dependents_Children_under_age_of_18__c = 1;
            app1.Family_Annual_Income__c = Decimal.valueOf('1000');
            app1.White__c =  true;
            app1.Black__c = true;
            app1.Citizenship__c = 'Eligible Citizen';
            app1.RAD_Next_Purge_Request_Date__c=Date.today();
            app1.Family__c=true;
            app1.Homeless_with_disability__c=true;
            app1.Live_Work_in_City_of_San_Diego__c=true;
            app1.Non_Elderly_Disabled__c=true;
            app1.Veteran_Family_of__c=true;
             
           
            applist.add(app1);
           
           
            insert  appList;
                        
            
            for(Applications__c app: appList){            
                app.RAD_Next_Purge_Request_Date__c=Datetime.Now().addDays(-3);
                app.RAD_Next_Purge_Date__c = Datetime.now().addDays(10);

            }
            update appList;


		Test.startTest();
        RAD_DailyBatchToPurge.createMemo(appList[0], 'PurgeUpdateEmail');
        appList = [select id, (SELECT id, Name FROM Memos_Records__r) FROM Applications__c WHERE id = :appList[0].id];
        for(Memo__c a:appList[0].Memos_Records__r){
        	System.assertEquals(a.Name, 'Email failure from Purge Update');
            }
        Test.stopTest();
    }
    public static testmethod void testCreateMemo3(){
        list<SwitchTrigger__c> sw_list = new List<SwitchTrigger__c>();
        SwitchTrigger__c sw = new SwitchTrigger__c(Name='Applications__c',Active__c=True);
        sw_list.add(sw);
        SwitchTrigger__c swWL = new SwitchTrigger__c(Name='Enrolled_Wait_List__c',Active__c=True);
        sw_list.add(swWL);
        insert sw_list;

        TestSuiteHelper.setupCustomSettings();  
        Account A1 = TestSuiteHelper.setupTestAccount();
        Id idd = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Applicant').getRecordTypeId();

        List<Contact> ctLst = new List<Contact>();
           Contact  ct = new Contact();
            ct.FirstName = 'firstname';
            ct.LastName = 'lName';
            ct.email = 'test@cgi.com';
            ct.accountId = A1.id;
            ct.Contact_Type__c  = 'Community Global User';
            ct.Do_not_Have__c  = true;
            ct.Date_of_Birth__c  = Date.Today().addMonths(-400);
            ct.Gender__c = 'Female';
            
            ct.Residential_Street__c=  'Residency Street'; 
            ct.Residential_City__c = 'San Diego';
            ct.Residential_State__c = 'CA';
            ct.Residential_Zipcode__c ='71117';
            
            ct.MailingStreet = 'EastMail Street'; 
            ct.MailingCity = 'San Diego';
            ct.MailingState = 'CA';
            ct.MailingPostalCode ='71119';
        ct.RecordTypeId = idd;
    ct.Active__c='Yes';
    ctLst.add(ct);
    
    Contact ct1 = new Contact();
            ct1.FirstName = 'firstname';
            ct1.LastName = 'lName';
            //ct1.email = 'test@cgi.com';
            ct1.accountId = A1.id;
            ct1.Contact_Type__c  = 'Community Global User';
            ct1.Do_not_Have__c  = true;
            ct1.Date_of_Birth__c  = Date.Today().addMonths(-400);
            ct1.Gender__c = 'Female';
            
            ct1.Residential_Street__c=  'Residency Street'; 
            ct1.Residential_City__c = 'San Diego';
            ct1.Residential_State__c = 'CA';
            ct1.Residential_Zipcode__c ='71117';
            
            ct1.MailingStreet = 'EastMail Street'; 
            ct1.MailingCity = 'San Diego';
            ct1.MailingState = 'CA';
            ct1.MailingPostalCode ='71119';
        ct1.RecordTypeId = idd;
    ct1.Active__c='Yes';
    ctLst.add(ct1);
            insert ctLst;

           
            




List<Applications__c> applist=new List<Applications__c>();
 Applications__c app1 = new Applications__c(); 
            app1.Applicant__c = ct.id;
            app1.Ethnicity__c = 'Hispanic or Latino';
            //app1.Section_8__c =true;
            //app1.PBVS_Project_Based_Single__c = true;
            //app1.PBV_Project_Based__c =true;
            app1.Public_Housing__c = true;
            app1.Application_Status__c = 'Update Required';
            app1.of_people_in_the_H_H_Adults__c = 1;
            app1.Dependents_Children_under_age_of_18__c = 1;
            app1.Family_Annual_Income__c = Decimal.valueOf('1000');
            app1.White__c =  true;
            app1.Black__c = true;
            app1.Citizenship__c = 'Eligible Citizen';
            app1.RAD_Next_Purge_Request_Date__c=Date.today();
            app1.Family__c=true;
            app1.Homeless_with_disability__c=true;
            app1.Live_Work_in_City_of_San_Diego__c=true;
            app1.Non_Elderly_Disabled__c=true;
            app1.Veteran_Family_of__c=true;
             
            app1.RAD_Next_Purge_Request_Date__c=Datetime.Now().addMonths(-1);
            
            appList.add(app1);
           
           
           app1 = new Applications__c(); 
            app1.Applicant__c = ct1.id;
            app1.Ethnicity__c = 'Hispanic or Latino';
            //app1.Section_8__c =true;
            //app1.PBVS_Project_Based_Single__c = true;
            //app1.PBV_Project_Based__c =true;
            app1.Public_Housing__c = true;
            app1.Application_Status__c = 'Update Required';
            app1.of_people_in_the_H_H_Adults__c = 1;
            app1.Dependents_Children_under_age_of_18__c = 1;
            app1.Family_Annual_Income__c = Decimal.valueOf('1000');
            app1.White__c =  true;
            app1.Black__c = true;
            app1.Citizenship__c = 'Eligible Citizen';
            app1.RAD_Next_Purge_Request_Date__c=Date.today();
            app1.Family__c=true;
            app1.Homeless_with_disability__c=true;
            app1.Live_Work_in_City_of_San_Diego__c=true;
            app1.Non_Elderly_Disabled__c=true;
            app1.Veteran_Family_of__c=true;
             
           
            applist.add(app1);
           
           
            insert  appList;
                        
            
            for(Applications__c app: appList){            
                app.RAD_Next_Purge_Request_Date__c=Datetime.Now().addDays(-3);
                app.RAD_Next_Purge_Date__c = Datetime.now().addDays(10);

            }
            update appList;


		Test.startTest();
        RAD_DailyBatchToPurge.createMemo(appList[0], 'PurgeReminderEmail');
        appList = [select id, (SELECT id, Name FROM Memos_Records__r) FROM Applications__c WHERE id = :appList[0].id];
        for(Memo__c a:appList[0].Memos_Records__r){
        	System.assertEquals(a.Name, 'Email failure from Purge Reminder');
            }
        Test.stopTest();
    } 
    public static testmethod void testCreateMemo4(){
        list<SwitchTrigger__c> sw_list = new List<SwitchTrigger__c>();
        SwitchTrigger__c sw = new SwitchTrigger__c(Name='Applications__c',Active__c=True);
        sw_list.add(sw);
        SwitchTrigger__c swWL = new SwitchTrigger__c(Name='Enrolled_Wait_List__c',Active__c=True);
        sw_list.add(swWL);
        insert sw_list;

        TestSuiteHelper.setupCustomSettings();  
        Account A1 = TestSuiteHelper.setupTestAccount();
        Id idd = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Applicant').getRecordTypeId();

        List<Contact> ctLst = new List<Contact>();
           Contact  ct = new Contact();
            ct.FirstName = 'firstname';
            ct.LastName = 'lName';
            ct.email = 'test@cgi.com';
            ct.accountId = A1.id;
            ct.Contact_Type__c  = 'Community Global User';
            ct.Do_not_Have__c  = true;
            ct.Date_of_Birth__c  = Date.Today().addMonths(-400);
            ct.Gender__c = 'Female';
            
            ct.Residential_Street__c=  'Residency Street'; 
            ct.Residential_City__c = 'San Diego';
            ct.Residential_State__c = 'CA';
            ct.Residential_Zipcode__c ='71117';
            
            ct.MailingStreet = 'EastMail Street'; 
            ct.MailingCity = 'San Diego';
            ct.MailingState = 'CA';
            ct.MailingPostalCode ='71119';
        ct.RecordTypeId = idd;
    ct.Active__c='Yes';
    ctLst.add(ct);
    
    Contact ct1 = new Contact();
            ct1.FirstName = 'firstname';
            ct1.LastName = 'lName';
            //ct1.email = 'test@cgi.com';
            ct1.accountId = A1.id;
            ct1.Contact_Type__c  = 'Community Global User';
            ct1.Do_not_Have__c  = true;
            ct1.Date_of_Birth__c  = Date.Today().addMonths(-400);
            ct1.Gender__c = 'Female';
            
            ct1.Residential_Street__c=  'Residency Street'; 
            ct1.Residential_City__c = 'San Diego';
            ct1.Residential_State__c = 'CA';
            ct1.Residential_Zipcode__c ='71117';
            
            ct1.MailingStreet = 'EastMail Street'; 
            ct1.MailingCity = 'San Diego';
            ct1.MailingState = 'CA';
            ct1.MailingPostalCode ='71119';
        ct1.RecordTypeId = idd;
    ct1.Active__c='Yes';
    ctLst.add(ct1);
            insert ctLst;

           
            




List<Applications__c> applist=new List<Applications__c>();
 Applications__c app1 = new Applications__c(); 
            app1.Applicant__c = ct.id;
            app1.Ethnicity__c = 'Hispanic or Latino';
            //app1.Section_8__c =true;
            //app1.PBVS_Project_Based_Single__c = true;
            //app1.PBV_Project_Based__c =true;
            app1.Public_Housing__c = true;
            app1.Application_Status__c = 'Update Required';
            app1.of_people_in_the_H_H_Adults__c = 1;
            app1.Dependents_Children_under_age_of_18__c = 1;
            app1.Family_Annual_Income__c = Decimal.valueOf('1000');
            app1.White__c =  true;
            app1.Black__c = true;
            app1.Citizenship__c = 'Eligible Citizen';
            app1.RAD_Next_Purge_Request_Date__c=Date.today();
            app1.Family__c=true;
            app1.Homeless_with_disability__c=true;
            app1.Live_Work_in_City_of_San_Diego__c=true;
            app1.Non_Elderly_Disabled__c=true;
            app1.Veteran_Family_of__c=true;
             
            app1.RAD_Next_Purge_Request_Date__c=Datetime.Now().addMonths(-1);
            
            appList.add(app1);
           
           
           app1 = new Applications__c(); 
            app1.Applicant__c = ct1.id;
            app1.Ethnicity__c = 'Hispanic or Latino';
            //app1.Section_8__c =true;
            //app1.PBVS_Project_Based_Single__c = true;
            //app1.PBV_Project_Based__c =true;
            app1.Public_Housing__c = true;
            app1.Application_Status__c = 'Update Required';
            app1.of_people_in_the_H_H_Adults__c = 1;
            app1.Dependents_Children_under_age_of_18__c = 1;
            app1.Family_Annual_Income__c = Decimal.valueOf('1000');
            app1.White__c =  true;
            app1.Black__c = true;
            app1.Citizenship__c = 'Eligible Citizen';
            app1.RAD_Next_Purge_Request_Date__c=Date.today();
            app1.Family__c=true;
            app1.Homeless_with_disability__c=true;
            app1.Live_Work_in_City_of_San_Diego__c=true;
            app1.Non_Elderly_Disabled__c=true;
            app1.Veteran_Family_of__c=true;
             
           
            applist.add(app1);
           
           
            insert  appList;
                        
            
            for(Applications__c app: appList){            
                app.RAD_Next_Purge_Request_Date__c=Datetime.Now().addDays(-3);
                app.RAD_Next_Purge_Date__c = Datetime.now().addDays(10);

            }
            update appList;

		Test.startTest();
        RAD_DailyBatchToPurge.createMemo(appList[0], 'BounceReminder');
        appList = [select id, (SELECT id, Name FROM Memos_Records__r) FROM Applications__c WHERE id = :appList[0].id];
        for(Memo__c a:appList[0].Memos_Records__r){
        	System.assertEquals(a.Name, 'Email bounce from Purge Reminder');
            }
        Test.stopTest();
    }    
}