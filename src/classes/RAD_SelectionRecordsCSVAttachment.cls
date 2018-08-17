/****
Purpose of this class : Once selection Process is completed, this class will create a csv attachment with all the selected waitlist records and send out as an email to Scheduler. 
****/

public class RAD_SelectionRecordsCSVAttachment{
public id slid;  // Wait list Selection Id
public Wait_List_Selection__c wls ;
public RAD_SelectionRecordsCSVAttachment(){}

public void csvAttachment(String slid){
    //Querying Selection Records ID = Wait list Selection Id
List<Selection_Records__c > selectionRecords = [select id, Position__c, Name__c,Prospect__c,Lottery_Rank__c, Income_Target__c, Status__c, Pref_Points__c,
                           RAD_Wait_List__r.Limit__c, RAD_Wait_List__r.Prefernce_Point__c, RAD_Wait_List__r.Bed_size__c, RAD_Wait_List__r.Current_Status__c,
                
                           RAD_Wait_List__r.Applications__r.Total_People__c, RAD_Wait_List__r.Applications__r.Family_Annual_Income__c, RAD_Wait_List__r.Applications__r.Applied_Date_time__c,   
                           RAD_Wait_List__r.Applications__r.Ethnicity__c,  RAD_Wait_List__r.Applications__r.HH_Stats__c,RAD_Wait_List__r.Applications__r.HH_Race__c,
                           
                           RAD_Wait_List__r.Applications__r.Near_Elderly__c, RAD_Wait_List__r.Applications__r.Disable__c, RAD_Wait_List__r.Applications__r.Elderly__c,
                           RAD_Wait_List__r.Applications__r.Displaced__c, RAD_Wait_List__r.Applications__r.Homeless__c, RAD_Wait_List__r.Applications__r.White__c, RAD_Wait_List__r.Applications__r.Black__c,
                           RAD_Wait_List__r.Applications__r.Pacific_Islander__c, RAD_Wait_List__r.Applications__r.American_Indian__c, RAD_Wait_List__r.Applications__r.Asian__c,
                           //Near_Elderly__c, Disable__c, Elderly__c,  Displaced__c,Homeless__c,White__c,Black__c, Pacific_Islander__c, American_Indian__c, Asian__c
                           
                           RAD_Wait_List__r.Applications__r.Applicant__r.Tenant_Number_YARDI__c, RAD_Wait_List__r.Applications__r.Applicant__r.Prospect_Number_YARDI__c, RAD_Wait_List__r.Applications__r.Applicant__r.Name,                           
                           RAD_Wait_List__r.Applications__r.Applicant__r.SSN_TaxID__c, RAD_Wait_List__r.Applications__r.Applicant__r.Gender__c
                                                                         
                           from Selection_Records__c where Selection_ID__c = :slid and Status__c = 'Selected' ];
                           
                           system.debug(' $$$$ selectionRecords '+selectionRecords );

//Column Header Names                         
string header = 'Position, Resident, Prospect, Name, SSN, Gender,#HH Occ.,HH Stats,HH Race,HH Ethnicity,HH Income, Income Target,Pref Points,#Bed Rooms, App Date/Time, Status \n';
string finalHeader = header ;
//Looping through Selection Records and combining field values in comma separated
for(Selection_Records__c sr: selectionRecords)
{

string recordString = sr.Position__c+','+sr.RAD_Wait_List__r.Applications__r.Applicant__r.Tenant_Number_YARDI__c+','+sr.Prospect__c+','+
                      sr.RAD_Wait_List__r.Applications__r.Applicant__r.Name+','+sr.RAD_Wait_List__r.Applications__r.Applicant__r.SSN_TaxID__c+','+
                      sr.RAD_Wait_List__r.Applications__r.Applicant__r.Gender__c+','+sr.RAD_Wait_List__r.Applications__r.Total_People__c+','+
                      sr.RAD_Wait_List__r.Applications__r.HH_Stats__c+','+sr.RAD_Wait_List__r.Applications__r.HH_Race__c+','+sr.RAD_Wait_List__r.Applications__r.Ethnicity__c+','+
                      sr.RAD_Wait_List__r.Applications__r.Family_Annual_Income__c+','+sr.RAD_Wait_List__r.Limit__c+','+sr.Pref_Points__c+','+sr.RAD_Wait_List__r.Bed_size__c+','+
                      sr.RAD_Wait_List__r.Applications__r.Applied_Date_time__c+','+sr.Status__c+'\n';
       
            finalHeader = finalHeader +recordString;

}

wls = [select id, name,Wait_List_Type__r.name,CreatedBy.Email from Wait_List_Selection__c where id = :slid limit 1];

//Sending an email with selection records as attachment(.csv format) to the Scheduler
Messaging.EmailFileAttachment csvFormat = new Messaging.EmailFileAttachment();
blob csvBlob = Blob.valueOf(finalHeader);
string csvname = +wls.name+' '+'Selection Records.csv';
csvFormat.setFileName(csvname);
csvFormat.setBody(csvBlob);
Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();

String[] toAddresses = new list<string> {wls.CreatedBy.Email}; 
//String[] toAddresses = new list<string> {'ravisf4@gmail.com'}; 
/* Email should be fired to Scheduler  
AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,
                          TotalJobItems, CreatedBy.Email
                          from AsyncApexJob where Id =
                          :BC.getJobId()];
                          */
                          
String subject = +wls.Wait_List_Type__r.name+' ' +'Selection Records'; //Selection Records for SL-000000000092(selectionRecords.Name) 
email.setSubject(subject);
email.setToAddresses( toAddresses );
system.debug('$$$$ email sent to the scheduler');

email.setPlainTextBody('Selection Process for' +' '+wls.Wait_List_Type__r.name+' '+'has completed.\n'+
            'Please find the attachment for Selection Records' );
email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvFormat});
Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});

}

}