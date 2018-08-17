@isTest
public class RAD_ContactTrigHlprTest{

    public static testmethod void testContact(){
        Test.startTest();
            TestSuiteHelper.setupCustomSettings();
            List<Contact> cts =TestSuiteHelper.setupPortalRequiredData();  
            Contact ct = cts[0];
            
            Contact ctt = [Select SSN_TaxID__c, Date_of_Birth__c, Gender__c, Prospect_Number_YARDI__c, Tenant_Number_YARDI__c from Contact where id=:ct.id limit 1];
            ctt.SSN_TaxID__c = '998998998';
            update ctt;       
                 
        Test.stopTest();
    }
    
    public static testmethod void testContact1(){

        Id idd = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Applicant').getRecordTypeId();
    
        Contact c = new contact(Gender__c='Male',LastName = 'sagar', Contact_Type__c = 'Community Global User', recordtypeid=idd, Active__c = 'Yes');
    
        insert c;
        c.SSN_TaxID__c='123456789';
        update c;
        
        
    }
    
}