global class RADGenericController
{

    public PageReference cancel() {
        return null;
    }


   public String profilecontact { get; set; }

    public PageReference login() {
        return null;
    }


    public PageReference RegisterUser() {
        //return Page.RADNewWaitlist; //rhathi commented this on 25 Aug 2017, not used anywhere during deployment.
        return null;
    }

    public RADGenericController(ApexPages.StandardController controller) {

    }

    global String SiteCSS;
    global String SiteJS;
    global Long   iCnt = 0;
    global Boolean LoogedIn = false;
    
    global RADGenericController()
    {      
        StaticResource objStc = [Select Id, LastModifiedDate From StaticResource where Name='RAD_Web'];
        
        iCnt = objStc.LastModifiedDate.getTime();
    
        SiteCSS = '/resource/'+iCnt+'/RAD_Web/css/';
        SiteJS  = '/resource/'+iCnt+'/RAD_Web/js/';
    }
    
    global  String getCSSURL()
    {
        return SiteCSS;
    }
    global  String getJSURL()
    {
        return SiteJS;
    }
}