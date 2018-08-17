@isTest
public class RAD_NEDSelctdNtfyBatch_Test
{
public static testMethod void TestNEDSelctdNtfy()
{


        list<SwitchTrigger__c> sw_list = new List<SwitchTrigger__c>();
        SwitchTrigger__c sw = new SwitchTrigger__c(Name='Applications__c',Active__c=True);
        sw_list.add(sw);
        SwitchTrigger__c swWL = new SwitchTrigger__c(Name='Enrolled_Wait_List__c',Active__c=True);
        sw_list.add(swWL);
        insert sw_list; 
        
RAD_Configuration__c confg = new RAD_Configuration__c(Name = 'Main Configurations', Update_Duration_Months__c = 6, RAD_Purge_Extension_Months__c =1,
                RAD_Portal_Forgot_Password_Note__c ='This is Forgotten Password Note', RAD_Portal_Forgot_UserName_Note__c ='This is Forgotten Username Note',
                RAD_Portal_Contact_Address__c = 'This is Portal Contact Address', Announcement__c = 'This is Announcement');
                insert confg;
                
         SwitchTrigger__c  st=new SwitchTrigger__c();
        st.Name='Enrolled_Wait_List__c';
        st.Active__c=true;
        insert st;
        
 Id idd = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Applicant').getRecordTypeId();
 Contact con=new  Contact();
    //con.Name='test@cgi.com';
    con.FirstName='test1';
    con.LastName='testLast1';
    con.Contact_Type__c='Developer';
    con.RecordTypeId = idd;
    con.Active__c='Yes';

    insert con;
    
    
    Applications__c app=new Applications__c();
    
    app.Applicant__c=con.id;
    app.Ethnicity__c='testEthnicity1';
    app.Family_Annual_Income__c=Decimal.valueof('2000');
    app.RAD_Next_Purge_Request_Date__c=Datetime.Now().addMonths(2);
    app.RAD_Next_Purge_Date__c=Datetime.Now(); 
    app.White__c=false;
    app.Total_People__c = 3;
    insert app;

 Wait_List_Type__c wltype=new  Wait_List_Type__c();
    wltype.Name='NED';
    wltype.YARDI_HMY__c=1.233;
    insert wltype;
    
    Enrolled_Wait_List__c en=new Enrolled_Wait_List__c();
      //en.Name='test';
      en.Applications__c=app.id;
      en.Current_Status__c='Onlist';
      en.Wait_List_Type__c=wltype.id;
      en.Prefernce_Point__c=3;
      en.Lottery__c=56743;
      en.bed_size__c = 1;
      en.Limit__c='eli-30';
      
      insert en;
     List< Wait_List_Selection__c> liswl=new  List< Wait_List_Selection__c>();
      
       Wait_List_Selection__c wls = new Wait_List_Selection__c();
        wls.Wait_List_Type__c = wltype.id;    
        wls.Scheduled_Date__c = Date.Today()+1;
        wls.Schedule_Time__c = '4:00 PM';
        wls.Number_of_vacancies_to_fill__c=3;
        wls.Pull_Rank__c=45673; 
 
        insert wls;
        wls.Applicant_at_eli_30_75__c = 2;
        wls.Applicant_at_vli_50_25__c = 1;
        wls.Applicant_at_LI_80__c     = 0;
        update wls;
  
         wls.Status__c = 'Completed';
         update wls;
        List<Selection_Records__c> srlist=new List<Selection_Records__c>();
        Selection_Records__c sr=new Selection_Records__c();
        sr.Status__c='Selected';
        sr.RAD_Wait_List__c=en.id;
        sr.Name__c='test';
        sr.Selection_ID__c=wls.id;
        insert sr;
        
        Selection_Records__c sr1=new Selection_Records__c();
        sr1.Status__c='Selected';
        sr1.Name__c='test';
        sr1.RAD_Wait_List__c=en.id;
        sr1.Selection_ID__c=wls.id;
        insert sr1;
        
        srlist.add(sr);
        srlist.add(sr1);
                
        
        RAD_NEDSelctdNtfyBatch NEDT=new RAD_NEDSelctdNtfyBatch(wls.id);
        Database.executeBatch(NEDT);
        
 

}
public static testMethod void TestNEDSelctdNtfy2()
{
        list<SwitchTrigger__c> sw_list = new List<SwitchTrigger__c>();
        SwitchTrigger__c sw = new SwitchTrigger__c(Name='Applications__c',Active__c=True);
        sw_list.add(sw);
        SwitchTrigger__c swWL = new SwitchTrigger__c(Name='Enrolled_Wait_List__c',Active__c=True);
        sw_list.add(swWL);
        insert sw_list; 

RAD_Configuration__c confg = new RAD_Configuration__c(Name = 'Main Configurations', Update_Duration_Months__c = 6, RAD_Purge_Extension_Months__c =1,
                RAD_Portal_Forgot_Password_Note__c ='This is Forgotten Password Note', RAD_Portal_Forgot_UserName_Note__c ='This is Forgotten Username Note',
                RAD_Portal_Contact_Address__c = 'This is Portal Contact Address', Announcement__c = 'This is Announcement');
                insert confg;
                
         SwitchTrigger__c  st=new SwitchTrigger__c();
        st.Name='Enrolled_Wait_List__c';
        st.Active__c=true;
        insert st;
        
 Id idd = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Applicant').getRecordTypeId();
 Contact con=new  Contact();
    //con.Name='test@cgi.com';
    con.FirstName='test1';
    con.LastName='testLast1';
    con.Contact_Type__c='Developer';
    con.RecordTypeId = idd;
    con.Active__c='Yes';
    con.email='test@test.com';

    insert con;
    
    
    Applications__c app=new Applications__c();
    
    app.Applicant__c=con.id;
    app.Ethnicity__c='testEthnicity1';
    app.Family_Annual_Income__c=Decimal.valueof('2000');
    app.RAD_Next_Purge_Request_Date__c=Datetime.Now().addMonths(2);
    app.RAD_Next_Purge_Date__c=Datetime.Now(); 
    app.White__c=false;
    app.Total_People__c = 3;
    insert app;

 Wait_List_Type__c wltype=new  Wait_List_Type__c();
    wltype.Name='NED';
    wltype.YARDI_HMY__c=1.233;
    insert wltype;
    
    Enrolled_Wait_List__c en=new Enrolled_Wait_List__c();
      //en.Name='test';
      en.Applications__c=app.id;
      en.Current_Status__c='Onlist';
      en.Wait_List_Type__c=wltype.id;
      en.Prefernce_Point__c=3;
      en.Lottery__c=56743;
      en.bed_size__c = 1;
      en.Limit__c='eli-30';
      
      insert en;
     List< Wait_List_Selection__c> liswl=new  List< Wait_List_Selection__c>();
      
       Wait_List_Selection__c wls = new Wait_List_Selection__c();
        wls.Wait_List_Type__c = wltype.id;    
        wls.Scheduled_Date__c = Date.Today()+1;
        wls.Schedule_Time__c = '4:00 PM';
        wls.Number_of_vacancies_to_fill__c=3;
        wls.Pull_Rank__c=45673;     
        insert wls;
        wls.Applicant_at_eli_30_75__c = 2;
        wls.Applicant_at_vli_50_25__c = 1;
        wls.Applicant_at_LI_80__c     = 0;
        update wls;
  
         wls.Status__c = 'Completed';
         update wls;
        List<Selection_Records__c> srlist=new List<Selection_Records__c>();
        Selection_Records__c sr=new Selection_Records__c();
        sr.Status__c='Selected';
        sr.RAD_Wait_List__c=en.id;
        sr.Name__c='test';
        sr.Selection_ID__c=wls.id;
        insert sr;
        
        Selection_Records__c sr1=new Selection_Records__c();
        sr1.Status__c='Selected';
        sr1.Name__c='test';
        sr1.RAD_Wait_List__c=en.id;
        sr1.Selection_ID__c=wls.id;
        insert sr1;
        
        srlist.add(sr);
        srlist.add(sr1);
                
        
        RAD_NEDSelctdNtfyBatch NEDT=new RAD_NEDSelctdNtfyBatch(wls.id);
        Database.executeBatch(NEDT);
        
}

}