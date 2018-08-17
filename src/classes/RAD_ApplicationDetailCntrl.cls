public class RAD_ApplicationDetailCntrl {
    
    public datetime applied_dt{get;set;}
    public string receivedAppliedDate_str{get;set;}
    public string applied_str{get;set;}
    public Applications__c apps{get;set;}
    public Datetime local_dt{get;set;}
    
    public ApexPages.StandardController Editcontroller;
    
    public RAD_ApplicationDetailCntrl(ApexPages.StandardController controller){
        this.Editcontroller = controller;
        
        this.apps = (Applications__c)controller.getRecord();
        system.debug(apps.Applied_Date_Time__c);
        if (apps.Applied_Date_Time__c == null )
        {
            //applied_dt = datetime.now();
            
            //Integer offset = UserInfo.getTimezone().getOffset(applied_dt);
            //local_dt = applied_dt.addSeconds(offset/1000);  
        } else
        {
            applied_dt = datetime.valueof(apps.Applied_Date_Time__c);
            Integer offset = UserInfo.getTimezone().getOffset(applied_dt);
            local_dt = applied_dt.addSeconds(offset/1000);
            applied_str = applied_dt.format('MM/dd/yyyy hh:mm:ss a');
            system.debug('applied_str:' + applied_str);
        }
    }
    
    public PageReference updateAppliedDate() {
        datetime gmt_dt;
        system.debug('String Applied Date:' + Apexpages.currentPage().getParameters().get('newAppliedDate'));
        receivedAppliedDate_str = Apexpages.currentPage().getParameters().get('newAppliedDate'); 
        system.debug('receivedAppliedDate_dt:' + receivedAppliedDate_str);
        if(receivedAppliedDate_str != Null)
        {
            gmt_dt = datetime.valueof(receivedAppliedDate_str);
            applied_dt = gmt_dt;
            Integer offset = UserInfo.getTimezone().getOffset(gmt_dt);
            local_dt = gmt_dt.addSeconds(offset/1000);

        }
        Return null;
    }
    
    public PageReference Save() {
    
        PageReference cancel = Editcontroller.cancel();
        this.apps.Applied_Date_Time__c = applied_dt;
        if(applied_dt != null)
        {
            Integer offset = UserInfo.getTimezone().getOffset(applied_dt);
            Datetime dtLocal = applied_dt.addSeconds(offset/1000);
            this.apps.Applied_Date_Time_With_Seconds__c = applied_dt.format('MM/dd/yyyy hh:mm:ss a');
        }
        upsert this.apps; 
        return cancel;
        
    }
 
    
}