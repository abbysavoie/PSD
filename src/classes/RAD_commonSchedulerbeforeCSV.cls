//Purpose of this scheduler is to run RAD_SelectionRecordsCSVAttachment class.

global class RAD_commonSchedulerbeforeCSV implements Schedulable {
global String  wlsidd;   
        
    public RAD_commonSchedulerbeforeCSV (String wlsId){
    wlsidd = wlsId;
    } 

   global void execute(SchedulableContext SC) {
    RAD_SelectionRecordsCSVAttachment SR = new RAD_SelectionRecordsCSVAttachment();
            SR.csvAttachment(wlsidd); // Sending an email to Scheduler.(Email will have an attachment(.CSV format) which will have Seletion Records.)
}

}