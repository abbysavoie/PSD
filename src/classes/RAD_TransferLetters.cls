public class RAD_TransferLetters{
    
    public Transfer_Letter_Address__mdt TransLettAddress{get;set;}
    public List<Memo__c> Memos{get;set;}
    
    public RAD_TransferLetters(ApexPages.StandardController controller){
        map<String,Transfer_Letter_Address__mdt> Traslettersmap = new  map<String,Transfer_Letter_Address__mdt>();
        String memoid= ApexPages.currentPage().getParameters().get('id') ; //getting the memo id.        
        String result;
        
        if(memoid!=null)
            result  = [select id, Result__c, Name  from Memo__c where id = :memoid].Result__c; // getting the value present on Result dropdown of Memo Object
        
        //looping through Transfer Letter Address custom metadata, checking result in Memo_Result__c and getting the addresses. 
        
        for(Transfer_Letter_Address__mdt trlsdd:  [select id, DeveloperName ,Name__c,label, Address__c, City__c, State__c, Zip_Code__c, Phone_Number__c, Memo_Result__c   
                                                   from Transfer_Letter_Address__mdt])
                                                   
            Traslettersmap.put(trlsdd.Memo_Result__c, trlsdd);
        
        if(result!=null)
            if(Traslettersmap.containskey(result))
            TransLettAddress = Traslettersmap.get(result);            
            
        
        
    }
    
}