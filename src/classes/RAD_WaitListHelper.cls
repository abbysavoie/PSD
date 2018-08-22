public class RAD_WaitListHelper{



    private List<Enrolled_Wait_List__c> WaitListRecs_new;
    private List<Enrolled_Wait_List__c> WaitListRecs_old;
    private List<Wait_List_Type__c> wltype;
    private Map<ID,Selection_Records__c> selectionRecMap = new Map<ID,Selection_Records__c>();
    private Map<ID,Wait_List_Type__c> wlTypeMap = new Map<ID,Wait_List_Type__c>();
    
    private List<ID> waitListIDs = new List<ID>();
    private Boolean updateLeaseUpRate=false;
    
    public RAD_WaitListHelper(List<Enrolled_Wait_List__c> waitListRecs_new, List<Enrolled_Wait_List__c> waitListRecs_old)
    {
         this.WaitListRecs_new = waitListRecs_new;
         this.WaitListRecs_old = waitListRecs_old;
         this.wlTypeMap = new Map<ID,Wait_List_Type__c>([Select id, name, Total_Housed__c, Lease_up__c, RADDisabled_Family__c, RADFamily__c, RADHomeless_with_disability__c, 
                                                RADLive_Work_in_City_of_San_Diego__c, RADVeteran_Active_Military__c, RADNon_Elderly_Disabled__c 
                                             From Wait_List_Type__c]);
         this.wltype= wlTypeMap.values();
         for(Enrolled_Wait_List__c e : this.waitListRecs_new)
            {this.waitListIDs.add(e.ID);
            }
          
        //This is a map of the person's enrolled wait list record ID to their selection record                                      
        for(Selection_Records__c s : [SELECT id, status__c, RAD_Wait_List__c FROM Selection_Records__c WHERE  RAD_Wait_List__c IN :this.waitListIDs]){
            this.selectionRecMap.put(s.RAD_Wait_List__c,s);
        }        
    }

 
    public void processWLsBeforeInsert(){ 
    
        List<Applications__c> Applications_List = New List<Applications__c>();
        List<Contact> con_List=new List<Contact>();
            
        Map<String, Wait_List_Type__c> wltMap = new Map<String, Wait_List_Type__c>(); 
        for( Wait_List_Type__c wlt : wltype ){
            wltMap.put(wlt.id, wlt);
        }
        

        Enrolled_Wait_List__c tempWL =new Enrolled_Wait_List__c();
        
        List<Wait_List_Income_Limit_Details__c> wlIncInfo = new List<Wait_List_Income_Limit_Details__c>();
        for( Wait_List_Income_Limit_Details__c wlInc : [Select name,Income_Limit__r.Code__c, Limit_Effective_Date__c, Limit_Expiration_Date__c,
                                                        Limit_1__c, Limit_2__c, Limit_3__c, Limit_4__c, Limit_5__c, Limit_6__c, Limit_7__c,
                                                        Limit_8__c, Limit_9__c, Limit_10__c, Limit_11__c, Limit_12__c, Limit_13__c, Limit_14__c, Limit_15__c, Limit_16__c
                                                        from Wait_List_Income_Limit_Details__c
                                                        where Limit_Effective_Date__c <= TODAY and  Limit_Expiration_Date__c >= TODAY 
                                                        order by Income_Limit__r.Percent_Income_Limit__c asc] ){
            wlIncInfo.add(wlInc);
        }
        
        Wait_List_Type__c wltp = new Wait_List_Type__c();
        
        List<RAD_Exception_Log__c> excpLogs = new List<RAD_Exception_Log__c>();
        RAD_Exception_Log__c eLog = new RAD_Exception_Log__c();                               
                                             
        Set<Id>applIds = new Set<Id>();
        for(Enrolled_Wait_List__c ewl : WaitListRecs_new){
            applIds.add(ewl.Applications__c);
        }                                             

        Map<Id, Applications__c> aplMap = new Map<Id, Applications__c>([Select Id,Total_People__c, of_people_in_the_H_H_Adults__c, Family_Annual_Income__c ,
                                             Family__c, Homeless_with_disability__c, Live_Work_in_City_of_San_Diego__c, Non_Elderly_Disabled__c,Elderly_Family__c, Disabled_Family__c, Veteran_Family_of__c,
                                             Dependents_Children_under_age_of_18__c , Spouse_Co_Head_If_applicable__c, Applied_Date_Time__c
 
                                             from Applications__c where id in : applIds]);
                      
                                        
        Applications__c tempApl = new Applications__c();
        
        
        String limitHdr = '';
        String incVal = '';
        Decimal fmlyCnt = 0;
        Decimal bedRoomSize = 1;
        Decimal totalCount = 0;
        Decimal adultCount_dec = 0;
        Decimal childCount_dec = 0;
        Decimal bCnt = null;

        for(Enrolled_Wait_List__c wl : WaitListRecs_new) {  
            if(!(UserInfo.getName() =='Dell Boomi'))
                wl.Send_To_Boomi__c=true;

            system.debug('wl.Wait_List_Type__r.Name: ' + wl.Wait_List_Type__c);
            
            wltp = wltMap.get(wl.Wait_List_Type__c); //Section 8;
            system.debug('wltp: ' + wltp);
            
            eLog = new RAD_Exception_Log__c();
            tempApl = aplMap.get(wl.Applications__c);

            if(wl.Wait_List_Type__c == null){
                eLog = new RAD_Exception_Log__c();
                eLog.RAD_Error_Source__c = 'WaitList type not defined on Waitlist'+wl.id;
                eLog.RAD_Error_Message__c = 'Waitlist not defined for calculating details';
    
                excpLogs.add(eLog);

                continue;//no futher processing
            }
            
            
            //wltp = wltMap.get(wl.Wait_List_Type__c); //Section 8 
            wl.Prefernce_Point__c = calculatePrefPtsFromAppl(tempApl,wltp); 
            
            if(wl.Prefernce_Point__c == 12){
                wl.RAD_Preference_Group__c = 'Group 1';
            }
            else if(wl.Prefernce_Point__c == 8){
                wl.RAD_Preference_Group__c = 'Group 2';
            }
            else if(wl.Prefernce_Point__c == 4){
                wl.RAD_Preference_Group__c = 'Group 3';        
            }
            else if(wl.Prefernce_Point__c == 0){
                wl.RAD_Preference_Group__c = 'Group 4';
            }
            
            
            //calculateIncomeZone();
           /* if(tempApl.of_people_in_the_H_H_Adults__c != null && tempApl.of_people_in_the_H_H_Adults__c > 0 && tempApl.of_people_in_the_H_H_Adults__c <=16){ */
             if(tempApl.Total_People__c >=0)
            {
                
                /*fmlyCnt = (tempApl.of_people_in_the_H_H_Adults__c == null?0:tempApl.of_people_in_the_H_H_Adults__c) +
                                 (tempApl.Dependents_Children_under_age_of_18__c == null?0:tempApl.Dependents_Children_under_age_of_18__c); */
                                 
                 //fmlyCnt=(tempApl.TotalPeople__c == null?0:tempApl.TotalPeople__c);
                 //fmlyCnt=(tempApl.Total_Number_of_People__c == null?0:tempApl.Total_Number_of_People__c);
                 fmlyCnt=tempApl.Total_People__c; 
                    
                //limitHdr = 'Limit_' +tempApl.of_people_in_the_H_H_Adults__c+ '__c';     //Limit_14__c
                limitHdr = 'Limit_' + fmlyCnt + '__c';     //Limit_14__c
                incVal = '';
                
                
                for(Wait_List_Income_Limit_Details__c wlInc : wlIncInfo){
                    incVal = (String)wlInc.get(limitHdr);
                
                    
                    if(tempApl.Family_Annual_Income__c <= Decimal.valueOf(incVal.trim()) ){
                    
                        wl.Limit__c = wlInc.Income_Limit__r.Code__c;
                        break;
                    }                
                }
            
            }else{
                    wl.Limit__c = '';
                    eLog = new RAD_Exception_Log__c();
                    eLog.RAD_Error_Source__c = 'WaitList Income limit is set to blank for '+wl.id;
                    eLog.RAD_Error_Message__c = 'Verify Number of people in household.';
        
                    excpLogs.add(eLog);
            
            }
            //calculateBedroomSize()
            //RULE: After the head/spouse is figured, it is one bedroom for every two persons – dependent or not.  
            if( wltp.name != 'Section 8' && wltp.name != 'NED' && wltp.name != 'Pass-Through' ){ //if not sect 8 or NED then calc bedroom size
                    if(!System.isBatch() && !System.isScheduled())
                    {
                        bedRoomSize = 1;
                       
                        if (tempApl.of_people_in_the_H_H_Adults__c == null || tempApl.of_people_in_the_H_H_Adults__c == 0)
                        {
                            totalCount = tempApl.Total_People__c != Null ? tempApl.Total_People__c : 0;
                            wl.Bed_size__c = (totalCount/2).round(System.RoundingMode.CEILING); 
                        } else {
                            adultCount_dec = tempApl.of_people_in_the_H_H_Adults__c != Null ? tempApl.of_people_in_the_H_H_Adults__c : 0;
                            childCount_dec = tempApl.Dependents_Children_under_age_of_18__c != Null ? tempApl.Dependents_Children_under_age_of_18__c : 0;
                            totalCount = adultCount_dec + childCount_dec;
                  
                            if(adultCount_dec > 1){
                                if (tempApl.Spouse_Co_Head_If_applicable__c == true) {
                                    totalCount = totalCount - 2;
                                } else {
                                    totalCount = totalCount - 1;
                                }    
                            } else {
                                if (adultCount_dec == 1){
                                    totalCount = totalCount - 1 ;
                                } else {
                                    totalCount = totalCount ;
                                }
                            }

                            
                            if(totalCount <0){//bad data
                                totalCount = 0;
                            }
                            if(totalCount > 0) {
                                bCnt = (totalCount/2).round(System.RoundingMode.CEILING);
                            } else {
                                bCnt = 0;
                            }
                            
                            wl.Bed_size__c = bCnt + bedRoomSize;
                            bedRoomSize = null;
                            bCnt = null;
                        }
                    }
            }else{
                 wl.Bed_size__c = 0;
            } 
            
            //set portal status 17 aug
            if(wl.Status__c == 'On List' || wl.Status__c == 'Selected'){
                wl.Portal_Status__c = 'Active';
            }
            
            if(wl.Current_Status__c == 'Onlist' ){
                wl.Portal_Status__c = 'Active';
                wl.Reason__c = 'Active';
            }else if(wl.Current_Status__c == 'Removed' ){
                wl.Portal_Status__c = 'Inactive';            
            }else if(wl.Current_Status__c == 'Leased'){
                wl.Portal_Status__c = 'On Program';              
            }else if(wl.Current_Status__c == 'Issue/Offer'){
                wl.Portal_Status__c = 'Issued Voucher / Offered Unit';              
            }else if(wl.Current_Status__c == 'Selected'){
                wl.Portal_Status__c = 'Selected';              
            }
            
            //  Set Portal Status - Workflow
            //if(wl.Status__c == 'On List' || wl.Status__c == 'Selected'){
            //    wl.Portal_Status__c = 'Active';
            //}  
                       
            // * PASS THROUGH - Workflow
            if(wl.PASS_THROUGH__c) {
                wl.Current_Status__c = 'Selected';
                wl.YARDI_Wait_List_Type__c  = '9';          
            }
            
            //Fix for bug where Wait List Type not being set upon insert.
            
            if(!wl.Pass_through__c){
                if(  wltp.name == 'Section 8' ){
                    wl.YARDI_Wait_List_Type__c = '5';
                }
                if(  wltp.name == 'Mod Rehab' ){
                    wl.YARDI_Wait_List_Type__c = '1';
                }              
                //check NED
                if(  wltp.name == 'NED' ){
                      wl.YARDI_Wait_List_Type__c = '10';
                }
    
                if(  wltp.name == 'Project Based' ){
                    wl.YARDI_Wait_List_Type__c = '3';           
                }
                if( wltp.name == 'Project Based Single' ){
                    wl.YARDI_Wait_List_Type__c = '4';            
                }
                
                if(  wltp.name == 'Public Housing' ){
                    wl.YARDI_Wait_List_Type__c = '2';
                }
            }                
            
            
            // Change Reason field to Income Targeted- workflow
            //if(wl.Status__c == 'On List'){
            //    wl.Reason__c = 'Active';
            //}
            
           //satya 10_23_2017
            
            
          /* if(wl.PASS_THROUGH__c && wl.Property_Code__c!=null ) {
           System.debug('passthrough code--->'+wl.Property_Code__c);
           wl.Applications__r.Applicant__r.Property_Code__c=Decimal.valueOf(wl.Property_Code__c);                             
            } 
            */
            
            
            
            
            
            // * Set Removed Reason - workflow
          /*  if( wl.Current_Status__c == 'Removed') {
                wl.Reason__c = 'Dropped';
            } */
            // SET INT FLAG - workflow
            //wl.INT_FLAG__c = 'S';
            
            // * Update Reason code for WL Types - workflow
            if(wltp.name == 'Mod Rehab' && wl.Current_Status__c == 'Selected') {
                wl.Reason__c = 'System Selection';
            }
            
           
            // * UpdateReason for Other WL - workflow
            if((wltp.name =='NED' || wltp.name =='Public Housing' || wltp.name =='Section 8' ||
                        wltp.name =='Project Based' || wltp.name =='Project Based Single') && wl.Current_Status__c == 'Selected' )
            {
                wl.Reason__c = 'Income Targeting';
                system.debug('Set to: ' + wl.Reason__c);
            }
            system.debug('Set to: ' + wl.Reason__c);            
            // * upadte appln_waitlist - workflow
            
           
            Applications__c Applications_rec = new Applications__c();
            
            Applications_rec.Id = wl.Applications__c;            
            Applications_rec.newdate__c = datetime.now();
            wl.Current_Status_Date_Time__c = wl.Current_Status_Date_Time__c != Null ? wl.Current_Status_Date_Time__c: Applications_rec.newdate__c;
            wl.SFDC_Original_Datetime__C = wl.SFDC_Original_Datetime__C != Null ? wl.SFDC_Original_Datetime__C: wl.Current_Status_Date_Time__c; 
           
           if(wl.Current_Status_Date_Time__c != Null)
            {
            Integer offset = UserInfo.getTimezone().getOffset(wl.Current_Status_Date_Time__c);
            Datetime dtLocal = (wl.Current_Status_Date_Time__c).addSeconds(offset/1000);
            wl.Current_Status_Date_Time_With_Seconds__c = (wl.Current_Status_Date_Time__c).format('MM/dd/yyyy hh:mm:ss a');             
            }
            if(wl.SFDC_Original_Datetime__C != Null)
            {
            Integer offset = UserInfo.getTimezone().getOffset(wl.SFDC_Original_Datetime__C );
            Datetime dtLocal = (wl.SFDC_Original_Datetime__C ).addSeconds(offset/1000);
            wl.Original_Date_Time_with_seconds__c = (wl.SFDC_Original_Datetime__C ).format('MM/dd/yyyy hh:mm:ss a');
            } 
            Applications_List.add(Applications_rec);        

            // next                    


            
        } // End For
        if(!Applications_List.isEmpty()){
            //update Applications_List;
        }
                      

        if(!excpLogs.isEmpty()){
            Database.insert(excpLogs, false);
        } 
    }

    
     public static Decimal calculatePrefPoints(Enrolled_Wait_List__c wl, Wait_List_Type__c wltp){
        Decimal prefPoints = 0;
        if(wl.Applications__r.Live_Work_in_City_of_San_Diego__c){
            prefPoints = 8;
        }
        
        Boolean others = false;
        if(wl.Applications__r.Family__c){
            others = true;
        }
        if(wl.Applications__r.Homeless_with_disability__c){
            others = true;
        }
        
        if(wl.Applications__r.Elderly_Family__c){
            others = true;
        }
        if(wl.Applications__r.Disabled_Family__c){
            others = true;
        }
        if(wl.Applications__r.Veteran_Family_of__c){
            others = true;
        }
        
        
        if(others == true){
            prefPoints = prefPoints + 4;
        }        
      return prefPoints;

    
    }
    
     public static Decimal calculatePrefPtsFromAppl(Applications__c appln, Wait_List_Type__c wltp){
        Decimal prefPoints = 0;
        if(appln.Live_Work_in_City_of_San_Diego__c){
            prefPoints = 8;
        }
        
        Boolean others = false;
        if(appln.Family__c){
            others = true;
        }
        if(appln.Homeless_with_disability__c){
            others = true;
        }
        if(appln.Live_Work_in_City_of_San_Diego__c){
            others = true;
        }
        if(appln.Elderly_Family__c){
            others = true;
        }
        if(appln.Disabled_Family__c){
            others = true;
        }
        if(appln.Veteran_Family_of__c){
            others = true;
        }
        
        if(others == true){
            prefPoints = prefPoints + 4;
        }        
      return prefPoints;

    
    }

    public void processWLsBeforeUpdate(){
    
        List<Applications__c> Applications_List = New List<Applications__c>();
        //System.debug('RHATHI IN WL UPDATE');
    
        Map<String, Wait_List_Type__c> wltMap = new Map<String, Wait_List_Type__c>(); 
        for( Wait_List_Type__c wlt : wltype ){
            
            wltMap.put(wlt.name, wlt);
        }
        

        
        List<Wait_List_Income_Limit_Details__c> wlIncInfo = new List<Wait_List_Income_Limit_Details__c>();
        for( Wait_List_Income_Limit_Details__c wlInc : [Select name,Income_Limit__r.Code__c, Limit_Effective_Date__c, Limit_Expiration_Date__c,
                                                        Limit_1__c, Limit_2__c, Limit_3__c, Limit_4__c, Limit_5__c, Limit_6__c, Limit_7__c,
                                                        Limit_8__c, Limit_9__c, Limit_10__c, Limit_11__c, Limit_12__c, Limit_13__c, Limit_14__c, Limit_15__c, Limit_16__c
                                                        from Wait_List_Income_Limit_Details__c
                                                        where Limit_Effective_Date__c <= TODAY and  Limit_Expiration_Date__c >= TODAY 
                                                        order by Income_Limit__r.Percent_Income_Limit__c asc] ){
            wlIncInfo.add(wlInc);
        }
        
        Wait_List_Type__c wltp = new Wait_List_Type__c();
        

        RAD_Exception_Log__c eLog = new RAD_Exception_Log__c();                               


        Map<Id, Enrolled_Wait_List__c> wlMap = new Map<Id, Enrolled_Wait_List__c>([Select Id,Applications__r.Total_People__c, Applications__r.of_people_in_the_H_H_Adults__c, Applications__r.Family_Annual_Income__c ,
                                             Applications__r.Family__c, Applications__r.Homeless_with_disability__c, Applications__r.Live_Work_in_City_of_San_Diego__c, Applications__r.Non_Elderly_Disabled__c, Applications__r.Disabled_Family__c,Applications__r.Elderly_Family__c, Applications__r.Veteran_Family_of__c,
                                             Applications__r.Dependents_Children_under_age_of_18__c , Applications__r.Spouse_Co_Head_If_applicable__c,
                                             Prefernce_Point__c, Limit__c , Bed_size__c, Wait_List_Type__r.Name,Current_Status__c 
                                             from Enrolled_Wait_List__c where id in : this.WaitListRecs_new]);

        Enrolled_Wait_List__c tempWL =new Enrolled_Wait_List__c(); 
        Decimal bedRoomSize = 1;
        Decimal totalCount = 0;
        Decimal adultCount_dec = 0;
        Decimal childCount_dec = 0;
        Decimal bCnt = null;
        Decimal fmlyCnt = 0;
                                                 
        for(Enrolled_Wait_List__c wl : WaitListRecs_new){ 
                      
            // next
            if(!(UserInfo.getName() =='Dell Boomi'))
                wl.Send_To_Boomi__c=true;
            Wait_List_Type__c selectedWaitListType_rec = wltMap.get(wl.wait_list_type__c);
            system.debug(wltp);
            tempWL = wlMap.get(wl.id);
            
            wltp = wltMap.get(tempWL.Wait_List_Type__r.Name); //Section 8;
            system.debug('DLS wl waitlist type is '+ wl.wait_list_type__c);
            system.debug('DLS wltMap is '+ wltMap);
            if (wltp == null)
                    wltp = wlTypeMap.get(wl.Wait_List_Type__c);
            if(wl.Current_Status__c =='Onlist'){
                eLog = new RAD_Exception_Log__c();
                
                
                wl.Prefernce_Point__c = calculatePrefPoints(tempWL,wltp); 
                
                if(wl.Prefernce_Point__c == 12){
                    wl.RAD_Preference_Group__c = 'Group 1';
                }
                else if(wl.Prefernce_Point__c == 8){
                    wl.RAD_Preference_Group__c = 'Group 2';
                }
                else if(wl.Prefernce_Point__c == 4){
                    wl.RAD_Preference_Group__c = 'Group 3';        
                }
                else if(wl.Prefernce_Point__c == 0){
                    wl.RAD_Preference_Group__c = 'Group 4';
                }
                
                //calculateIncomeZone();
                /*if(tempWL.Applications__r.of_people_in_the_H_H_Adults__c != null && tempWL.Applications__r.of_people_in_the_H_H_Adults__c > 0 && tempWL.Applications__r.of_people_in_the_H_H_Adults__c <=16){ */
                if(tempWL.Applications__r.Total_People__c<=16)
                {
                    /*fmlyCnt = (tempWL.Applications__r.of_people_in_the_H_H_Adults__c == null?0:tempWL.Applications__r.of_people_in_the_H_H_Adults__c) +
                                 (tempWL.Applications__r.Dependents_Children_under_age_of_18__c == null?0:tempWL.Applications__r.Dependents_Children_under_age_of_18__c); */
                                 
                      //fmlyCnt=(tempWL.Applications__r.TotalPeople__c == null?0:tempWL.Applications__r.TotalPeople__c);
                      //fmlyCnt=(tempWL.Applications__r.Total_Number_of_People__c == null?0:tempWL.Applications__r.Total_Number_of_People__c);
                      fmlyCnt=(tempWL.Applications__r.Total_People__c );
                      
                      system.debug('family count is-->'+fmlyCnt);
                        system.debug('family count is first');
                                                                                                                             
                    String limitHdr = 'Limit_' + fmlyCnt + '__c';     //Limit_14__c                                     
                    String incVal = '';
                    
                    for(Wait_List_Income_Limit_Details__c wlInc : wlIncInfo){
                        incVal = (String)wlInc.get(limitHdr);
                    
                        
                        if(tempWL.Applications__r.Family_Annual_Income__c <= Decimal.valueOf(incVal.trim()) ){
                        
                            wl.Limit__c = wlInc.Income_Limit__r.Code__c;
                            break;
                        }                
                    }
                }
                
                else{
                
                fmlyCnt=(tempWL.Applications__r.Total_People__c );                  
                  system.debug('family count is-->'+fmlyCnt);
                   system.debug('family count is second');
                   fmlyCnt=16;   
                   system.debug('fmlyCnt'+fmlyCnt);                      
                   String limitHdr = 'Limit_' + fmlyCnt + '__c';     //Limit_14__c                                     
                    String incVal = '';                
                   for(Wait_List_Income_Limit_Details__c wlInc : wlIncInfo){
                     incVal = (String)wlInc.get(limitHdr);                      
                     system.debug('16 income is '+incVal); 
                     
                     
                    /* if(tempWL.Applications__r.Family_Annual_Income__c > 142601 ){                      
                            wl.Limit__c = wlInc.Income_Limit__r.Code__c;
                            //wl.Limit__c='li-80+';
                            break;
                                        
                      }  */
                      
                    
                     if( Decimal.valueOf(incVal.trim()) > tempWL.Applications__r.Family_Annual_Income__c ){                      
                            wl.Limit__c = wlInc.Income_Limit__r.Code__c;
                            //wl.Limit__c='li-80+';
                            break;
                                        
                      }   
                      
                      
                         
                    }
                
                    //wl.Limit__c = '';
                    //no need to log, just set blank and continue, not really required
                }
                //calculateBedroomSize()
                //RULE: After the head/spouse is figured, it is one bedroom for every two persons – dependent or not.  
                System.debug('DLS- wltp is now:'+ wltp); 
                if( wltp.name != 'Section 8' && wltp.name != 'NED'  && wltp.name != 'Pass-Through' ) { //if not sect 8 or NED then calc bedroom size
                    if(!System.isBatch() && !System.isScheduled())
                    {
                        bedRoomSize = 1;
                        
                        if (tempWL.Applications__r.of_people_in_the_H_H_Adults__c == null)
                        {   System.debug('DLS--entered the zero adults code');
                            totalCount = tempWL.Applications__r.Total_People__c != Null ? tempWL.Applications__r.Total_People__c : 0;
                            wl.Bed_size__c = (totalCount/2).round(System.RoundingMode.CEILING);                           
                        } 
                        else {
                            System.debug('DLS--entered the positive number of adults code');
                            adultCount_dec = tempWL.Applications__r.of_people_in_the_H_H_Adults__c != Null ? tempWL.Applications__r.of_people_in_the_H_H_Adults__c : 0;
                            childCount_dec = tempWL.Applications__r.Dependents_Children_under_age_of_18__c != Null ? tempWL.Applications__r.Dependents_Children_under_age_of_18__c : 0;
                            totalCount = adultCount_dec + childCount_dec;
                        
                            if(adultCount_dec > 1){
                                if (tempWL.Applications__r.Spouse_Co_Head_If_applicable__c == true) {
                                    totalCount = totalCount - 2;
                                }
                                else {                            
                                    totalCount = totalCount - 1;
                                }
                            } else {
                                if (adultCount_dec == 1){
                                    totalCount = totalCount - 1 ;
                                } else {
                                    totalCount = totalCount ;
                                }
                            }
                            if(totalCount <0){//bad data
                                totalCount = 0;
                                System.debug('DLS--total count = 0');
                            }
                            if(totalCount > 0) {
                                bCnt = (totalCount/2).round(System.RoundingMode.CEILING);
                                System.debug('DLS--total count > 0');
                            } else {
                                bCnt = 0;
                            }
                            wl.Bed_size__c = bCnt + bedRoomSize;
                            bedRoomSize = null;
                            bCnt = null;
                        }
                    }
                }else{
                    wl.Bed_size__c = 0;
                }


            
                //System.debug('rhathi income limit '+wl.Limit__c);
                //System.debug('rhathi pref '+wl.Prefernce_Point__c);                
            }//onlist
            
            //set portal status 17 aug
            if(wl.Status__c == 'On List' || wl.Status__c == 'Selected'){
                wl.Portal_Status__c = 'Active';
            }


            if(wl.Current_Status__c == 'Onlist' ){
                wl.Portal_Status__c = 'Active';
                wl.Reason__c = 'Active';
                
            }else if(wl.Current_Status__c == 'Removed' ){
                wl.Portal_Status__c = 'Inactive';            
            }else if(wl.Current_Status__c == 'Leased'){
                wl.Portal_Status__c = 'On Program';              
            }else if(wl.Current_Status__c == 'Issue/Offer'){
                wl.Portal_Status__c = 'Issued Voucher / Offered Unit';              
            }else if(wl.Current_Status__c == 'Selected'){
                wl.Portal_Status__c = 'Selected';              
            }
            
            //on explicit changing the applied date and time(original date time) by user, update it's text time on waitlist, 30 Aug 2017
            /*
            if( ((Enrolled_Wait_List__c)Trigger.oldMap.get(wl.id)).RAD_Applied_Date_and_Time__c != wl.RAD_Applied_Date_and_Time__c ){
                String strConvertedDate =   wl.RAD_Applied_Date_and_Time__c.format('MM/dd/yyyy HH:mm:ss a', 'America/Los_Angeles');//PDT
                wl.RAD_Date_and_Time_with_Seconds__c = strConvertedDate;
                
            }
            if( ((Enrolled_Wait_List__c)Trigger.oldMap.get(wl.id)).RAD_Date_and_Time_with_Seconds__c != wl.RAD_Date_and_Time_with_Seconds__c ){
                wl.SFDC_Original_Datetime__c = RAD_Utils.convertStringToDate(wl.RAD_Date_and_Time_with_Seconds__c);
            } */

            //  Set Portal Status - Workflow
            //if(wl.Status__c == 'On List' || wl.Status__c == 'Selected'){
            //    wl.Portal_Status__c = 'Active';
            //}             
            // PASS THROUGH - Workflow
            if(wl.PASS_THROUGH__c) {
                wl.Current_Status__c = 'Selected';
                wl.YARDI_Wait_List_Type__c  = '9';
                
            }
            // Change Reason field to Active - workflow
            //if(wl.Status__c == 'On List'){
            //    wl.Reason__c = 'Active';
            //}
            
            
            
          /*  if(wl.PASS_THROUGH__c && wl.Property_Code__c!=null ) {
           System.debug('passthrough code--->'+wl.Property_Code__c);
           wl.Applications__r.Applicant__r.Property_Code__c=Decimal.valueOf(wl.Property_Code__c);                             
            } */

            
            
            
            
            // Set Removed Reason - workflow
         /*   if( wl.Current_Status__c == 'Removed') {
                wl.Reason__c = 'Dropped';
            }*/
            // SET INT FLAG - workflow
            //wl.INT_FLAG__c = 'S';
            system.debug(wltp);
            // Update Reason code for WL Types - workflow
            if(wltp.name == 'Mod Rehab' && wl.Current_Status__c == 'Selected') {
                wl.Reason__c = 'System Selection';
            }
            system.debug('Current Status: ' + wl.Current_Status__c);
            
            // UpdateReason for Other WL - workflow
            if((wltp.name =='NED' ||wltp.name =='Public Housing' || wltp.name =='Section 8' ||
                        wltp.name =='Project Based' || wltp.name =='Project Based Single') && (wl.Current_Status__c == 'Selected') )
            {
                wl.Reason__c = 'Income Targeting';
                system.debug('Set to: ' + wl.Reason__c);
            }
            system.debug('Waitlist Type: ' + wltp.name);
            system.debug('Current Status: ' + wl.Current_Status__c);
            system.debug('Set to: ' + wl.Reason__c); 
            system.debug('WLT ID: ' + wl.wait_list_type__c);
            system.debug('WLT Name: ' + selectedWaitListType_rec);

            // upadte appln_waitlist - workflow
            if(((Enrolled_Wait_List__c)Trigger.oldMap.get(wl.id)).Current_Status__c != wl.Current_Status__c ||
                    ((Enrolled_Wait_List__c)Trigger.oldMap.get(wl.id)).Current_Status__c != wl.Current_Status__c ||
                    ((Enrolled_Wait_List__c)Trigger.oldMap.get(wl.id)).Reason__c != wl.Reason__c ||
                    ((Enrolled_Wait_List__c)Trigger.oldMap.get(wl.id)).RAD_Preference_Group__c != wl.RAD_Preference_Group__c ||
                    //((Enrolled_Wait_List__c)Trigger.oldMap.get(wl.id)).RAD_Applied_Date_and_Time__c != wl.RAD_Applied_Date_and_Time__c ||
                    //((Enrolled_Wait_List__c)Trigger.oldMap.get(wl.id)).RAD_Date_and_Time_with_Seconds__c != wl.RAD_Date_and_Time_with_Seconds__c ||
                    ((Enrolled_Wait_List__c)Trigger.oldMap.get(wl.id)).Current_Status_Date_Time__c != wl.Current_Status_Date_Time__c ||
                    ((Enrolled_Wait_List__c)Trigger.oldMap.get(wl.id)).Property__c != wl.Property__c ||
                    ((Enrolled_Wait_List__c)Trigger.oldMap.get(wl.id)).Prefernce_Point__c != wl.Prefernce_Point__c ||
                    ((Enrolled_Wait_List__c)Trigger.oldMap.get(wl.id)).Limit__c != wl.Limit__c ||
                    ((Enrolled_Wait_List__c)Trigger.oldMap.get(wl.id)).reason_out_of_order__c != wl.reason_out_of_order__c ||
                    ((Enrolled_Wait_List__c)Trigger.oldMap.get(wl.id)).Lottery__c != wl.Lottery__c ||
                    ((Enrolled_Wait_List__c)Trigger.oldMap.get(wl.id)).Bed_size__c != wl.Bed_size__c) {
            
                Applications__c Applications_rec = new Applications__c();
                
                Applications_rec.Id = wl.Applications__c;            
                Applications_rec.newdate__c = datetime.now();
                Applications_List.add(Applications_rec);    
          
              if( ((Enrolled_Wait_List__c)Trigger.oldMap.get(wl.id)).Current_Status__c != wl.Current_Status__c ){
                    wl.Current_Status_Date_Time__c = Datetime.Now();
                    if(wl.Current_Status_Date_Time__c != Null)
                        {
                        Integer offset = UserInfo.getTimezone().getOffset(wl.Current_Status_Date_Time__c);
                        Datetime dtLocal = (wl.Current_Status_Date_Time__c).addSeconds(offset/1000);
                        wl.Current_Status_Date_Time_With_Seconds__c = (wl.Current_Status_Date_Time__c).format('MM/dd/yyyy hh:mm:ss a');             
                        }
                } 
                // Check if current status is moving from 'Removed' to 'Onlist' if yes then update original date/time with current status date/time
                if (((Enrolled_Wait_List__c)Trigger.oldMap.get(wl.id)).Current_Status__c == 'Removed' && wl.Current_Status__c == 'Onlist') {
                    wl.SFDC_Original_Datetime__c = wl.Current_Status_Date_Time__c;
                    if(wl.SFDC_Original_Datetime__C != Null)
                    {
                        Integer offset = UserInfo.getTimezone().getOffset(wl.SFDC_Original_Datetime__C );
                        Datetime dtLocal = (wl.SFDC_Original_Datetime__C ).addSeconds(offset/1000);
                        wl.Original_Date_Time_with_seconds__c = (wl.SFDC_Original_Datetime__C ).format('MM/dd/yyyy hh:mm:ss a');
                    } 
                }      
                    
            
            }       
               system.debug('DLS---YARDI_BUG');
                //Update Yardi Wait List Type
                if(!wl.Pass_through__c){
                    if(  wltp.name == 'Section 8' ){
                        wl.YARDI_Wait_List_Type__c = '5';
                    }
                    if(  wltp.name == 'Mod Rehab' ){
                        wl.YARDI_Wait_List_Type__c = '1';
                    }              
                    //check NED
                    if(  wltp.name == 'NED' ){
                          wl.YARDI_Wait_List_Type__c = '10';
                    }
        
                    if(  wltp.name == 'Project Based' ){
                        wl.YARDI_Wait_List_Type__c = '3';           
                    }
                    if( wltp.name == 'Project Based Single' ){
                        wl.YARDI_Wait_List_Type__c = '4';            
                    }
                    
                    if(  wltp.name == 'Public Housing' ){
                        wl.YARDI_Wait_List_Type__c = '2';
                    }
                }    
 
        }//for
        if(!Applications_List.isEmpty()){
            //update Applications_List;
        }
            
    }

    //create memo on after adding waitlist
   /* public void processWLsAfterInsert(){ 
        List<Memo__c> mmoLst = new List<Memo__c>();
        for( Enrolled_Wait_List__c  wl : [Select id, Current_Status__c, Applications__c from Enrolled_Wait_List__c where id in : WaitListRecs_new]){
            Memo__c mmo = new Memo__c();
            mmo.Name = 'Waitlist Updated to ' + wl.Current_Status__c;
            mmo.Type__c = 'Wait List';
            mmo.Notes__c = 'System Generated Memo';
            mmo.Applications__c = wl.Applications__c;
            mmoLst.add(mmo);
            
        }
        
        insert mmoLst;
    } */
    
    public void processWLsAfterInsert(){ 
         Set<Id> ctIds = new Set<Id>(); 
         List<Memo__c> mmoLst = new List<Memo__c>();    
        for( Enrolled_Wait_List__c  wl : [Select id, Current_Status__c, Applications__c,Property_Code__c,PASS_THROUGH__c, Applications__r.Applicant__r.id, Wait_List_Type__c,Wait_List_Type__r.Name from Enrolled_Wait_List__c where id in : WaitListRecs_new]){
        Memo__c mmo = new Memo__c();
            mmo.Name = 'Waitlist updated to ' + wl.Current_Status__c;
            mmo.Type__c = 'Wait List';
            if(wl.Wait_List_Type__r.Name == 'Pass-Through')
           {mmo.Notes__c = '"Special Admission" for Wait List created ';}
            else
            {mmo.Notes__c = 'Application Submitted. Client on list for ' + wl.Wait_List_Type__r.Name;}
            mmo.Applications__c = wl.Applications__c;
            mmoLst.add(mmo); 
            
        if(wl.Wait_List_Type__r.Name=='Pass-Through' && wl.PASS_THROUGH__c==true)
        
            ctIds.add(wl.Applications__r.Applicant__r.id);            
       
        if(!ctIds.isEmpty()){
            List<Contact> ctList = new List<Contact>();
            for(Contact ct : [Select Id, Property_Code__c, RAD_Is_Selected__c, Is_Selected__c from Contact where id in :ctIds]){   
                ct.Is_Selected__c = 'X';
                ct.RAD_Is_Selected__c = true;            
                  
                ct.Property_Code__c = wl.Property_Code__c == null?0:Decimal.valueOf(wl.Property_Code__c);
               ctList.add(ct);
            }
     update ctList;
     
    }
  
    }
 insert mmoLst;
    }
    
  
    //Create memo on status change
    /*public void processWLsAfterUpdate(){ 
    
        List<Memo__c> mmoLst = new List<Memo__c>();
        for( Enrolled_Wait_List__c  wl : [Select id, Current_Status__c, Applications__c from Enrolled_Wait_List__c where id in : WaitListRecs_new]){
            if( ((Enrolled_Wait_List__c)Trigger.oldMap.get(wl.id)).Current_Status__c != wl.Current_Status__c ){
                Memo__c mmo = new Memo__c();
                mmo.Name = 'Waitlist Updated to .' + wl.Current_Status__c;
                mmo.Type__c = 'Wait List';
                mmo.Notes__c = 'System Generated Memo';
                mmo.Applications__c = wl.Applications__c;
                mmoLst.add(mmo);
            }
        }
        
        insert mmoLst;
    }  */
    
    public void processWLsAfterUpdate(){
      List<Applications__c> Applications_List = New List<Applications__c>();
      List<Contact> ctList = new List<Contact>();
      Set<Id> ctIds = new Set<Id>(); 
      Set<Id> ctIdAdded = new Set<Id>();
      Set<Id> applicationIds = new Set<Id>(); 
      Map<Id, Applications__c> application_map = new Map<Id, Applications__c>();
      
      List<Memo__c> mmoLst = new List<Memo__c>(); 
      for( Enrolled_Wait_List__c  wl : [Select id, Current_Status__c, 
                    Applications__c,Property_Code__c,PASS_THROUGH__c, Applications__r.Applicant__r.id, 
                    Wait_List_Type__c,Wait_List_Type__r.Name, Reason__c, RAD_Preference_Group__c, RAD_Applied_Date_and_Time__c, SFDC_Original_Datetime__c, 
                    Current_Status_Date_Time__c, Property__c, Prefernce_Point__c, Limit__c, reason_out_of_order__c, Lottery__c, Bed_size__c,
                    Applications__r.Applicant__r.LastModifiedById, Applications__r.Applicant__r.Yardi_ID__c, Current_Status_Date_Time_With_Seconds__c, Applications__r.Application_Status__c                     
                    from Enrolled_Wait_List__c 
                    where id in : WaitListRecs_new]){
            if( ((Enrolled_Wait_List__c)Trigger.oldMap.get(wl.id)).Current_Status__c != wl.Current_Status__c ){
                
                updateLeaseUpRateInfo(wl);
                
                Memo__c mmo = new Memo__c();
                mmo.Name = 'Waitlist updated to ' + wl.Current_Status__c;
                mmo.Type__c = 'Wait List';
                if(wl.Current_Status__c == 'Onlist')
                    mmo.Notes__c = 'Applicant reapplied for ' + wl.Wait_List_Type__r.Name+' wait list. New date and time assigned.';
                if(wl.Current_Status__c == 'Leased')
                    mmo.Notes__c = 'System Generated Memo';
                if(wl.Current_Status__c == 'Issue/Offer')
                    mmo.Notes__c = 'System Generated Memo';
                if(wl.Current_Status__c == 'Selected' && (wl.Wait_List_Type__r.Name == 'Section 8' || wl.Wait_List_Type__r.Name == 'NED'))
                    mmo.Notes__c = wl.Wait_List_Type__r.Name+' application selected from wait list on '+wl.Current_Status_Date_Time_With_Seconds__c+' . Intake packet and appointment letter/email sent to schedule an appointment within 10 days.';
                if(wl.Current_Status__c == 'Selected' && (wl.Wait_List_Type__r.Name == 'Project Based' || wl.Wait_List_Type__r.Name == 'Project Based Single' || wl.Wait_List_Type__r.Name == 'Mod Rehab'))
                    mmo.Notes__c = 'Selection for '+wl.Wait_List_Type__r.Name+'. Notice of Opportunity letter/email sent to applicant.';
                if(wl.Current_Status__c == 'Selected' && wl.Wait_List_Type__r.Name == 'Public Housing')
                    mmo.Notes__c = 'Selection for '+wl.Wait_List_Type__r.Name+'. Selection list sent to SDHC staff.';
                if(wl.Current_Status__c == 'Removed')
                    mmo.Notes__c = 'Applicant removed from ' + wl.Wait_List_Type__r.Name+' wait list.';
                if(wl.Applications__r.Application_Status__c == 'Update Required')
                    mmo.Notes__c = 'Letter/email sent to applicant requesting response to Update';
                if(((Enrolled_Wait_List__c)Trigger.oldMap.get(wl.id)).Current_Status__c == 'Selected' &&(wl.Wait_List_Type__r.Name == 'Section 8'||wl.Wait_List_Type__r.Name == 'NED') && wl.current_Status__c == 'Removed')
                    mmo.Notes__c = 'Selection no response for Section 8: '+wl.Current_Status_Date_Time_With_Seconds__c +' dropped no response to intake appointment letter/email';
                if(((Enrolled_Wait_List__c)Trigger.oldMap.get(wl.id)).Current_Status__c == 'Selected' && wl.Wait_List_Type__r.Name == 'NED' && wl.current_Status__c == 'Removed')
                    mmo.Notes__c = 'Selection no response for '+ wl.Wait_List_Type__r.Name+': '+wl.Current_Status_Date_Time_With_Seconds__c +' dropped no response to intake appointment letter/email';
                if(((Enrolled_Wait_List__c)Trigger.oldMap.get(wl.id)).Current_Status__c == 'Selected' && (wl.Wait_List_Type__r.Name == 'Project Based Single'||wl.Wait_List_Type__r.Name =='Project Based'||wl.Wait_List_Type__r.Name =='Mod Rehab') && wl.current_Status__c == 'Removed')
                    mmo.Notes__c = 'Selection no response for '+ wl.Wait_List_Type__r.Name+': '+wl.Current_Status_Date_Time_With_Seconds__c +' not selected for unit by owner/property manager.';    
                mmo.Applications__c = wl.Applications__c;
                mmoLst.add(mmo); 
            }
            Applications__c Applications_rec = new Applications__c();
            system.debug('LastModifiedById: ' + wl.Applications__r.Applicant__r.LastModifiedById);
            system.debug('wl.Applications__r.Applicant__r.Yardi_ID__C: ' + wl.Applications__r.Applicant__r.Yardi_ID__C);
            // upadte appln_waitlist - workflow
            if(((Enrolled_Wait_List__c)Trigger.oldMap.get(wl.id)).Current_Status__c != wl.Current_Status__c ||
                    ((Enrolled_Wait_List__c)Trigger.oldMap.get(wl.id)).Current_Status__c != wl.Current_Status__c ||
                    ((Enrolled_Wait_List__c)Trigger.oldMap.get(wl.id)).Reason__c != wl.Reason__c ||
                    ((Enrolled_Wait_List__c)Trigger.oldMap.get(wl.id)).RAD_Preference_Group__c != wl.RAD_Preference_Group__c ||
                    //((Enrolled_Wait_List__c)Trigger.oldMap.get(wl.id)).RAD_Applied_Date_and_Time__c != wl.RAD_Applied_Date_and_Time__c ||
                    //((Enrolled_Wait_List__c)Trigger.oldMap.get(wl.id)).RAD_Date_and_Time_with_Seconds__c != wl.RAD_Date_and_Time_with_Seconds__c ||
                    ((Enrolled_Wait_List__c)Trigger.oldMap.get(wl.id)).Current_Status_Date_Time__c != wl.Current_Status_Date_Time__c ||
                    ((Enrolled_Wait_List__c)Trigger.oldMap.get(wl.id)).Property__c != wl.Property__c ||
                    ((Enrolled_Wait_List__c)Trigger.oldMap.get(wl.id)).Prefernce_Point__c != wl.Prefernce_Point__c ||
                    ((Enrolled_Wait_List__c)Trigger.oldMap.get(wl.id)).Limit__c != wl.Limit__c ||
                    ((Enrolled_Wait_List__c)Trigger.oldMap.get(wl.id)).reason_out_of_order__c != wl.reason_out_of_order__c ||
                    ((Enrolled_Wait_List__c)Trigger.oldMap.get(wl.id)).Lottery__c != wl.Lottery__c ||
                    ((Enrolled_Wait_List__c)Trigger.oldMap.get(wl.id)).Bed_size__c != wl.Bed_size__c) {
            

                
                if(applicationIds.contains(wl.Applications__c))
                {
                    application_map.remove(wl.Applications__c);
                } else {
                    applicationIds.add(wl.Applications__c);
                }
                Applications_rec.Id = wl.Applications__c;            
                Applications_rec.newdate__c = datetime.now();
                Applications_rec.HMY__c = wl.Applications__r.Applicant__r.Yardi_ID__C;
                Applications_List.add(Applications_rec); 
                application_map.put(wl.Applications__c, Applications_rec); 
                      
            }        
     
           if(wl.Wait_List_Type__r.Name=='Pass-Through' && wl.PASS_THROUGH__c==true)
           {
                ctIds.add(wl.Applications__r.Applicant__r.id);            
           }
            if(!ctIds.isEmpty()){
                
                for(Contact ct : [Select Id, Property_Code__c, RAD_Is_Selected__c, Is_Selected__c from Contact where id in :ctIds]){   
                    ct.Is_Selected__c = 'X';
                    ct.RAD_Is_Selected__c = true;
                    
                    if (wl.Property_Code__c != Null) {       
                        ct.Property_Code__c = wl.Property_Code__c == null?0:Decimal.valueOf(wl.Property_Code__c);
                       if(!ctIdAdded.Contains(ct.Id)) {
                           ctList.add(ct);
                           ctIdAdded.add(ct.Id);
                       }
                    }
                 }
         
            }          
        }

    
        if(!mmoLst.isEmpty())
        {
            insert mmoLst;
        }   
        if(!ctList.isEmpty())
        {           
            update ctList;  
        }
        
        if(!Applications_List.isEmpty())
        {
            List<Applications__c> saveApps_list = application_map.values();
            //Database.update(saveApps_list, false);
        }
        
    } 
    
    /******* Manage all DML operations as needed  - Start- ******/ 
    public static void manageTrigger()
    {
        // Create handler and delegate events to methods
        RAD_WaitListHelper waitListHandler = new RAD_WaitListHelper(Trigger.new, Trigger.Old);
        
        if (Trigger.isInsert) 
        {
            if (Trigger.isBefore) 
            {
                waitListHandler.processWLsBeforeInsert();
            } 
            else if (Trigger.isAfter) 
            {
                waitListHandler.processWLsAfterInsert();
            }
    
        }
        if (Trigger.isUpdate) 
        {
            if (Trigger.isBefore) 
            {
                waitListHandler.processWLsBeforeUpdate();
                
            } 
            else if (Trigger.isAfter) 
            {
                waitListHandler.processWLsAfterUpdate(); 
                waitListHandler.cleanupAfterUpdate();
            }
        }
    }     
    
    Public static Void updateApplications(List<Applications__c> appUpdates) 
    {
        update appUpdates;
    }

    private void updateLeaseUpRateInfo(Enrolled_Wait_List__c wl)
    {/*This updates the status value in the Selection_Records__c record associated with this 
        enrolled waitlist record
        then updates the waitlist type record's total housed, and lease up rate fields.
        */
        if(wl.current_Status__c=='Leased'){
            if(updateLeaseUpRate==false){
                updateLeaseUpRate=true;
                }
            this.selectionRecMap.get(wl.id).status__c='Leased'; 
            }  
    }
    
    private void cleanupAfterUpdate(){
        //update all waitlist type records
        //Pull all wait_list_selection records for each type
        //Tally up the number of leased for each income level, and the total number overall, and update the lease up rate
        //Also update the total housed field
        if(updateLeaseUpRate==true){
            List<Wait_List_Type__c> wltRecords = [SELECT id, name, Lease_Up__c , (SELECT Acceptedateli30__c, Acceptedatvli50__c, Acceptedatli80__c, Acceptedatli80Plus__c, Prospect_Selected__c FROM Wait_List_Selections__r) FROM Wait_List_Type__c];
            for(Wait_List_Type__c wlt : wltRecords){
                Decimal NumIn30Group=0;
                Decimal NumIn50Group=0;
                Decimal NumIn80Group=0;
                Decimal NumIn100Group=0;
                Decimal totalHoused = 0;
                Decimal totalSelected = 0;
                for(Wait_List_Selection__c wls:wlt.Wait_List_Selections__r){
                    NumIn30Group = NumIn30Group + wls.AcceptedAteLI30__c;
                    NumIn50Group = NumIn50Group + wls.AcceptedAtvLI50__c;
                    NumIn80Group = NumIn80Group + wls.AcceptedAtLI80__c;
                    NumIn100Group = NumIn100Group + wls.AcceptedAtLI80Plus__c;
                    totalSelected = totalSelected + wls.Prospect_Selected__c;
                    totalHoused = totalHoused + wls.AcceptedAtELI30__c + wls.AcceptedAtVLI50__c + wls.AcceptedAtLI80__c + wls.AcceptedAtLI80Plus__c;
                }
                //Add in logic to weight different income levels in the lease up rate here
                if (totalSelected == 0)
                    wlt.Lease_Up__c = '100';
                else
                    wlt.Lease_Up__c=String.valueOf(100*(numIn30Group + numIn50Group + numIn80Group + numIn100Group)/totalSelected);
                
                wlt.Total_Housed__c=totalHoused;
                
            }
            update wltRecords;
            
        }
        //update all selection records
        update this.selectionRecMap.values();
        
        
    }
}