trigger ContactTrigger on Contact (before insert, before update, after insert, after update, before delete, after undelete, after delete) {
   if(Trigger.isBefore){
       system.debug('RJP:' + Trigger.isBefore);
       if(Trigger.isUpdate){
           RAD_ContactHelper.processCntBeforeUpdate(Trigger.new);
       }
       else
       if(Trigger.isInsert){
            
            RAD_ContactHelper.processCntBeforeInsert(Trigger.new);
           /*
            for (Contact c : Trigger.new){
          
                Contact[] contacts= [select id from Contact where FirstName = :c.FirstName and LastName = :c.LastName and Email = :c.Email];
          
                  if (contacts.size() > 0) {
                      c.Email.addError('Contact cannot be created - Contact already exists');
                  }    
           }
           */
        }
  }else if(Trigger.isAfter) {
  
      if(Trigger.isUpdate){ 
          RAD_ContactHelper.processCntAfterUpdate();
      
      }
      if(Trigger.isInsert) {
          RAD_ContactHelper.processCntAfterInsert();
      }
  
  }

}