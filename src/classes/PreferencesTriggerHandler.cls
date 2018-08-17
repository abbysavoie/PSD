public class PreferencesTriggerHandler extends TriggerHandler {
    public PreferencesTriggerHandler() {
    //this.setMaxLoopCount(1);
    }

    public override void beforeUpdate() {
       
          for(Preferences__c pref:(List< Preferences__c >) Trigger.new){
          if(!(UserInfo.getName() =='Dell Boomi'))
              pref.Send_To_Boomi__c=true;
        } 


    }
      
    public override void afterUpdate() {

    }

    public override void beforeInsert() {
        for(Preferences__c pref:(List< Preferences__c >) Trigger.new){
          if(!(UserInfo.getName() =='Dell Boomi'))
              pref.Send_To_Boomi__c=true;
        }
     

    }
    
    public override void afterInsert() {

    }

    public override void beforeDelete() {

    }

    public override void afterDelete() {

    }

    public override void afterUndelete() {
    
    }
}