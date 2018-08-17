@isTest
public class RAD_WeeklyUpdtScheduler_Test {
    static testMethod void testMethod1()
    {
        Test.StartTest();
        RAD_WeeklyUpdtScheduler sh1 = new RAD_WeeklyUpdtScheduler();
        String CRON_EXP = '0 0 0 3 9 ? 2022';
        system.schedule('weeklystatustest', CRON_EXP, sh1);
        Test.stopTest(); 
    }
    
    
    
}