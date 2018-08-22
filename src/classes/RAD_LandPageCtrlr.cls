global class RAD_LandPageCtrlr {
    public List<Enrolled_Wait_List__c> enwaitlst { get; set; }  
    public List<Enrolled_Wait_List__c> wlsToUpdate {get;set;}
    public String CSSURL {get; set;}
    public String JSURL {get; set;}
    public Applications__c theApp {get; set;}
    public Boolean userLoggedIn{get;set;}{userLoggedIn = false;}//org rhathi
  
    public String loggedInUserName{get;set;}{loggedInUserName = '';}
    public String loggedInUser{get;set;}{loggedInUser = '';}
    public List<Applications__c> userApplications{get;set;}{userApplications = new List<Applications__c>();}
    public contactWrapper userContactandApplicationDetails{get;set;}{userContactandApplicationDetails = new contactWrapper();}
    public String jsonstring{get;set;}{jsonstring = '';}
    public String annSubject {get;set;}
    public String annDetail {get;set;}
    public RAD_Configuration__c anncnfg {get;set;}
    public string MonthRegister{get;set;}    
    
    public RAD_LandPageCtrlr(){
        //userLoggedIn = false;
        getContactandApplication(); 
             
    }   
    
    public PageReference init() {
        string comid = Network.getNetworkId();
        if(UserInfo.getUserType() == 'Guest' || UserInfo.getUserId() == null){
            String startUrl = System.currentPageReference().getParameters().get('startURL');
             return new pagereference(Site.getPathPrefix()+'/RADNewLand');           
            //return new PageReference(Network.getLoginUrl(comid));
            //return new PageReference('https://waitlist-sdhcportal.cs32.force.com/RADWL/RADNewLand');
        }
        else{
            //Clear the previous cookies
            System.Cookie cookieNameObj= ApexPages.currentPage().getCookies().get('Name');
            System.debug('DLS--getCookies is '+ ApexPages.currentPage().getCookies());
            System.debug('DLS--cookieNameObj is '+ cookieNameObj);
            if (cookieNameObj <>null){
                String cookieName=cookieNameObj.getName();
                // create a new cookie with name , an initial value of Name at the page,   
                // path 'null', maxAge '-1', and isSecure 'false'. 
                System.Cookie newCookie=new System.Cookie(cookieName,'',null,-1,true);
                ApexPages.currentPage().setCookies(new Cookie[]{newCookie});
                }
            userLoggedIn = true;
            //PageReference pr = new PageReference('RADNewLand');
            loggedInUserName = UserInfo.getName();
            loggedInUser=UserInfo.getUsername();
             return null;
        }
    }    
    
    public contactWrapper getContactandApplication(){
        User UserRec = [select Id,ContactId,contact.name from User where Id = :Userinfo.getUserId()];
        
        /*userApplications = [select Id,Name,SEC8_Enrollment_Date__c,Portal_Status__c
                                              from Applications__c 
                    where Applicant__c = : UserRec.ContactId];*/
        contactWrapper cw = new contactWrapper();
        try{

            contact cont=[SELECT Id, 
                                firstname, lastname,
                                SSN_TaxID__c, Phone,
                                Email, MailingStreet,
                                MailingCity, MailingState,Age__c,Age1__c,
                                MailingPostalCode,Sandiago_checkbox__c, Date_of_Birth__c, RAD_Homeless__c, Residential_City__c,Residential_State__c,Residential_Street__c,Residential_Zipcode__c,
                                Gender__c, Paperless_Email_only__c, Do_not_Have__c,
                                (SELECT Id, Name,
                                        Portal_Status__c,
                                        of_people_in_the_H_H_Adults__c, White__c, 
                                        Veteran_Family_of__c,Sight_Access__c, 
                                        Spouse_SSN__c, Spouse_Date_of_Birth__c,Pacific_Islander__c, 
                                        Occupation__c, Non_Elderly_Disabled__c, 
                                        Near_Elderly__c, Mobility_Access__c, 
                                        Middle_Name__c, Live_Work_in_City_of_San_Diego__c, 
                                        Last_Name__c, Homeless_with_disability__c, 
                                        Homeless__c, Hearing_Access__c, 
                                        First_Name__c, Family__c, 
                                        Ethnicity__c, 
                                        Employment_Zip_Code__c,Elderly__c, Family_Annual_Income__c,
                                        Education__c, Displaced__c, 
                                        Disabled_Family__c, Disable__c,Agency_List__c, 
                                        Dependents_Children_under_age_of_18__c, 
                                        DOB__c, Citizenship__c,Agency_Contact_Email__c,Spouse_Co_Head_If_applicable__c, 
                                        Black__c, Mod_Rehab__c, Agency_Contact_Name__c,Did_anyone_helped_you_to_submit_the_info__c,
                                        Section_8__c, NED_Non_Elderly_Person_with_Disability__c,Elderly_Family__c,
                                        PBVS_Project_Based_Single__c, Asian__c,Agency_Contact_Phone__c, 
                                        Are_you_veteran_or_a_family_of_a_ventera__c, PBV_Project_Based__c,
                                        Public_Housing__c, Are_you_or_your_spouse_co_head_disabled__c, 
                                        Are_you_in_Active_duty_with_US_Army__c,American_Indian__c,age__c, Enter_Agency_name_if_selected_other__c,
                                        Application_status__c
                                        FROM 
                                        Applications_WL_00000001__r 
                                        WHERE Application_status__c <> 'Closed'
                                        ORDER BY CREATEDDATE DESC)
                                FROM 
                                Contact 
                                where Id=:UserRec.contactId]; //RHATHI 01 JULY 2017..Where clause and order by
            
            
            cw.Cnt = cont;
            if(cont.Applications_WL_00000001__r.size() >0){
                cw.contactApplication = cont.Applications_WL_00000001__r[0];
                userApplications = cont.Applications_WL_00000001__r;
                if(userApplications.size() > 0){
                    /* enwaitlst = [select Id, Name, Applications__r.Name, Wait_List_Type__c,Wait_List_Type__r.Name, Wait_List_Type__r.Long_Description__c, Current_Status__c, RAD_Date_and_Time_with_Seconds__c, Portal_Status__c from Enrolled_Wait_List__c
                                       where Applications__c = :userApplications[0].id];   */// satya-6/19/207- (Date_and_Time__c,Portal_Status__c)


  enwaitlst = [select Id, Name, Applications__r.Name, Wait_List_Type__c,Wait_List_Type__r.Name, Wait_List_Type__r.Long_Description__c, Current_Status__c, SFDC_Original_Datetime__c, Portal_Status__c from Enrolled_Wait_List__c
                                       where Applications__c = :userApplications[0].id  and Wait_List_Type__r.Name In ('Section 8','Mod Rehab','Project Based Single','Public Housing','Project Based','NED')];   

                    getEnrollmentDetails(cw, enwaitlst);
                }
            }
            else{
                cw.contactApplication = new Applications__c();
            }        
        }
        catch(Exception e){
            
            System.Debug('Exception--- IN Landing Page Ctrl---->'+e.getMessage());
        }
        finally{
            userContactandApplicationDetails = cw;
            jsonstring = JSON.serialize(cw);
            System.Debug('JSONFormat'+jsonstring);
            getAnnouncement(); 
        }
        return userContactandApplicationDetails;
    }
    
    private void getEnrollmentDetails(contactWrapper cwrpr,  List<Enrolled_Wait_List__c> ewlst){
        for(Enrolled_Wait_List__c wl : ewlst){
            
            if(wl.Wait_List_Type__r.Name == 'Section 8' && wl.Current_Status__c != 'Removed'){
                cwrpr.section8Enrld =true;
            }
            
            if(wl.Wait_List_Type__r.Name == 'Project Based' && wl.Current_Status__c != 'Removed'){
                cwrpr.PBVProjBsdEnrld = true;
            }
            
            if(wl.Wait_List_Type__r.Name == 'Project Based Single' && wl.Current_Status__c != 'Removed'){
                cwrpr.PBVSProjBsdSnglEnrld = true;
            }
            
            if(wl.Wait_List_Type__r.Name == 'NED' && wl.Current_Status__c != 'Removed'){
                cwrpr.NEDEnrld = true;
            }
            if(wl.Wait_List_Type__r.Name == 'Public Housing' && wl.Current_Status__c != 'Removed'){
            
                cwrpr.publicHsgEnrld = true;
            }
            
        }
        //return;
    }
    //This method is used to display announcement on Landing page.
    //RHATHI 15 JUN 2017
    public void getAnnouncement(){
        annSubject = '';
        annDetail = '';
        //if( userLoggedIn ){
            System.debug('rhathi, user has logged in');
            anncnfg = [select Announcement_Subject__c,Announcement__c from  RAD_Configuration__c where name = 'Main Configurations' limit 1];
            annSubject = annCnfg.Announcement_Subject__c;
            annDetail = annCnfg.Announcement__c;
            
        //}
        
        System.debug('rhathi subject is '+annSubject );
    }
    
    
    @RemoteAction
    global static Applications__c saveSubmit(string userApplication, String cont, String action){       
        
        //system.debug('the user application is---------->'+userApplication);
        //system.debug('the cont is----->'+cont);

        try {
            Applications__c app = new Applications__c();
            Contact UserCont = new Contact();
            if(cont != null){
                UserCont = (Contact)Json.deserialize(cont,Contact.class);
                system.Debug(UserCont);
                //update UserCont;
                
                List<User> lstLoggedInUser = [SELECT Id, LastName FROM User WHERE ContactId = :UserCont.Id AND LastName <> :UserCont.LastName LIMIT 1];
                if(lstLoggedInUser != null && lstLoggedInUser.size() == 1)
                {
                    lstLoggedInUser[0].LastName = UserCont.LastName;
                    update lstLoggedInUser;
                }
            }
            
            if(app != null){
                app = (Applications__c)Json.deserialize(userApplication,Applications__c.class);
                system.Debug(app);
            }
            
            //RHATHI 02 JULY 2017
            
            List<Applications__c> lstApp = [Select Application_status__c from applications__c where id =:app.id];
            if(!lstApp.isEmpty()){
                
                if(lstApp[0].Application_status__c == 'Closed' ){
                     app.Application_status__c = 'Closed';//dont update just return back
                     return app;
                }
                
            }
            
            system.debug('ACTION: ' + action);
            if(app.Applicant__c == null){
                if(UserCont == null){
                    set<Id> idSet = new set<Id>();
                    system.debug('USER INFO: ' + UserInfo.getUserId());                
                    idSet.add(UserInfo.getUserId());
                    idSet.add('005r0000001IqLg');
                
                    for(User usr : [select ContactId, Id from user where Id IN :idSet]){
                        if(usr.contactId != null){
                            app.Applicant__c = usr.contactId;
                        }
                        else{
                            app.Applicant__c = usr.contactId;
                        }
                    }
                }
                else{
                    app.Applicant__c = UserCont.Id;
                }
            }           
            
            System.debug('the spouse dob is '+app.Spouse_Date_of_Birth__c);

            if(action.equals('save')){                              
                app.Application_Status__c = 'Saved';
                app.Applied_Date_time__c = Null;
                app.RAD_Next_Purge_Request_Date__c = Null;
                app.RAD_Next_Purge_Date__c =  Null;
            }
            else if(action.equals('submit')){
                // Save Application first
                               
                app.Application_Status__c = 'Submitted';
                for (Applications__c App_list : [Select Id, Applied_Date_time__c from applications__c where id =:app.id])
                {
                    app.Applied_Date_time__c = App_list.Applied_Date_time__c;
                }
                if (app.Applied_Date_time__c == Null)
                {
                    app.Applied_Date_time__c = Datetime.now();
                }
                
                RAD_Configuration__c cnfg = [select Update_Duration_Months__c, RAD_Purge_Extension_Months__c from  RAD_Configuration__c where name = 'Main Configurations' limit 1];
                Integer totalMonths = Integer.valueOf(cnfg.Update_Duration_Months__c) + Integer.valueOf(cnfg.RAD_Purge_Extension_Months__c);
                app.Application_status__c = 'Submitted';
                app.RAD_Last_Update_Date__c = Datetime.Now();
                app.RAD_Next_Purge_Request_Date__c = Datetime.Now().addMonths(Integer.valueOf(cnfg.Update_Duration_Months__c));
                app.RAD_Next_Purge_Date__c =  Datetime.Now().addMonths(totalMonths);
                
            }
            
            system.debug('application Id is----------->' + app);
            if(app.Id != null){
                system.debug('The app that should be updated'+app);
                
                String zipInfo = getZipCodeLocation(UserCont.Residential_Zipcode__c, app.Employment_Zip_Code__c);
              
                if(zipInfo == 'San Diego'){
                    app.Live_Work_in_City_of_San_Diego__c = true;
                }else{
                    app.Live_Work_in_City_of_San_Diego__c = false;
                }
                
                update(app); 
               
                // Update Removed  WaitList  
                
            set<String> setApplicableWaitlists = new set<string>();
            if(app.Section_8__c == true)
                setApplicableWaitlists.add('Section 8');
            if(app.PBV_Project_Based__c == true)  
                setApplicableWaitlists.add('Project Based');
            if(app.PBVS_Project_Based_Single__c == true)  
                setApplicableWaitlists.add('Project Based Single');
            if(app.Public_Housing__c == true)   
                setApplicableWaitlists.add('Public Housing');
                System.debug(app.Public_Housing__c);
            if(app.NED_Non_Elderly_Person_with_Disability__c == true)   
                setApplicableWaitlists.add('NED');
                     
            List<Enrolled_Wait_List__c> wlsToUpdate =[SELECT Id, Applications__c, Current_Status__c, Current_Status_Date_Time__c, SFDC_Original_Datetime__c FROM Enrolled_Wait_List__c WHERE (Applications__c = :app.id AND Wait_List_Type__r.Name IN :setApplicableWaitlists AND Current_Status__c= 'Removed')];
            if(wlsToUpdate != NULL && wlsToUpdate.size() > 0)
            {
                for(Enrolled_Wait_List__c enWL:wlsToUpdate)
                { 
                    enWL.Current_Status__c = 'Onlist';
                    enWL.Current_Status_Date_Time__c = Datetime.Now();
                    enWL.SFDC_Original_Datetime__c = Datetime.Now();
                }
                update wlsToUpdate;
                ID AppToUpdate = wlsToUpdate[0].Applications__c;
                updateApplication(AppToUpdate);
                system.debug(wlsToUpdate);
              /*RAD_Configuration__c cnfg = [select Update_Duration_Months__c, RAD_Purge_Extension_Months__c from  RAD_Configuration__c where name = 'Main Configurations' limit 1];
                Integer totalMonths = Integer.valueOf(cnfg.Update_Duration_Months__c) + Integer.valueOf(cnfg.RAD_Purge_Extension_Months__c);
                
                
                app.RAD_Last_Update_Date__c = Datetime.Now();
                system.debug('TIMEEEE');
                system.debug(app.RAD_Last_Update_Date__c);
                app.RAD_Next_Purge_Request_Date__c = Datetime.Now().addMonths(Integer.valueOf(cnfg.Update_Duration_Months__c));
                app.RAD_Next_Purge_Date__c =  Datetime.Now().addMonths(totalMonths);
                update app; */
            } 

            }
            else {
                app.Id = null;
                
                String zipInfo = getZipCodeLocation(UserCont.Residential_Zipcode__c, app.Employment_Zip_Code__c);
                
                if(zipInfo == 'San Diego'){
                    app.Live_Work_in_City_of_San_Diego__c = true;
                }else{
                    app.Live_Work_in_City_of_San_Diego__c = false;
                }
               // app.Applied_Date_time__c = Datetime.now();
                
                insert(app);
                for(Applications__c application : [Select a.Name, a.of_people_in_the_H_H_Adults__c, 
                                                   a.White__c, a.Veteran_Family_of__c, a.Sight_Access__c, 
                                                   a.Spouse_SSN__c,a.Spouse_Date_of_Birth__c, a.Pacific_Islander__c,a.Section_8__c,
                                                   a.NED_Non_Elderly_Person_with_Disability__c,a.PBVS_Project_Based_Single__c, 
                                                   a.Occupation__c, a.Non_Elderly_Disabled__c, 
                                                   a.Near_Elderly__c, a.Mobility_Access__c, a.Middle_Name__c, 
                                                   a.Live_Work_in_City_of_San_Diego__c, a.Last_Name__c, 
                                                   a.Homeless_with_disability__c, a.Homeless__c,a.Agency_Contact_Phone__c, 
                                                   a.Hearing_Access__c, a.First_Name__c, a.Family__c,a.Agency_Contact_Name__c, 
                                                   a.ethnicity__c,a.PBV_Project_Based__c, a.Family_Annual_Income__c, 
                                                   a.Employment_Zip_Code__c, a.Elderly__c, a.Education__c,a.Spouse_Co_Head_If_applicable__c,
                                                   a.Displaced__c, a.Disabled_Family__c, a.Disable__c,a.Agency_Contact_Email__c, 
                                                   a.Dependents_Children_under_age_of_18__c, a.DOB__c,a.Did_anyone_helped_you_to_submit_the_info__c, 
                                                   a.Citizenship__c, a.Black__c, a.Asian__c,a.Public_Housing__c,a.Mod_Rehab__c, 
                                                   a.Are_you_veteran_or_a_family_of_a_ventera__c,a.Agency_List__c,a.Elderly_Family__c,
                                                   a.Are_you_or_your_spouse_co_head_disabled__c, 
                                                   a.Are_you_in_Active_duty_with_US_Army__c, a.Enter_Agency_name_if_selected_other__c, 
                                                   a.American_Indian__c, a.age__c 
                                                   From Applications__c a where Id = :app.id 
                                                   AND Application_status__c <> 'Closed'
                                                   ORDER BY CREATEDDATE DESC 
                                                   Limit 1]){   //RHATHI 01 JULY 2017..Where clause and order by                                                                         
                    app = application;
                }
            }               
            system.debug('the updated app is------->'+ app);
            system.debug('the updated dob is------->'+app.DOB__c);
            system.debug('the updated dob is------->'+app.age__c);
             
            return app;
        }
        catch(Exception e){
            system.debug(e.getMessage() +'  '+e.getStackTraceString());
            return null;
            //return 'FAIL : ' + e.getMessage();            
        }           
    }
    
    @RemoteAction
    public static contact profile_In_Appl(){
        
        user u=[select Id,contactId from user where Id=:Userinfo.getUserId()];
        contact cont=[select Id,firstname,lastname,SSN_TaxID__c,Phone,Email,MailingStreet,
                       MailingCity,MailingState,MailingPostalCode,Date_of_Birth__c,Gender__c,
                      Paperless_Email_only__c, Do_not_Have__c
                       from contact where Id=:u.contactId];
        
        return cont;
    }
    
    @RemoteAction
    global static Applications__c getApplication(String Id){
        if((id != null && id != 'undefined')|| id.length() > 0){          
            List<Applications__c> app = new List<Applications__c>();
            for(Applications__c application : [Select a.Name, a.of_people_in_the_H_H_Adults__c, a.White__c, a.Veteran_Family_of__c, a.Sight_Access__c, a.Spouse_SSN__c, a.Spouse_Date_of_Birth__c,a.Pacific_Islander__c, 
                                                a.Occupation__c, a.Non_Elderly_Disabled__c, a.Near_Elderly__c, a.Mobility_Access__c, a.Middle_Name__c,a.Elderly_Family__c,
                                                a.Live_Work_in_City_of_San_Diego__c, a.Last_Name__c, a.Homeless_with_disability__c, a.Homeless__c,a.Agency_List__c,
                                                a.Hearing_Access__c, a.First_Name__c,a.Family_Annual_Income__c, a.Family__c, a.Ethnicity__c, a.Employment_Zip_Code__c, 
                                                a.Elderly__c, a.Education__c, a.Displaced__c, a.Disabled_Family__c, a.Disable__c, a.Dependents_Children_under_age_of_18__c,a.Spouse_Co_Head_If_applicable__c,
                                                a.DOB__c, a.Citizenship__c, a.Black__c,a.Mod_Rehab__c,a.Section_8__c,a.NED_Non_Elderly_Person_with_Disability__c,a.PBVS_Project_Based_Single__c,
                                                a.Asian__c, a.Are_you_veteran_or_a_family_of_a_ventera__c,a.PBV_Project_Based__c,a.Public_Housing__c,a.Agency_Contact_Email__c,a.Agency_Contact_Name__c,
                                                a.Agency_Contact_Phone__c,a.Are_you_or_your_spouse_co_head_disabled__c, a.Are_you_in_Active_duty_with_US_Army__c, a.Enter_Agency_name_if_selected_other__c, a.American_Indian__c, a.age__c, 
                                                a.Did_anyone_helped_you_to_submit_the_info__c From Applications__c a 
                                                where Id = :id Limit 1]){                                                                            
                app.add(application);
            }
            if(!app.isEmpty()){
                return app.get(0);
            }
            else return new Applications__c();                                 
        }
        else return new Applications__c();             
    } 

    
   //RHATHI 7/7/17 
    @RemoteAction
    public static string getZipCodeLocation(String zip,string eZip){
        ZipLocation__c sanDiegoLoc = ZipLocation__c.getValues('San Diego');
        if(sanDiegoLoc == null){
            return 'Not Set';
        }
        
        List<String> zCodesLst = sanDiegoLoc.ZipRanges__c.split(',');
        
        if(zCodesLst != null && !zCodesLst.isEmpty()){
            Set<String>zCodes = new Set<String>();
            zCodes.addAll(zCodesLst);
            if( zCodes.contains(zip) || zCodes.contains(eZip) ){
                return 'San Diego';
            }else{
                return 'Non San Diego';
            }
            
        }else{
            return 'Not Set';
        }
        
        
        
        
    }

    @RemoteAction
    global static Boolean confirmPurgeExtnInterest(String idd){
       String sid = idd;
       System.debug('radtest '+idd);
        try{
        
        RAD_Configuration__c cnfg = [select Update_Duration_Months__c, RAD_Purge_Extension_Months__c from  RAD_Configuration__c where name = 'Main Configurations' limit 1];
        Integer totalMonths = Integer.valueOf(cnfg.Update_Duration_Months__c) + Integer.valueOf(cnfg.RAD_Purge_Extension_Months__c);
        
        Applications__c appln = [Select id, Application_status__c,RAD_Last_Update_Date__c, RAD_Next_Purge_Request_Date__c,RAD_Next_Purge_Date__c from Applications__c where id =:sid limit 1] ;
        appln.Application_status__c = 'Submitted';
        appln.RAD_Last_Update_Date__c = Datetime.Now();
        appln.RAD_Next_Purge_Request_Date__c = Datetime.Now().addMonths(Integer.valueOf(cnfg.Update_Duration_Months__c));
        appln.RAD_Next_Purge_Date__c =  Datetime.Now().addMonths(totalMonths);
        update appln;
        
        Memo__c mmo = new Memo__c();
        //mmo.Subject__c = 'Response to update provided.';
        mmo.Name = 'Response to update provided.';
        mmo.Type__c = 'Wait List';
        mmo.Notes__c = 'System Generated Memo';
        mmo.Applications__c = appln.id;

        insert mmo;
        
        }catch(Exception e){
            System.debug('RADTEST EXCP'+e);
            return false;
        }
        return true;
        
    
    }

    @RemoteAction
    global static Boolean reapplyWL(String idd){
       StrinG wl_ID = idd;
       System.debug('radtest '+idd);
        try{
        
        RAD_Configuration__c cnfg = [select Update_Duration_Months__c, RAD_Purge_Extension_Months__c from  RAD_Configuration__c where name = 'Main Configurations' limit 1];
        Integer totalMonths = Integer.valueOf(cnfg.Update_Duration_Months__c) + Integer.valueOf(cnfg.RAD_Purge_Extension_Months__c);
        
        
        Enrolled_Wait_List__c  wl = [Select id, Applications__c, Current_Status_Date_Time__c, Current_Status__c, SFDC_Original_Datetime__c  from Enrolled_Wait_List__c where id=:wl_ID limit 1];
        wl.Current_Status__c = 'Onlist';
        wl.Current_Status_Date_Time__c = Datetime.Now();
        wl.SFDC_Original_Datetime__c = Datetime.Now();
        //String strConvertedDate =   Datetime.now().format('MM/dd/yyyy HH:mm:ss a', 'America/Los_Angeles');//PDT
        //wl.RAD_Date_and_Time_with_Seconds__c = strConvertedDate;
        wl.RAD_Applied_Date_and_Time__c = Datetime.now();
                
        update wl;
        
        Applications__c appln = [Select id, Application_status__c,RAD_Last_Update_Date__c, RAD_Next_Purge_Request_Date__c,RAD_Next_Purge_Date__c from Applications__c where id =:wl.Applications__c limit 1] ;
        appln.Application_status__c = 'Submitted';
        appln.RAD_Last_Update_Date__c = Datetime.Now();
        appln.RAD_Next_Purge_Request_Date__c = Datetime.Now().addMonths(Integer.valueOf(cnfg.Update_Duration_Months__c));
        appln.RAD_Next_Purge_Date__c =  Datetime.Now().addMonths(totalMonths);
        
        update appln;
        
        }catch(Exception e){
            System.debug('RADTEST EXCP'+e);
            RAD_Exception_Log__c eLog = new RAD_Exception_Log__c();
            eLog.RAD_Error_Source__c = 'Reapply for Wait List.';
            eLog.RAD_Error_Message__c = e.getMessage();
            eLog.RAD_Exception_Record_ID__c = wl_ID ;
            Database.insert(eLog, false);
            return false;
        }
        return true;
        
    
    }

    
    //Wapper Class for Contact and its Application  
    public class contactWrapper{
        
        public Contact Cnt{get;set;}{Cnt = new Contact();}
        //public ApplicationWrapper applicationDetails{get;set;}
        public Applications__c contactApplication{get;set;}{contactApplication = new Applications__c();}
        public Boolean publicHsgEnrld {get;set;}
        public Boolean section8Enrld {get;set;}
        public Boolean PBVProjBsdEnrld {get;set;}
        public Boolean PBVSProjBsdSnglEnrld {get;set;}
        public Boolean NEDEnrld {get;set;}
        
    }   
    
    /*// Helper Wrapper Class for Application Details
    public class ApplicationWrapper{
        public Applications__c contactApplication{get;set;}
    }
    */
 
    @future
    public static void updateApplication(ID AppToUpdate)
    {   
        Applications__c appln = [SELECT ID, Application_status__c, RAD_Last_Update_Date__c, RAD_Next_Purge_Request_Date__c, RAD_Next_Purge_Date__c FROM Applications__c WHERE Id = :AppToUpdate];
        RAD_Configuration__c cnfg = [select Update_Duration_Months__c, RAD_Purge_Extension_Months__c from  RAD_Configuration__c where name = 'Main Configurations' limit 1];
        Integer totalMonths = Integer.valueOf(cnfg.Update_Duration_Months__c) + Integer.valueOf(cnfg.RAD_Purge_Extension_Months__c);
        
       
        appln.Application_status__c = 'Submitted';
        appln.RAD_Last_Update_Date__c = Datetime.Now();
        appln.RAD_Next_Purge_Request_Date__c = Datetime.Now().addMonths(Integer.valueOf(cnfg.Update_Duration_Months__c));
        appln.RAD_Next_Purge_Date__c =  Datetime.Now().addMonths(totalMonths);
        
        update appln;
    }
    
    
}