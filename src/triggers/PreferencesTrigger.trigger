trigger PreferencesTrigger on Preferences__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    new PreferencesTriggerHandler().run();


}