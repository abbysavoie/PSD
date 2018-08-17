@isTest
public class RAD_LandingCtrlrTest
{    
    static testMethod void RADLandingCtrlrMethod() 
    {         
        TestSuiteHelper.setupCustomSettings();
        PageReference pageRef = Page.RADNewLand;
        Test.setCurrentPage(pageRef);
        
        Test.StartTest();
        RAD_LandPageCtrlr controller = new RAD_LandPageCtrlr();
        controller.init();
        
        
        Test.StopTest();    
        
    }
    
    static testMethod void testLandingCntrlr() 
    {         
        list<SwitchTrigger__c> sw_list = new List<SwitchTrigger__c>();
        SwitchTrigger__c sw = new SwitchTrigger__c(Name='Applications__c',Active__c=True);
        sw_list.add(sw);
        SwitchTrigger__c swWL = new SwitchTrigger__c(Name='Enrolled_Wait_List__c',Active__c=True);
        sw_list.add(swWL);
        insert sw_list;    
        
        TestSuiteHelper.setupCustomSettings();
        List<Contact> cts =TestSuiteHelper.setupPortalRequiredData();  
        Contact ct = cts[0];
        Applications__c app = [Select id, Application_Status__c from Applications__c limit 1]; // where Applicant__c =:ct.id 
        
        String jsonApp = json.serialize(app);
        String jsonCt = json.serialize(ct);
        Wait_List_Type__c wlt = [Select name, RADFamily__c, RADLive_Work_in_City_of_San_Diego__c, 
                                 RADNon_Elderly_Disabled__c, RADVeteran_Active_Military__c from Wait_List_Type__c where name ='Public Housing' limit 1];
        Test.StartTest();
        RAD_LandPageCtrlr.getZipCodeLocation('11', '92101');
        RAD_LandPageCtrlr.getZipCodeLocation('123','123');
        //RAD_LandPageCtrlr.saveSubmit(jsonApp, jsonCt, 'save');
        //RAD_LandPageCtrlr.saveSubmit(jsonApp, jsonCt, 'submit');
        RAD_LandPageCtrlr.getApplication(app.id);
        RAD_LandPageCtrlr.confirmPurgeExtnInterest(app.id);
        RAD_LandPageCtrlr.confirmPurgeExtnInterest('noid');
        RAD_LandPageCtrlr.reapplyWL('noid');
        List<Enrolled_Wait_List__c> wls = [Select id from Enrolled_Wait_List__c  where Applications__c =:app.id limit 1] ;
        Enrolled_Wait_List__c ew = new Enrolled_Wait_List__c();
        if(wls.isEmpty()){
            ew = new Enrolled_Wait_List__c();
            ew.Wait_List_Type__c=wlt.id;
            ew.Prefernce_Point__c=Decimal.valueof('3'); 
            ew.Applications__c=app.id;   
            ew.Current_Status__c='Onlist'; 
            ew.Status__c = 'On List';
            ew.Reason__c ='Active';
            
            //Database.insert( ew, false);      
        }else{
            ew = wls[0];
        }
        RAD_LandPageCtrlr.reapplyWL(ew.id);
        
        RAD_LandPageCtrlr r = new RAD_LandPageCtrlr();
            r.getContactandApplication();
        
        Test.StopTest();    
        
    }
    
    static testmethod void testUser(){
        list<SwitchTrigger__c> sw_list = new List<SwitchTrigger__c>();
        SwitchTrigger__c sw = new SwitchTrigger__c(Name='Applications__c',Active__c=True);
        sw_list.add(sw);
        SwitchTrigger__c swWL = new SwitchTrigger__c(Name='Enrolled_Wait_List__c',Active__c=True);
        sw_list.add(swWL);
        insert sw_list;    
        
        Test.startTest();
       TestSuiteHelper.setupCustomSettings();
        Contact con=new  Contact();
        Account acc = TestSuiteHelper.setupTestAccount();
        Id idd1 = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Applicant').getRecordTypeId();
        con.AccountId = acc.id;
        con.FirstName='testuser';
        con.LastName='testLast';
        con.Contact_Type__c='Community Global User';
        con.Email='test@cgi.com';
        con.RecordTypeId = idd1;
        con.Active__c = 'Yes';
        insert con;
         Applications__c app = new Applications__c();
            app.Applicant__c = con.id;
            app.Ethnicity__c = 'Hispanic or Latino';
            app.Public_Housing__c = true;
            app.Application_Status__c = 'Submitted';
            app.Family_Annual_Income__c = 10000;
            app.White__c =  true;
            app.Black__c = true;
            app.Citizenship__c = 'Eligible Citizen';
            app.of_people_in_the_H_H_Adults__c = 1;
            app.Dependents_Children_under_age_of_18__c = 1;
            app.Family__c = true;
          insert app;
           Wait_List_Type__c wlt = [Select name from Wait_List_Type__c where name ='Public Housing' limit 1];
           List<Enrolled_Wait_List__c> wlst = [Select id from Enrolled_Wait_List__c where Applications__c =: app.id ];
            Database.delete(wlst, false);
          Enrolled_Wait_List__c ew = new Enrolled_Wait_List__c();
             ew.Current_Status__c= 'Removed';
             ew.Wait_List_Type__c=wlt.id;
             ew.Prefernce_Point__c=Decimal.valueof('3'); 
             ew.Applications__c=app.id;
             ew.Reason__c ='Active';   

             Database.insert( ew, false);
        
        Profile p = [select id from profile where name='RAD_Community_Profile']; 
        User u = new User();
            u.FirstName = 'testuser';
            u.LastName = 'testLast';
            u.username = con.Email;
            u.ProfileId  = p.id;
            u.CommunityNickname = 'tcwoq';
            U.alias = 'rusrr';
            u.Email = con.Email;
            u.TIMEZONESIDKEY = 'America/Los_Angeles';
            u.contactId = con.id;
            u.emailencodingkey='UTF-8';
            u.languagelocalekey='en_US';
            
            u.localesidkey='en_US';
            insert u;
        System.runAs(u){
            RAD_LandPageCtrlr.profile_In_Appl();  
            RAD_LandPageCtrlr r = new RAD_LandPageCtrlr();
            r.getContactandApplication();
            
        }
        Test.stopTest();
        
        
    }
    
    static testMethod void testnewApp() {
    
        list<SwitchTrigger__c> sw_list = new List<SwitchTrigger__c>();
        SwitchTrigger__c sw = new SwitchTrigger__c(Name='Applications__c',Active__c=True);
        sw_list.add(sw);
        SwitchTrigger__c swWL = new SwitchTrigger__c(Name='Enrolled_Wait_List__c',Active__c=True);
        sw_list.add(swWL);
        insert sw_list;
    
        TestSuiteHelper.setupCustomSettings();
        List<Contact> cts =TestSuiteHelper.setupPortalRequiredData();  
        Contact ct = cts[0];
        Applications__c app = [Select id, Application_Status__c from Applications__c limit 1]; // where Applicant__c =:ct.id 
        
        Wait_List_Type__c wlt = [Select name, RADFamily__c, RADLive_Work_in_City_of_San_Diego__c, 
                                 RADNon_Elderly_Disabled__c, RADVeteran_Active_Military__c from Wait_List_Type__c where name ='Public Housing' limit 1];
        Test.StartTest();
       
        app.Applicant__c = null;
        Database.update(app, false);
        
        String jsonApp = json.serialize(app);
        
        
        RAD_LandPageCtrlr.saveSubmit(jsonApp, null, 'submit');
        
        
        
    }
    static testMethod void testClosedApp() {

        list<SwitchTrigger__c> sw_list = new List<SwitchTrigger__c>();
        SwitchTrigger__c sw = new SwitchTrigger__c(Name='Applications__c',Active__c=True);
        sw_list.add(sw);
        SwitchTrigger__c swWL = new SwitchTrigger__c(Name='Enrolled_Wait_List__c',Active__c=True);
        sw_list.add(swWL);
        insert sw_list;    
        TestSuiteHelper.setupCustomSettings();
        List<Contact> cts =TestSuiteHelper.setupPortalRequiredData();  
        Contact ct = cts[0];
        Applications__c app = [Select id, Application_Status__c from Applications__c  limit 1]; //where Applicant__c =:ct.id
        
        app.Application_Status__c ='Closed';
        Database.update(app, false);
        
        String jsonApp = json.serialize(app);
        String jsonCt = json.serialize(ct);
        Wait_List_Type__c wlt = [Select name, RADFamily__c, RADLive_Work_in_City_of_San_Diego__c, 
                                 RADNon_Elderly_Disabled__c, RADVeteran_Active_Military__c from Wait_List_Type__c where name ='Public Housing' limit 1];
        Test.StartTest();
        
        //RAD_LandPageCtrlr.saveSubmit(jsonApp, jsonCt, 'submit');
        
        
    }
    
}