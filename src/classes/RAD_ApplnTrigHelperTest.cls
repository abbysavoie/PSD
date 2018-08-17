@isTest
public class RAD_ApplnTrigHelperTest{
    public static testmethod void testAppln(){
    
list<SwitchTrigger__c> sw_list = new List<SwitchTrigger__c>();
SwitchTrigger__c sw = new SwitchTrigger__c(Name='Applications__c',Active__c=True);
sw_list.add(sw);
SwitchTrigger__c swWL = new SwitchTrigger__c(Name='Enrolled_Wait_List__c',Active__c=True);
sw_list.add(swWL);
insert sw_list;
        Test.startTest();
        TestSuiteHelper.setupCustomSettings();
        List<Contact> cts = TestSuiteHelper.setupPortalRequiredData();  
        Contact ct = cts[0];

        Applications__c app = [Select id, Application_Status__c from Applications__c limit 1]; //where Applicant__c =:ct.id 
        
        app.Application_Status__c = 'Submitted';
        //Database.update(app, false);
        
        //clearing WL to work for mig and normal mode        
        List<Enrolled_Wait_List__c> wlst = [Select id from Enrolled_Wait_List__c where Applications__c =: app.id ];
        //Database.delete(wlst, false);
        
        List<Preferences__c > prefLst = new List<Preferences__c>();
        
        Preferences__c pref = new Preferences__c();
        pref.Name ='lwsd';
        pref.Application__c = app.id;
        pref.status__c = 'Active';
        
        prefLst.add(pref);
        pref = new Preferences__c();
        pref.Name ='vetam';
        pref.Application__c = app.id;
        pref.status__c = 'Active';
        prefLst.add(pref);
        
        pref = new Preferences__c();
        pref.Name ='Family';
        pref.Application__c = app.id;
        pref.status__c = 'Active';
        prefLst.add(pref);
        
        pref = new Preferences__c();
        pref.Name ='Elderly Family';
        pref.Application__c = app.id;
        pref.status__c = 'Active';
        prefLst.add(pref);
        
        pref = new Preferences__c();
        pref.Name ='Homeless';
        pref.Application__c = app.id;
        pref.status__c = 'Active';
        prefLst.add(pref);
        
        pref = new Preferences__c();
        pref.Name ='Disabled Family';
        pref.Application__c = app.id;
        pref.status__c = 'Active';
        prefLst.add(pref);
        
        Database.insert(prefLst, false);
        
        //Database.update(app, false);
        
        app.Homeless__c = true;
        app.Family__c = false;
        app.Elderly_Family__c = true;
        app.Disabled_Family__c = true;
        app.Veteran_Family_of__c = true;
        app.Live_Work_in_City_of_San_Diego__c = true;    
        //Database.update(app, false);
        
        Test.stopTest();
    }
    
}