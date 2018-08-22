public class RAD_ApplicationHelper{
    
    private List<Applications__c> ApplicationRecs_new;
    private List<Applications__c> ApplicationRecs_old;
    public Map<Id, Applications__c> oldAppsMap;
    public Map<Id, Applications__c> newAppsMap;
    public Map<Id, String> appEmailMap;
    public RAD_Configuration__c confg = new RAD_Configuration__c();
 

    public RAD_ApplicationHelper(List<Applications__c> applicationRecs_new, List<Applications__c> applicationRecs_old)
    {
        this.confg = [select Update_Duration_Months__c, RAD_Purge_Extension_Months__c from  RAD_Configuration__c where name = 'Main Configurations' limit 1];
        this.ApplicationRecs_new = applicationRecs_new;
        this.ApplicationRecs_old = applicationRecs_old;
        newAppsMap= new Map<Id, Applications__c>();
        oldAppsMap= new Map<Id, Applications__c>();
        for(Applications__c app:ApplicationRecs_new){
            newAppsMap.put(app.Id, app);
        }
        if (ApplicationRecs_old<>null){
            for(Applications__c app:ApplicationRecs_old){
                oldAppsMap.put(app.Id, app);
            }
        }
        appEmailMap = new Map<Id, String>(); 
        for(Applications__c app:ApplicationRecs_new){
            System.debug('DLS App ids added to emailMap: '+ app.id);
            appEmailMap.put(app.id,'');            
        }
        List<Id> tempApps = new List<id>();
        tempApps.addAll(appEmailMap.keyset());
        System.debug('DLS tempApps collection is: '+ tempApps);
        for(Applications__c app:[SELECT applicant__r.email, applicant__r.paperless_email_only__c, applicant__r.EmailBouncedDate, id FROM Applications__c WHERE id IN :tempApps ]){
            if((app.applicant__r.EmailBouncedDate==null)&&(app.applicant__r.paperless_email_only__c)){
                appEmailMap.put(app.id,app.Applicant__r.email);
                System.debug('DLS Email being added to map: '+ app.id);
            }
        }
        
        
    }
    
    public void processApplnBeforeInsert(){
        
        if(!System.isBatch() && !System.isScheduled())
        {   
            Map<Id, Contact> mapCts = new Map<Id, Contact>();
            Set<Id> ctIds = new Set<Id>();
            Set<Id> setSubmittedApplicationContacts = new Set<Id>();
            //RAD_Configuration__c cnfg = [select Update_Duration_Months__c, RAD_Purge_Extension_Months__c from  RAD_Configuration__c where name = 'Main Configurations' limit 1];
            Integer totalMonths = Integer.valueOf(confg.Update_Duration_Months__c) + Integer.valueOf(confg.RAD_Purge_Extension_Months__c);
            
            for(Applications__c apl : (List<Applications__c>)Trigger.new)
            {
                ctIds.add(apl.Applicant__c);
                if(apl.Application_Status__c == 'Submitted')  
                {
                    setSubmittedApplicationContacts.add(apl.Applicant__c);
                    if(!(UserInfo.getName() =='Dell Boomi'))
                    {
                        apl.Send_To_Boomi__c=true;
                    }
                    apl.Applied_Date_time__c = Datetime.Now();  
                    Integer offset = UserInfo.getTimezone().getOffset(apl.Applied_Date_time__c);
                    Datetime dtLocal = (apl.Applied_Date_time__c).addSeconds(offset/1000);
                    apl.Applied_Date_Time_With_Seconds__c = (apl.Applied_Date_time__c).format('MM/dd/yyyy hh:mm:ss a');   
                    apl.RAD_Next_Purge_Request_Date__c = Datetime.Now().addMonths(Integer.valueOf(confg.Update_Duration_Months__c));
                    apl.RAD_Next_Purge_Date__c =  Datetime.Now().addMonths(totalMonths);                                                 
                }
                else if(apl.Application_Status__c == 'Saved')
                {
                    apl.RAD_Next_Purge_Request_Date__c = Null;
                    apl.RAD_Next_Purge_Date__c   = Null;
                }
                
                if(apl.Section_8__c)
                    apl.Mod_Rehab__c = true;
                if(apl.Dependents_Children_under_age_of_18__c == null)
                    apl.Dependents_Children_under_age_of_18__c = 0;
            }
            
            if(!(UserInfo.getName() == 'Dell Boomi'))
                setSendToBoomiOnContacts(setSubmittedApplicationContacts);
            
            mapCts = new Map<Id, Contact>([Select SSN_TaxID__c, Date_of_Birth__c, Gender__c, RAD_Homeless__c, Prospect_Number_YARDI__c, Tenant_Number_YARDI__c from Contact where id in :ctIds]);
            
            Contact ct = new Contact();
            for(Applications__c apln : (List<Applications__c>)trigger.new)
            {
                ct = mapCts.get(apln.Applicant__c);
                
                if(ct != null )
                {
                    apln.SSN__c = ct.SSN_TaxID__c;
                    apln.DOB__c = ct.Date_of_Birth__c;
                    apln.Gender__c = ct.Gender__c;
                    apln.Homeless__c = ct.RAD_Homeless__c;
                    apln.Prospect_Name__c = ct.Prospect_Number_YARDI__c;
                    apln.Tenant__c = ct.Tenant_Number_YARDI__c ;
                    //apln.Applied_Date_time__c = apln.Applied_Date_time__c != Null ? apln.Applied_Date_time__c : Datetime.Now();
                }
            }
        }
    }    
    
    public void processApplnAfterInsert(){
        
        if(!System.isBatch() && !System.isScheduled())
        {    
            //add pseudo ssn if not found after creating/inserting application -rhathi 23 Jun 2017
            //calc pref settings to be added in WL based on settings on Appln
            //calc income tgt to be added in WL based on settings on Appln
            //Next create WL based on settings on Appln and above
            //
            
            //PSEUDO SSN ENTRY
            List<Applications__c> applLst = [Select Applicant__c, Applicant__r.SSN_TaxID__c, Application_Status__c ,
                                             Spouse_Co_Head_If_applicable__c, Dependents_Children_under_age_of_18__c,
                                             Family__c, Homeless_with_disability__c, Live_Work_in_City_of_San_Diego__c, Non_Elderly_Disabled__c, Veteran_Family_of__c,
                                             Section_8__c, NED_Non_Elderly_Person_with_Disability__c, PBV_Project_Based__c, PBVS_Project_Based_Single__c , Public_Housing__c, 
                                             Family_Annual_Income__c, of_people_in_the_H_H_Adults__c, Applied_Date_time__c
                                             from Applications__c where id in : trigger.new];
            
            List<PSEUDO_SSN__c> pseudoLst = new List<PSEUDO_SSN__c>();
            PSEUDO_SSN__c pseudo = null;
            //applLst[0].Applied_Date__c=Datetime.Now();
            
            
            List<Enrolled_Wait_List__c> wlLst = new List<Enrolled_Wait_List__c>();
            Enrolled_Wait_List__c wl = new Enrolled_Wait_List__c();
            Wait_List_Type__c wltp = new Wait_List_Type__c();
            
            Map<String, Wait_List_Type__c> wltMap = new Map<String, Wait_List_Type__c>(); 
            for( Wait_List_Type__c wlt : [Select name, RADDisabled_Family__c, RADFamily__c, RADHomeless_with_disability__c, RADLive_Work_in_City_of_San_Diego__c,
                                          RADVeteran_Active_Military__c, RADNon_Elderly_Disabled__c from Wait_List_Type__c] ){
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
            
            
            
            List<RAD_Exception_Log__c> excpLogs = new List<RAD_Exception_Log__c>();
            RAD_Exception_Log__c eLog = new RAD_Exception_Log__c();
            
            
            for (Applications__c appl : applLst){
                if(String.isBlank(appl.Applicant__r.SSN_TaxID__c)){
                    pseudo = new PSEUDO_SSN__c();
                    pseudo.Contact__c = appl.Applicant__c;
                    pseudoLst.add(pseudo);
                }
                
                
                //CREATE USER SELECTED WLs
                if( appl.Section_8__c == true && appl.Application_Status__c =='Submitted' ){
                    wltp = wltMap.get('Section 8');            
                    wl = createWaitList(appl, wltp, wlIncInfo);
                    wl.YARDI_Wait_List_Type__c = '5';
                    
                    
                    wlLst.add(wl);
                    
                    //CREATE MOD REHAB        
                    wltp = wltMap.get('Mod Rehab');                
                    wl = createWaitList(appl, wltp, wlIncInfo);
                    wl.YARDI_Wait_List_Type__c = '1';
                    
                    wlLst.add(wl);
                    
                }
                
                //check NED
                if(appl.NED_Non_Elderly_Person_with_Disability__c== true && appl.Application_Status__c =='Submitted'){
                    wltp = wltMap.get('NED');
                    wl = createWaitList(appl, wltp, wlIncInfo);
                    //wl.YARDI_Wait_List_Type__c = '12';
                    wl.YARDI_Wait_List_Type__c = '10';
                    
                    //NO YARDI TYPE DEFINED
                    
                    wlLst.add(wl);                
                }
                
                
                if(appl.PBV_Project_Based__c == true  && appl.Application_Status__c =='Submitted'){
                    wltp = wltMap.get('Project Based');
                    wl = createWaitList(appl, wltp, wlIncInfo);
                    wl.YARDI_Wait_List_Type__c = '3';
                    
                    wlLst.add(wl);                
                }
                if(appl.PBVS_Project_Based_Single__c == true  && appl.Application_Status__c =='Submitted'){
                    wltp = wltMap.get('Project Based Single');
                    wl = createWaitList(appl, wltp, wlIncInfo);
                    wl.YARDI_Wait_List_Type__c = '4';
                    
                    wlLst.add(wl);                
                }
                
                if(appl.Public_Housing__c == true  && appl.Application_Status__c =='Submitted'){
                    wltp = wltMap.get('Public Housing');
                    wl = createWaitList(appl, wltp, wlIncInfo);
                    wl.YARDI_Wait_List_Type__c = '2';
                    
                    wlLst.add(wl);                                 
                    
                }     
                
            }
            
            if(!pseudoLst.isEmpty()){
                Database.insert(pseudoLst, false);
            }
            
            
            if(!wlLst.isEmpty()){
                List<Database.SaveResult> wlResultList = Database.insert(wlLst, false);
                for(Integer i=0;i<wlResultList .size();i++){
                    
                    if(!wlResultList[i].isSuccess()){
                        eLog = new RAD_Exception_Log__c();
                        eLog.RAD_Error_Source__c = 'Error when processing processApplnAfterInsert: '+ wlLst[i].id ;
                        eLog.RAD_Error_Message__c = 'Creating WL: '+wlResultList[i].getErrors();
                        
                        excpLogs.add(eLog);
                    }
                    
                }
            }
            
            
            if(!excpLogs.isEmpty()){
                Database.insert(excpLogs, false);
            }
            
            
            
        }
    }
    @future
    public static void saveWaitlist(String wl)
    {
        

    
    }
    
    public void processApplnBeforeUpdate()
    {
        Set<Id> setSubmittedApplicationContacts = new Set<Id>();
        //RAD_Configuration__c confg = [select Update_Duration_Months__c, RAD_Purge_Extension_Months__c from  RAD_Configuration__c where name = 'Main Configurations' limit 1];
        
        for(Applications__c appl:(List<Applications__c>)Trigger.new)
        {
            
            Integer totalMonths = Integer.valueOf(confg.Update_Duration_Months__c) + Integer.valueOf(confg.RAD_Purge_Extension_Months__c); 
            if(appl.Application_Status__c == 'Submitted')
            {
                setSubmittedApplicationContacts.add(appl.Applicant__c);
                if(!(UserInfo.getName() =='Dell Boomi'))
                {
                    appl.Send_To_Boomi__c=true;
                }
                if(appl.Applied_Date_time__c == Null)
                {
                    appl.Applied_Date_time__c = Datetime.Now();
                    Integer offset = UserInfo.getTimezone().getOffset(appl.Applied_Date_time__c);
                    Datetime dtLocal = (appl.Applied_Date_time__c).addSeconds(offset/1000);
                    appl.Applied_Date_Time_With_Seconds__c = (appl.Applied_Date_time__c).format('MM/dd/yyyy hh:mm:ss a');
                } 
                if(appl.Applied_Date_time__c != NULL)
                {
                    Integer offset = UserInfo.getTimezone().getOffset(appl.Applied_Date_time__c);
                    Datetime dtLocal = (appl.Applied_Date_time__c).addSeconds(offset/1000);
                    appl.Applied_Date_Time_With_Seconds__c = (appl.Applied_Date_time__c).format('MM/dd/yyyy hh:mm:ss a');
                }
                
                if(appl.RAD_Next_Purge_Request_Date__c == Null && appl.RAD_Next_Purge_Date__c == Null)  
                {
                    appl.RAD_Next_Purge_Request_Date__c = Datetime.Now().addMonths(Integer.valueOf(confg.Update_Duration_Months__c));
                    appl.RAD_Next_Purge_Date__c =  Datetime.Now().addMonths(totalMonths);                                                 
                }
                
                if(appl.Section_8__c)
                    appl.Mod_Rehab__c = true;
                if(appl.Dependents_Children_under_age_of_18__c == null)
                    appl.Dependents_Children_under_age_of_18__c = 0;
            }
            
            if(appl.Application_Status__c == 'Saved')
            {
                appl.RAD_Next_Purge_Request_Date__c = Null;
                appl.RAD_Next_Purge_Date__c   = Null;
            }
            if(appl.Application_Status__c == 'Update Required' && appl.Update_Confirmation__c == True)
            {
                appl.RAD_Last_Update_Date__c = Datetime.Now();
                appl.RAD_Next_Purge_Request_Date__c = Datetime.Now().addMonths(Integer.valueOf(confg.Update_Duration_Months__c));
                appl.RAD_Next_Purge_Date__c =  Datetime.Now().addMonths(totalMonths);
                appl.Application_Status__c = 'Submitted';
            } 
            
        }
        
        if(!(UserInfo.getName() == 'Dell Boomi'))
            setSendToBoomiOnContacts(setSubmittedApplicationContacts);
    }
    
    public void processApplnAfterUpdate(){
        List<Memo__c> mmoLst = new List<Memo__c>();
        if(!system.isBatch() && !System.isScheduled() && !System.isQueueable())
            
        {   
            EmailTemplate templateId_SD = [Select id from EmailTemplate 
                                           where name ='Status update email for applicants living /working in City of San Diego'];
            EmailTemplate templateId_NSD = [Select id from EmailTemplate 
                                            where name ='Status update email for applicants not living/working in City of San Diego'];
            
            //Send email to client if any of the public fields is edited:
            
            System.debug('DLS--processing update');
            if(!(UserInfo.getName() =='Dell Boomi')){
                sendEmailIfPublicInfoChanged();  
            }
            //Send email to client if any of the public fields is edited:
            List<Messaging.SingleEmailMessage> emailLst = new List<Messaging.SingleEmailMessage>();
            
            Map<String, Wait_List_Type__c> wltMap = new Map<String, Wait_List_Type__c>(); 
            for( Wait_List_Type__c wlt : [Select name, RADDisabled_Family__c, RADFamily__c, RADHomeless_with_disability__c, RADLive_Work_in_City_of_San_Diego__c,
                                          RADVeteran_Active_Military__c, RADNon_Elderly_Disabled__c from Wait_List_Type__c] ){
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
            
            
            
            
            List<Applications__c> applLst = [Select Id, Createddate,Applicant__c, Application_Status__c , 
                                             Spouse_Co_Head_If_applicable__c, Dependents_Children_under_age_of_18__c,
                                             Family__c, Homeless_with_disability__c, Live_Work_in_City_of_San_Diego__c, Applicant__r.Email, Applicant__r.Paperless_Email_only__c, Non_Elderly_Disabled__c, Veteran_Family_of__c,
                                             Section_8__c, NED_Non_Elderly_Person_with_Disability__c, PBV_Project_Based__c, PBVS_Project_Based_Single__c , Public_Housing__c,
                                             Family_Annual_Income__c, of_people_in_the_H_H_Adults__c, Applied_Date_time__c, 
                                             (Select Id,name, Applications__c ,Applications__r.of_people_in_the_H_H_Adults__c, Applications__r.Family__c, SFDC_Original_Datetime__c,
                                                 Applications__r.Spouse_Co_Head_If_applicable__c, Applications__r.Dependents_Children_under_age_of_18__c,
                                                 Applications__r.Homeless_with_disability__c, Applications__r.Live_Work_in_City_of_San_Diego__c, Applications__r.Non_Elderly_Disabled__c,
                                                 Applications__r.Veteran_Family_of__c, Applications__r.Applied_Date_time__c,
                                                 Applications__r.Family_Annual_Income__c, RAD_Applied_Date_and_Time__c,
                                                 Wait_List_Type__c, Wait_List_Type__r.Name,Current_Status__c from Enrolled_Wait_Lists__r),
                                             (Select name, Application__c , Application__r.Family__c, Application__r.Disabled_Family__c , Application__r.Elderly_Family__c ,
                                                 Application__r.Homeless_with_disability__c, Application__r.Live_Work_in_City_of_San_Diego__c, Application__r.Non_Elderly_Disabled__c,
                                                 Application__r.Homeless__c, Application__r.Veteran_Family_of__c, Application__r.Applied_Date_time__c,
                                                 End_Date__c, Status__c   from Preferences__r)
                                              from Applications__c where id in : trigger.new];       
            List<Enrolled_Wait_List__c> enrolledWL = new List<Enrolled_Wait_List__c>();
            List<Preferences__c> prefList = new List<Preferences__c>();
            for(Applications__c applRec: applLst)
            {
                if( ((Applications__c)Trigger.oldMap.get(applRec.id)).Application_Status__c != applRec.Application_Status__c){
                    
                    Memo__c mmo = new Memo__c();
                    
                    mmo.Name = 'Application updated to ' + applRec.Application_Status__c;
                    mmo.Type__c = 'Application';
                    if( applRec.Application_Status__c == 'Update Required')
                    {
                        mmo.Notes__c = 'Letter/email sent to applicant requesting response to Update' ;
                    }
                    if( applRec.Application_Status__c == 'Removed'&& applRec.Applied_Date_time__c!= Null)
                    {
                        Datetime dt = applRec.Applied_Date_time__c;
                        Integer yr = dt.year();
                        mmo.Notes__c = 'Update/Purge:  Removed/no update '+ yr;
                    }
                    if( applRec.Application_Status__c == 'Submitted')
                    {
                        mmo.Notes__c = 'Application Submitted' ;
                    }
                    if( ((Applications__c)Trigger.oldMap.get(applRec.id)).Application_Status__c =='Update Required' && applRec.Application_Status__c=='Submitted' && applRec.Applied_Date_time__c!= Null)
                    {
                        Datetime dt = applRec.Applied_Date_time__c;
                        Integer yr = dt.year();
                        mmo.Notes__c = 'Applicant responded to Update '+yr ;
                    }
                    
                    mmo.Applications__c = applRec.Id;
                    mmoLst.add(mmo);   
                }
                if (applRec.Enrolled_Wait_Lists__r <> Null)
                {
                    enrolledWL.AddAll(applRec.Enrolled_Wait_Lists__r);
                }
                if (applRec.Preferences__r <> Null)
                {
                    prefList.AddAll(applRec.Preferences__r);
                }
            }
            if(!mmoLst.isEmpty())
            {
                Upsert mmoLst;
                //insert mmoLst;
            } 
            //System.debug('radtest applLst '+applLst );
            
            //Select all WL this Application has, if it has any WL of specific type dont create WL for it, 
            //just update the WL if it is ONLIST
            
            List<Enrolled_Wait_List__c> wlLst = new List<Enrolled_Wait_List__c>();
            Enrolled_Wait_List__c wl = new Enrolled_Wait_List__c();
            Wait_List_Type__c wltp = new Wait_List_Type__c();
            Map<String, Set<Id>> wl2Appls = new Map<String, Set<Id>>();
            Set<Id>appl4section8 = new Set<Id>();
            Set<Id>appl4NED = new Set<Id>();
            Set<Id>appl4PbHsg = new Set<Id>();
            Set<Id>appl4PB = new Set<Id>();
            Set<Id>appl4PBsngl = new Set<Id>();
            
            Set<Id> appId = new Set<Id>();        
            
            List<RAD_Exception_Log__c> excpLogs = new List<RAD_Exception_Log__c>();
            RAD_Exception_Log__c eLog = new RAD_Exception_Log__c();
            
            if(!(UserInfo.getName() =='Dell Boomi'))
            {
                /*
                for(Enrolled_Wait_List__c wls : [Select name, Applications__c ,Applications__r.of_people_in_the_H_H_Adults__c, Applications__r.Family__c, SFDC_Original_Datetime__c,
                                                 Applications__r.Spouse_Co_Head_If_applicable__c, Applications__r.Dependents_Children_under_age_of_18__c,
                                                 Applications__r.Homeless_with_disability__c, Applications__r.Live_Work_in_City_of_San_Diego__c, Applications__r.Non_Elderly_Disabled__c,
                                                 Applications__r.Veteran_Family_of__c, Applications__r.Applied_Date_time__c,
                                                 Applications__r.Family_Annual_Income__c, RAD_Applied_Date_and_Time__c,
                                                 Wait_List_Type__c, Wait_List_Type__r.Name,Current_Status__c from Enrolled_Wait_List__c where Applications__c in: Trigger.New])
                */
                for (Enrolled_Wait_List__c wls : enrolledWL)
                {
                    
                    //eg, if there is a wl for sec 8 with any status, do not create WL, just update it if the wl status is onlist
                    if(wls.Wait_List_Type__r.Name == 'Section 8'){ 
                        appl4section8.add(wls.Applications__c );
                        if(wls.Current_Status__c == 'Onlist')
                        {
                            wlLst.add(wls);
                        }
                        
                    }
                    else if(wls.Wait_List_Type__r.Name == 'Mod Rehab'){ 
                        appl4section8.add(wls.Applications__c );
                        if(wls.Current_Status__c == 'Onlist')
                        {
                            wlLst.add(wls);//just mark the record for updation
                        }
                        
                    }
                    else if(wls.Wait_List_Type__r.Name == 'NED'){
                        appl4NED.add(wls.Applications__c );
                        if(wls.Current_Status__c == 'Onlist')
                        {
                            wlLst.add(wls);
                        }
                        
                    }
                    else if(wls.Wait_List_Type__r.Name == 'Project Based'){
                        appl4PB.add(wls.Applications__c );
                        if(wls.Current_Status__c == 'Onlist')
                        {
                            wlLst.add(wls);
                        }
                        
                    }
                    else if(wls.Wait_List_Type__r.Name == 'Project Based Single'){
                        appl4PBsngl.add(wls.Applications__c );
                        if(wls.Current_Status__c == 'Onlist')
                        {
                            wlLst.add(wls);
                        }
                        
                    }
                    else if(wls.Wait_List_Type__r.Name == 'Public Housing')
                    {
                        appl4PbHsg.add(wls.Applications__c );
                        if(wls.Current_Status__c == 'Onlist')
                        {
                            wlLst.add(wls);
                        }
                        
                    }
                    
                    
                    
                }
            }
            List<Preferences__c > prefLst = new List<Preferences__c >();
            List<Preferences__c > preferences_exist = new List<Preferences__c >();
            //Yardi preferences - make sure preferences base records exist otherwise create.
            if(!System.isBatch() && !(UserInfo.getName() =='Dell Boomi'))
            {
                if(prefList != Null)
                {
                    preferences_exist = prefList;
                }
                /*
                preferences_exist = [Select name, Application__c , Application__r.Family__c, Application__r.Disabled_Family__c , Application__r.Elderly_Family__c ,
                                     Application__r.Homeless_with_disability__c, Application__r.Live_Work_in_City_of_San_Diego__c, Application__r.Non_Elderly_Disabled__c,
                                     Application__r.Homeless__c, Application__r.Veteran_Family_of__c, Application__r.Applied_Date_time__c,
                                     End_Date__c, Status__c   from Preferences__c where Application__c in: Trigger.New];
                */
            }
            
            List<Preferences__c > preferences_listnew = new List<Preferences__c >();
            //update-submit create wl when none exist for that type
            
            for(Applications__c appl : applLst ){
                //System.debug('rhathi before chk');
                if( appl.Section_8__c == true && 
                   appl.Application_Status__c =='Submitted' && !appl4section8.contains(appl.id)){ 
                       
                       if(!(UserInfo.getName() =='Dell Boomi'))
                       {
                           wltp = wltMap.get('Section 8');     
                           wl = createWaitList(appl, wltp, wlIncInfo);
                           wl.YARDI_Wait_List_Type__c = '5';
                           
                           
                           wlLst.add(wl);
                           
                           wltp = wltMap.get('Mod Rehab');  
                           wl = createWaitList(appl, wltp, wlIncInfo);
                           wl.YARDI_Wait_List_Type__c = '1';
                           
                           wlLst.add(wl);
                       }
                   }
                
                if(  appl.NED_Non_Elderly_Person_with_Disability__c ==true && appl.Application_Status__c =='Submitted' && !appl4NED.contains(appl.id)){ 
                    
                    if(!(UserInfo.getName() =='Dell Boomi'))
                    {
                        wltp = wltMap.get('NED');
                        wl = createWaitList(appl, wltp, wlIncInfo);
                        //wl.YARDI_Wait_List_Type__c = '12';
                        wl.YARDI_Wait_List_Type__c = '10';
                        //NO YARDI TYPE DEFND              
                        
                        wlLst.add(wl);
                    }
                    
                    
                }
                
                if( appl.PBV_Project_Based__c == true && 
                   appl.Application_Status__c =='Submitted' && !appl4PB.contains(appl.id)){ 
                       
                       if(!(UserInfo.getName() =='Dell Boomi'))
                       {                    
                           wltp = wltMap.get('Project Based');
                           wl = createWaitList(appl, wltp, wlIncInfo);
                           wl.YARDI_Wait_List_Type__c = '3';
                           
                           wlLst.add(wl);
                       }                  
                       
                   }
                
                if( appl.PBVS_Project_Based_Single__c == true && 
                   appl.Application_Status__c =='Submitted' && !appl4PBsngl.contains(appl.id)){ 
                       
                       if(!(UserInfo.getName() =='Dell Boomi'))     
                       {               
                           wltp = wltMap.get('Project Based Single'); 
                           wl = createWaitList(appl, wltp, wlIncInfo);
                           wl.YARDI_Wait_List_Type__c = '4';
                           
                           
                           wlLst.add(wl);
                       }                  
                       
                       
                   }
                
                if( appl.Public_Housing__c && 
                   appl.Application_Status__c =='Submitted' && !appl4PbHsg.contains(appl.id)){ 
                       
                       if(!(UserInfo.getName() =='Dell Boomi'))
                       {
                           wltp = wltMap.get('Public Housing');  
                           wl = createWaitList(appl, wltp, wlIncInfo);
                           wl.YARDI_Wait_List_Type__c = '2';
                           
                           wlLst.add(wl);
                       }                    
                       
                   }
                if (!System.isBatch() && !(UserInfo.getName() =='Dell Boomi'))
                {
                    if(preferences_exist.size() == 0)
                    {
                        preferences_listnew = new List<Preferences__c>();
                        if(appl.Application_Status__c == 'Submitted')
                        {
                            preferences_listnew.add(new Preferences__c(Application__c = appl.Id, End_Date__c = DateTime.Parse('1/1/2100 12:00 AM'), Name = 'Live/Work in City of San Diego', Status__c = 'Inactive', Yardi_Preference_Code__c = '1'));
                            //preferences_listnew.add(new Preferences__c(Application__c = appl.Id, End_Date__c = appl.Createddate, Name = 'edfv', Status__c = 'Inactive', Yardi_Preference_Code__c = '3'));
                            preferences_listnew.add(new Preferences__c(Application__c = appl.Id, End_Date__c = DateTime.Parse('1/1/2100 12:00 AM'), Name = 'Veteran / Active Military', Status__c = 'Inactive', Yardi_Preference_Code__c = '5'));
                            preferences_listnew.add(new Preferences__c(Application__c = appl.Id, End_Date__c = DateTime.Parse('1/1/2100 12:00 AM'), Name = 'Elderly', Status__c = 'Inactive', Yardi_Preference_Code__c = '6'));
                            preferences_listnew.add(new Preferences__c(Application__c = appl.Id, End_Date__c = DateTime.Parse('1/1/2100 12:00 AM'), Name = 'Disabled', Status__c = 'Inactive', Yardi_Preference_Code__c = '7'));
                            preferences_listnew.add(new Preferences__c(Application__c = appl.Id, End_Date__c = DateTime.Parse('1/1/2100 12:00 AM'), Name = 'Family', Status__c = 'Inactive', Yardi_Preference_Code__c = '8'));
                            preferences_listnew.add(new Preferences__c(Application__c = appl.Id, End_Date__c = DateTime.Parse('1/1/2100 12:00 AM'), Name = 'Homeless with disability', Status__c = 'Inactive', Yardi_Preference_Code__c = '9'));
                        }
                        /*
preferences_listnew.add(new Preferences__c(Application__c = appl.Id, End_Date__c = DateTime.Parse('1/1/2100 12:00 AM'), Name = 'Live/Work in City of San Diego', Status__c = 'Active', Yardi_Preference_Code__c = '1'));
preferences_listnew.add(new Preferences__c(Application__c = appl.Id, End_Date__c = appl.Createddate, Name = 'edfv', Status__c = 'Active', Yardi_Preference_Code__c = '3'));
preferences_listnew.add(new Preferences__c(Application__c = appl.Id, End_Date__c = DateTime.Parse('1/1/2100 12:00 AM'), Name = 'Veteran / Active Military', Status__c = 'Active', Yardi_Preference_Code__c = '5'));
preferences_listnew.add(new Preferences__c(Application__c = appl.Id, End_Date__c = DateTime.Parse('1/1/2100 12:00 AM'), Name = 'Elderly', Status__c = 'Active', Yardi_Preference_Code__c = '6'));
preferences_listnew.add(new Preferences__c(Application__c = appl.Id, End_Date__c = DateTime.Parse('1/1/2100 12:00 AM'), Name = 'Disabled', Status__c = 'Active', Yardi_Preference_Code__c = '7'));
preferences_listnew.add(new Preferences__c(Application__c = appl.Id, End_Date__c = DateTime.Parse('1/1/2100 12:00 AM'), Name = 'Family', Status__c = 'Active', Yardi_Preference_Code__c = '8'));
preferences_listnew.add(new Preferences__c(Application__c = appl.Id, End_Date__c = DateTime.Parse('1/1/2100 12:00 AM'), Name = 'Homeless with disability', Status__c = 'Active', Yardi_Preference_Code__c = '9'));
*/
                        
                        
                    }    
                    
                }
            }//for
            if (preferences_listnew.size() > 0  )
            {
                insert preferences_listnew;
            }
            
            List<Database.UpsertResult> wlResultList = new List<Database.UpsertResult>();
            if(!wlLst.isEmpty()){
                wlResultList = Database.upsert(wlLst, false);
            }
            for(Integer i=0;i<wlResultList .size();i++){
                
                if(!wlResultList[i].isSuccess())
                {
                    eLog = new RAD_Exception_Log__c();
                    eLog.RAD_Error_Source__c = 'Error when processing processApplnAfterUpdate: '+wlLst[i].id ;
                    eLog.RAD_Error_Message__c = 'Updating WL: '+wlResultList[i].getErrors();
                    
                    excpLogs.add(eLog);
                }
                
            }
            
            if(!(UserInfo.getName() =='Dell Boomi'))
            {
                //SET YARDI PREFERENCES
                
                List<Preferences__c> preferences_list= preferences_listnew;
                /*
                [Select name, Application__c , Application__r.Family__c, Application__r.Disabled_Family__c , Application__r.Elderly_Family__c ,
                                                        Application__r.Homeless_with_disability__c, Application__r.Live_Work_in_City_of_San_Diego__c, Application__r.Non_Elderly_Disabled__c,
                                                        Application__r.Homeless__c, Application__r.Veteran_Family_of__c,
                                                        End_Date__c, Status__c   from Preferences__c where Application__c in: Trigger.New];
                */
                Boolean updtPref = false;
                for(Preferences__c pref : preferences_list)
                {
                
                    updtPref = false;
                    if(pref.Name == 'Live/Work in City of San Diego'){
                        if( pref.Application__r.Live_Work_in_City_of_San_Diego__c == true){
                            pref.Status__c ='Active';
                            pref.End_Date__c = Datetime.newInstance(2100, 1, 1, 0, 0, 0);
                            updtPref = true;
                        }else{
                            if(pref.Status__c == 'Active'){
                                pref.Status__c ='Inactive';
                                pref.End_Date__c = Datetime.now();
                                updtPref = true;
                            }
                        }
                    }
                    
                    //DELETED edfh and edfv
                    
                    if(pref.Name == 'Veteran / Active Military'){
                        if(pref.Application__r.Veteran_Family_of__c == true){
                            pref.Status__c ='Active';
                            pref.End_Date__c = Datetime.newInstance(2100, 1, 1, 0, 0, 0);
                            updtPref = true;
                        }else{
                            if(pref.Status__c == 'Active'){
                                pref.Status__c ='Inactive';
                                pref.End_Date__c = Datetime.now();
                                updtPref = true;
                            }
                        }
                    }
                    
                    if(pref.Name == 'Disabled'){
                        if(pref.Application__r.Disabled_Family__c  == true){//note the naming convention here 
                            pref.Status__c ='Active';
                            pref.End_Date__c = Datetime.newInstance(2100, 1, 1, 0, 0, 0);
                            updtPref = true;
                        }else{
                            if(pref.Status__c == 'Active'){
                                pref.Status__c ='Inactive';
                                pref.End_Date__c = Datetime.now();
                                updtPref = true;
                            }
                        }
                    }
                    
                    
                    if(pref.Name == 'Elderly'){
                        if(pref.Application__r.Elderly_Family__c == true){//note the naming convention here 
                            pref.Status__c ='Active';
                            pref.End_Date__c = Datetime.newInstance(2100, 1, 1, 0, 0, 0);
                            updtPref = true;
                        }else
                        {
                            if(pref.Status__c == 'Active'){
                                pref.Status__c ='Inactive';
                                pref.End_Date__c = Datetime.now();
                                updtPref = true;
                            }
                        }
                    }
                    
                    if(pref.Name == 'Family'){
                        if(pref.Application__r.Family__c == true){//note the naming convention here 
                            pref.Status__c ='Active';
                            pref.End_Date__c = Datetime.newInstance(2100, 1, 1, 0, 0, 0);
                            updtPref = true;
                        }else
                        {
                            if(pref.Status__c == 'Active'){
                                pref.Status__c ='Inactive';
                                pref.End_Date__c = Datetime.now();
                                updtPref = true;
                            }
                        }
                    }   
                    
                    if(pref.Name == 'Homeless with disability')
                    {
                        
                        if(pref.Application__r.Homeless_with_disability__c== true){              
                            pref.Status__c ='Active';
                            pref.End_Date__c = Datetime.newInstance(2100, 1, 1, 0, 0, 0);
                            updtPref = true;
                        }else
                        {
                            if(pref.Status__c == 'Active')
                            {
                                pref.Status__c ='Inactive';
                                pref.End_Date__c = Datetime.now();
                                updtPref = true;
                            }
                        }
                    }  
                    
                    if(updtPref == true){
                        // pref.Send_To_Boomi__c = true;
                        prefLst.add(pref);
                    }
                    
                }
                
                
                if(!prefLst.isEmpty())
                {
                    List<Database.SaveResult> pfResultList = Database.update(prefLst, false);
                    for(Integer i=0;i<pfResultList .size();i++){
                        
                        if(!pfResultList[i].isSuccess()){
                            eLog = new RAD_Exception_Log__c();
                            eLog.RAD_Error_Source__c = 'Error when processing YARDI preferences: '+ prefLst[i].id ;
                            eLog.RAD_Error_Message__c = 'Creating YARDI PREF: '+pfResultList[i].getErrors();
                            
                            excpLogs.add(eLog);
                        }
                        
                    }
                }
                
                
                
                if(!excpLogs.isEmpty())
                {
                    Database.insert(excpLogs, false);
                } 
            }
        }
    }
    
    /******* Manage all DML operations as needed  - Start- ******/ 
    public static void manageTrigger()
    {
        // Create handler and delegate events to methods
        RAD_ApplicationHelper applicationHandler = new RAD_ApplicationHelper(Trigger.new, Trigger.Old);
        
        if (Trigger.isInsert) 
        {
            if (Trigger.isBefore) 
            {
                applicationHandler.processApplnBeforeInsert();
            } 
            else if (Trigger.isAfter) 
            {
                applicationHandler.processApplnAfterInsert();
            }
            
        }
        if (Trigger.isUpdate) 
        {
            if (Trigger.isBefore) 
            {
                applicationHandler.processApplnBeforeUpdate();
            } 
            else if (Trigger.isAfter) 
            {
                applicationHandler.processApplnAfterUpdate();       
            }
        }
    }     
    
    public static Enrolled_Wait_List__c createWaitList(Applications__c appl,Wait_List_Type__c wltp,  List<Wait_List_Income_Limit_Details__c> wlIncInfo)
    {
        //System.debug('creating WaitList');
        Enrolled_Wait_List__c wl = new Enrolled_Wait_List__c();
        
        wl.Wait_List_Type__c = wltp.id;
        
        //strConvertedDate =   Datetime.now().format('MM/dd/yyyy HH:mm:ss a', 'America/New_York');//EDT
        //String strConvertedDate =   Datetime.now().format('MM/dd/yyyy HH:mm:ss a', 'America/Los_Angeles');//PDT
        //wl.RAD_Date_and_Time_with_Seconds__c = strConvertedDate;
        wl.RAD_Applied_Date_and_Time__c = appl.Applied_Date_time__c;
        //wl.SFDC_Original_Datetime__c = RAD_Utils.convertStringToDate(wl.RAD_Date_and_Time_with_Seconds__c);
        wl.SFDC_Original_Datetime__c = wl.RAD_Applied_Date_and_Time__c;
        
        wl.Current_Status__c = 'Onlist';
        wl.Status__c = 'On List';
        wl.Portal_Status__c = 'Active';
        wl.Reason__c = 'Active';
        wl.Applications__c = appl.id;
        wl.Current_Status_Date_Time__c = wl.RAD_Applied_Date_and_Time__c;
        
        return wl;
    }
    
    /*
Set 'Send to Boomi flag' on contacts if the Application corresponding to the contact is in Submitted Status
*/

    public static void setSendToBoomiOnContacts(Set<Id> setContactIds)
    {
        //Retrieve all contacts related to the submitted list of applications. setContactIds contains all contacts that satisfy this criteria
        List<Contact> lstContacts = [SELECT Id, Send_To_Boomi__c FROM Contact WHERE Id IN :setContactIds LIMIT 1000];
        
        //Set Contact.Send_To_Boomi__c as TRUE only for submitted applications
        if(lstContacts != null && !lstContacts.isEmpty())
        {
            for(Contact c : lstContacts)
                c.Send_To_Boomi__c = true;
            
            update lstContacts;
        }
    }

    public void sendEmailIfPublicInfoChanged(){
         EmailTemplate templateId_SD;
         EmailTemplate templateId_NSD;
    
        System.debug('DLS--Entering method');
        
        System.debug('*****Code is being called. Batch status is '+ System.isBatch());
        //Create list to hold all outgoing emails
        transient List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        List<EmailTemplate> templates = [Select DeveloperName, id from EmailTemplate 
                                         where DeveloperName in ('Status_update_email','Status_update_email_not_living')];
        for(EmailTemplate e:templates){
            if (e.DeveloperName =='Status_update_email')
                templateId_SD=e;
            else if (e.DeveloperName =='Status_update_email_not_living')
                templateId_NSD=e;
        }
        //Has it changed?
        transient Boolean changed = false;
        
        //Iterate through the applications in the trigger        
        for(Applications__c app:this.newAppsMap.values()){
            if(appEmailMap.get(app.id)!=null){    
                changed = false;
                if (app.Spouse_Co_Head_If_applicable__c<>(oldAppsMap.get(app.id).Spouse_Co_Head_If_applicable__c)){
                    changed = true;
                }
                if (app.Spouse_Date_of_Birth__c<>(oldAppsMap.get(app.id).Spouse_Date_of_Birth__c)){
                    changed = true;
                }
                if (app.First_Name__c<>(oldAppsMap.get(app.id).First_Name__c)){
                    changed = true;
                }
                if (app.Last_Name__c<>(oldAppsMap.get(app.id).Last_Name__c)){
                    changed = true;
                }
                if (app.Spouse_SSN__c<>(oldAppsMap.get(app.id).Spouse_SSN__c)){
                    changed = true;
                }
                if (app.Total_People__c<>(oldAppsMap.get(app.id).Total_People__c)){
                    changed = true;
                }
                if (app.Dependents_Children_under_age_of_18__c<>(oldAppsMap.get(app.id).Dependents_Children_under_age_of_18__c)){
                    changed = true;
                }
                if (app.Family_Annual_Income__c<>(oldAppsMap.get(app.id).Family_Annual_Income__c)){
                    changed = true;
                }
                if (app.Are_you_in_Active_duty_with_US_Army__c<>(oldAppsMap.get(app.id).Are_you_in_Active_duty_with_US_Army__c)){
                    changed = true;
                }
                if (app.Are_you_or_your_spouse_co_head_disabled__c<>(oldAppsMap.get(app.id).Are_you_or_your_spouse_co_head_disabled__c)){
                    changed = true;
                }
                if (app.Are_you_veteran_or_a_family_of_a_ventera__c<>(oldAppsMap.get(app.id).Are_you_veteran_or_a_family_of_a_ventera__c)){
                    changed = true;
                }
                if (app.Employment_Zip_Code__c<>(oldAppsMap.get(app.id).Employment_Zip_Code__c)){
                    changed = true;
                }
                if (app.Occupation__c<>(oldAppsMap.get(app.id).Occupation__c)){
                    changed = true;
                }
                if (app.Ethnicity__c<>(oldAppsMap.get(app.id).Ethnicity__c)){
                    changed = true;
                }
                if (app.Citizenship__c<>(oldAppsMap.get(app.id).Citizenship__c)){
                    changed = true;
                }
                if (app.White__c<>(oldAppsMap.get(app.id).White__c)){
                    changed = true;
                }
                if (app.Black__c<>(oldAppsMap.get(app.id).Black__c)){
                    changed = true;
                }
                if (app.Asian__c<>(oldAppsMap.get(app.id).Asian__c)){
                    changed = true;
                }
                if (app.American_Indian__c<>(oldAppsMap.get(app.id).American_Indian__c)){
                    changed = true;
                }
                if (app.Pacific_Islander__c<>(oldAppsMap.get(app.id).Pacific_Islander__c)){
                    changed = true;
                }
                if (app.Near_Elderly__c<>(oldAppsMap.get(app.id).Near_Elderly__c)){
                    changed = true;
                }
                if (app.Elderly__c<>(oldAppsMap.get(app.id).Elderly__c)){
                    changed = true;
                }
                if (app.Homeless__c<>(oldAppsMap.get(app.id).Homeless__c)){
                    changed = true;
                }
                if (app.Disable__c<>(oldAppsMap.get(app.id).Disable__c)){
                    changed = true;
                }
                if (app.Displaced__c<>(oldAppsMap.get(app.id).Displaced__c)){
                    changed = true;
                }
                if (app.Hearing_Access__c<>(oldAppsMap.get(app.id).Hearing_Access__c)){
                    changed = true;
                }
                if (app.Mobility_Access__c<>(oldAppsMap.get(app.id).Mobility_Access__c)){
                    changed = true;
                }
                if (app.Sight_Access__c<>(oldAppsMap.get(app.id).Sight_Access__c)){
                    changed = true;
                }
                if (app.Did_anyone_helped_you_to_submit_the_info__c<>(oldAppsMap.get(app.id).Did_anyone_helped_you_to_submit_the_info__c)){
                    changed = true;
                }
                if (app.Agency_Contact_Email__c<>(oldAppsMap.get(app.id).Agency_Contact_Email__c)){
                    changed = true;
                }
                if (app.Agency_Contact_Name__c<>(oldAppsMap.get(app.id).Agency_Contact_Name__c)){
                    changed = true;
                }
                if (app.Agency_Contact_Phone__c<>(oldAppsMap.get(app.id).Agency_Contact_Phone__c)){
                    changed = true;
                }
                if (app.Agency_List__c<>(oldAppsMap.get(app.id).Agency_List__c)){
                    changed = true;
                }
                if (app.Enter_Agency_name_if_selected_other__c<>(oldAppsMap.get(app.id).Enter_Agency_name_if_selected_other__c)){
                    changed = true;
                }
                System.debug('DLS--changed = '+changed);
                
                
                
                if (changed){
                    
                    
                    
                    //Create an email for this app            
                    transient Messaging.SingleEmailMessage newEmail = new Messaging.SingleEmailMessage();
                    System.debug('DLS--creating email');
                    
                    
                    // Set Template -- TEST WHAT TO DO IF TEMPLATES DON'T EXIST -- PLAIN TEXT
                    if(app.Live_Work_in_City_of_San_Diego__c)
                        newEmail.templateid=templateId_SD.id;
                    else
                        newEmail.templateid=templateId_NSD.id;
                    
                    // Send to app email address
                    system.debug('DLS--Email is '+ appEmailMap.get(app.id));
                    newEmail.toaddresses=new List<String>();
                    if(appEmailMap.get(app.id)<>''){
                        newEmail.toaddresses.add(appEmailMap.get(app.id));
                        newEmail.saveAsActivity = false;
                        // Set From address
                        newEmail.setReplyTo('no-reply@sdhc.org');
                        newEmail.setSenderDisplayName('SDHC');
                        //Set target object did
                        newEmail.setTargetObjectId(app.Applicant__c);
                        newEmail.setWhatId(app.id);
                        System.debug('DLS--new email:'+newEmail);
                        emails.add(newEmail);
                    }
                    else
                    {
                        
                        createMemo(app.id);
                        
                    }
                    
                }
            }
            //ID jobID = System.enqueueJob(new RAD_QueueableApplicationUpdateEmail(emails));
            
            System.debug('*****calling sendEmail from DLS code');
            if (emails.size()>0){
                Messaging.SendEmailResult[] results = Messaging.sendEmail(emails);
                System.debug('DLS-- email results: '+ results);
                for(Messaging.SendEmailResult res:results)
                    if (res.success) 
                {
                    System.debug('DLS--The email was sent successfully.');
                    
                } else 
                {   //Go through the results and set up memos for failed emails
                    System.debug('DLS--The email failed.');
                    createMemo(res.getErrors()[0].getTargetObjectId());
                    
                }
            }
        } 
    }
    
    public static void createMemo(Id targetId){
        System.debug('DLS--The email failed to send');
        Memo__c newMemo = new Memo__c();
        newMemo.applications__c = targetId;
        newMemo.Action__c = 'Email failed';
        newMemo.Status__c='Completed';
        newMemo.Name='Email failed after application change';
        newMemo.Action_Date__c = DateTime.now();
        newMemo.notes__c = 'Email failed after application change';
        newMemo.ErrorMemoType__c='FieldUpdateEmailFailure';
        System.debug('DLS--memo created: '+ newMemo);
        insert newMemo;
    }
}