/**
 * An apex page controller that exposes the change password functionality
 */
@IsTest public with sharing class ChangePwdCntrl_Test{
     @IsTest(SeeAllData=true) public static void testChangePwdCntrl() {
        // Instantiate a new controller with all parameters in the page
        ChangePwdCntrl controller = new ChangePwdCntrl();
        controller.oldPassword = '123456';
        controller.newPassword = 'qwerty1'; 
        controller.verifyNewPassword = 'qwerty1'; 
        controller.inpUsrName='myname@myname.com';
         
         ApexPages.currentPage().getParameters().put('retURL','a?usn=1');
         controller.init();
        
        System.assertEquals(controller.changePassword(),null);                           
    }    
}