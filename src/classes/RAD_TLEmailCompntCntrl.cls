public class RAD_TLEmailCompntCntrl
{
    public Id memoId {get; set;}
    public String strName;
    
    public RAD_TLEmailCompntCntrl()
    {
    }
    
    public List<Transfer_Letter_Address__mdt> getTransferLetterAddress()
    {
        if(memoId != NULL)
        {
            Memo__c memo = [SELECT Id, Result__c, Name
                            FROM Memo__c
                            WHERE Id = :memoId
                            LIMIT 1];
            if(memo != NULL && memo.Result__c != NULL)
            {
                List<Transfer_Letter_Address__mdt> transferletterAddress = [SELECT Id, DeveloperName, Name__c, Label, Address__c, City__c, State__c, Zip_Code__c, Phone_Number__c, Memo_Result__c   
                                                                            FROM Transfer_Letter_Address__mdt
                                                                            WHERE Memo_Result__c = :memo.Result__c
                                                                            LIMIT 1];
                return transferletterAddress; 
            }
        }
        return null;
    }
}