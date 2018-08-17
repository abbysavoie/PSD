global class RAD_LoginRegisterCtrl{ 
        
    global String SiteCSS;
    global String SiteJS;
    global Long   iCnt = 0;
    global Boolean LoogedIn = false;
    public String strErrMsg {get;set;}
    public Boolean hasErrMsg{get;set;}
    public RAD_Configuration__c radCnfg {get;set;}
    public String cnfgPortalAddr{get;set;}
    
    public String cnfgForgotNote{get;set;} //NO LONGER REFRNCD
    
    public String cnfgUsernameNote {get;set;}
    public String cnfgPasswordNote {get;set;}
   
    public String bYear{get;set;} 
    public String dateYear{get;set;}
        
    public RAD_LoginRegisterCtrl() {
        
        StaticResource objStc = [Select Id, LastModifiedDate From StaticResource where Name='RAD_Web'];
        
        iCnt = objStc.LastModifiedDate.getTime();
        
        SiteCSS = '/resource/'+iCnt+'/RAD_Web/css/';
        SiteJS  = '/resource/'+iCnt+'/RAD_Web/js/';
        //passwordchange();
        //findSecurityQuestions();
        randompassword='';
        
         radCnfg = [select RAD_Portal_Contact_Address__c, RAD_Portal_Forgot_UserName_Note__c, RAD_Portal_Forgot_Password_Note__c from  RAD_Configuration__c where name = 'Main Configurations' limit 1];
         cnfgPortalAddr = radCnfg.RAD_Portal_Contact_Address__c;
         cnfgUsernamenote = radCnfg.RAD_Portal_Forgot_UserName_Note__c;
         cnfgPasswordNote = radCnfg.RAD_Portal_Forgot_Password_Note__c;
         
         
        //RHATHI...
        strErrMsg =null;
        hasErrMsg = false;
        String message = '' + ApexPages.CurrentPage().GetParameters().Get('message');
        String pageHeaderReferer = ApexPages.currentPage().getHeaders().get('Referer'); 

        // Use the referrer parameter to only show the message when coming from Page 1
        if(pageHeaderReferer != null && pageHeaderReferer.containsIgnoreCase('RADNewLogReg') && message != 'null')
        {
               ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Error, message)); 
        }
        
        //...RHATHI
    }
    
    public PageReference forwardToCustomAuthPage() {
        if(UserInfo.getUserType() == 'Guest'){
            return new PageReference('/RAD_Log_Reg_Site_Temp');
        }
        else{
            return null;
        }
    }
    
    global  String getCSSURL(){
        return SiteCSS;
    }
    global  String getJSURL(){
        return SiteJS;
    }
    
    global String Username {get; set;}
    global String Password {get; set;}
    global String UsernameRegister {get; set;}
    global String UNameRegister {get; set;}    
    global string ApplicantNameRegister{get;set;} 
    global string FirstNameRegister{get;set;}
    global string LastNameRegister{get;set;}
    global string SSNRegister{get;set;}
    global string PhoneRegister{get;set;}
    global string EmailRegister{get;set;}
    global string GenderRegister{get;set;}
    global string MonthRegister{get;set;}
    global string AgeRegister{get;set;}
    global String NewStreetRegister {get; set;}
    global String NewCityRegister {get; set;}
    global String NewStateRegister {get; set;}
    global String NewZipcodeRegister {get; set;}
    global String NewAltStreetRegister {get; set;}
    global String NewAltCityRegister {get; set;}
    global String NewAltStateRegister {get; set;}
    global String NewAltZipcodeRegister {get; set;}
    global String NewPswdRegister {get; set;}
    global String NewRetypePswdRegister {get; set;}
    global String Newscques1Register {get; set;}
    global String Newscans1Register {get; set;}
    global String Newscques2Register {get; set;}
    global String Newscans2Register {get; set;}
    global String Newscques3Register {get; set;}
    global String Newscans3Register {get; set;}
    global boolean UserLoggedIn {get; set;}
    global boolean UserLoggedOut {get; set;}
    global String usernameResetPswd {get; set;} 
    global string usernameResetPassId{get;set;} 
    global string securityResetPswd{get;set;} 
    global string securityResetpwd{get;set;}
    global string randompassword{get;set;}
    global boolean homeless_check{get;set;}
    global boolean SSN_DoNotHave_check{get;set;}
    global boolean paperless_check{get;set;}
    global User LoggedInUser;
    global string usrnmResetPswd{get;set;}
    public string forgotUserNameMail{get;set;}
    public string ssnsearch{get;set;}
    public string ssnLNamesrch{get;set;}
    global Boolean validEmail{get;set;}{validEmail = true;}
    public Boolean validSSN{get;set;}{validSSN = true;}
    public Boolean validEmailPhone{get;set;}{validEmailPhone = true;}
    public Boolean validFristPhone{get;set;}{validFristPhone = true;}
    
    
    
    global String strMsg; 
    
    public RAD_LoginRegisterCtrl(RADGenericController controller) {
        
        UserLoggedIn = false;
        UserLoggedOut = false;
        
        LoggedInUser = [Select ContactId, AccountId, Profile.Name, UserType from user where Id=: UserInfo.getUserId()];
        
        if(LoggedInUser.ContactId != null)
            UserLoggedIn = true;
        else
            UserLoggedOut = true;           
        
    }
    
    global PageReference login() {
        String startUrl = System.currentPageReference().getParameters().get('startURL');
        try
        {
            PageReference pr = Site.login(Username, Password, '/RADNewLand');
            //PageReference pr = Site.login(Username, Password, '/DUPRADLandingV2');//rhathi
            return pr;
        }
        catch(Exception Ex)
        {    
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, String.Valueof(Ex.getStacktracestring()));
            ApexPages.addmessage(myMsg);
            return null;
        } 
        
        if(ApexPages.hasMessages())
        {
            ApexPages.Message[] apm = ApexPages.getMessages();
            for(ApexPages.Message am : apm)
            {
                if(strMsg != null && strMsg != '')
                    strMsg = strMsg + '  ' + am.getSummary();
                else
                    strMsg = am.getSummary();
            }
        }
        else
        {
            strMsg = '';
        } 
        Password = '';
        return null;
    }
    
    //--------Register Method-------
    
    @RemoteAction
    public static String userPreCreationValidations(String userEnteredFirstName, String userEnteredEmail, String userEnteredPhone){
        String validationMsg = 'NoErrors';
        system.debug('user entered first name is----->'+userEnteredFirstName);
        system.debug('user entered email name is----->'+userEnteredEmail);
        system.debug('user entered phone name is----->'+userEnteredPhone);
        
        List<Contact> existingContact = new List<Contact>();
        if(!String.isEmpty(userEnteredEmail) && String.isEmpty(userEnteredPhone)){
            existingContact = [select Id from Contact where Email =:userEnteredEmail];
            if(existingContact.size () > 0){
                validationMsg = 'Email exists.Please login to your account';
            }
        }
        else if(!String.isEmpty(userEnteredEmail) &&  !String.isEmpty(userEnteredPhone)){
            existingContact = [select Id from Contact where Email =:userEnteredEmail and Phone =:userEnteredPhone ];
            if(existingContact.size () > 0){
                validationMsg = 'Email and Phone exists.Please login to your account';
            }
        }
        else if(String.isEmpty(userEnteredEmail) && !String.isEmpty(userEnteredPhone)){
            if(!String.isEmpty(userEnteredFirstName)){
                existingContact = [select Id from Contact where FirstName =:userEnteredFirstName and Phone =:userEnteredPhone ];
                if(existingContact.size () > 0){
                    validationMsg = 'Phone and fisrt name exists.Please login to your account';
                }
            }
        }
        return validationMsg;
    }
    
    @RemoteAction
    public static Boolean validateSSN(String userEnteredSSN){
        system.debug('the ssn entered is------->'+userEnteredSSN);
        
        Boolean validationPass = true;
        userEnteredSSN = userEnteredSSN;
        
        List<Contact> cts = [Select Id, SSN_TaxID__c from Contact where SNN_DUP__c =:userEnteredSSN];
        if(cts != null && cts.size() >= 1){
            validationPass = false;
        }
                
        return validationPass;
    }
    
    
   

    @RemoteAction
    public static Boolean validateUserName(String userEnteredUserName){
        system.debug('the username entered is------->'+userEnteredUserName);
        
        Boolean uservalidationPass = true;
        List<User> usrs = [select Id, username from User where username =: userEnteredUserName ];
        if(usrs != null && usrs.size() == 1 ){
            uservalidationPass = false;
        }

                
        return uservalidationPass;
    }
    
    
    
    public PageReference save(){
        
        PageReference returnPage = new PageReference('/');
        String profileId = null; // To be filled in by customer.
        String roleEnum = null; // To be filled in by customer.
        String accountId = ''; 
        //RHATHI 29 June 2017
        Account[] accounts = [Select id, name From Account a Where name = 'RAD Community Account' limit 1];
        if(!accounts.isEmpty()){
            accountId = accounts[0].Id;
        }else{    
            throw new RADSiteException('Please contact Site Administrator.');
        } 
        
        
        String userId;
        //String userName = FirstNameRegister + LastNameRegister.substring(0,1) + '@sdhc.com';

        //String uniqueNo = '.'+ System.now().millisecond() + Math.round(Math.random() * 100) + Math.round(Math.random() * 100);
        //String userName = FirstNameRegister + LastNameRegister.substring(0,1) + uniqueNo  +  '@sdhc.com';
        String userName= UNameRegister;
        system.debug('The first username is'+ userName);
        User u          = new User();
        //u.username      = ApplicantNameRegister;
        
        u.username      = userName;
        //username= username.replaceAll( '\\s+', '');
        system.debug('The username is------>'+ u.username);
        if(EmailRegister != null && EmailRegister != ''){
            u.Email         = EmailRegister;
        }
        else{
            u.Email         = username;
        }
        u.FirstName     = FirstNameRegister;
        u.LastName      = LastNameRegister;
        u.Phone         = PhoneRegister;
        u.ProfileId     = profileId;
        
        //u.Address__c = AddressRegister +', '+ ZipCodeRegister;
        //u.CommunityNickname = FirstNameRegister.substring(0,2) + LastNameRegister.substring(0,2) + String.ValueOf([select Count() from User]);
        //u.CommunityNickname = 'SDHCComunity';
        u.CommunityNickname = FirstNameRegister.substring(0,1) + LastNameRegister.substring(0,1)+String.valueOf(Datetime.now().gettime());
        
        //u.ProfileId = '00et0000000QHD6';
        u.TIMEZONESIDKEY = 'America/Los_Angeles';
        
        
        try {
            if(SSN_DoNotHave_check == true ||  validateSSN(SSNRegister)){ //short circuit logic
                string ErrorMsg = userPreCreationValidations(FirstNameRegister,EmailRegister,PhoneRegister);
                if(ErrorMsg != 'NoErrors'){
                    throw new RADSiteException(ErrorMsg);
                }
            }else{
                throw new RADSiteException('SSN already registered.Please login to your account');
            }
            
            /*
            if(validateSSN(SSNRegister)){
                string ErrorMsg = userPreCreationValidations(FirstNameRegister,EmailRegister,PhoneRegister);
                if(ErrorMsg != 'NoErrors'){
                    throw new RADSiteException(ErrorMsg);
                }
            }
            else{
                throw new RADSiteException('SSN already registered.Please login to your account');
            }
            */
            
            
            Site.validatePassword(u, NewPswdRegister, NewPswdRegister);
            userId = Site.createExternalUser(u, accountId, NewPswdRegister);
            //system.debug('userId---------->' +SSNRegister);
            // updateUserContact(userId,SSNRegister,PhoneRegister, FirstNameRegister,MonthRegister);
            
            User newUser = [select Id,ContactId from USer where id = :userId];
            system.debug('new user-------------'+ newUser);
            Contact UserContact                = new Contact();
            UserContact.Id                     = newUser.ContactId;
            UserContact.Contact_Type__c        = 'Community Global User';
            UserContact.FirstName              = FirstNameRegister;
            UserContact.Phone                  = PhoneRegister; 
            UserContact.SSN_TaxID__c           = SSNRegister.remove('-');
            UserContact.SNN_DUP__c             = SSNRegister;
            UserContact.Gender__c              = GenderRegister;
            //UserContact.Age__c                 = AgeRegister; //RHATHI WE ARE NOT USING THIS BUT FORMULA AND TYPE IS NUMBER IN PROD
            UserContact.Email                  = EmailRegister;
            UserContact.Security_Question_1__c = Newscques1Register;
            UserContact.Security_Question_2__c = Newscques2Register;
            UserContact.Security_Question_3__c = Newscques3Register;
            UserContact.Security_Answer_1__c   = Newscans1Register;
            UserContact.Security_Answer_2__c   = Newscans2Register;
            UserContact.Security_Answer_3__c   = Newscans3Register;
            UserContact.MailingStreet          = NewStreetRegister;
            UserContact.MailingCity            = NewCityRegister;
            UserContact.MailingState           = NewStateRegister;
            UserContact.MailingPostalCode      = NewZipcodeRegister;
            UserContact.Residential_Street__c  = NewAltStreetRegister;
            UserContact.Residential_City__c    = NewAltCityRegister;
            UserContact.Residential_State__c   = NewAltStateRegister;
            UserContact.Residential_Zipcode__c = NewAltZipcodeRegister;
            UserContact.Date_of_Birth__c       = date.valueOf(MonthRegister);
            UserContact.RAD_Homeless__c            = homeless_check;
            UserContact.Do_not_Have__c         = SSN_DoNotHave_check;
            UserContact.Paperless_Email_only__c= paperless_check;
           
             String zipInfo = getZipCodeLocation(UserContact.Residential_Zipcode__c);
              
                if(zipInfo == 'San Diego'){
                    UserContact.Sandiago_checkbox__c = true;
                }else{
                    UserContact.Sandiago_checkbox__c = false;
                }
            
            upsert UserContact;
            
            //all fine ...let the user login
            returnPage = Site.login(Username, NewPswdRegister, '/RADNewLand');//RHATHI 19 JUN
                    
        } catch(Site.ExternalUserCreateException ex) {
            List<String> errors = ex.getDisplayMessages();
            for (String error : errors)  {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, error));
            }
            
            // This message is used for debugging. Do not display this in the UI to the end user.
            // It has the information around why the user creation failed.
            System.debug(ex.getMessage()+'  '+ex.getStacktracestring());

            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'rhathi hello error found'));
            strErrMsg = 'rhathi found error here';
            hasErrMsg = true;
            return null;
            
        } catch (RADSiteException radExcp){//RHATHI 19 JUN 2017
            System.debug('RHATHI EXCP RADEXCP'+ radExcp.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, radExcp.getMessage())); 
            strErrMsg = 'rhathi found RAD error here';
            hasErrMsg = true;
            return null;
            
            
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            System.debug('RHATHI EXCP E '+ e.getMessage());
            strErrMsg = 'rhathi found some exceptoon here'; 
            hasErrMsg = true;
            return null;

            
        }
        finally{
            /* shifted the logic in try block RHATHI 19 JUN 2017
            
            if (userId != null){ 
                if(NewPswdRegister != null && NewPswdRegister.length() > 1) {
                    //acc.OwnerId = userId;
                    //update acc;
                    //returnPage = Site.login(userName, NewPswdRegister, ApexPages.currentPage().getParameters().get('/RADNewLogReg'));//cmntd by RHATHI 15 FEB 2017 
                    returnPage = Site.login(Username, NewPswdRegister, '/RADNewLand');//RHATHI 15 JUN
                    //return Site.login(ApplicantNameRegister, NewPswdRegister, '/RADNewLogReg'); 
                }
                else {
                    returnPage = System.Page.RADNewLogReg;
                    returnPage.setRedirect(true);
                    //return page;
                }  
            }
            */
        }
        return returnPage;
    }
    
        
    public PageReference cancel() {
        return null;
    }
    
    /**
    *@Method-- Method used to reset password
    *@param--- N/A
    *@return-- redirects to the change password vf page
    */
    //RHATHI 03 JUL 2017
    public PageReference ResetPassword() {
        boolean success = Site.forgotPassword(usernameResetPswd);
        
        //adding IF for now.
        if(ApexPages.hasMessages()){
            ApexPages.Message[] apm = ApexPages.getMessages();
            for(ApexPages.Message am : apm){  
                if(strMsg != null && strMsg != '')
                strMsg = strMsg + '  ' + am.getSummary();
                else
                strMsg = am.getSummary();
            }
        }
        else{
            strMsg = '';
        }
        
        
         
        return null;    
    }

    
    /*global PageReference ResetUsername() {
        
        user usr=new user();
        EmailTemplate templateId = [Select id from EmailTemplate where name = 'RAD_Email'];
        usr=[select id,username from user where id=:usrnmResetPswd];
        List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setTemplateID('00Xr0000000MNec'); 
        mail.setTargetObjectId(usr.username);
        mail.setSaveAsActivity(false);
        allmsg.add(mail);
        Messaging.sendEmail(allmsg,false);
        return null;
    }*/
    
    public PageReference getForgotUserName(){
        try{
            if(forgotUserNameMail != null && forgotUserNameMail != ''){
                List<User> forgotUser = [select Id, UserName,contact.email from User where contact.Email =: forgotUserNameMail and isActive = true and UserType='CspLitePortal'];
                if(forgotUser.size() > 1){
                    
                    throw new RADSiteException('Please Contact Customer Care for your username.');
                    //TODO ? create case or log error
                }
                if(forgotUser.size() == 1){
                    EmailTemplate forgotUserTemplate = [Select id from EmailTemplate where name = 'RAD_Email'];
                    List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setTemplateID(forgotUserTemplate.Id); 
                    mail.setTargetObjectId(forgotUser[0].Id);
                    mail.setSaveAsActivity(false);
                    string[] sendingTo=new string []{'rohini.hathi@cgi.com'};
                    //mail.setCcAddresses(sendingTo);//TODOComment later
                    allmsg.add(mail);
                    Messaging.sendEmail(allmsg,false);
                }
            }
            else{
                throw new RADSiteException('Please enter a valid email address.');
            }
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            return null;
        }
        return null;
    }

/*---method for search ssn----*/
    
    public PageReference getSSNsearch(){
    
        
        PageReference pg =new pageReference('/');
        try{
            
            List<User> Usr=[select u.username, u.contact.SNN_DUP__c, u.contact.lastname, u.RAD_Migrated_User__c from User u where u.contact.SNN_DUP__c=:ssnsearch and  u.contact.lastname =: ssnLNamesrch];
system.debug('$$$$ Usr' +Usr);            
            if(Usr.size()==1){
                if(usr[0].RAD_Migrated_User__c == false){
                    throw new RADSiteException('Please login with your existing credentials.');
                }
                system.debug('the user returned for search query is-------->' + usr[0]);
                ResetPasswordResult  pr =  system.resetPassword(usr[0].Id,false);
                
                pg = Site.login(usr[0].UserName,pr.getPassword(),'/RADNewLand?usn=1');
                pg.setredirect(true);
                 

                System.debug('RHATHI THE URL IS '+ pg.getUrl());
                
            }
            else if(Usr.size() > 1){
                throw new RADSiteException('Please Contact Customer Care.');
            }
            else{
                throw new RADSiteException('Invalid details.Please use the sign up link to create a new profile');
            }
        }
        
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            return null;
        }
        
        return pg;
        
    }
    
    /*---Method ends----*/
    
    
           
    public List<Contact> ContactUser{get;set;}{ContactUser = new List<Contact>();}
    
@RemoteAction
    public static List<QuestionandAnswers> getAllQuestionandAnswers(string Resetusername){
        List<QuestionandAnswers> userSeccurityQuestion = new List<QuestionandAnswers>();
        system.debug('The email is------------>'+Resetusername);
        if(Resetusername != null){
           user usrname=[select Id,username,contactid, contact.email from user where username=:Resetusername];
           system.debug('The query returned is----->'+ usrname);
           
           //List<Contact> CntUser = [select Id,contact.email,Security_Question_1__c,Security_Answer_1__c,Security_Question_2__c,Security_Answer_2__c,Security_Question_3__c,  Security_Answer_3__c from Contact where email =:usrname.contact.email Limit 1];
           //RHATHI 10 JUL 2017
           //FETCH SECURITY QUESTIONS OF CONTACT FROM USER WHOSE USERNAME IS TYPED
           List<Contact> CntUser = [select Id,contact.email,Security_Question_1__c,Security_Answer_1__c,Security_Question_2__c,Security_Answer_2__c,Security_Question_3__c,  Security_Answer_3__c from Contact where id=:usrname.contactid Limit 1];
           system.debug('The username is--------->'+CntUser[0].email);
           system.debug('first security question is------>'+CntUser[0].Security_Question_1__c);
           system.debug('first security answer is ----->'+CntUser[0].Security_Answer_1__c);
           system.debug('second security question is------>'+CntUser[0].Security_Question_2__c);
           system.debug('second s answer is ----->'+CntUser[0].Security_Answer_2__c);
           system.debug(' third security question is------>'+CntUser[0].Security_Question_3__c);
           system.debug(' third security answer is------>'+CntUser[0].Security_Answer_3__c);
           
            
            QuestionandAnswers temp1 = new QuestionandAnswers();
            temp1.question = CntUser[0].Security_Question_1__c;
            temp1.answer = CntUser[0].Security_Answer_1__c;
            userSeccurityQuestion.add(temp1);
            
            QuestionandAnswers temp2 = new QuestionandAnswers();
            temp2.question = CntUser[0].Security_Question_2__c;
            temp2.answer = CntUser[0].Security_Answer_2__c;
            userSeccurityQuestion.add(temp2);
            
            QuestionandAnswers temp3 = new QuestionandAnswers();
            temp3.question = CntUser[0].Security_Question_3__c;
            temp3.answer = CntUser[0].Security_Answer_3__c;
            userSeccurityQuestion.add(temp3);
        }
        return userSeccurityQuestion;
    }
        
    
    public class QuestionandAnswers{
        public string question{get;set;}
        public string answer{get;set;}
    }
    
    
    /**
    *@Method-- Wrapper Class to hold information for User and Contact Creation
    *@param--- N/A
    *@return-- N/A
    */
    public class contactUserWrapper{
        
        public String Username {get; set;}
        public String Password {get; set;}
        public String UsernameRegister {get; set;}
        public string ApplicantNameRegister{get;set;} 
        public string FirstNameRegister{get;set;}
        public string LastNameRegister{get;set;}
        public string SSNRegister{get;set;}
        public string PhoneRegister{get;set;}
        public string EmailRegister{get;set;}
        public string GenderRegister{get;set;}
        public string MonthRegister{get;set;}
        public string AgeRegister{get;set;}
        
    }
    /* public static void TestupdateUserContact(){
        User ud = [select Id from User where UserName='tsonga@test.com'];
        ResetPasswordResult  pr =  system.resetPassword(ud.Id,false);
        Site.login(ud.Id,pr.getPassword(),'/RADNewLand');
        Site.ChangePassword('Sfdc99881','Sfdc99881',pr.getPassword());
        
        
    }
    */
    
     
    public PageReference passwordchange(){
        PageReference pg =  new PageReference('/');
        try{  
            User ud = [select Id,Username from User where UserName=:securityResetpwd];
            ResetPasswordResult  pr =  system.resetPassword(ud.Id,false);
            randompassword=pr.getpassword();
            
            //Site.ChangePassword('Sfdc12345!','Sfdc12345!',pr.getPassword());
            //Site.ChangePassword(NewPswdRegister,NewRetypePswdRegister,pr.getpassword());
            pg =  Site.login(ud.UserName,pr.getPassword(),'/RADNewLogReg');
            
        }
        catch(Exception Ex)
        {    
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, String.Valueof(Ex.getStacktracestring()));
            ApexPages.addmessage(myMsg);
            return null;
        }  
        return pg;
    }
    
    
    public class RADSiteException extends Exception{}

    
    @future
    public static void updateUserContact(string userId,string SSNRegister, string PhoneRegister, string FirstNameRegister,string MonthRegister){
        
        User newUser = [select Id,ContactId from USer where id = :userId];
        system.debug('new user-------------'+ newUser);
        Contact UserContact = new Contact();
        UserContact.Id = newUser.ContactId;
        UserContact.Contact_Type__c = 'Community Global User';
        
        UserContact.FirstName = FirstNameRegister;
        UserContact.Phone = PhoneRegister; 
        UserContact.SSN_TaxID__c = SSNRegister;
        UserContact.Date_of_Birth__c = Date.valueOf(MonthRegister);
        upsert UserContact;
        
    }
    //rhathi 26 Jun 2017 -1036
    public List<SelectOption> getbirthYearLst() {
        List<SelectOption>birthYearLst = new List<SelectOption>();
        birthYearLst.add(new SelectOption('0','Year'));
        
        Integer yr = Date.today().Year();
        for (Integer i = 1;i<= 100;i++){   
            
            birthYearLst.add(new SelectOption(yr+'',yr+''));
            yr--;
        
        }
        return birthYearLst;    
           
    }
    
    @RemoteAction
    public static string getZipCodeLocation(String zip){
        ZipLocation__c sanDiegoLoc = ZipLocation__c.getValues('San Diego');
        if(sanDiegoLoc == null){
            return 'Not Set';
        }
        
        List<String> zCodesLst = sanDiegoLoc.ZipRanges__c.split(',');
        
        if(zCodesLst != null && !zCodesLst.isEmpty()){
            Set<String>zCodes = new Set<String>();
            zCodes.addAll(zCodesLst);
            if( zCodes.contains(zip)){
                return 'San Diego';
            }else{
                return 'Non San Diego';
            }
            
        }else{
            return 'Not Set';
        }
        
    
    } 
    
 
    /*@future
    public static void TestupdateUserContact(){
        
       User ud = [select Id from User where UserName='thomas@test.com'];
        ResetPasswordResult  pr =  system.resetPassword(ud.Id,false);
        Site.ChangePassword('Sfdc99881','Sfdc99881',pr.getPassword());
        
    }*/
    
}

/* if(ApexPages.hasMessages())
{
ApexPages.Message[] apm = ApexPages.getMessages();
for(ApexPages.Message am : apm)
{
if(strMsg != null && strMsg != '')
strMsg = strMsg + '  ' + am.getSummary();
else
strMsg = am.getSummary();
}
}
else
{
strMsg = '';
} 

ApplicantNameRegister = '';
NewPswdRegister = ''; 
NewRetypePswdRegister = '';
*/
/*  try 
{
Id AccoutRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Citizen').getRecordTypeId();
string AccName = FirstNameRegister + ' ' +LastNameRegister;

Account acc = New Account(Phone__C=PhoneRegister, Email__c=EmailRegister,Gender__c=GenderRegister,Security_Answer1__c=Newscans1Register,Security_Question1__c=Newscques1Register,Security_Answer2__c=Newscans2Register,Security_Question2__c=Newscques2Register,Security_Answer3__c=Newscans3Register,Security_Question3__c=Newscques3Register,Add_City__c=NewCityRegister,Add_state__c=NewStateRegister,Add_Street__c=NewStreetRegister, name= 'ApplicantNameRegister', First_Name__c = FirstNameRegister,Add_Zip__c=NewZipcodeRegister,Last_Name__c =LastNameRegister);
insert acc;

userId = Site.createExternalUser(u, acc.Id, NewPswdRegister);
System.debug('--User Registered-- '+ userId);
}

catch(Site.ExternalUserCreateException ex) 
{
ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, String.Valueof(ex.getmessage()));
ApexPages.addmessage(myMsg);
System.Debug('Error------>'+ex.getMessage());
return null;
} */