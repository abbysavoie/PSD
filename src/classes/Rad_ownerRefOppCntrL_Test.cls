@isTest
public class Rad_ownerRefOppCntrL_Test {
    public static testMethod void  RAD_OwnerRefOpptCntrlTest()
    {

       list<SwitchTrigger__c> sw_list = new List<SwitchTrigger__c>();
        SwitchTrigger__c sw = new SwitchTrigger__c(Name='Applications__c',Active__c=True);
        sw_list.add(sw);
        SwitchTrigger__c swWL = new SwitchTrigger__c(Name='Enrolled_Wait_List__c',Active__c=True);
        sw_list.add(swWL);
        insert sw_list;    
        RAD_Configuration__c  confg = new RAD_Configuration__c(Name = 'Main Configurations', Update_Duration_Months__c = 6, RAD_Purge_Extension_Months__c =1,
                                                               RAD_Portal_Forgot_Password_Note__c ='This is Forgotten Password Note', RAD_Portal_Forgot_UserName_Note__c ='This is Forgotten Username Note',
                                                               RAD_Portal_Contact_Address__c = 'This is Portal Contact Address', Announcement__c = 'This is Announcement');
        
        insert confg;
        
        User thisUser = [select Id from User where Id = :UserInfo.getUserId()];
        //Id RecTypeaccount=Schema.SObjectType.account.getRecordTypeInfosByName().get('RAD Community Account').getRecordTypeId();
        Id idd = Schema.SObjectType.Account.getRecordTypeInfosByName().get('RAD Community Account').getRecordTypeId();
        
        Account A1 = new Account(Name = 'Test Account', OwnerId=thisUser.Id,First_Name__c='test',Last_Name__c='test',RecordTypeId=idd
                                );
        
        insert A1;
        Id idd1 = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Applicant').getRecordTypeId();
        
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
        ct.RecordTypeId = idd1;
        ct.Active__c='Yes';
        
        
        insert ct;
        
        Applications__c app = new Applications__c(); 
        app.Applicant__c = ct.id;
        app.Ethnicity__c = 'Hispanic or Latino';
        app.Section_8__c =true;
        app.PBVS_Project_Based_Single__c = true;
        app.PBV_Project_Based__c =true;
        app.Public_Housing__c = true;
        app.Application_Status__c = 'Update Required';
        app.Family_Annual_Income__c = Decimal.valueOf('1000');
        app.White__c =  true;
        app.Black__c = true;
        app.Citizenship__c = 'Eligible Citizen';
        app.of_people_in_the_H_H_Adults__c = 1;
        //app.Dependents_Children_under_age_of_18__c = '1';
        app.Family__c = true; 
        app.RAD_Next_Purge_Request_Date__c=Date.Today().addMonths(-400);
        insert app;
        
        
        
        Wait_List_Type__c  wlt=new  Wait_List_Type__c();
        wlt.Name='Mod Rehab';
        wlt.YARDI_HMY__c=Decimal.valueof('12345');
        wlt.RADFamily__c=1;
        insert wlt;
        
        Enrolled_Wait_List__c ew=new Enrolled_Wait_List__c();
        ew.Current_Status__c='Onlist'; 
        ew.Wait_List_Type__c=wlt.id;
        ew.Prefernce_Point__c=Decimal.valueof('3'); 
        ew.Applications__c=app.id;   
        ew.Lottery__c=56712;
        insert ew; 
        
        Wait_List_Selection__c wls = new Wait_List_Selection__c();
        wls.Wait_List_Type__c = wlt.id;
        wls.Scheduled_Date__c = Date.Today()+1;
        wls.Schedule_Time__c = '4:00 PM';
        wls.Number_of_vacancies_to_fill__c = 3;
        wls.Bedroom_Size__c=3;     
        insert wls;
        
        list< Wait_List_Selection__c> wlis=[select Name from Wait_List_Selection__c where id=:wls.id];    
        
        System.debug('wls id---->'+wlis[0].Name);
        
        list<Wait_List_Selection__c> listwls=[select Name from Wait_List_Selection__c];
        system.debug('listwls size is----.'+listwls.size());
        system.debug('listwls size is----.'+listwls[0].Name);
        
        
        Selection_Records__c   sr=new Selection_Records__c();
        sr.Selection_ID__c=wls.id;
        sr.Status__c='Selected' ;
        sr.RAD_Wait_List__c=ew.id;
        sr.Lottery_Rank__c=45678;
        sr.Name__c='test';
        sr.Bed_Rooms__c='1';
        
        insert sr; 
        
        
        List<selectOption> options = new List<selectOption>();
        
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(wls);
        RAD_OwnerRefOpptCntrl rf = new RAD_OwnerRefOpptCntrl(sc);
        //rf.letter='NOletter';       
        rf.SelectedRunId =wlis[0].Name;
        rf.wlType='Mod Rehab';
        
        
        rf.ContactManagerDate=Date.today();
        rf.submit();
        rf.ChangeAccInformation();
        rf.ChangeletterInformation();
        rf.ChangesidInformation(); 
        rf.responddate='test';
        rf.cmdatem='test';
        rf.caseworker='test';
        rf.Bedroomsize='test';
        rf.pdfUnitaddress='test';
        rf.OwnerNamephone='test';
        rf.OwnerAddress='test';
        rf.cmdatem='test';
        
        options=rf.getIdNames();
        rf.ctDate=Date.today();
        rf.datename='test';
        rf.query='test';
        Test.StopTest();
        System.assertEquals(wls.Bedroom_Size__c,3); 
        PageReference tpageRef = Page.RAD_OwnerRefAndOppt;
        Test.setCurrentPage(tpageRef);
        tpageRef.getParameters().put('myParam1', 'test');
        list<Selection_Records__c> list1=[select Name,Status__c,RAD_Wait_List__c,RAD_Wait_List__r.Name,RAD_Wait_List__r.Wait_List_Type__r.Name from  Selection_Records__c  where Selection_ID__r.Name=:wlis[0].Name and Status__c='Selected'];
        
        
        
        
        
    }
    public static testMethod void  RAD_OwnerRefOpptCntrlpbvTest()
    {
       list<SwitchTrigger__c> sw_list = new List<SwitchTrigger__c>();
        SwitchTrigger__c sw = new SwitchTrigger__c(Name='Applications__c',Active__c=True);
        sw_list.add(sw);
        SwitchTrigger__c swWL = new SwitchTrigger__c(Name='Enrolled_Wait_List__c',Active__c=True);
        sw_list.add(swWL);
        insert sw_list; 
        RAD_Configuration__c  confg = new RAD_Configuration__c(Name = 'Main Configurations', Update_Duration_Months__c = 6, RAD_Purge_Extension_Months__c =1,
                                                               RAD_Portal_Forgot_Password_Note__c ='This is Forgotten Password Note', RAD_Portal_Forgot_UserName_Note__c ='This is Forgotten Username Note',
                                                               RAD_Portal_Contact_Address__c = 'This is Portal Contact Address', Announcement__c = 'This is Announcement');
        
        insert confg;
        
        User thisUser = [select Id from User where Id = :UserInfo.getUserId()];
        //Id RecTypeaccount=Schema.SObjectType.account.getRecordTypeInfosByName().get('RAD Community Account').getRecordTypeId();
        Id idd = Schema.SObjectType.Account.getRecordTypeInfosByName().get('RAD Community Account').getRecordTypeId();
        
        Account A1 = new Account(Name = 'Test Account', OwnerId=thisUser.Id,First_Name__c='test',Last_Name__c='test',RecordTypeId=idd
                                );
        
        insert A1;
        Id idd1 = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Applicant').getRecordTypeId();
        
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
        ct.RecordTypeId = idd1;
        ct.Active__c='Yes';
        
        
        insert ct;
        
        Applications__c app = new Applications__c(); 
        app.Applicant__c = ct.id;
        app.Ethnicity__c = 'Hispanic or Latino';
        app.Section_8__c =true;
        app.PBVS_Project_Based_Single__c = true;
        app.PBV_Project_Based__c =true;
        app.Public_Housing__c = true;
        app.Application_Status__c = 'Update Required';
        app.Family_Annual_Income__c = Decimal.valueOf('1000');
        app.White__c =  true;
        app.Black__c = true;
        app.Citizenship__c = 'Eligible Citizen';
        app.of_people_in_the_H_H_Adults__c = 1;
        //app.Dependents_Children_under_age_of_18__c = '1';
        app.Family__c = true; 
        app.RAD_Next_Purge_Request_Date__c=Date.Today().addMonths(-400);
        insert app;
        
        
        
        Wait_List_Type__c  wlt=new  Wait_List_Type__c();
        wlt.Name='project Based';
        wlt.YARDI_HMY__c=Decimal.valueof('12345');
        wlt.RADFamily__c=1;
        insert wlt;
        
        Enrolled_Wait_List__c ew=new Enrolled_Wait_List__c();
        ew.Current_Status__c='Onlist'; 
        ew.Wait_List_Type__c=wlt.id;
        ew.Prefernce_Point__c=Decimal.valueof('3'); 
        ew.Applications__c=app.id;   
        ew.Lottery__c=56712;
        insert ew; 
        
        Wait_List_Selection__c wls = new Wait_List_Selection__c();
        wls.Wait_List_Type__c = wlt.id;
        wls.Scheduled_Date__c = Date.Today()+1;
        wls.Schedule_Time__c = '4:00 PM';
        wls.Number_of_vacancies_to_fill__c = 3;
        wls.Bedroom_Size__c=3;     
        insert wls;
        
        list< Wait_List_Selection__c> wlis=[select Name from Wait_List_Selection__c where id=:wls.id];    
        
        System.debug('wls id---->'+wlis[0].Name);
        
        list<Wait_List_Selection__c> listwls=[select Name from Wait_List_Selection__c];
        system.debug('listwls size is----.'+listwls.size());
        system.debug('listwls size is----.'+listwls[0].Name);
        
        
        Selection_Records__c   sr=new Selection_Records__c();
        sr.Selection_ID__c=wls.id;
        sr.Status__c='Selected' ;
        sr.RAD_Wait_List__c=ew.id;
        sr.Lottery_Rank__c=45678;
        sr.Name__c='test';
        sr.Bed_Rooms__c='1';
        
        insert sr; 
        
        
        List<selectOption> options = new List<selectOption>();
        
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(wls);
        RAD_OwnerRefOpptCntrl rf = new RAD_OwnerRefOpptCntrl(sc);
        rf.letter='NRletter';       
        rf.SelectedRunId =wlis[0].Name;
        rf.wlType='project Based';
        rf.ContactManagerDate=Date.today();
        rf.submit();
        rf.ChangeAccInformation();
        rf.ChangeletterInformation();
        rf.ChangesidInformation(); 
        rf.responddate='test';
        rf.cmdatem='test';
        
        options=rf.getIdNames();
        rf.ctDate=Date.today();
        rf.datename='test';
        rf.query='test';
        Test.StopTest();
        System.assertEquals(wls.Bedroom_Size__c,3); 
        PageReference tpageRef = Page.RAD_OwnerRefAndOppt;
        Test.setCurrentPage(tpageRef);
        tpageRef.getParameters().put('myParam1', 'test');
        list<Selection_Records__c> list1=[select Name,Status__c,RAD_Wait_List__c,RAD_Wait_List__r.Name,RAD_Wait_List__r.Wait_List_Type__r.Name from  Selection_Records__c  where Selection_ID__r.Name=:wlis[0].Name and Status__c='Selected'];
        
        
        
        
        
    } 
    
    
}