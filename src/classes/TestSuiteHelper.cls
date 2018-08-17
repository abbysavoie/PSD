public class TestSuiteHelper {
    public static RAD_Configuration__c confg;
    public static Contact[] testContacts;
    public static Account[] testAccounts;
    public static Account testAccount;
    public static Applications__c[] testApplns;
//    public static customsetting cSetting;
    public static Wait_List_Type__c[] wlts;
    public static Wait_List_Income_Limit__c[]  wlIncLmts;
    public static Wait_List_Income_Limit_Details__c[] wlIncLmtDtl ;


    public static Account setupTestAccount(){
        testAccounts = [Select id, name From Account  Where name = 'RAD Community Account' ];
        if( testAccounts.isEmpty() ){
            Id idd = Schema.SObjectType.Account.getRecordTypeInfosByName().get('RAD Community Account').getRecordTypeId();
            testAccount = new Account(Name = 'RAD Community Account', First_Name__c = 'TestName',Last_Name__c ='LastName', RecordTypeId = idd );
            insert testAccount;
        }else{
            testAccount =testAccounts[0];
        }
        
        return testAccount;
    }
    
    public static void setupCustomSettings(){
        
        
        try{
            confg = [Select Update_Duration_Months__c, RAD_Purge_Extension_Months__c, RAD_Portal_Forgot_Password_Note__c, 
                RAD_Portal_Forgot_UserName_Note__c, RAD_Portal_Contact_Address__c, Announcement__c
                from RAD_Configuration__c where name = 'Main Configurations'];
        }catch(Exception e){
            confg = new RAD_Configuration__c(Name = 'Main Configurations', Update_Duration_Months__c = 6, RAD_Purge_Extension_Months__c =1,
                RAD_Portal_Forgot_Password_Note__c ='This is Forgotten Password Note', RAD_Portal_Forgot_UserName_Note__c ='This is Forgotten Username Note',
                RAD_Portal_Contact_Address__c = 'This is Portal Contact Address', Announcement__c = 'This is Announcement');

            insert confg; 
        }
        
        ZipLocation__c zLocSetting = null;
        if(ZipLocation__c.getInstance('San Diego')==null)
        {
          zLocSetting = new ZipLocation__c(Name='San Diego',ZipRanges__c='92101,92102,92103,92104');
          insert zLocSetting ;
        }
            
        wlts =  new Wait_List_Type__c[]{
        new Wait_List_Type__c( Name = 'Section 8', Lease_Up__c = '50', RADDisabled_Family__c = 1, RADFamily__c = 2, RADHomeless_with_disability__c = 3,
        RADNon_Elderly_Disabled__c = 4, RADLive_Work_in_City_of_San_Diego__c = 5, RADVeteran_Active_Military__c = 6, YARDI_HMY__c = 5),
        new Wait_List_Type__c( Name = 'Project Based', Lease_Up__c = '50', RADDisabled_Family__c = 10, RADFamily__c = 11, RADHomeless_with_disability__c = 13,
        RADNon_Elderly_Disabled__c = 14, RADLive_Work_in_City_of_San_Diego__c = 15, RADVeteran_Active_Military__c = 16, YARDI_HMY__c = 3),
        new Wait_List_Type__c( Name = 'Project Based Single', Lease_Up__c = '50', RADDisabled_Family__c = 20, RADFamily__c = 21, RADHomeless_with_disability__c = 23,
        RADNon_Elderly_Disabled__c = 24, RADLive_Work_in_City_of_San_Diego__c = 25, RADVeteran_Active_Military__c = 26, YARDI_HMY__c = 4),
        new Wait_List_Type__c( Name = 'Mod Rehab', Lease_Up__c = '50', RADDisabled_Family__c = 30, RADFamily__c = 31, RADHomeless_with_disability__c = 33,
        RADNon_Elderly_Disabled__c = 34, RADLive_Work_in_City_of_San_Diego__c = 35, RADVeteran_Active_Military__c = 36, YARDI_HMY__c = 1),
        new Wait_List_Type__c( Name = 'Public Housing', Lease_Up__c = '50', RADDisabled_Family__c = 30, RADFamily__c = 31, RADHomeless_with_disability__c = 33,
        RADNon_Elderly_Disabled__c = 34, RADLive_Work_in_City_of_San_Diego__c = 35, RADVeteran_Active_Military__c = 36, YARDI_HMY__c = 2),
        new Wait_List_Type__c( Name = 'NED', Lease_Up__c = '50', RADDisabled_Family__c = 30, RADFamily__c = 31, RADHomeless_with_disability__c = 33,
        RADNon_Elderly_Disabled__c = 34, RADLive_Work_in_City_of_San_Diego__c = 35, RADVeteran_Active_Military__c = 36, YARDI_HMY__c = 13456)
        };
        insert wlts;
        
        wlIncLmts = new Wait_List_Income_Limit__c[]{
            new Wait_List_Income_Limit__c(Name = '1',Code__c = 'eli-30', Percent_Income_Limit__c = 30),
            new Wait_List_Income_Limit__c(Name = '2',Code__c = 'vli-50', Percent_Income_Limit__c = 50),
            new Wait_List_Income_Limit__c(Name = '3',Code__c = 'li-80', Percent_Income_Limit__c = 80)
        };               
        insert wlIncLmts; 
        
        wlIncLmtDtl = new Wait_List_Income_Limit_Details__c[]{
            new Wait_List_Income_Limit_Details__c(Name = '1', Limit_Effective_Date__c = Date.Today()-5, Limit_Expiration_Date__c = Date.Today()+5,
                         Income_Limit__c = wlIncLmts[0].id, Limit_1__c = '10000', Limit_2__c = '20000', Limit_3__c = '23000',Limit_4__c = '25000' ),
            new Wait_List_Income_Limit_Details__c(Name = '2', Limit_Effective_Date__c = Date.Today()-5, Limit_Expiration_Date__c = Date.Today()+5,
                         Income_Limit__c = wlIncLmts[1].id, Limit_1__c = '31850', Limit_2__c = '36400', Limit_3__c = '40950',Limit_4__c = '45450' ),
            new Wait_List_Income_Limit_Details__c(Name = '3', Limit_Effective_Date__c = Date.Today()-5, Limit_Expiration_Date__c = Date.Today()+5,
                         Income_Limit__c = wlIncLmts[2].id, Limit_1__c = '50950', Limit_2__c = '58200', Limit_3__c = '65500',Limit_4__c = '72750' )                                                
        };
        
        insert wlIncLmtDtl ;
        
        //add inc limit
    
    }
    

    public static List<Contact> setupPortalRequiredData() {  
       // TestSuiteHelper.setupCustomSettings();
        TestSuiteHelper.setupTestAccount();
        testApplns = new List<Applications__c>();
        testContacts = new List<Contact>();
        
        
        
        testContacts.addAll(createPortalSDContacts(4, 'SDeli0ne', 'T1', true));
        testApplns.addAll(createAppln(4,'SDeli0ne' ,10000, 1 ) );
        
        testContacts.addAll(createPortalSDContacts(1, 'SDelithree', 'T2', true));
        testApplns.addAll(createAppln(1,'SDelithree' ,10000, 3 ) );
        
        testContacts.addAll(createPortalSDContacts(3, 'SDVlione', 'T3', true));
        testApplns.addAll(createAppln(3,'SDVlione' ,30000, 1 ) );

        testContacts.addAll(createPortalSDContacts(2, 'SDLione', 'T4', true));
        testApplns.addAll(createAppln(2,'SDLione' ,40000, 1 ) );
        
        
        
  /*
        testContacts.addAll(createNonSDContacts(10, 'NSDWithEmail', 'T2', true));
        testApplns.addAll(createAppln(4,'NSDWithEmail' ,10000, 1 ) );
        testApplns.addAll(createAppln(1,'NSDWithEmail' ,10000, 3 ) );        
        testApplns.addAll(createAppln(3,'NSDWithEmail' ,30000, 1 ) );
        testApplns.addAll(createAppln(2,'NSDWithEmail' ,40000, 1 ) );
        
        */
        //Database.insert(testContacts, false);
        //Database.insert(testApplns, false);//only insert applns
        
        //insert testContacts;
        try{
            insert testApplns;
            }catch(Exception ee){
                System.debug('founnd exception '+ee.getMessage());
            }
        
        
        return testContacts;
        
    }
    
    public static List<Contact> createSDContacts(Integer cnt, String lName, String uniqIdx, Boolean withEmail) {  
        Id idd = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Applicant').getRecordTypeId();
        List<Contact> ctLst = new List<Contact>();
        Contact ct = new Contact();
        for(Integer i=1;i<=cnt;i++){
            ct = new Contact();
            ct.FirstName = 'SD'+i;
            ct.LastName = lName;
            if(withEmail ==  true){
                ct.email = lName + uniqIdx + i+'@testpqr.com';
            }
            ct.accountId = testAccount.id;
            ct.Contact_Type__c  = 'Community Global User';
            ct.Do_not_Have__c  = true;
            ct.Date_of_Birth__c  = Date.Today().addMonths(-400);
            ct.Gender__c = 'Female';
            
            ct.Residential_Street__c= i + 'Residency Street'; 
            ct.Residential_City__c = 'San Diego';
            ct.Residential_State__c = 'CA';
            ct.Residential_Zipcode__c ='92101';
            
            ct.MailingStreet = i + 'EastMail Street'; 
            ct.MailingCity = 'San Diego';
            ct.MailingState = 'CA';
            ct.MailingPostalCode ='92101';
            
            ct.Active__c = 'Yes';
            ct.RecordTypeId = idd;
                        
            ctLst.add(ct);
        }
        return ctLst;        
    }
    
  
    public static List<Contact> createPortalSDContacts(Integer cnt, String lName, String uniqIdx, Boolean withEmail) {  
        Id idd = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Applicant').getRecordTypeId();
        List<Contact> ctLst = new List<Contact>();
        Contact ct = new Contact();
        for(Integer i=1;i<=cnt;i++){
            ct = new Contact();
            ct.FirstName = 'SD'+i;
            ct.LastName = lName;
            ct.email = lName + uniqIdx + i+'@testpqr.com';
            ct.accountId = testAccount.id;
            ct.Contact_Type__c  = 'Community Global User';
            ct.Do_not_Have__c  = true;
            ct.Date_of_Birth__c  = Date.Today().addMonths(-400);
            ct.Gender__c = 'Female';
            
            ct.Residential_Street__c= i + 'Residency Street'; 
            ct.Residential_City__c = 'San Diego';
            ct.Residential_State__c = 'CA';
            ct.Residential_Zipcode__c ='92101';
            
            ct.MailingStreet = i + 'EastMail Street'; 
            ct.MailingCity = 'San Diego';
            ct.MailingState = 'CA';
            ct.MailingPostalCode ='92101';
            
            ct.Active__c = 'Yes';
            ct.RecordTypeId = idd;
            
            ctLst.add(ct);
        }
        
        Database.insert(ctLst, false);
        
        if(withEmail ==  false ){
            for(Contact ctt : ctLst){
                ctt.Email = '';
            }
            
            Database.update(ctLst, false);//chkk
        
        }
        
        Profile p = [select id from profile where name='RAD_Community_Profile']; 
        List<User> lstUser = new List<User>();
        User u = new User();

      
        Integer i =1;
        for(Contact ctt : ctLst){
            u = new User();
            u.FirstName = 'SD'+i;
            u.LastName = lName;
            u.username = ctt.Email;
            u.ProfileId  = p.id;
            u.CommunityNickname = 'tcwo' + String.ValueOf(cnt);
            U.alias = 'r'+String.ValueOf(cnt);
            u.Email = ctt.Email;
            u.TIMEZONESIDKEY = 'America/Los_Angeles';
            u.contactId = ctt.id;
            u.emailencodingkey='UTF-8';
            u.languagelocalekey='en_US';
            
            u.localesidkey='en_US';
            
            i++;
            lstUser.add(u);
        }
        
        
        
        Database.insert(lstUser, false);
        
        return ctLst;
        
    }
    
    
    public static List<Contact> createNonSDContacts(Integer cnt, String lName, String uniqIdx, Boolean withEmail) {  

        Id idd = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Applicant').getRecordTypeId();
        List<Contact> ctLst = new List<Contact>();
        Contact ct = new Contact();
        for(Integer i=1;i<=cnt;i++){
            ct = new Contact();
            ct.FirstName = 'NSD'+i;
            ct.LastName = lName;
            ct.email = lName + uniqIdx + i+'@testpqr.com';
            ct.accountId = testAccount.id;
            ct.Contact_Type__c  = 'Community Global User';
            ct.Do_not_Have__c  = true;
            ct.Date_of_Birth__c  = Date.Today().addMonths(-400);
            ct.Gender__c = 'Female';
            
            ct.Residential_Street__c= i + 'Residency Street'; 
            ct.Residential_City__c = 'San Diego';
            ct.Residential_State__c = 'CA';
            ct.Residential_Zipcode__c ='71117';
            
            ct.MailingStreet = i + 'EastMail Street'; 
            ct.MailingCity = 'San Diego';
            ct.MailingState = 'CA';
            ct.MailingPostalCode ='71119';
            
            ct.Active__c = 'Yes';
            ct.RecordTypeId = idd;
            
            ctLst.add(ct);
        }
        
        Database.insert(ctLst, false);
        
        
        if(withEmail ==  false ){
            for(Contact ctt : ctLst){
                ctt.Email = '';
            }
            
            Database.update(ctLst, false);//chkk
        
        }
        
        Profile p = [select id from profile where name='RAD_Community_Profile']; 
        List<User> lstUser = new List<User>();
        User u = new User();


        Integer i =1;
        for(Contact ctt : ctLst){
            u = new User();
            u.FirstName = 'NonSandiego'+i;
            u.LastName = lName;
            u.username = ctt.Email;
            u.ProfileId  = p.id;
            u.CommunityNickname = 'tcwo' + String.ValueOf(cnt);
            U.alias = 'r'+String.ValueOf(cnt);
            u.Email = ctt.Email;
            u.TIMEZONESIDKEY = 'America/Los_Angeles';
            u.contactId = ctt.id;
            u.emailencodingkey='UTF-8';
            u.languagelocalekey='en_US';
            
            u.localesidkey='en_US';

            i++;
            lstUser.add(u);
        }
        
        
        
        Database.insert(lstUser, false);
        
        return ctLst;
        
    }
    
    public static List<Applications__c> createAppln(Integer cnt, String lname,Decimal annInc, Integer chldcnt ){
        List<Applications__c> appLst = new List<Applications__c>();
        Applications__c app = new Applications__c();
        
        List<Contact>ctLst = [Select  Id from Contact where lastname =: lname order by name asc ]; 
        for(Contact ct : ctLst){
            app = new Applications__c();
            app.Applicant__c = ct.id;
            app.Ethnicity__c = 'Hispanic or Latino';
            app.Section_8__c =true;
            app.PBVS_Project_Based_Single__c = true;
            app.PBV_Project_Based__c =true;
            app.Public_Housing__c = true;
            app.Application_Status__c = 'Submitted';
            app.Family_Annual_Income__c = annInc;
            app.White__c =  true;
            app.Black__c = true;
            app.Citizenship__c = 'Eligible Citizen';
            app.of_people_in_the_H_H_Adults__c = 1;
            app.Dependents_Children_under_age_of_18__c = chldcnt;
            app.Family__c = true;
            appLst.add(app);
        
        }

        return appLst;
    }
    


}