@isTest
public class RAD_PubHsgSelnCnt_BatchTest
{
public static testMethod void PubHsgtest(){

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
 Id idd = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Applicant').getRecordTypeId();
 Contact con=new  Contact();
    //con.Name='test@cgi.com';
    con.FirstName='test';
    con.LastName='testLast';
    con.Contact_Type__c='Developer';
    con.RecordTypeId = idd;
    con.Active__c='Yes';

    insert con;
    
    
    Applications__c app=new Applications__c();
    
    app.Applicant__c=con.id;
    app.Ethnicity__c='testEthnicity';
    app.Family_Annual_Income__c=Decimal.valueof('1000');
    app.RAD_Next_Purge_Request_Date__c=Datetime.Now().addMonths(2);
    app.RAD_Next_Purge_Date__c=Datetime.Now(); 
    app.White__c=true;
    app.Total_People__c = 1;
    insert app;
   //clearing WL to work for mig and normal mode        
        List<Enrolled_Wait_List__c> wlst = [Select id from Enrolled_Wait_List__c where Applications__c =: app.id ];
        Database.delete(wlst, false);
        
  
   Wait_List_Type__c wltype=new  Wait_List_Type__c();
    wltype.Name='Public Housing';
    wltype.YARDI_HMY__c=1.233;
    insert wltype;
    
    Enrolled_Wait_List__c en=new Enrolled_Wait_List__c();
      //en.Name='test';
      en.Applications__c=app.id;
      en.Current_Status__c='Onlist';
      en.Wait_List_Type__c=wltype.id;
      en.Bed_size__c=4;
      en.Prefernce_Point__c=3;
      en.Lottery__c=45673;
      en.Limit__c='eli-30';
      en.Reason__c ='Active';  
      
      insert en;
    
    
        
        Wait_List_Selection__c wls = new Wait_List_Selection__c();
        wls.Wait_List_Type__c = wltype.id;
        wls.Scheduled_Date__c = Date.Today()+1;
        wls.Schedule_Time__c = '4:00 PM';
        wls.Number_of_vacancies_to_fill__c=3;
        wls.Bedroom_Size__c=4;
        wls.Pull_Rank__c=45673;
        wls.RAD_Current_Scheduler_Count__c = 1;
        
        insert wls;
        
        wls.Applicant_at_eli_30_75__c = 2;
        wls.Applicant_at_vli_50_25__c = 1;
        wls.Applicant_at_LI_80__c     = 0;
        update wls;
        

        wls.Status__c = 'Scheduled';
        update wls;
        System.assertEquals(en.Current_Status__c,'Onlist');
         Test.startTest();

           RAD_PubHsgSelnCnt_Batch obj = new RAD_PubHsgSelnCnt_Batch(wls.id,wls.Bedroom_Size__c);
          DataBase.executeBatch(obj); 
            
          Test.stopTest();

}
}