//Scheduler for RAD_DailyAppRecsDeleteBatch class

global class RAD_DailyAppRecsDeleteSch implements Schedulable {
    
    global void execute(SchedulableContext SC) {
        RAD_DailyAppRecsDeleteBatch appDeleteBatch = new RAD_DailyAppRecsDeleteBatch ();
        database.executebatch(appDeleteBatch);
        
    }  
}