public class RAD_Purge {

public String Error = '';

public RAD_Purge(){
}

public void callBatch()
{

try{

 RAD_DailyBatchToPurge b = new RAD_DailyBatchToPurge();
 Database.executeBatch(b,1);
 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Purge Batch Executed Sucessfully'));
 }
catch (Exception e){

 String errorMsg = 'Error : ' + e.getMessage() ;
                    Error = errorMsg;
                    
 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Error occurred, Please contact your Administrator'));
 }
 
}

}