trigger RAD_WaitListTrigger on Enrolled_Wait_List__c (before insert, before update, after insert, after update, before delete, after delete, after undelete) {

    //Execute Case Trigger Logic
    if(SwitchTrigger__c.getValues('Enrolled_Wait_List__c').Active__C)
    {
        System.debug('Waitlist Trigger Executing... ');
        RAD_WaitListHelper.manageTrigger();
    }      
}