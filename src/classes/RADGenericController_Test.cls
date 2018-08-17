@isTest
public class RADGenericController_Test
{
    public static testMethod void testGeneric()
    {
        PageReference pageRef = Page.RADNewLogReg;
        Test.setCurrentPage(pageRef);
        
        Test.StartTest();
            RADGenericController controller = new RADGenericController();
            controller.cancel();
            controller.login();
            controller.RegisterUser();
            controller.getCSSURL();
            controller.getJSURL();
        Test.StopTest();    
        
    }
    
}