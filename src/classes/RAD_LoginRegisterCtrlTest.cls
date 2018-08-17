@isTest(seeAllData=true)
public class RAD_LoginRegisterCtrlTest
{    
    static testMethod void RAD_LoginRegisterCtrlMethod1() 
    {
        
        PageReference pageRef = Page.RADNewLogReg;
        Test.setCurrentPage(pageRef);
        
        Test.StartTest();
        RAD_LoginRegisterCtrl controller = new RAD_LoginRegisterCtrl();
        controller.forwardToCustomAuthPage();
        controller.getCSSURL();
        controller.getJSURL();
        controller.login();
        String empty = '';
        RAD_LoginRegisterCtrl.userPreCreationValidations(empty, empty,empty);
        RAD_LoginRegisterCtrl.userPreCreationValidations('noentry','noeml@abchhh.com','1231231231');
        controller.ResetPassword();
        Test.StopTest();
        
        
    }
    
   /* static testMethod void testRemoteMethods() {
        //TestSuiteHelper.setupCustomSettings();
        //List<Contact> cts =TestSuiteHelper.setupPortalRequiredData();  
        //Contact ct = cts[0];
        Id idd = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Applicant').getRecordTypeId();
        Contact con=new  Contact();
        con.FirstName='test';
        con.LastName='testNED';
        con.Contact_Type__c  = 'Community Global User';
        con.RecordTypeId = idd;
        con.Active__c='Yes';
        insert con;  
        Applications__c app = [Select id, Application_Status__c from Applications__c where Applicant__c =:con.id limit 1];
        
        RAD_LoginRegisterCtrl.validateUserName('noname@nozone.com');
        
        RAD_LoginRegisterCtrl.validateUserName( 'SDeli0neT11@testpqr.com'); 
        
    }
    
    static testMethod void testLogin() 
    {
        Test.StartTest();
        RAD_LoginRegisterCtrl controller = new RAD_LoginRegisterCtrl();
        controller.Username = 'noemailformat.com';
        controller.login();
        System.assertEquals(controller.Username, 'noemailformat.com'); 
        
    }
    
    static testMethod void RAD_LoginRegisterCtrlMethod2() 
    {
        
        PageReference pageRef = Page.RADNewLogReg;
        Test.setCurrentPage(pageRef);
        
        Test.StartTest();
        RADGenericController controller1 = new RADGenericController();
        RAD_LoginRegisterCtrl controller = new RAD_LoginRegisterCtrl(controller1);
        controller.cancel();
        controller.FirstNameRegister ='fname';
        controller.LastNameRegister = 'dfgh';
        controller.SSN_DoNotHave_check = true;
        //controller.save();
        Test.StopTest();    
        
    }
    
    /*
static testMethod void testuserLogin() 
{
List<Contact> cts =TestSuiteHelper.setupPortalRequiredData();  
Contact ct = cts[0];
Applications__c app = [Select id, Application_Status__c from Applications__c where Applicant__c =:ct.id limit 1];
User usr = [Select contactid, username,profileid from User where contactid=: ct.id];
System.runAs(usr){
PageReference pageRef = Page.RADNewLogReg;
Test.setCurrentPage(pageRef);

Test.StartTest();
RADGenericController controller1 = new RADGenericController();
RAD_LoginRegisterCtrl controller = new RAD_LoginRegisterCtrl(controller1);
//controller.FirstNameRegister = 'Hello';
//controller.LastNameRegister = 'byee';
controller.save();
Test.StopTest();    
}
} 
*/
    
   /* static testMethod void testvalidateSSN() 
    {
        //List<Contact> cts =TestSuiteHelper.setupPortalRequiredData();  
        //Contact ct = cts[0];
        Id idd = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Applicant').getRecordTypeId();
        Contact con=new  Contact();
        con.FirstName='test';
        con.LastName='testNED';
        con.Contact_Type__c  = 'Community Global User';
        con.RecordTypeId = idd;
        con.Active__c='Yes';
        insert con;  
        Applications__c app = [Select id, Application_Status__c from Applications__c where Applicant__c =:con.id limit 1];
        User usr = [Select contactid from User where contactid=: con.id];
        System.runAs(usr){
            PageReference pageRef = Page.RADNewLogReg;
            Test.setCurrentPage(pageRef);
            
            Test.StartTest();
            
            RAD_LoginRegisterCtrl.validateSSN('990');
            RAD_LoginRegisterCtrl.validateSSN('');
            
            Test.StopTest();    
        }
    } */
    
   /* static testMethod void testUsernameQ() 
    {
        //List<Contact> cts =TestSuiteHelper.setupPortalRequiredData();
        
        Id idd = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Applicant').getRecordTypeId();
        Contact con=new  Contact();
        con.FirstName='test';
        con.LastName='testNED';
        con.Contact_Type__c  = 'Community Global User';
        con.RecordTypeId = idd;
        con.Active__c='Yes';
        insert con;  
        //Contact ct = cts[0];
        Applications__c app = [Select id, Application_Status__c from Applications__c where Applicant__c =:con.id limit 1];
        User usr = [Select contactid, username from User where contactid=: con.id limit 1];
        String uname = usr.username;
        System.runAs(usr){
            PageReference pageRef = Page.RADNewLogReg;
            Test.setCurrentPage(pageRef);
            
            Test.StartTest();
            
            RAD_LoginRegisterCtrl.getAllQuestionandAnswers(uname);
            RAD_LoginRegisterCtrl.validateUserName(uname);
            RAD_LoginRegisterCtrl.validateSSN('');
            
            
            Test.StopTest();    
        }
    } */
    static testMethod void testprevalidations() 
    {
        Contact con=new  Contact();
        Account acc = TestSuiteHelper.setupTestAccount();
        Id idd1 = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Applicant').getRecordTypeId();
        con.AccountId = acc.id;
        con.FirstName='test';
        con.LastName='testLast';
        con.Contact_Type__c='Community Global User';
        con.Email='testclass@cgi.com';
        con.Phone = '9899899898';
        con.Do_not_Have__c = false;
        con.RecordTypeId = idd1;
        con.Active__c = 'Yes';
        insert con;
        
        
        Test.StartTest();
        RAD_LoginRegisterCtrl rl=new RAD_LoginRegisterCtrl();
        RAD_LoginRegisterCtrl.userPreCreationValidations('test','testclass@cgi.com',null);
        RAD_LoginRegisterCtrl.userPreCreationValidations('test',null,'9899899898');
        
        con=new  Contact();
        con.AccountId = acc.id;
        con.FirstName='test';
        con.LastName='testLast11';
        con.Contact_Type__c='Community Global User';
        con.Email='testclass@cgi.com';
        con.Phone = '9899899898';
        con.Do_not_Have__c = false;
        con.RecordTypeId = idd1;
        con.Active__c = 'Yes';
        insert con;
        RAD_LoginRegisterCtrl.userPreCreationValidations('test','testclass@cgi.com','9899899898');
        Test.StopTest();    
    }
    
    static testMethod void testgetbirthYearLst()
    {
        Contact con=new  Contact();
        Account acc = TestSuiteHelper.setupTestAccount();
        Id idd1 = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Applicant').getRecordTypeId();
        con.AccountId = acc.id;
        con.FirstName='test';
        con.LastName='testLast';
        con.Contact_Type__c='Community Global User';
        con.Email='test@cgi.com';
        con.RecordTypeId = idd1;
        con.Active__c = 'Yes';
        insert con;
        
        
        List<SelectOption> lisyear=new List<SelectOption>();
        Test.StartTest();
        RAD_LoginRegisterCtrl rl=new RAD_LoginRegisterCtrl();
        lisyear=rl.getbirthYearLst();
        
        Test.StopTest();    
    }
    
   /* static testMethod void testupdateUserContact()
{



 Id RecTypeaccount=Schema.SObjectType.account.getRecordTypeInfosByName().get('RAD Community Account').getRecordTypeId();
        
       Account A1 = new Account(Name = 'Test Account', First_Name__c='test',Last_Name__c='test',RecordTypeId=RecTypeaccount
 );
 
 Id idd = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Applicant').getRecordTypeId();
Contact c = new Contact(LastName = 'Contact Last Name', AccountId = A1.id,Active__c='Yes',RecordTypeId = idd, Contact_Type__c='Community Global User');
insert c; 


UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];

User user = new User();
user.ProfileID = [Select Id From Profile Where Name='RAD_Community_Profile'].id;
user.EmailEncodingKey = 'ISO-8859-1';
user.LanguageLocaleKey = 'en_US';
user.TimeZoneSidKey = 'America/New_York';
user.LocaleSidKey = 'en_US';
user.FirstName = 'first';
user.LastName = 'last';
user.Username = 'test@appirio.com';   
user.CommunityNickname = 'testUser123';
user.Alias = 't1';
user.Email = 'no@email.com';
user.IsActive = true;
user.ContactId = c.Id;
user.UserRoleId=portalRole.Id;


insert user;
System.runAs(user)
{
Test.StartTest();
RAD_LoginRegisterCtrl rl=new RAD_LoginRegisterCtrl();
RAD_LoginRegisterCtrl.updateUserContact(user.id,'test','test','test','test');
Test.StopTest();    

}
} */



    /*static testMethod void testPasswordChange()
    {
        PageReference pageRef = Page.RADNewLogReg;
        Test.setCurrentPage(pageRef);
        
        Test.StartTest();
        RADGenericController controller1 = new RADGenericController();
        RAD_LoginRegisterCtrl rl= new RAD_LoginRegisterCtrl(controller1);
        rl.UsernameRegister='mytestclass@testclass.com'; 
        rl.FirstNameRegister='Ftest';
        rl.LastNameRegister='Ltest';
        rl.PhoneRegister='test';
        
        rl.NewPswdRegister='abcde12345'; 
        rl.NewRetypePswdRegister='abcde12345'; 
        
        rl.SSNRegister = '';
        rl.GenderRegister='Female';
        rl.AgeRegister='31';
        rl.Newscques1Register='test1'; 
        rl.Newscans1Register ='ans1';
        rl.Newscques2Register='test2';
        rl.Newscans2Register='ans2'; 
        rl.Newscques3Register='test3';
        rl.Newscans3Register='ans3';
        
        rl.NewStreetRegister='test'; 
        rl.NewCityRegister='test'; 
        rl.NewStateRegister='test'; 
        rl.NewZipcodeRegister='12345'; 

        rl.NewAltStreetRegister='test'; 
        rl.NewAltCityRegister='test';
        rl.NewAltStateRegister='test'; 
        rl.NewAltZipcodeRegister='12345'; 

        rl.MonthRegister='01/03/1980';

        rl.homeless_check=false;
        rl.SSN_DoNotHave_check= true;        
        rl.paperless_check=false;
        
        rl.cnfgForgotNote='test';
        
        rl.save();
    Test.StopTest();  
        
    
    
    } */
    
    static testMethod void testAllchange()
    {
        Contact con=new  Contact();
        Account acc = TestSuiteHelper.setupTestAccount();
        Id idd1 = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Applicant').getRecordTypeId();
        con.AccountId = acc.id;
        con.FirstName='test';
        con.LastName='testLast';
        con.Contact_Type__c='Community Global User';
        con.Email='test@cgi.com';
        con.RecordTypeId = idd1;
        con.Active__c = 'Yes';
        insert con;
        
        Test.StartTest();
        RAD_LoginRegisterCtrl rl=new RAD_LoginRegisterCtrl();
        rl.passwordchange();
        rl.getSSNsearch() ;
        rl.getForgotUserName(); 
        rl.ResetPassword();
        rl.cnfgForgotNote='test';
        rl.bYear='test';
        rl.dateYear='test';
        rl.UsernameRegister='test'; 
        rl.UNameRegister='test';   
        rl.ApplicantNameRegister='test';
        rl.FirstNameRegister='test';
        rl.LastNameRegister='tets';
        rl.SSNRegister='test';
        rl.PhoneRegister='test';
        rl.EmailRegister='test';
        rl.GenderRegister='test';
        rl.MonthRegister='test';
        rl.AgeRegister='test';
        rl.NewStreetRegister='test'; 
        rl.NewCityRegister='test'; 
        rl.NewStateRegister='test'; 
        rl.NewZipcodeRegister='test'; 
        rl.NewAltStreetRegister='test'; 
        rl.NewAltCityRegister='test';
        rl.NewAltStateRegister='test'; 
        rl.NewAltZipcodeRegister='test'; 
        rl.NewPswdRegister='test'; 
        rl.NewRetypePswdRegister='test'; 
        rl.Newscques1Register='test'; 
        rl.Newscans1Register ='test';
        rl.Newscques2Register='test';
        rl.Newscans2Register='test'; 
        rl.Newscques3Register='test';
        rl.Newscans3Register='test';
        rl.usernameResetPassId='test';
        rl.securityResetPswd='test';
        rl.homeless_check=false;
        rl.paperless_check=false;
        rl.usrnmResetPswd='test';
        
        
        Test.StopTest();    
    }
    
  
    
    
}