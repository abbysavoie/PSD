@isTest
public class TestSuiteHelper_Test{
    static testmethod void testTestSuiteHelper1() {
        Test.startTest();
        TestSuiteHelper.setupTestAccount();
        TestSuiteHelper.setupCustomSettings();
        TestSuiteHelper.setupPortalRequiredData();

        Test.stopTest();
    }
    static testmethod void testTestSuiteHelper2() {
        Test.startTest();
        TestSuiteHelper.setupTestAccount();
        TestSuiteHelper.setupCustomSettings();

        TestSuiteHelper.createNonSDContacts(1, 'nsd', 'uuu', true );

        TestSuiteHelper.createSDContacts(1,'sdiego', 'qq', true);
    
    Test.stopTest();
  }
    
}