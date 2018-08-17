@isTest
public class Rad_PublishingPrintLabl_Test {
public static testMethod void RefLetterpdf()
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
     wlt.Name='Public Housing';
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
      List<Selection_Records__c> listsel=new    List<Selection_Records__c>(); 
        
Test.startTest();
 ApexPages.StandardController sc = new ApexPages.StandardController(wls);
RAD_PubHsgPrintLbl rf = new RAD_PubHsgPrintLbl(sc);
Test.StopTest();
System.assertEquals(wls.Bedroom_Size__c,3);
listsel=rf.getSelList(); 



}
}