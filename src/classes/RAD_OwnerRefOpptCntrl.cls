global with sharing class RAD_OwnerRefOpptCntrl {
    
    public Wait_List_Selection__c  wlcon {get;set;}
    public Date RespondedBy {get;set;} 
    public string Unitaddress {get;set;} 
    public string caseworker {get;set;}
    public string OwnerNamephone {get;set;} 
    public Date ContactManagerDate {get;set;}
    //public string  ContactManagerDate {get;set;}
    public Date ctDate{get;set;}
    public String datename {get; set;} 
    public string  SelectedRunId {get;set;} 
    public list<Wait_List_Selection__c > lis;
    public string OwnerAddress {get;set;} 
    public string  Bedroomsize {get;set;} 
    public String wlType {get;set;}
    public Selection_Records__c  sel {get;set;}
    public static  list<Selection_Records__c> sellist {get;set;}
    public static  list<Selection_Records__c> sellist1 {get;set;}
    public string query  {get;set;}
    public string selectedletter {get;set;}
    public string letter {get;set;}
    public string pdfUnitaddress {get;set;}
    public Applications__c al {get;set;}
    public  list<Applications__c> appli;
    public id id1 {get;set;} 
    public string responddate {get;set;}
    public string cmdatem {get;set;} 
    Public Date today {get;set;} 
    public string todayp {get;set;}
    public string OwnerPhone{get;set;}
    
    public list<selectedRecs> selectedRecs{get;set;}
    public string wlid;
    
    public RAD_OwnerRefOpptCntrl(){
        
        Applications__c a=new  Applications__c();
        Wait_List_Selection__c  wl=new Wait_List_Selection__c ();   
        selectedRecs = new list<selectedRecs>();
    } 
    
    public class selectedRecs{
    public boolean checked{get;set;}
    public Selection_Records__c selRec{get;set;}
    
    public selectedRecs(boolean b, Selection_Records__c sel){
    checked = true;
    selRec = sel;
    }    
    }
    
    
    public RAD_OwnerRefOpptCntrl(ApexPages.StandardController stdController ) {
        this.wlcon = (Wait_List_Selection__c)stdController.getRecord();        
        
    }  
    
    public string displaySelectionRecords(){
    
    if(wlType == '' ||wlType == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Select Wait List Type'));
            return null;}
        if(SelectedRunId  == '' ||SelectedRunId  == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Select Selected RunId'));
            return null;}
            
        if(RespondedBy == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter Respond By Date'));
            return null;}
        if(caseworker == '' || caseworker == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter case Worker'));
            return null;}
        if(Bedroomsize == '' || Bedroomsize == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter Bedroom Size'));
            return null;}
        if(Unitaddress == '' || Unitaddress == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter Unit Address'));
            return null;}
        if(OwnerNamephone == '' || OwnerNamephone == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter Owner Name'));
            return null;}
        if(OwnerPhone == '' || OwnerPhone == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter Owner Phone'));
            return null;}
        if(OwnerAddress  == '' || OwnerAddress  == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter Owner Address'));
            return null;}
        if(ContactManagerDate == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter Contact Manager Date'));
            return null;}
        /*if(SelectedRunId  == '' ||SelectedRunId  == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Select Selected RunId'));
            return null;} */
        if(letter=='None'){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Select letter Type')); 
            return null;}
    
        //Querying SelectionRecords, based on Selected Run ID and Status is Selected. 
        sellist= [select Name, Position__c ,Name__c, Prospect__c ,Lottery_Rank__c,Income_Target__c,Status__c,Pref_Points__c,
        RAD_Wait_List__c, Selection_ID__c,Selection_ID__r.Name,RAD_Wait_List__r.Applications__c,
        RAD_Wait_List__r.Applications__r.Name,RAD_Wait_List__r.Applications__r.Applicant__c,
        RAD_Wait_List__r.Applications__r.Applicant__r.Name,RAD_Wait_List__r.Applications__r.Applicant__r.Email,
        RAD_Wait_List__r.Applications__r.Applicant__r.Person_Email__c ,RAD_Wait_List__r.Applications__r.Applicant__r.Paperless_Email_only__c from  Selection_Records__c 
        where Selection_ID__r.name=:SelectedRunId and Status__c ='Selected']; 
        system.debug('$$$$ Selection records Based on Selection Run ID  '+sellist);

        //Querying WaitListSelectionRecord based on Selected Run ID.
       Wait_List_Selection__c  wls = [select id,Wait_List_Type__r.name,Name from Wait_List_Selection__c  where name = :SelectedRunId];
       wlId = wls.id;
        system.debug('$$$$ Wait list Selection Id '+wlId );  
    
    /*if(sellist.isempty()){
    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'No Selection Records for selected Wait List')); 
    }
    else    */      

      selectedRecs = new list<selectedRecs>();
      list<selectedRecs> selectedRecs1 = new list<selectedRecs>(); 
       selectedRecs se;
       
       //Setting Selected Checkbox to True for all childRecords
       for(Selection_Records__c sel: sellist){             //sellist --> all child records
       se = new selectedRecs(true,sel);   
        selectedRecs1.add(se);
        }
        if(selectedRecs1.isempty()){
         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFo,'No selection records')); 
         return null;
        }
        selectedRecs  = selectedRecs1; 
        return null;  
        }
        
    
    
    
    
    public  void submit()
    {
       system.debug('Responded '+ RespondedBy);
        system.debug('caseworker' + caseworker);
        system.debug('Bedroomsize '+ Bedroomsize);
        system.debug('SelectedRunId------> '+ SelectedRunId);
        system.debug('OwnerNamephone '+ OwnerNamephone);
        system.debug('OwnerAddress '+  OwnerAddress);
        system.debug('selectedletter '+  selectedletter);
        system.debug('$$$$ Owner phone from Page'+  OwnerPhone);
        
        letter=selectedletter;
        pdfUnitaddress=Unitaddress;     
 
 
        system.debug('ContactManagerDate '+  ContactManagerDate);
        if(RespondedBy!=Null){
            responddate=RespondedBy.format();
        }
        if(ContactManagerDate!=Null){
            cmdatem=ContactManagerDate.format();
        }
        today=Date.today();
        if(today!=null)
            todayp=today.format();
        
        
        Id folderMRRefId = [select id from folder where name ='Notice of Owner Referral - MR'].Id;
        Id folderPBRefId = [select id from folder where name ='Notice of Owner Referral - PBV'].Id;
        Id folderPBSRefId = [select id from folder where name ='Notice of Owner Referral - PBS'].Id;
        
        List<Document> docList = new List<Document>();
        Document doc = new Document();
        Blob b = null;
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
        List<Messaging.SingleEmailMessage> emailLst = new List<Messaging.SingleEmailMessage>();
        
       // system.debug('wlType----> '+ wlType);
       // sellist= [select Name,RAD_Wait_List__c, Selection_ID__c,Selection_ID__r.Name,RAD_Wait_List__r.Applications__c,RAD_Wait_List__r.Applications__r.Name,RAD_Wait_List__r.Applications__r.Applicant__c,RAD_Wait_List__r.Applications__r.Applicant__r.Name,RAD_Wait_List__r.Applications__r.Applicant__r.Email,RAD_Wait_List__r.Applications__r.Applicant__r.Person_Email__c ,RAD_Wait_List__r.Applications__r.Applicant__r.Paperless_Email_only__c from  Selection_Records__c where Selection_ID__r.Name=:SelectedRunId and Status__c ='Selected'];  
         list<Selection_Records__c> SelRecords = new list<Selection_Records__c>();    //User selected child Records
        for(selectedRecs s: selectedRecs){
        if(s.checked){
                SelRecords.add(s.SelRec);
        system.debug('$$$$ Records Selected by Staff' +SelRecords ); 
        }
        }
     //Adding Selected Selection Records Ids. 
     Set<Id> SelRecordsIds= new Set<Id>();
    for(Selection_Records__c srids:SelRecords){
       SelRecordsIds.add(srids.Id);
    }
    
        PageReference pdf=null;
        if (selectedRecs.size() > 0){
            if(letter=='NRletter')
            {
                
                if(wlType=='Mod Rehab')
                    
                { 
                    
                    RAD_RefletterBatch b1=new RAD_RefletterBatch (wlId,responddate,caseworker,Bedroomsize,pdfUnitaddress,OwnerNamephone,OwnerAddress,cmdatem,SelRecordsIds);
                    Database.executeBatch(b1) ;
                    
                    
                }   
                
                else if(wlType=='project Based')      
                {
                    
                    RAD_RefletterBatch b1=new RAD_RefletterBatch (wlId,responddate,caseworker,Bedroomsize,pdfUnitaddress,OwnerNamephone,OwnerAddress,cmdatem,SelRecordsIds);
                    Database.executeBatch(b1) ;
                } 
                
                else if(wlType=='Project Based Single')      
                {
                    
                    RAD_RefletterBatch b1=new RAD_RefletterBatch (wlId,responddate,caseworker,Bedroomsize,pdfUnitaddress,OwnerNamephone,OwnerAddress,cmdatem,SelRecordsIds);
                    Database.executeBatch(b1) ;
                }
            }
            if(letter=='NORLetter')
            {
                
                if(wlType=='Mod Rehab')
                    
                { 
                    
                    RAD_RefletterBatch b1=new RAD_RefletterBatch (wlId,responddate,caseworker,Bedroomsize,pdfUnitaddress,OwnerNamephone,OwnerAddress,cmdatem,SelRecordsIds);
                    Database.executeBatch(b1) ;
                    
                    
                    RAD_projectbased_Notify_Batch pr=new RAD_projectbased_Notify_Batch( SelectedRunId,letter,pdfUnitaddress,OwnerNamephone,Bedroomsize,ContactManagerDate,OwnerAddress,RespondedBy,caseworker,todayp,SelRecords, OwnerPhone);
                    Database.executeBatch(pr);
                    
                    
                }
                else if(wlType=='project Based')  
                {
                    
                    RAD_RefletterBatch b1=new RAD_RefletterBatch (wlId,responddate,caseworker,Bedroomsize,pdfUnitaddress,OwnerNamephone,OwnerAddress,cmdatem,SelRecordsIds);
                    Database.executeBatch(b1) ;
                    RAD_projectbased_Notify_Batch pr=new RAD_projectbased_Notify_Batch( SelectedRunId,letter,pdfUnitaddress,OwnerNamephone,Bedroomsize,ContactManagerDate,OwnerAddress,RespondedBy,caseworker,todayp,SelRecords, OwnerPhone);
                    Database.executeBatch(pr);
                    
                }
                else if(wlType=='Project Based Single')      
                {
                    
                    RAD_RefletterBatch b1=new RAD_RefletterBatch (wlId,responddate,caseworker,Bedroomsize,pdfUnitaddress,OwnerNamephone,OwnerAddress,cmdatem,SelRecordsIds);
                    Database.executeBatch(b1) ;
                    RAD_projectbased_Notify_Batch pr=new RAD_projectbased_Notify_Batch( SelectedRunId,letter,pdfUnitaddress,OwnerNamephone,Bedroomsize,ContactManagerDate,OwnerAddress,RespondedBy,caseworker,todayp,SelRecords, OwnerPhone);
                    Database.executeBatch(pr);
                }
                
            }
            
            
            
            
            if(letter=='NOletter')
            {
                
                RAD_projectbased_Notify_Batch pr=new RAD_projectbased_Notify_Batch( SelectedRunId,letter,pdfUnitaddress,OwnerNamephone,Bedroomsize,ContactManagerDate,OwnerAddress,RespondedBy,caseworker,todayp,SelRecords,OwnerPhone);
                Database.executeBatch(pr);                  
            }
        } 
        //List<Database.SaveResult> docResultList   =  Database.insert(docList, false); //not used...
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Letters Generated Sucessfully')); 
        
        
    }  
    
    public List<selectOption> getIdNames() {
        System.debug('wlType iss '+ wlType);
        List<selectOption> options = new List<selectOption>();
        options.add(new selectOption('', 'None')); 
        for(Wait_List_Selection__c acc : [select Name, Wait_List_Type__r.Name, Bedroom_Size__c from Wait_List_Selection__c  where Wait_List_Type__r.Name=:wlType  order by Name Desc])
        {
            options.add(new selectOption(acc.Name,acc.Name));
        }
        return options;
    } 
    
    public void ChangeAccInformation()
    {
        
        string passedParam1 = Apexpages.currentPage().getParameters().get('myParam');
        //        System.debug(passedParam1 );
        
        getIdNames();  
        
        
    }
    
    public void ChangesidInformation()
    {
        
        SelectedRunId=Apexpages.currentPage().getParameters().get('myParam1'); 
        
        
    } 
    public void ChangeletterInformation()
    {
        
        selectedletter=Apexpages.currentPage().getParameters().get('myParam2'); 
        
    }
    
    
}