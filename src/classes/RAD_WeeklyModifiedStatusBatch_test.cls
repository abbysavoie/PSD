@isTest
public class RAD_WeeklyModifiedStatusBatch_test{
    public static testmethod void wkmodfedstbt()
    {
list<SwitchTrigger__c> sw_list = new List<SwitchTrigger__c>();
SwitchTrigger__c sw = new SwitchTrigger__c(Name='Applications__c',Active__c=True);
sw_list.add(sw);
SwitchTrigger__c swWL = new SwitchTrigger__c(Name='Enrolled_Wait_List__c',Active__c=True);
sw_list.add(swWL);
insert sw_list;        
        TestSuiteHelper.setupCustomSettings();
        Id idd = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Applicant').getRecordTypeId();
        
        
        
        Contact con=new  Contact();
        
        con.FirstName='test';
        con.LastName='testLast';
        con.Contact_Type__c  = 'Community Global User';
        con.RecordTypeId = idd;
        con.Active__c='Yes';
        insert con;
        
        Applications__c app=new Applications__c();
        app.Applicant__c=con.id;
        app.Ethnicity__c = 'Hispanic or Latino';
        app.Family_Annual_Income__c=Decimal.valueof('1000');
        app.White__c=true;
        app.of_people_in_the_H_H_Adults__c = 1;
        app.Dependents_Children_under_age_of_18__c = 0;
        app.Application_Status__c ='Submitted';
        app.PBV_Project_Based__c =true;
        app.Live_Work_in_City_of_San_Diego__c = true;
        
        
        insert app;
        
        
        //clearing WL to work for mig and normal mode        
        List<Enrolled_Wait_List__c> wlst = [Select id from Enrolled_Wait_List__c where Applications__c =: app.id ];
        Database.delete(wlst, false);
        
        Wait_List_Type__c wltype =[Select id from Wait_List_Type__c where name ='Project Based' limit 1];
        
        
        Enrolled_Wait_List__c en=new Enrolled_Wait_List__c();
        en.Applications__c=app.id;
        en.Current_Status__c='Onlist';
        en.Reason__c ='Active';   
        en.Wait_List_Type__c=wltype.id;
        en.Bed_size__c=4;
        en.Prefernce_Point__c=3;
        en.Lottery__c=78901;
        en.Limit__c='eli-30';
        en.RAD_Applied_Date_and_Time__c = datetime.now();
        insert en;
        
        
        
        Test.StartTest();
        RAD_WeeklyModifiedStatusBatch wmsb = new RAD_WeeklyModifiedStatusBatch();
        
        Database.executeBatch(wmsb );
        
        Test.StopTest();   
        //System.AssertEquals(database.countquery('SELECT COUNT()'+' FROM Topic '), 3);
    }
    public static testmethod void wkmodfedstbtEmail()
    {
        
 list<SwitchTrigger__c> sw_list = new List<SwitchTrigger__c>();
SwitchTrigger__c sw = new SwitchTrigger__c(Name='Applications__c',Active__c=True);
sw_list.add(sw);
SwitchTrigger__c swWL = new SwitchTrigger__c(Name='Enrolled_Wait_List__c',Active__c=True);
sw_list.add(swWL);
insert sw_list;
       
        TestSuiteHelper.setupCustomSettings();
        
        List<Applications__c>lstAppln = new List<Applications__c>();
        
        Id idd = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Applicant').getRecordTypeId();
        Contact con=new  Contact();
        
        con.FirstName='test';
        con.LastName='testLast';
        con.Contact_Type__c  = 'Community Global User';
        con.Email='test1abc@cgi.com';
        con.RecordTypeId = idd;
        con.Active__c='Yes';
        insert con;
        Applications__c acc = new Applications__c();
        
        acc.Applicant__c=con.id;
        acc.Ethnicity__c = 'Hispanic or Latino';
        acc.Family_Annual_Income__c=Decimal.valueof('1000');
        acc.White__c=true;
        acc.of_people_in_the_H_H_Adults__c = 1;
        acc.Dependents_Children_under_age_of_18__c = 0;
        acc.Application_Status__c ='Submitted';
        acc.PBV_Project_Based__c =true;
        acc.Live_Work_in_City_of_San_Diego__c = true;
        
        
        lstAppln.add(acc);
        //insert acc;
        Contact con1=new  Contact();
        //con.Name='test@cgi.com';
        con1.FirstName='test';
        con1.LastName='testLast';
        con1.Contact_Type__c  = 'Community Global User';
        con1.Email='testdef@cgi.com';
        con1.Active__c='Yes';
        con1.RecordTypeId = idd;
        insert con1;
        Applications__c acc1 = new Applications__c();
        
        acc1.Applicant__c=con1.id;
        acc1.Ethnicity__c = 'Hispanic or Latino';
        acc1.Family_Annual_Income__c=Decimal.valueof('1000');
        acc1.White__c=true;
        acc1.of_people_in_the_H_H_Adults__c = 1;
        acc1.Dependents_Children_under_age_of_18__c = 0;
        acc1.Application_Status__c ='Submitted';
        acc1.PBV_Project_Based__c =true;
        acc1.Live_Work_in_City_of_San_Diego__c = false;
        
        lstAppln.add(acc1);
        //insert acc1;
        
        Contact con2=new  Contact();
        //con.Name='test@cgi.com';
        con2.FirstName='test';
        con2.LastName='testLast';
        con2.Contact_Type__c  = 'Community Global User';
        con2.Email='';
        con2.RecordTypeId = idd;
        con2.Paperless_Email_only__c =false;
        con2.Active__c='Yes';
        insert con2;
        Applications__c acc2 = new Applications__c();
        
        acc2.Applicant__c=con2.id;
        acc2.Ethnicity__c = 'Hispanic or Latino';
        acc2.Family_Annual_Income__c=Decimal.valueof('1000');
        acc2.White__c=true;
        acc2.of_people_in_the_H_H_Adults__c = 1;
        acc2.Dependents_Children_under_age_of_18__c = 0;
        acc2.Application_Status__c ='Submitted';
        acc2.PBV_Project_Based__c =true;
        acc2.Live_Work_in_City_of_San_Diego__c = false;
        
        lstAppln.add(acc2);
        
        Database.insert(lstAppln, false);
        
        Test.StartTest();
        
        RAD_WeeklyModifiedStatusBatch wmsb = new RAD_WeeklyModifiedStatusBatch();
        
        Database.executeBatch(wmsb );
        
        Test.StopTest();   
        
    }
    
}