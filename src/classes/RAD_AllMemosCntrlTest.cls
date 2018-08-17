/****
This is the Test Class for RAD_AllMemosCntrl Class.
****/


@isTest
public class RAD_AllMemosCntrlTest{
    
    static testMethod void runRAD_AllMemosCntrl(){
        
        list<SwitchTrigger__c> swlist = new List<SwitchTrigger__c>();
        SwitchTrigger__c sw = new SwitchTrigger__c(Name='Applications__c',Active__c=True);
        swlist.add(sw);
        SwitchTrigger__c swWL = new SwitchTrigger__c(Name='Enrolled_Wait_List__c',Active__c=True);
        swlist.add(swWL);        
        insert swlist;
        
        RAD_Configuration__c  confg = new RAD_Configuration__c(Name = 'Main Configurations', Update_Duration_Months__c = 6, RAD_Purge_Extension_Months__c =1,
                                                               RAD_Portal_Forgot_Password_Note__c ='This is Forgotten Password Note', RAD_Portal_Forgot_UserName_Note__c ='This is Forgotten Username Note',
                                                               RAD_Portal_Contact_Address__c = 'This is Portal Contact Address', Announcement__c = 'This is Announcement');
        insert confg;
        
        Account testAccount = new Account();
        testAccount.Name='Test Account' ;
        testAccount.First_Name__c = 'Test FN' ;
        testAccount.Last_Name__c = 'Test LN' ;
        insert testAccount;        
        
        Contact cont = new Contact ();
        cont.FirstName = 'FirstName';
        cont.LastName = 'LastName';
        cont.Email='TestEmail@Test.com';
        cont.phone='9988779988';
        cont.Account = testAccount ;
        cont.Gender__c='Male';
        cont.Contact_Type__c = 'Asset Manager';
        cont.SSN_TaxID__c = '121212121';
        cont.Date_of_Birth__c = Date.newInstance(1984, 12, 9); 
        cont.RAD_Homeless__c = false;
        cont.Prospect_Number_YARDI__c = 'p1212122';
        cont.Tenant_Number_YARDI__c = 't1212121';
        insert cont; 
        
        Applications__c app = new Applications__c();
        app.Applicant__c=cont.id;
        app.Ethnicity__c='Hispanic or Latino';
        app.Family__c=true;
        app.Homeless_with_disability__c=true;
        app.Family_Annual_Income__c=Decimal.valueof('1000');
        app.of_people_in_the_H_H_Adults__c=1;      
        app.Spouse_Co_Head_If_applicable__c=true;
        app.SSN__c = cont.SSN_TaxID__c ;
        app.DOB__c = cont.Date_of_Birth__c;
        app.Gender__c = cont.Gender__c;
        app.Homeless__c = cont.RAD_Homeless__c;
        app.Prospect_Name__c = cont.Prospect_Number_YARDI__c;
        app.Tenant__c = cont.Tenant_Number_YARDI__c ;
        app.Applied_Date_time__c = app.Applied_Date_time__c != Null ? app.Applied_Date_time__c : Datetime.Now();
        
        insert app;
        system.debug('$$$$ Application record ' +app);
        
        Memo__c memo = new Memo__c();
        memo.Name = 'Test';
        memo.Date_and_Time__c = datetime.newInstance(1984, 12, 9, 12, 30, 0);
        memo.Notes__c = 'Test Notes';
        memo.Applications__c = app.id;
        insert memo;
        system.debug('inserted memo' +memo );
        
        Test.StartTest(); 
        PageReference pageRef = Page.RAD_AllMemos; 
        pageRef.getParameters().put('id', String.valueOf(app.Id));
        Test.setCurrentPage(pageRef);
        RAD_AllMemosCntrl AllMemos = new RAD_AllMemosCntrl();
        
        Test.StopTest(); 
    }
    
    static testMethod void runBulkMemos(){
        
        list<SwitchTrigger__c> swlist = new List<SwitchTrigger__c>();
        SwitchTrigger__c sw = new SwitchTrigger__c(Name='Applications__c',Active__c=True);
        swlist.add(sw);
        SwitchTrigger__c swWL = new SwitchTrigger__c(Name='Enrolled_Wait_List__c',Active__c=True);
        swlist.add(swWL);        
        insert swlist;
        
        RAD_Configuration__c  confg = new RAD_Configuration__c(Name = 'Main Configurations', Update_Duration_Months__c = 6, RAD_Purge_Extension_Months__c =1,
                                                               RAD_Portal_Forgot_Password_Note__c ='This is Forgotten Password Note', RAD_Portal_Forgot_UserName_Note__c ='This is Forgotten Username Note',
                                                               RAD_Portal_Contact_Address__c = 'This is Portal Contact Address', Announcement__c = 'This is Announcement');
        insert confg;
        
        Account testAccount = new Account();
        testAccount.Name='Test Account' ;
        testAccount.First_Name__c = 'Test FN' ;
        testAccount.Last_Name__c = 'Test LN' ;
        insert testAccount;        
        
        Contact cont = new Contact ();
        cont.FirstName = 'FirstName';
        cont.LastName = 'LastName';
        cont.Email='TestEmail@Test.com';
        cont.phone='9988779988';
        cont.Account = testAccount ;
        cont.Gender__c='Male';
        cont.Contact_Type__c = 'Asset Manager';
        cont.SSN_TaxID__c = '121212121';
        cont.Date_of_Birth__c = Date.newInstance(1984, 12, 9); //9/1/1984;
        cont.RAD_Homeless__c = false;
        cont.Prospect_Number_YARDI__c = 'p1212122';
        cont.Tenant_Number_YARDI__c = 't1212121';
        insert cont; 
        
        Applications__c app = new Applications__c();
        app.Applicant__c=cont.id;
        app.Ethnicity__c='Hispanic or Latino';
        app.Family__c=true;
        app.Homeless_with_disability__c=true;
        app.Family_Annual_Income__c=Decimal.valueof('1000');
        app.of_people_in_the_H_H_Adults__c=1;      
        app.Spouse_Co_Head_If_applicable__c=true;
        app.SSN__c = cont.SSN_TaxID__c ;
        app.DOB__c = cont.Date_of_Birth__c;
        app.Gender__c = cont.Gender__c;
        app.Homeless__c = cont.RAD_Homeless__c;
        app.Prospect_Name__c = cont.Prospect_Number_YARDI__c;
        app.Tenant__c = cont.Tenant_Number_YARDI__c ;
        app.Applied_Date_time__c = app.Applied_Date_time__c != Null ? app.Applied_Date_time__c : Datetime.Now();
        insert app;
        system.debug('$$$$ Application record ' +app);
        
        list<Memo__c > memolist = new list<Memo__c >();
        for(integer i=0;i<200;i++) {
            Memo__c m = new Memo__c (Name = 'Test Memo ' +i,Date_and_Time__c = datetime.newInstance(1984, 12, 9, 12, 30, 0), 
                                     Notes__c = 'Test Notes' + i, Applications__c = app.id);
            memolist.add(m);
        }
        insert memolist;
        
        Test.StartTest(); 
        
        PageReference pageRef = Page.RAD_AllMemos; 
        pageRef.getParameters().put('id', String.valueOf(app.Id));
        Test.setCurrentPage(pageRef);
        RAD_AllMemosCntrl AllMemos = new RAD_AllMemosCntrl();
        Test.StopTest();
    }
    
    
}