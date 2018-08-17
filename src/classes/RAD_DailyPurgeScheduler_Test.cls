@isTest
public class RAD_DailyPurgeScheduler_Test {
 static testMethod void testMethod1()
 {
 Test.StartTest();
RAD_DailyPurgeScheduler sh1 = new RAD_DailyPurgeScheduler();
String CRON_EXP = '0 0 0 3 9 ? 2022';
 system.schedule('purge', CRON_EXP, sh1);
 Test.stopTest(); 
 }
 
   
     
 }