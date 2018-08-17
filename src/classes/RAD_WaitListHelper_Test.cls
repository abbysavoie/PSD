@isTest
public  class RAD_WaitListHelper_Test
{
public static testmethod void RAD_WaitListHelperTest()
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
        Contact c = new contact(Gender__c='Male',LastName = 'sagar', Contact_Type__c = 'Asset Manager');
        
        insert c;
        c.SSN_TaxID__c='123456789';
        update c;
        Applications__c app = new Applications__c();
        app.Applicant__c=c.id;
        app.Ethnicity__c='test';
        app.SSN__c='123456789';
        app.Family__c=true;
        app.Homeless_with_disability__c=true;
        app.Family_Annual_Income__c=Decimal.valueof('1000');
        app.of_people_in_the_H_H_Adults__c=1;
        app.Homeless_with_disability__c=true;
        app.Spouse_Co_Head_If_applicable__c=true;
        insert app;
        
         Wait_List_Type__c  wlt=new  Wait_List_Type__c();
         wlt.Name='Mod Rehab';
         wlt.YARDI_HMY__c=Decimal.valueof('12345');
         wlt.RADFamily__c=1;
         wlt.RADDisabled_Family__c=1;
         wlt.RADHomeless_with_disability__c=1;
         wlt.RADLive_Work_in_City_of_San_Diego__c=1;
         wlt.RADVeteran_Active_Military__c=1;
         wlt.RADNon_Elderly_Disabled__c=1;
      
         insert wlt;
    
     
     
     
     Enrolled_Wait_List__c ew=new Enrolled_Wait_List__c();
     ew.Current_Status__c='OnList'; 
     ew.Wait_List_Type__c=wlt.id;
     //ew.Prefernce_Point__c=Decimal.valueof('3'); 
     ew.Applications__c=app.id;  
     ew.Status__c ='On List';
     ew.Portal_Status__c='Active';
     insert ew;
     Decimal pref;
  
  Test.StartTest();
   //RAD_WaitListHelper wlh = new  RAD_WaitListHelper();
     RAD_WaitListHelper.calculatePrefPoints(ew,wlt);
    
     
  Test.StopTest();
  
}
public static testmethod void RAD_WaitListHelperTest2()
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
        Contact c = new contact(Gender__c='Male',LastName = 'sagar', Contact_Type__c = 'Asset Manager');
        
        insert c;
        c.SSN_TaxID__c='123456789';
        update c;
        Applications__c app = new Applications__c();
        app.Applicant__c=c.id;
        app.Ethnicity__c='test';
        app.SSN__c='123456789';
        app.Family__c=true;
        app.Homeless_with_disability__c=true;
        app.Family_Annual_Income__c=Decimal.valueof('1000');
        app.of_people_in_the_H_H_Adults__c=1;
        app.Homeless_with_disability__c=true;
        insert app;
        
         Wait_List_Type__c  wlt=new  Wait_List_Type__c();
         wlt.Name='Mod Rehab';
         wlt.YARDI_HMY__c=Decimal.valueof('12345');
         wlt.RADFamily__c=1;
         wlt.RADDisabled_Family__c=1;
         wlt.RADHomeless_with_disability__c=1;
         wlt.RADLive_Work_in_City_of_San_Diego__c=1;
         wlt.RADVeteran_Active_Military__c=1;
         wlt.RADNon_Elderly_Disabled__c=1;
      
         insert wlt;
       
       Wait_List_Income_Limit__c wilimit=new  Wait_List_Income_Limit__c ();
       wilimit.Code__c='test';
       //wilimit.Percent_Income_Limit__c='10%';
       insert wilimit;
       
    
   Wait_List_Income_Limit_Details__c wl=new Wait_List_Income_Limit_Details__c();
    wl.Limit_Effective_Date__c=Date.today();
    wl.Limit_Effective_Date__c=Date.today();
   //wl.Percent_Income_Limit__c =1;
   wl.Income_Limit__c=wilimit.id;
    insert wl;
     
     
     Enrolled_Wait_List__c ew=new Enrolled_Wait_List__c();
     ew.Current_Status__c='Selected'; 
     ew.Wait_List_Type__c=null;
     //ew.Prefernce_Point__c=Decimal.valueof('3'); 
     ew.Applications__c=app.id;  
     ew.Status__c ='On List';
     ew.Portal_Status__c='Active';
     insert ew;
     Decimal pref;
  
  Test.StartTest();
   //RAD_WaitListHelper wlh = new  RAD_WaitListHelper();
     RAD_WaitListHelper.calculatePrefPoints(ew,wlt);
    
     
  Test.StopTest();
}
public static testmethod void RAD_WaitListHelperTest3()
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
        Contact c = new contact(Gender__c='Male',LastName = 'sagar', Contact_Type__c = 'Asset Manager');
        
        insert c;
        c.SSN_TaxID__c='123456789';
        update c;
        Applications__c app = new Applications__c();
        app.Applicant__c=c.id;
        app.Ethnicity__c='test';
        app.SSN__c='123456789';
        app.Family__c=true;
        app.Homeless_with_disability__c=true;
        app.Family_Annual_Income__c=Decimal.valueof('1000');
        app.of_people_in_the_H_H_Adults__c=1;
        app.Homeless_with_disability__c=true;
        app.Spouse_Co_Head_If_applicable__c=false;
        app.Live_Work_in_City_of_San_Diego__c=true;
        app.Non_Elderly_Disabled__c=true;
        app.Veteran_Family_of__c=true;
        insert app;
        
         Wait_List_Type__c  wlt=new  Wait_List_Type__c();
         wlt.Name='Mod Rehab';
         wlt.YARDI_HMY__c=Decimal.valueof('12345');
         wlt.RADFamily__c=1;
         wlt.RADDisabled_Family__c=1;
         wlt.RADHomeless_with_disability__c=1;
         wlt.RADLive_Work_in_City_of_San_Diego__c=1;
         wlt.RADVeteran_Active_Military__c=1;
         wlt.RADNon_Elderly_Disabled__c=1;
      
         insert wlt;
     
     Enrolled_Wait_List__c ew=new Enrolled_Wait_List__c();
     ew.Current_Status__c='OnList'; 
     ew.Wait_List_Type__c=wlt.id;
     //ew.Prefernce_Point__c=Decimal.valueof('3'); 
     ew.Applications__c=app.id;  
     ew.Status__c ='On List';
     ew.Portal_Status__c='Active';
     insert ew;
    
  

   //RAD_WaitListHelper wlh = new  RAD_WaitListHelper();
     RAD_WaitListHelper.calculatePrefPoints(ew,wlt);
    
     

}
public static testmethod void RAD_WaitListHelperTest4()
{
RAD_Configuration__c  confg = new RAD_Configuration__c(Name = 'Main Configurations', Update_Duration_Months__c = 6, RAD_Purge_Extension_Months__c =1,
                RAD_Portal_Forgot_Password_Note__c ='This is Forgotten Password Note', RAD_Portal_Forgot_UserName_Note__c ='This is Forgotten Username Note',
                RAD_Portal_Contact_Address__c = 'This is Portal Contact Address', Announcement__c = 'This is Announcement');

            insert confg;
        list<SwitchTrigger__c> sw_list = new List<SwitchTrigger__c>();
        SwitchTrigger__c sw = new SwitchTrigger__c(Name='Applications__c',Active__c=True);
        sw_list.add(sw);
        SwitchTrigger__c swWL = new SwitchTrigger__c(Name='Enrolled_Wait_List__c',Active__c=True);
        sw_list.add(swWL);
        
        insert sw_list;            
        Contact c = new contact(Gender__c='Male',LastName = 'sagar', Contact_Type__c = 'Asset Manager');
        
        insert c;
        c.SSN_TaxID__c='123456789';
        update c;
        Applications__c app = new Applications__c();
        app.Applicant__c=c.id;
        app.Ethnicity__c='test';
        app.SSN__c='123456789';
        app.Family__c=true;
        app.Homeless_with_disability__c=true;
        app.Family_Annual_Income__c=Decimal.valueof('1000');
        app.of_people_in_the_H_H_Adults__c=1;
        app.Homeless_with_disability__c=true;
        app.Spouse_Co_Head_If_applicable__c=false;
        app.Live_Work_in_City_of_San_Diego__c=true;
        app.Non_Elderly_Disabled__c=true;
        app.Veteran_Family_of__c=true;
        insert app;
        
         Wait_List_Type__c  wlt=new  Wait_List_Type__c();
         wlt.Name='Mod Rehab';
         wlt.YARDI_HMY__c=Decimal.valueof('12345');
         wlt.RADFamily__c=1;
         wlt.RADDisabled_Family__c=1;
         wlt.RADHomeless_with_disability__c=1;
         wlt.RADLive_Work_in_City_of_San_Diego__c=1;
         wlt.RADVeteran_Active_Military__c=1;
         wlt.RADNon_Elderly_Disabled__c=1;
      
         insert wlt;
     
     Enrolled_Wait_List__c ew=new Enrolled_Wait_List__c();
     ew.Current_Status__c='Removed'; 
     ew.Wait_List_Type__c=wlt.id;
     //ew.Prefernce_Point__c=Decimal.valueof('3'); 
     ew.Applications__c=app.id;  
     ew.Status__c ='On List';
     ew.Portal_Status__c='Active';
     insert ew;
     Decimal pref;
  
 
   //RAD_WaitListHelper wlh = new  RAD_WaitListHelper();
     RAD_WaitListHelper.calculatePrefPoints(ew,wlt);
    
     
}
public static testmethod void RAD_WaitListHelperTest5()
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
        Contact c = new contact(Gender__c='Male',LastName = 'sagar', Contact_Type__c = 'Asset Manager');
        
        insert c;
        c.SSN_TaxID__c='123456789';
        update c;
        Applications__c app = new Applications__c();
        app.Applicant__c=c.id;
        app.Ethnicity__c='test';
        app.SSN__c='123456789';
        app.Family__c=true;
        app.Homeless_with_disability__c=true;
        app.Family_Annual_Income__c=Decimal.valueof('1000');
        app.of_people_in_the_H_H_Adults__c=1;
        app.Homeless_with_disability__c=true;
        app.Spouse_Co_Head_If_applicable__c=false;
        app.Live_Work_in_City_of_San_Diego__c=true;
        app.Non_Elderly_Disabled__c=true;
        app.Veteran_Family_of__c=true;
        insert app;
        
         Wait_List_Type__c  wlt=new  Wait_List_Type__c();
         wlt.Name='Mod Rehab';
         wlt.YARDI_HMY__c=Decimal.valueof('12345');
         wlt.RADFamily__c=1;
         wlt.RADDisabled_Family__c=1;
         wlt.RADHomeless_with_disability__c=1;
         wlt.RADLive_Work_in_City_of_San_Diego__c=1;
         wlt.RADVeteran_Active_Military__c=1;
         wlt.RADNon_Elderly_Disabled__c=1;
      
         insert wlt;
     
     Enrolled_Wait_List__c ew=new Enrolled_Wait_List__c();
     ew.Current_Status__c='Leased'; 
     ew.Wait_List_Type__c=wlt.id;
     //ew.Prefernce_Point__c=Decimal.valueof('3'); 
     ew.Applications__c=app.id;  
     ew.Status__c ='On List';
     ew.Portal_Status__c='Active';
     insert ew;
     Decimal pref;
  
 
   //RAD_WaitListHelper wlh = new  RAD_WaitListHelper();
     RAD_WaitListHelper.calculatePrefPoints(ew,wlt);
    
}
public static testmethod void RAD_WaitListHelperTest6()
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
        Contact c = new contact(Gender__c='Male',LastName = 'sagar', Contact_Type__c = 'Asset Manager');
        
        insert c;
        c.SSN_TaxID__c='123456789';
        update c;
        Applications__c app = new Applications__c();
        app.Applicant__c=c.id;
        app.Ethnicity__c='test';
        app.SSN__c='123456789';
        app.Family__c=true;
        app.Homeless_with_disability__c=true;
        app.Family_Annual_Income__c=Decimal.valueof('1000');
        app.of_people_in_the_H_H_Adults__c=1;
        app.Homeless_with_disability__c=true;
        app.Spouse_Co_Head_If_applicable__c=false;
        app.Live_Work_in_City_of_San_Diego__c=true;
        app.Non_Elderly_Disabled__c=true;
        app.Veteran_Family_of__c=true;
        insert app;
        
         Wait_List_Type__c  wlt=new  Wait_List_Type__c();
         wlt.Name='Mod Rehab';
         wlt.YARDI_HMY__c=Decimal.valueof('12345');
         wlt.RADFamily__c=1;
         wlt.RADDisabled_Family__c=1;
         wlt.RADHomeless_with_disability__c=1;
         wlt.RADLive_Work_in_City_of_San_Diego__c=1;
         wlt.RADVeteran_Active_Military__c=1;
         wlt.RADNon_Elderly_Disabled__c=1;
      
         insert wlt;
     
     Enrolled_Wait_List__c ew=new Enrolled_Wait_List__c();
     ew.Current_Status__c='Selected'; 
     ew.Wait_List_Type__c=wlt.id;
     ew.Applications__c=app.id;       
     ew.Portal_Status__c='Active';
     insert ew;
     Decimal pref;

   //RAD_WaitListHelper wlh = new  RAD_WaitListHelper();
   RAD_WaitListHelper.calculatePrefPoints(ew,wlt);
    

}
public static testmethod void RAD_WaitListHelperTest7()
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
        Contact c = new contact(Gender__c='Male',LastName = 'sagar', Contact_Type__c = 'Asset Manager');
        
        insert c;
        c.SSN_TaxID__c='123456789';
        update c;
        Applications__c app = new Applications__c();
        app.Applicant__c=c.id;
        app.Ethnicity__c='test';
        app.SSN__c='123456789';
        app.Family__c=false;
        app.Homeless_with_disability__c=true;
        app.Family_Annual_Income__c=Decimal.valueof('1000');
        app.of_people_in_the_H_H_Adults__c=16;
        app.Homeless_with_disability__c=true;
        app.Spouse_Co_Head_If_applicable__c=false;
        app.Live_Work_in_City_of_San_Diego__c=true;
        app.Non_Elderly_Disabled__c=true;
        app.Veteran_Family_of__c=true;
        insert app;
        
         Wait_List_Type__c  wlt=new  Wait_List_Type__c();
         wlt.Name='Mod Rehab';
         wlt.YARDI_HMY__c=Decimal.valueof('12345');
         wlt.RADFamily__c=1;
         wlt.RADDisabled_Family__c=1;
         wlt.RADHomeless_with_disability__c=1;
         wlt.RADLive_Work_in_City_of_San_Diego__c=1;
         wlt.RADVeteran_Active_Military__c=1;
         wlt.RADNon_Elderly_Disabled__c=1;
      
         insert wlt;
     
     Enrolled_Wait_List__c ew=new Enrolled_Wait_List__c();
     ew.Current_Status__c ='Onlist';
     //ew.Wait_List_Type__c=wlt.id;
     ew.Applications__c=app.id;      
     insert ew;
   
   //RAD_WaitListHelper wlh = new  RAD_WaitListHelper();
    //RAD_WaitListHelper.processWLsBeforeUpdate();
   
    
}
}