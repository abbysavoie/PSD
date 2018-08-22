trigger MemoTrigger on Memo__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    new MemosTriggerHandler().run();

}