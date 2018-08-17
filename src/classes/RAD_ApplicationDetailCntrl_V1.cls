public class RAD_ApplicationDetailCntrl_V1 {
    
    public datetime applied_dt{get;set;}
    public string receivedAppliedDate_str{get;set;}
    public string applied_str{get;set;}
    public Applications__c apps{get;set;}
    public Datetime local_dt{get;set;}
    
    public ApexPages.StandardController Editcontroller;
    
    public RAD_ApplicationDetailCntrl_V1(ApexPages.StandardController controller){
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
        local_dt=null;
        system.debug('String Applied Date:' + Apexpages.currentPage().getParameters().get('newAppliedDate'));
        receivedAppliedDate_str = Apexpages.currentPage().getParameters().get('newAppliedDate'); 
        system.debug('receivedAppliedDate_dt:' + receivedAppliedDate_str);
        if(receivedAppliedDate_str != Null)
        {
            receivedAppliedDate_str = receivedAppliedDate_str.replaceAll('/','-');
            //receivedAppliedDate_str = receivedAppliedDate_str.replaceAll('AM', ' ');
            //receivedAppliedDate_str = receivedAppliedDate_str.replaceAll('PM', ' ');
            system.debug(receivedAppliedDate_str);
           // gmt_dt = datetime.valueof(receivedAppliedDate_str);
            //applied_dt = gmt_dt;
            //system.debug(applied_dt);
            //Integer offset = UserInfo.getTimezone().getOffset(gmt_dt);
            //local_dt = gmt_dt.addSeconds(offset/1000);
            
            /*String myDate = receivedAppliedDate_str;
            string sTimeZone ;
            if(receivedAppliedDate_str.Contains('AM')){
                sTimeZone = 'AM';
            }
            else {
                sTimeZone = 'PM';
            }  
            String stringDate = myDate.substring(6,10) + '-' + 
                                myDate.substring(3,5) + '-' +
                                myDate.substring(0,2) + ' ' +
                                myDate.substring(11,19)+ ' ' +sTimeZone;*/
                              

            local_dt = getMyDateTime(receivedAppliedDate_str);
            applied_dt =  getMyDateTime(receivedAppliedDate_str);
            system.debug(local_dt);

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

    public static DateTime getMyDateTime(string strdt){  

        String[] DTSplitted = strDT.split(' ');
        string sAMPM;
        string year = DTSplitted.get(0).split('-').get(2);
        string month = DTSplitted.get(0).split('-').get(0);
        string day = DTSplitted.get(0).split('-').get(1);
        string hour = DTSplitted.get(1).split(':').get(0);
        string minute = DTSplitted.get(1).split(':').get(1);
        string second = DTSplitted.get(1).split(':').get(2);
        system.debug(year);
        system.debug(month);
        system.debug(day);
        system.debug(hour);
        system.debug(minute);
        system.debug(second);
        if (strdt.contains('AM')){
            sAMPM = 'AM';
        }
        else {
             if(hour == '01')
                hour='13';
            if(hour == '02')
                hour='14';
            if(hour == '03')
                hour='15';
            if(hour == '04')
                hour='16';
            if(hour == '05')
                hour='17';
            if(hour == '06')
                hour='18';
            if(hour == '07')
                hour='19';
            if(hour == '08')
                hour='20';
            if(hour == '09')
                hour='21';
            if(hour == '10')
                hour='22';
            if(hour == '11')
                hour='22';                                            
            sAMPM = 'PM';
        }
        system.debug('hour===='+hour);
        string stringDate = year + '-' + month + '-' + day + ' ' + hour + ':' + minute +  ':' + second+' '+sAMPM;
        system.debug(stringDate);
        return datetime.valueOf(stringDate);
    
    }
    
    
}