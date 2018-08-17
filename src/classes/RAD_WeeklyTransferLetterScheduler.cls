global class RAD_WeeklyTransferLetterScheduler implements Schedulable {
     global void execute(SchedulableContext sc){
        RAD_WeeklyModifiedTransferBatch btch = new RAD_WeeklyModifiedTransferBatch();  
        ID myBatchJobID = Database.executeBatch(btch, 1) ;     
    }  

}