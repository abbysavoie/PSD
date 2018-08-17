global class RADApplicationCtrlr {
    /*
    public String CSSURL {get; set;}
    public String JSURL {get; set;}    
    
    public Applications__c theApp {get; set;}               
    
    public RADApplicationCtrlr(){
        StaticResource objStc = [Select Id, LastModifiedDate From StaticResource where Name='RAD_Web'];        
        Long iCnt = objStc.LastModifiedDate.getTime();        
        CSSURL = '/resource/'+iCnt+'/RAD_Web/css/';
        JSURL  = '/resource/'+iCnt+'/RAD_Web/js/';
    }
    
    @RemoteAction
    global static Applications__c saveSubmit(Applications__c app, String action){       
        try {                                                           
            system.debug('ACTION: ' + action);
            if(app.Applicant__c == null){
                app.Applicant__c = [select Id from Contact limit 1][0].Id; //to change  
            }           
            
            if(action.equals('save')){                              
                app.Application_Status__c = 'Saved';
            }else if(action.equals('submit')){
                app.Application_Status__c = 'Submitted';
            }
            
            if(app.Id != null){
                update(app);                
            }else {
                insert(app);
                for( Applications__c application : [Select a.Name, a.of_people_in_the_H_H_Adults__c, a.White__c, a.Veteran_Family_of__c, a.Sight_Access__c, a.SSN__c, a.Pacific_Islander__c,a.Family_Annual_Income__c, a.Occupation__c, a.Non_Elderly_Disabled__c, a.Near_Elderly__c, a.Mobility_Access__c, a.Middle_Name__c, a.Live_Work_in_City_of_San_Diego__c, a.Last_Name__c, a.Homeless_with_disability__c, a.Homeless__c, a.Hearing_Access__c, a.First_Name__c, a.Family__c,  a.Ethnicity__c, a.Employment_Zip_Code__c, a.Elderly__c, a.Education__c, a.Displaced__c, a.Disabled_Family__c, a.Disable__c, a.Dependents_Children_under_age_of_18__c, a.DOB__c, a.Citizenship__c, a.Black__c, a.Asian__c, a.Are_you_veteran_or_a_family_of_a_ventera__c, a.Are_you_or_your_spouse_co_head_disabled__c, a.Are_you_in_Active_duty_with_US_Army__c, a.American_Indian__c, a.Age__c From Applications__c a where Id = :app.id Limit 1]){                                                                           
                    app = application;
                }
            }               
            
            return app;
        }catch(Exception e){
            system.debug(e.getMessage());
            return null;
            //return 'FAIL : ' + e.getMessage();            
        }           
    }   
    
    @RemoteAction
    global static Applications__c getApplication(String appid){
        if(appid != null || appid.length() > 0){            
            List<Applications__c> app = new List<Applications__c>();
            for( Applications__c application : [Select a.Name, a.of_people_in_the_H_H_Adults__c, a.White__c, a.Veteran_Family_of__c, a.Sight_Access__c, a.SSN__c, a.Pacific_Islander__c, a.Family_Annual_Income__c,a.Occupation__c, a.Non_Elderly_Disabled__c, a.Near_Elderly__c, a.Mobility_Access__c, a.Middle_Name__c, a.Live_Work_in_City_of_San_Diego__c, a.Last_Name__c, a.Homeless_with_disability__c, a.Homeless__c, a.Hearing_Access__c, a.First_Name__c, a.Family__c,  a.Ethnicity__c, a.Employment_Zip_Code__c, a.Elderly__c, a.Education__c, a.Displaced__c, a.Disabled_Family__c, a.Disable__c, a.Dependents_Children_under_age_of_18__c, a.DOB__c, a.Citizenship__c, a.Black__c, a.Asian__c, a.Are_you_veteran_or_a_family_of_a_ventera__c, a.Are_you_or_your_spouse_co_head_disabled__c, a.Are_you_in_Active_duty_with_US_Army__c, a.American_Indian__c, a.Age__c From Applications__c a where Id = :appid Limit 1]){
                                                                                      
                                                                                          
                app.add(application);
            }
            if(!app.isEmpty()){
                return app.get(0);
            }else return new Applications__c();                                 
        }else return new Applications__c();             
    }   
    
    */ 
    
}