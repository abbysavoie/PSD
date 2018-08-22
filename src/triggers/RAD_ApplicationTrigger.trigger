trigger RAD_ApplicationTrigger on Applications__c (before insert, before update, after insert, after update) {

    //Execute Case Trigger Logic
    if(SwitchTrigger__c.getValues('Applications__c').Active__C)
    {
        System.debug('Application Trigger Executing... ');
        RAD_ApplicationHelper.manageTrigger();
    }      
}