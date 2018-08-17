@isTest
public class RAD_ContactHelper_test{
public static testmethod void RAD_ContactHelpertest()
{

RAD_Configuration__c  confg = new RAD_Configuration__c(Name = 'Main Configurations', Update_Duration_Months__c = 6, RAD_Purge_Extension_Months__c =1,
                RAD_Portal_Forgot_Password_Note__c ='This is Forgotten Password Note', RAD_Portal_Forgot_UserName_Note__c ='This is Forgotten Username Note',
                RAD_Portal_Contact_Address__c = 'This is Portal Contact Address', Announcement__c = 'This is Announcement');

            insert confg;
SwitchTrigger__c sw = new SwitchTrigger__c(Name='Applications__c',Active__c=True);
insert sw;
SwitchTrigger__c swWL = new SwitchTrigger__c(Name='Enrolled_Wait_List__c',Active__c=True);
insert swWL;            
Contact c = new contact(Gender__c='Male',LastName = 'sagar', Contact_Type__c = 'Asset Manager');

insert c;
c.SSN_TaxID__c='123456789';
update c;
Applications__c app = new Applications__c();
app.Applicant__c=c.id;
app.Total_People__c = 3;
app.Ethnicity__c='test';

app.SSN__c='123456789';
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
     Enrolled_Wait_List__c ew1=new Enrolled_Wait_List__c();
     ew1.Current_Status__c='Onlist'; 
     ew1.Wait_List_Type__c=wlt.id;
     ew1.Prefernce_Point__c=Decimal.valueof('3'); 
     ew1.Applications__c=app.id;   
     ew1.Lottery__c=56712;
     insert ew1;
    



 Test.StartTest();
 

        RAD_ContactHelper cntcthlpr = new RAD_ContactHelper();
        
        
        
        Test.StopTest();   
}
}