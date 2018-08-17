//This class selects the records
global class RAD_NEDScheduler implements Schedulable{

    global String  wlsidd;   
    global Decimal tEli;
    global Decimal tVli;
    global Decimal tLi;
    global Decimal totalRecordCount;
    global Decimal currentSchdlrCount;
        
    public RAD_NEDScheduler(String wlsId){
        
        System.debug('rhathi in RAD_NEDScheduler wlsid is '+wlsId);
        this.wlsidd =  wlsId;
        totalRecordCount = 0;
        
        
    }           

    
    global void execute(SchedulableContext sc){
    
        System.debug('Rhathi in RAD_NEDScheduler execute ');
        
        Wait_List_Selection__c wls = [Select Number_to_Select_from_List__c, RAD_Temp_Number_to_Select__c, RAD_Temp_Eli_Count__c, RAD_Temp_Vli_Count__c, RAD_Temp_Li_Count__c, RAD_Scheduler_Count__c, RAD_Current_Scheduler_Count__c, Property_Code__c from Wait_List_Selection__c where id =: wlsidd  limit 1];           
         system.debug('$$$$ NEDScheduler wls rec' +wls);
        
        tEli = wls.RAD_Temp_Eli_Count__c;
        tVli = wls.RAD_Temp_Vli_Count__c;
        tLi  = wls.RAD_Temp_Li_Count__c;

        wls.RAD_Current_Scheduler_Count__c = wls.RAD_Current_Scheduler_Count__c != Null ? wls.RAD_Current_Scheduler_Count__c + 1 : 1;
        
        currentSchdlrCount = wls.RAD_Current_Scheduler_Count__c;
       
        Decimal tNumToSelect = wls.Number_to_Select_from_List__c;
        
        List<Selection_Records__c> selRecList = new List<Selection_Records__c>();
        Selection_Records__c selRec = new Selection_Records__c();
        
        List<Enrolled_Wait_List__c> wlLst = new List<Enrolled_Wait_List__c>();
        
        List<Id> ctIds = new List<Id>();
         
        List<RAD_Exception_Log__c> excpLogs = new List<RAD_Exception_Log__c>();
        RAD_Exception_Log__c eLog = new RAD_Exception_Log__c();                               

        List<String>raceLst = new List<String>();
        String raceString ='';
        
        Integer posNo = 1;
        //Ned should also takecare of Application Fields(Age__c<62, of_people_in_the_H_H_Adults__c = 1, Disabled_Family__c = true and Dependents_Children_under_age_of_18__c = 0.) So added these conditions in below Query . 

        for(Enrolled_Wait_List__c wl : [Select name, RAD_Selection_Marker__c, Current_Status__c, 
                    Applications__r.Ethnicity__c, Applications__r.Family_Annual_Income__c, Applications__r.Total_People__c,
                    Applications__r.Applicant__r.Tenant_Number_YARDI__c, Applications__r.Applicant__r.Prospect_Number_YARDI__c,
                    Applications__r.Applicant__r.Name, Applications__r.Applicant__r.SSN_TaxID__c,  Applications__r.Applicant__r.Gender__c,
                    Applications__r.White__c, Applications__r.Black__c, Applications__r.Asian__c, Applications__r.American_Indian__c, Applications__r.Pacific_Islander__c,
                    Applications__r.Applied_Date_time__c,Limit__c, Prefernce_Point__c,SFDC_Original_Datetime__c,
                    Applications__r.Applicant__r.id,
                    Applications__r.Age__c,Applications__r.of_people_in_the_H_H_Adults__c,Applications__r.Dependents_Children_under_age_of_18__c, Applications__r.Disabled_Family__c
                    from Enrolled_Wait_List__c 
                    where Current_Status__c = 'Onlist' and Wait_List_Type__r.Name ='NED' and CreatedDate>=2018-07-19T19:12:41.000+0000 and Applications__r.Age__c < 62 and Applications__r.of_people_in_the_H_H_Adults__c = 1 and Applications__r.Dependents_Children_under_age_of_18__c = 0 and Applications__r.Disabled_Family__c = true  and RAD_Selection_Marker__c != :wlsidd                  
                    order by Prefernce_Point__c desc, SFDC_Original_Datetime__c asc limit 1000]){

             // check loop for remaining counts to fill before exiting to limit records processed.
              
            if( tEli > 0 || tVli > 0 || tLi > 0) {
            system.debug('$$$$ NED Eli value' +tEli);  
            system.debug('$$$$ NED Vli value' +tVli); 
            system.debug('$$$$ NED li value' +tLi);             
                
                    system.debug('wl.Applications__r.Total_People__c:' + wl.Applications__r.Total_People__c);
                    selRec = new Selection_Records__c();
                    selRec.Status__c = wl.Current_Status__c;
                    if(tEli > 0 &&  wl.Limit__c  == 'eli-30' ){ // && wl.Applications__r.Total_People__c == 1
                        
                            selRec.Status__c = 'Selected';
                            wl.Current_Status__c = 'Selected';
                            wl.RAD_Selection_Marker__c = wlsidd;
                            wl.Property_Code__c = wls.Property_Code__c;
                            system.debug('$$$$ condition 1 ' +wl);  
                            wlLst.add(wl);

                            tEli--;

                            ctIds.add(wl.Applications__r.Applicant__r.id);
        
                    }
                    else if( tVli > 0 && wl.Limit__c  == 'vli-50' ){

                        
                            selRec.Status__c = 'Selected';
                            wl.Current_Status__c = 'Selected';
                            wl.RAD_Selection_Marker__c = wlsidd;
                            wl.Property_Code__c = wls.Property_Code__c;
                            system.debug('$$$$ condition 2 ' +wl);  
                            wlLst.add(wl);
                            tVli--;
                            
                            ctIds.add(wl.Applications__r.Applicant__r.id);
        
                    }
                    else if(tLi > 0 && wl.Limit__c  == 'li-80' ){
                        
                            selRec.Status__c = 'Selected';
                            wl.Current_Status__c = 'Selected';
                            wl.RAD_Selection_Marker__c = wlsidd;
                            wl.Property_Code__c = wls.Property_Code__c;
                            system.debug('$$$$ condition 3 ' +wl);  
                            wlLst.add(wl);

                            tLi--;
                            
                             ctIds.add(wl.Applications__r.Applicant__r.id);
                                    
                    }else{
                        selRec.Status__c = 'Not selected due to income target';
                        
                        wl.RAD_Selection_Marker__c = wlsidd;
                        wl.Property_Code__c = wls.Property_Code__c;
                        system.debug('$$$$ condition 4 ' +wl);  
                        wlLst.add(wl);
                    }
                    
                    //add this selection record in list
                    raceLst = new List<String>();
                    selRec.Position__c = posNo + ((currentSchdlrCount-1) * 1000); 
                    posNo++;
                    selRec.Prospect__c = wl.Applications__r.Applicant__r.Prospect_Number_YARDI__c;
                    selRec.Resident__c = wl.Applications__r.Applicant__r.Tenant_Number_YARDI__c;
                    selRec.Name__c = wl.Applications__r.Applicant__r.Name;
                    selRec.SSN__c = wl.Applications__r.Applicant__r.SSN_TaxID__c;
                    selRec.Gender__c = wl.Applications__r.Applicant__r.Gender__c;
                    selRec.HH_Occ__c = wl.Applications__r.Total_People__c;
                    //RACE
                    if(wl.Applications__r.White__c == true){
                        raceLst.add('White');
                    }
                    if(wl.Applications__r.Black__c == true){
                        raceLst.add('Black');
                    }
                    if(wl.Applications__r.Asian__c== true){
                        raceLst.add('Asian');
                    }
                    if(wl.Applications__r.American_Indian__c == true){
                        raceLst.add('American Indian');
                    }
                    if(wl.Applications__r.Pacific_Islander__c == true){
                        raceLst.add('Pacific Islander');
                    }       
                    
                    raceString = string.join(raceLst , ',');
                    selRec.Race__c = raceString;
                    selRec.HH_Ethnicity__c = wl.Applications__r.Ethnicity__c;
                    selRec.HH_Income__c = wl.Applications__r.Family_Annual_Income__c;
                    selRec.Income_Target__c = wl.Limit__c;
                    selRec.Pref_Points__c = wl.Prefernce_Point__c==null?0:wl.Prefernce_Point__c;
                    selRec.Bed_Rooms__c ='N/A';
                    //selRec.App_Date_Time__c = wl.RAD_Applied_Date_and_Time__c;  
                    selRec.App_Date_Time__c = wl.Applications__r.Applied_Date_time__c;                        
                    
                    
                    selRec.Selection_ID__c = wlsIdd;
                    selRec.RAD_Wait_List__c = wl.id;
                    
                    
                    
                    selRecList.add(selRec);
                        
            } else
            {
                break;
            }         
        } //for 1000
            
        //UPDATE THE WAITLIST         
        if(!wlLst.isEmpty()){
            List<Database.SaveResult> wlResultList = Database.update(wlLst, false);
            for(Integer i=0;i<wlResultList .size();i++){
            
                if(!wlResultList[i].isSuccess()){
                     eLog = new RAD_Exception_Log__c();
                     eLog.RAD_Error_Source__c = 'Error when updating WL in RAD_NEDScheduler: '+ wlLst[i].id ;
                     eLog.RAD_Error_Message__c = 'NED Selection: '+wlResultList[i].getErrors();
                     eLog.RAD_Exception_Object_Name__c = 'Wait List Selection: '+wls.id;
    
                     excpLogs.add(eLog);
                }
            
            }
        }
        
        //INSERT THE SRs        
        if(!selRecList.isEmpty()){
            List<Database.SaveResult> srResultList = Database.insert(selRecList, false);
            RAD_checkTnumberafterSelection.checkTnumber(wlsidd);            
            for(Integer i=0;i<srResultList.size();i++){
            
                if(!srResultList[i].isSuccess()){
                     eLog = new RAD_Exception_Log__c();
                     eLog.RAD_Error_Source__c = 'Error when inserting SR in RAD_NEDScheduler: '+ selRecList[i].id ;
                     eLog.RAD_Error_Message__c = 'NED Selection: '+srResultList[i].getErrors();
                     eLog.RAD_Exception_Object_Name__c = 'Wait List Selection: '+wls.id;
    
                     excpLogs.add(eLog);
                }
            
            }
        }
        
        //UPDATE SELECTED CONTACT 7 SEP 2017
        if(!ctIds.isEmpty()){
            List<Contact> ctList = new List<Contact>();
            for(Contact ct : [Select Property_Code__c, RAD_Is_Selected__c from Contact where id in :ctIds]){
                ct.RAD_Is_Selected__c = true;
                ct.Property_Code__c = wls.Property_Code__c == null?0:Decimal.valueOf(wls.Property_Code__c);
                ctList.add(ct);
            }
            
            List<Database.SaveResult> ctResultList = Database.update(ctList, false);
            for(Integer i=0;i<ctResultList.size();i++){
            
                if(!ctResultList[i].isSuccess()){
                     eLog = new RAD_Exception_Log__c();
                     eLog.RAD_Error_Source__c = 'Error when updating Contact in RAD_NEDScheduler : '+ ctList[i].id ;
                     eLog.RAD_Error_Message__c = 'NED Selection - Contact Update : '+ ctResultList[i].getErrors();
                     eLog.RAD_Exception_Object_Name__c = 'Wait List Selection: '+wls.id;
    
                     excpLogs.add(eLog);
                }
            
            }
        }      
        
        if(!excpLogs.isEmpty()){
            Database.insert(excpLogs, false);
        }        
        
        wls.RAD_Temp_Eli_Count__c = tEli;
        wls.RAD_Temp_Vli_Count__c = tVli;
        wls.RAD_Temp_Li_Count__c = tLi;
        
        wls.RAD_Scheduler_Count__c = wls.RAD_Scheduler_Count__c != Null ? wls.RAD_Scheduler_Count__c - 1 : 0;
        
        if(tEli ==0 && tVli == 0 && tLi == 0 && tNumToSelect == 0 ){
            wls.RAD_Scheduler_Count__c = 0; //TODO IN  OTHERS
        }
        
        if(wls.RAD_Scheduler_Count__c == 0){
            wls.Status__c = 'Completed';
            // Set Application Trigger on during run.
            SwitchTrigger__c AppTrigger = SwitchTrigger__c.getInstance('Applications__c');
            if(AppTrigger != Null) {
                AppTrigger.Active__c = true;
                update AppTrigger;
            }            
        }
        

        
        try{
            update wls;
            
        }catch(Exception e){
            eLog = new RAD_Exception_Log__c();
            eLog.RAD_Error_Source__c = 'Error when updating WLS in RAD_NEDScheduler: '+ wls.id ;
            eLog.RAD_Error_Message__c = e.getMessage();
            eLog.RAD_Exception_Object_Name__c = 'Wait List Selection: '+wls.id;
            insert eLog;
            
        
        }
        
        String abortId = sc.getTriggerId();
        System.abortJob(abortId);
           
    }       
                
}