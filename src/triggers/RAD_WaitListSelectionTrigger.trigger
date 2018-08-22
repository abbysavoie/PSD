trigger RAD_WaitListSelectionTrigger on Wait_List_Selection__c (after update, before update) {
    Wait_List_Type__c wltp = new Wait_List_Type__c();
    Map<String, String> wltMap = new Map<String, String>(); 
    String wlType='';
    String cronExpr = '';
    Datetime dt = Datetime.now();
    Decimal tempMin = 0;
    
    if(wltMap.isEmpty()){
        for( Wait_List_Type__c wlt : [Select name from Wait_List_Type__c] ){
            wltMap.put(wlt.id, wlt.Name);
        }
    }
    
    
    
    if(Trigger.isBefore){
        if(Trigger.isUpdate){
            for (Wait_List_Selection__c wls: Trigger.new) {
                wlType = wltMap.get(wls.Wait_List_Type__c);
                
                
                if(wls.Cancel_Run__c == true && ( ((Wait_List_Selection__c)Trigger.oldMap.get(wls.id)).Cancel_Run__c != wls.Cancel_Run__c )){
                    //abort the jobs related to this wls //dont cancel midway for specific batch chunk, ok to continue
                    continue;
                }
                
                
            }
        }
    }    
    else if(Trigger.isAfter){
        if(Trigger.isUpdate){
            
            for (Wait_List_Selection__c wls: Trigger.new) {
                wlType = wltMap.get(wls.Wait_List_Type__c);
                
                
                System.debug('RHATHI The date selected is '+ wls.Scheduled_Date__c);
                System.debug('RHATHI The time selected is '+ wls.Schedule_Time__c);
                //
                if( wls.Cancel_Run__c == false && wls.Status__c == 'Scheduled' 
                   && wls.RAD_Scheduler_Count__c == null && ((Wait_List_Selection__c)Trigger.oldMap.get(wls.id)).Status__c != wls.Status__c ){
                       //user just scheduled, so first initiate having default values
                       //this method will schedule the job at specific time which in turn will update the wls details count to 0 from null
                       
                       Integer randSeed = Math.round(Math.random()*100000);
                       cronExpr = RAD_Utils.getCRONExpression(wls.Scheduled_Date__c, wls.Schedule_Time__c);
                       RAD_InitiateScheduler initSchdlr = new RAD_InitiateScheduler(wls.id);
                       String jobID = System.schedule('SelectionInitiate' + wls.Name+'_'+ wls.Scheduled_Date__c.format()+'_'+String.valueof(randSeed), cronExpr , initSchdlr );
system.debug('$$$$ randSeed  value'+randSeed );  
system.debug('$$$$ cronExpr  value'+cronExpr  ); 
system.debug('$$$$ jobID  value'+jobID );                      
                       
                       
                }
                else if( wls.Cancel_Run__c == false && wls.Status__c == 'Scheduled' && wls.RAD_Scheduler_Count__c == 0 &&
                        ( ((Wait_List_Selection__c)Trigger.oldMap.get(wls.id)).RAD_Scheduler_Count__c == null ) ){
                        
                        //this is the actual time when the scheduler will have to start running,so counting the records first in wls in batch
                        //which will increment the schdlr count to greater than 1
                        
                        
                        if(wlType == 'Section 8'){
                     
                            RAD_Sec8SelnCnt_Batch b=new RAD_Sec8SelnCnt_Batch (wls.id);
                            Database.executeBatch(b) ; 
                            
                        }else if(wlType == 'NED'){
                            RAD_NEDSelnCnt_Batch bs=new RAD_NEDSelnCnt_Batch(wls.id);//default bed size is 1
                            Database.executeBatch(bs) ; 
                            
                        }else if(wlType == 'Public Housing'){
                            System.debug('rhathiii in public housing scheduled status ');
                            RAD_PubHsgSelnCnt_Batch b = new RAD_PubHsgSelnCnt_Batch(wls.id, wls.Bedroom_Size__c);
                            Database.executeBatch(b) ; 
                            
                        }else if(wlType == 'Project Based'){
                            RAD_PBSeln_Batch b=new RAD_PBSeln_Batch(wls.id, wls.Bedroom_Size__c);
                            Database.executeBatch(b) ; 
                            
                        }else if(wlType == 'Project Based Single'){
                            RAD_PBSSeln_Batch bs=new RAD_PBSSeln_Batch(wls.id); //default bedroom size is 1
                            Database.executeBatch(bs) ; 
                            
                        }else if(wlType == 'Mod Rehab'){
                            RAD_MODRBSeln_Batch b = new RAD_MODRBSeln_Batch(wls.id, wls.Bedroom_Size__c);
                            Database.executeBatch(b) ; 
                            
                        }
                            
                }
                
                else if( wls.Cancel_Run__c == false && wls.Status__c == 'Scheduled' 
                        && wls.RAD_Scheduler_Count__c >0 && ((Wait_List_Selection__c)Trigger.oldMap.get(wls.id)).RAD_Scheduler_Count__c != wls.RAD_Scheduler_Count__c  ){
                            
                            //this is the actual scheduler processing where the schdlr count is decremented once processed in execute
                            
                            if(wlType == 'Section 8'){
                                System.debug('hiiii');
                                
                                dt = Datetime.now();
                                tempMin = dt.minute() + 1 ;  //dont use current min
                                if(dt.second()>=55 ){
                                    tempMin = dt.minute() + 2 ;
                                }
                                
                                if(tempMin >= 59){ //greater
                                    tempMin = 0;
                                }
                                cronExpr = '0 ' + tempMin + ' * * * ? *';
                                System.debug('Recurring cron expression datetime is' + dt + ' :: '+ cronExpr );
                                
                                
                                Integer randSeed = Math.round(Math.random()*100000);
                                RAD_Section8Scheduler sec8Sch = new RAD_Section8Scheduler(wls.id);
                                String jobID = System.schedule('Sec8Seln_'+ wls.RAD_Current_Scheduler_Count__c + wls.Name+'_'+ wls.Scheduled_Date__c.format()+'_'+String.valueof(randSeed), cronExpr , sec8Sch);
                                
                                
                                
                            }
                            
                            else if(wlType == 'NED'){
                                System.debug('hiiii');
                                
                                
                                //For immediate testing ___
                                dt = Datetime.now();
                                tempMin = dt.minute() + 1 ;  //dont use current min, 
                                if(dt.second()>=55 ){
                                    tempMin = dt.minute() + 2 ;
                                }
                                if(tempMin >= 59){
                                    tempMin = 0;
                                }
                                cronExpr = '0 ' + tempMin + ' * * * ? *';
                                System.debug('my cron trigger will be 1 min from now '+ dt+ '::'+ cronExpr );
                                //__for immediate testing
                                
                                Integer randSeed = Math.round(Math.random()*100000);
                                RAD_NEDScheduler nedSch = new RAD_NEDScheduler(wls.id);
                                String jobID = System.schedule('NEDSeln_'+ wls.RAD_Current_Scheduler_Count__c +wls.Name+'_'+ wls.Scheduled_Date__c.format()+'_'+String.valueof(randSeed), cronExpr , nedSch);
                                
                                
                            }
                            else if(wlType == 'Public Housing'){
                                System.debug('rhathi trigger schdlr on count change');
                                
                                
                                //For immediate testing ___
                                dt = Datetime.now();
                                tempMin = dt.minute() + 1 ;  //dont use current min, 
                                if(dt.second()>=55 ){
                                    tempMin = dt.minute() + 2 ;
                                }
                                if(tempMin >= 59){
                                    tempMin = 0;
                                }
                                cronExpr = '0 ' + tempMin + ' * * * ? *';
                                System.debug('my cron trigger will be 1 min from now '+ dt+ '::'+ cronExpr );
                                //__for immediate testing
                                
                                Integer randSeed = Math.round(Math.random()*100000);
                                RAD_PubHsgScheduler pubHsgSch = new RAD_PubHsgScheduler(wls.id);
                                String jobID = System.schedule('PubHsgSeln_'+ wls.RAD_Current_Scheduler_Count__c +wls.Name+'_'+ wls.Scheduled_Date__c.format()+'_'+string.valueof(randSeed), cronExpr , pubHsgSch);
                                
                                
                            }
                            
                            else if(wlType == 'Project Based'){
                                system.debug('satya-schedular');
                                
                                //For immediate testing ___
                                dt = Datetime.now();
                                tempMin = dt.minute() + 1 ;  //dont use current min, 
                                if(dt.second()>=55 ){
                                    tempMin = dt.minute() + 2 ;
                                }
                                if(tempMin >= 59){
                                    tempMin = 0;
                                }
                                cronExpr = '0 ' + tempMin + ' * * * ? *';
                                System.debug('my cron trigger will be 1 min from now '+ dt+ '::'+ cronExpr );
                                //__for immediate testing
                                
                                Integer randSeed = Math.round(Math.random()*100000);
                                RAD_PB_Scheduler pbs = new RAD_PB_Scheduler(wls.id);
                                String jobID = System.schedule('PrjBsdSln_' + wls.RAD_Current_Scheduler_Count__c +wls.Name+'_'+ wls.Scheduled_Date__c.format()+'_'+String.valueof(randSeed), cronExpr , pbs);
                                
                            }
                            else if(wlType == 'Project Based Single'){
                                system.debug('satya-schedular');
                                
                                //For immediate testing ___
                                dt = Datetime.now();
                                tempMin = dt.minute() + 1 ;  //dont use current min,
                                if(dt.second()>=55 ){
                                    tempMin = dt.minute() + 2 ;
                                } 
                                if(tempMin >= 59){
                                    tempMin = 0;
                                }
                                cronExpr = '0 ' + tempMin + ' * * * ? *';
                                System.debug('my cron trigger will be 1 min from now '+ dt+ '::'+ cronExpr );
                                //__for immediate testing
                                
                                Integer randSeed = Math.round(Math.random()*100000);
                                RAD_PBS_Scheduler pbss = new RAD_PBS_Scheduler(wls.id);
                                String jobID = System.schedule('PrjBsdSglSln_' + wls.RAD_Current_Scheduler_Count__c +wls.Name+'_'+ wls.Scheduled_Date__c.format()+'_'+String.valueof(randSeed), cronExpr , pbss);
                                
                            }
                            
                            
                            else if(wlType == 'Mod Rehab'){
                                
                                system.debug('narasimha-schedular');
                                
                                //For immediate testing ___
                                dt = Datetime.now();
                                tempMin = dt.minute() + 1 ;  //dont use current min,
                                if(dt.second()>=55 ){
                                    tempMin = dt.minute() + 2 ;
                                } 
                                if(tempMin >= 59){
                                    tempMin = 0;
                                }
                                cronExpr = '0 ' + tempMin + ' * * * ? *';
                                System.debug('my cron trigger will be 1 min from now '+ dt+ '::'+ cronExpr );
                                //__for immediate testing
                                
                                Integer randSeed = Math.round(Math.random()*100000);
                                RAD_MODRB_Scheduler b = new RAD_MODRB_Scheduler(wls.id);
                                String jobID = System.schedule('ModRhbSln_'+ wls.RAD_Current_Scheduler_Count__c +wls.Name+'_'+ wls.Scheduled_Date__c+'_'+String.valueof(randSeed), cronExpr , b);
                                
                            }
                            
                            
                        }
                
                
                else if(wls.Cancel_Run__c == false && wls.Status__c == 'Completed' && ( ((Wait_List_Selection__c)Trigger.oldMap.get(wls.id)).Status__c != wls.Status__c) ){
                    if(wlType == 'Section 8'){
                        RAD_Sec8SelctdNtfyBatch b = new RAD_Sec8SelctdNtfyBatch(wls.Id );
                        ID myBatchJobID = Database.executeBatch(b) ;
                    }else if(wlType == 'Public Housing'){
                        
                        RAD_PubHsgPrintLblBatch b=new RAD_PubHsgPrintLblBatch (wls.Id);
                        Database.executeBatch(b) ; 
                        
                    }
                    else if(wlType == 'NED'){                      
                        RAD_NEDSelctdNtfyBatch b=new  RAD_NEDSelctdNtfyBatch (wls.Id);
                        Database.executeBatch(b) ; 
                        
                    }
                    else if(wlType == 'Mod Rehab'){                      
                        RAD_MRSelctdNtfyBatch b=new  RAD_MRSelctdNtfyBatch (wls.Id);
                        Database.executeBatch(b) ; 
                        
                    }
                    else if(wlType == 'Project Based'){                      
                        RAD_ProjectBasedSelctdNtfyBatch b=new  RAD_ProjectBasedSelctdNtfyBatch (wls.Id);
                        Database.executeBatch(b) ; 
                        
                    }
                    else if(wlType == 'Project Based Single'){                      
                        RAD_ProjectBasedSingleSelctdNtfyBatch b=new  RAD_ProjectBasedSingleSelctdNtfyBatch (wls.Id);
                        Database.executeBatch(b) ; 
                        
                    }
                    
                }
                
            }    
            
        }
    }
}