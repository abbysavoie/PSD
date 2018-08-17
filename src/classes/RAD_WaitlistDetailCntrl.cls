public class RAD_WaitlistDetailCntrl {
    
    public datetime currents_dt{get;set;}
    public string receivedCurrentsDate_str{get;set;}
    public string Currents_str{get;set;}
    public Applications__c apps{get;set;}
    public Datetime localCurrents_dt{get;set;}

    public datetime original_dt{get;set;}
    public string receivedOriginalDate_str{get;set;}
    public string original_str{get;set;}
    public Enrolled_Wait_List__c wl_rec{get;set;}
    public Datetime localOriginal_dt{get;set;}
    
    public ApexPages.StandardController Editcontroller;
    
    public RAD_WaitlistDetailCntrl(ApexPages.StandardController controller){
        this.Editcontroller = controller;
        
        this.wl_rec = (Enrolled_Wait_List__c)controller.getRecord();
        
        system.debug(wl_rec.SFDC_Original_Datetime__c);
        original_dt = datetime.valueof(wl_rec.SFDC_Original_Datetime__c);
        if (original_dt !=Null)
        {
            Integer offset = UserInfo.getTimezone().getOffset(original_dt);
            localOriginal_dt = original_dt.addSeconds(offset/1000);
            system.debug('localOriginal_dt:' + localOriginal_dt);
            system.debug('original_dt :' + original_dt );
        }
        if(original_dt != Null)
        {
            original_str = original_dt.format('MM/dd/yyyy hh:mm:ss a'); 
        }
        system.debug('original_str:' + original_str);
        
        system.debug(wl_rec.Current_Status_Date_Time__c);
        currents_dt = datetime.valueof(wl_rec.Current_Status_Date_Time__c);
        if (currents_dt !=Null)
        {
            Integer offset = UserInfo.getTimezone().getOffset(currents_dt);
            localCurrents_dt = currents_dt.addSeconds(offset/1000);
            system.debug('localCurrents_dt:' + localCurrents_dt);
            system.debug('urrents_dt :' + currents_dt );
        }
        if(currents_dt != Null)
        {
            currents_str = currents_dt.format('MM/dd/yyyy hh:mm:ss a'); 
        }
        system.debug('currents_str:' + currents_str);        
    }
    
    public PageReference updateOriginalDate() {
        datetime gmt_dt;
        localOriginal_dt=null;       
        system.debug('String Original Date:' + Apexpages.currentPage().getParameters().get('newOriginalDate'));
        receivedOriginalDate_str = Apexpages.currentPage().getParameters().get('newOriginalDate'); 
        system.debug('receivedOriginalDate_dt:' + receivedOriginalDate_str);
        receivedOriginalDate_str = receivedOriginalDate_str.replaceAll('/','-');
        if(receivedOriginalDate_str != Null)
        {
            //gmt_dt = datetime.valueof(receivedOriginalDate_str);
            localOriginal_dt = getMyDateTime(receivedOriginalDate_str);
            original_dt = getMyDateTime(receivedOriginalDate_str);
            //Integer offset = UserInfo.getTimezone().getOffset(gmt_dt);
            //localOriginal_dt = gmt_dt.addSeconds(offset/1000);

        }
        Return null;
    }

    public PageReference updateCurrentsDate() {
        datetime gmt_dt;
        system.debug('String Currents Date:' + Apexpages.currentPage().getParameters().get('newCurrentsDate'));
        receivedCurrentsDate_str = Apexpages.currentPage().getParameters().get('newCurrentsDate'); 
        system.debug('receivedCurrentsDate_dt:' + receivedCurrentsDate_str);
        receivedCurrentsDate_str = receivedCurrentsDate_str.replaceAll('/','-');
        if(receivedCurrentsDate_str != Null)
        {
            //gmt_dt = datetime.valueof(receivedCurrentsDate_str);
            //currents_dt = gmt_dt;
            //Integer offset = UserInfo.getTimezone().getOffset(gmt_dt);
            localCurrents_dt =  getMyDateTime(receivedCurrentsDate_str);
            currents_dt =  getMyDateTime(receivedCurrentsDate_str);

        }
        Return null;
    }
    
    public PageReference Save() {
        system.debug('original_str' + original_str);
        system.debug('current_str' + currents_str);
        PageReference cancel = Editcontroller.cancel();
        this.wl_rec.SFDC_Original_Datetime__c = original_dt;
        this.wl_rec.Current_Status_Date_Time__c = currents_dt;
       if(original_dt!= null)
        {
            Integer offset = UserInfo.getTimezone().getOffset(original_dt);
            Datetime dtLocal = original_dt.addSeconds(offset/1000);
            this.wl_rec.Original_Date_Time_with_seconds__c = original_dt.format('MM/dd/yyyy hh:mm:ss a');
        }
        if(original_dt == null)
        {
        this.wl_rec.Original_Date_Time_with_seconds__c = '' ;
        }
        if(currents_dt!= null)
        {
            Integer offset = UserInfo.getTimezone().getOffset(currents_dt);
            Datetime dtLocal = currents_dt.addSeconds(offset/1000);
            this.wl_rec.Current_Status_Date_Time_With_Seconds__c = currents_dt.format('MM/dd/yyyy hh:mm:ss a');
        }
        if(currents_dt == null)
        {
        this.wl_rec.Current_Status_Date_Time_With_Seconds__c = '';
        } 
        upsert this.wl_rec; 
        return cancel;
        
    }

    public static DateTime getMyDateTime(string strdt){  

        String[] DTSplitted = strDT.split(' ');
        string sAMPM;
        system.debug('strdt============'+strdt);
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
        system.debug('hour=============='+hour);
        string stringDate = year + '-' + month + '-' + day + ' ' + hour + ':' + minute +  ':' + second+' '+sAMPM;
        system.debug(stringDate);
        return datetime.valueOf(stringDate);
    
    }
    
 
    
}