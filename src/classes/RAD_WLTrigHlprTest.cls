@isTest
public class RAD_WLTrigHlprTest{

     public static testmethod void testWLBasic(){

        list<SwitchTrigger__c> sw_list = new List<SwitchTrigger__c>();
        SwitchTrigger__c sw = new SwitchTrigger__c(Name='Applications__c',Active__c=True);
        sw_list.add(sw);
        SwitchTrigger__c swWL = new SwitchTrigger__c(Name='Enrolled_Wait_List__c',Active__c=True);
        sw_list.add(swWL);
        insert sw_list;     
        TestSuiteHelper.setupCustomSettings();
        Wait_List_Type__c wlt = [Select name, RADFamily__c, RADLive_Work_in_City_of_San_Diego__c, 
                RADNon_Elderly_Disabled__c, RADVeteran_Active_Military__c from Wait_List_Type__c where name ='Public Housing' limit 1];
        Test.startTest();

            List<Contact> cts = TestSuiteHelper.setupPortalRequiredData();  
            Contact ct = cts[0];
            Applications__c app = [Select id, Elderly_Family__c, Family__c, Homeless_with_disability__c, Live_Work_in_City_of_San_Diego__c,
                        Non_Elderly_Disabled__c, Disabled_Family__c, Veteran_Family_of__c from Applications__c where Applicant__c =:ct.id limit 1];

            
            List<Enrolled_Wait_List__c> wlst = [Select RAD_Applied_Date_and_Time__c,  Applications__r.Family__c, Applications__r.Homeless_with_disability__c,
                Applications__r.Live_Work_in_City_of_San_Diego__c, Applications__r.Non_Elderly_Disabled__c , Applications__r.Veteran_Family_of__c  from Enrolled_Wait_List__c where Applications__c =: app.id ];
            //Database.delete(wlst, false);

             Enrolled_Wait_List__c ew = new Enrolled_Wait_List__c();
             ew.Wait_List_Type__c=wlt.id;
             ew.Prefernce_Point__c=Decimal.valueof('3'); 
             ew.Applications__c=app.id;   
             ew.Current_Status__c='Onlist'; 
             ew.Status__c = 'On List';
             ew.Reason__c ='Active';
             
             //Database.insert( ew, false);
             //Database.delete(ew, false);
             
             
             
             ew = new Enrolled_Wait_List__c();
             ew.Current_Status__c= 'Removed';
             ew.Wait_List_Type__c=wlt.id;
             ew.Prefernce_Point__c=Decimal.valueof('3'); 
             ew.Applications__c=app.id;
             ew.Reason__c ='Active';   

             //Database.insert( ew, false);
             //Database.delete(ew, false);
             
             ew = new Enrolled_Wait_List__c();
             ew.Wait_List_Type__c=wlt.id;
             ew.Prefernce_Point__c=Decimal.valueof('2'); 
             ew.Applications__c=app.id;   
             ew.Current_Status__c= 'Leased';
             ew.Reason__c ='Active';
             
             //Database.insert( ew, false);
            //Database.delete(ew, false);
             
             ew = new Enrolled_Wait_List__c();
             ew.Wait_List_Type__c=wlt.id;
             ew.Prefernce_Point__c=Decimal.valueof('1'); 
             ew.Applications__c=app.id;   
             ew.Current_Status__c= 'Issue/Offer';
             ew.Reason__c ='Active';

             //Database.insert( ew, false);
             //Database.delete(ew, false);

             ew = new Enrolled_Wait_List__c();
             ew.Wait_List_Type__c=wlt.id;
             ew.Prefernce_Point__c=Decimal.valueof('3'); 
             ew.Applications__c=app.id;   
             ew.Current_Status__c= 'Selected';
             ew.Reason__c ='Active';

             //Database.insert( ew, false);
             //Database.delete(ew, false);
             
             
        Test.stopTest();
    }
    
    public static testmethod void testWLBasicUPDT(){
        list<SwitchTrigger__c> sw_list = new List<SwitchTrigger__c>();
        SwitchTrigger__c sw = new SwitchTrigger__c(Name='Applications__c',Active__c=True);
        sw_list.add(sw);
        SwitchTrigger__c swWL = new SwitchTrigger__c(Name='Enrolled_Wait_List__c',Active__c=True);
        sw_list.add(swWL);
        insert sw_list;    
        TestSuiteHelper.setupCustomSettings();
        Wait_List_Type__c wlt = [Select name, RADFamily__c, RADLive_Work_in_City_of_San_Diego__c, 
                RADNon_Elderly_Disabled__c, RADVeteran_Active_Military__c from Wait_List_Type__c where name ='Public Housing' limit 1];

        List<Contact> cts = TestSuiteHelper.setupPortalRequiredData();  

            Contact ct = cts[0];
            Applications__c app = [Select id, Family__c,Elderly_Family__c, Homeless_with_disability__c, Live_Work_in_City_of_San_Diego__c,
                        Non_Elderly_Disabled__c, Disabled_Family__c, Veteran_Family_of__c from Applications__c where Applicant__c =:ct.id limit 1];

            
            List<Enrolled_Wait_List__c> wlst = [Select RAD_Applied_Date_and_Time__c,  Applications__r.Family__c, Applications__r.Homeless_with_disability__c,
                Applications__r.Live_Work_in_City_of_San_Diego__c, Applications__r.Non_Elderly_Disabled__c , Applications__r.Veteran_Family_of__c  from Enrolled_Wait_List__c where Applications__c =: app.id ];
            //Database.delete(wlst, false);

        Test.startTest();

             //FOR UPDATE

             Enrolled_Wait_List__c ew = new Enrolled_Wait_List__c();
             ew.Wait_List_Type__c=wlt.id;
             
             ew.Prefernce_Point__c=Decimal.valueof('3'); 
             ew.Applications__c=app.id;   
             ew.Current_Status__c= 'Onlist';
             ew.Reason__c ='Active';
             ew.Status__c = 'On List';
             Database.insert( ew, false);
             
             ew = [Select RAD_Applied_Date_and_Time__c,  Applications__r.Family__c, Applications__r.Homeless_with_disability__c,
                Applications__r.Live_Work_in_City_of_San_Diego__c, Applications__r.Non_Elderly_Disabled__c , Applications__r.Disabled_Family__c, Applications__r.Veteran_Family_of__c  from Enrolled_Wait_List__c where Applications__c =: app.id limit 1];
             ew.Current_Status__c='On List'; 
             ew.Wait_List_Type__c=wlt.id;
             
             ew.Applications__r.Family__c = true;
             ew.Applications__r.Homeless_with_disability__c = false;
             ew.Applications__r.Live_Work_in_City_of_San_Diego__c = false;
             ew.Applications__r.Non_Elderly_Disabled__c = false;
             ew.Applications__r.Veteran_Family_of__c  = false;
             Database.update(ew, false);
             
             RAD_WaitListHelper.calculatePrefPoints(ew,wlt);
             RAD_WaitListHelper.calculatePrefPtsFromAppl(app,wlt);

             ew.Current_Status__c='Removed'; 
             Database.update(ew, false);
             
             ew.Current_Status__c='Leased'; 
             Database.update(ew, false);
             
             ew.Current_Status__c='Issue/Offer'; 
             Database.update(ew, false);
             
             ew.Current_Status__c='Selected'; 
             Database.update(ew, false);
             

             
        Test.stopTest();
    }
    public static testmethod void testWL(){
        Test.startTest();
            TestSuiteHelper.setupCustomSettings();
            TestSuiteHelper.setupPortalRequiredData();  

            List<Enrolled_Wait_List__c> wlst = [Select RAD_Applied_Date_and_Time__c from Enrolled_Wait_List__c where current_status__c ='Onlist'];
            
            for(Enrolled_Wait_List__c wl :wlst){
                wl.RAD_Applied_Date_and_Time__c =Datetime.Now();
            
            }
            Database.update(wlst, false);

        Test.stopTest();
    }
    public static testmethod void testWLS(){
        list<SwitchTrigger__c> sw_list = new List<SwitchTrigger__c>();
        SwitchTrigger__c sw = new SwitchTrigger__c(Name='Applications__c',Active__c=True);
        sw_list.add(sw);
        SwitchTrigger__c swWL = new SwitchTrigger__c(Name='Enrolled_Wait_List__c',Active__c=True);
        sw_list.add(swWL);
        insert sw_list;
        Wait_List_Type__c newSec8Type = new Wait_List_Type__c(Name='Section 8',YARDI_HMY__c=5);
        insert newSec8Type;
        
        Wait_List_Type__c wlt = [Select name from Wait_List_Type__c where name ='Section 8' limit 1];    
        Test.startTest();
            try {
                TestSuiteHelper.setupCustomSettings();
                TestSuiteHelper.setupPortalRequiredData();
            } catch(exception e) {
            }  



        Test.stopTest();
    }    
    

 
    
}