//Purpose of this class: Once selection Run is completed, boomi will pickup all selectedRecords and pass it to Yardi, Once update in Yardi is sucesssful Tnumber will be generated. Boomi will assign Tnumber back to Salesforce. 
//This class will check for Tnumbers, if present it run RAD_commonSchedulerbeforeCSV , if not delaying RAD_commonSchedulerbeforeCSV for 30 min. 


public class RAD_checkTnumberafterSelection{

public Static void checkTnumber(String wlsidd){

   set<id> Selids = new set<id>();
   //Querying selectionRecords whose selectionID is waitlistSelctionID and status is Selected. 
   
   List<Selection_Records__c> selList = [select id,Selection_ID__c, RAD_Wait_List__r.Applications__r.Applicant__r.Tenant_Number_YARDI__c, Selection_ID__r.RAD_Current_Scheduler_Count__c, Selection_ID__r.Wait_List_Type__c,
                                         Selection_ID__r.Name,Selection_ID__r.Scheduled_Date__c from Selection_Records__c where Selection_ID__c = :wlsidd and Status__c = 'Selected' ];
   //looping through selectionrecords, checking for Tnumber, if Tnumber is present then adding it to Selids.                       
   for(Selection_Records__c sr: selList ){
                 if(sr.RAD_Wait_List__r.Applications__r.Applicant__r.Tenant_Number_YARDI__c!=null && 
                         sr.RAD_Wait_List__r.Applications__r.Applicant__r.Tenant_Number_YARDI__c!=''){
                    Selids.add(sr.id);                           
                           } 
                  /*         else
                           {
                            String cronExpr = '';
                            Datetime dt = Datetime.now();
                            // Decimal tempMin = 59;
                            Decimal tempMin = 0;
                            dt = Datetime.now();
                                tempMin = dt.minute() + 1 ;  //dont use current min, 
                                tempMin = dt.minute() + 30 ;  //dont use current min, 
                                if(dt.second()>=55 ){
                                    tempMin = dt.minute() + 2 ;
                                }
                                if(tempMin >= 59){
                                    tempMin = 0;
                                }  
                                cronExpr = '0 ' + tempMin + ' * * * ? *';
system.debug('$$$$ CronTriggerExpession, else statement' +cronExpr );                                
                                System.debug('my cron trigger will be 1 min from now '+ dt+ '::'+ cronExpr );  
                                
                                
                                
                                String cronExpr = '';
                                Decimal tempHours = 1; 
                                cronExpr = '0 ' + '0 ' + tempHours+' * * ? '; // Setting crontriggerexpression ti run @1am. 
system.debug('$$$$ cronexpression value' +cronExpr);

                                Integer randSeed = Math.round(Math.random()*100000);
                                RAD_commonSchedulerbeforeCSV cs = new RAD_commonSchedulerbeforeCSV (wlsidd);
                                String jobID = System.schedule('Common Scheduler  '+ sr.Selection_ID__r.Wait_List_Type__c + sr.Selection_ID__r.RAD_Current_Scheduler_Count__c +sr.Selection_ID__r.Name+'_'+ sr.Selection_ID__r.Scheduled_Date__c.format()+'_'+String.valueof(randSeed), cronExpr , cs);
                             Break;
                           } */

}
if(!Selids.isEmpty() && !selList.isempty())
if(Selids.size() == selList.size())
{   RAD_SelectionRecordsCSVAttachment SR = new RAD_SelectionRecordsCSVAttachment();
    SR.csvAttachment(wlsidd); // Sending an email to Scheduler.(Email will have an attachment(.CSV format) which will have Seletion Records.)
    system.debug('$$$$ csvattachmentfired');
}
}
}