global class RAD_WeeklyUpdtScheduler implements Schedulable{
    
    global void execute(SchedulableContext sc){
        RAD_WeeklyModifiedStatusBatch btch = new RAD_WeeklyModifiedStatusBatch();  
        ID myBatchJobID = Database.executeBatch(btch, 1) ;     
    }  
}