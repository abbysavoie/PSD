global class RAD_DailyPurgeScheduler implements Schedulable{

  global void execute(SchedulableContext sc){
       RAD_DailyBatchToPurge btch = new RAD_DailyBatchToPurge();  
       ID myBatchJobID = Database.executeBatch(btch, 1) ;     
  }  
}