// Convert String Date in m/d/y hh:mm:ss format to datetime
//

public class RAD_Utils{
    public static DateTime convertStringToDate(String date_string) {
        String todParts = '';
        Integer hour_int = 0;
        Integer minute_int = 0;
        Integer second_int = 0;
        Integer year_int = 0;
        Integer month_int = 0;
        Integer day_int = 0;
        Datetime dtConverted;    
        DateTime converted_datetime = null;
        try{

            todParts = '';
            List <String> stringParts = date_string.split(' ');
            List <String> timeParts = stringParts[1].split(':');
            List <String> dateParts = stringParts[0].split('/');
            if(timeParts.size() > 0)
            {   
                if(Integer.valueof(timeParts[0]) > 12)
                {
                    todParts = 'PM';
                    hour_int = Integer.valueof(timeParts[0]);
                    //hour_int = Integer.valueof(timeParts[0])-12;
                } else
                {
                    todParts = 'AM';
                    hour_int = Integer.valueof(timeParts[0]);
                }
                minute_int = Integer.valueof(timeParts[1]);
                if(timeParts.size() == 3)
                {
                    second_int = Integer.valueof(timeParts[2]);
                } else
                {
                    second_int = 0;
                }
            } else
            {
                hour_int = 0;
                minute_int = 0;
                second_int = 0;
            }
            // begin assembly
    
            year_int = Integer.valueof(dateParts[2]);
            month_int = Integer.valueof(dateParts[0]);
            day_int = Integer.valueof(dateParts[1]);
    
            dtConverted = DateTime.newInstance(year_int,month_int,day_int, hour_int, minute_int, second_int);
            converted_datetime  = dtConverted;
            return converted_datetime;
            //system.debug('converted:' +String.valueof(dtConverted));
    
        } catch( exception ex)
        {
            System.debug('line:' + ex.getLineNumber() + ' __ ' +ex.getMessage());
            return converted_datetime;
        } finally
        {
            return converted_datetime;
        }
    
    }

//CRON FORMAT:: Seconds Minutes Hours Day_of_month Month Day_of_week Optional_year
//This class returns the cron expression for the given date and time of the day

    public static String getCRONExpression(Date dt, String tm) {
        system.debug('dt.day @@@ '+dt.day());
        system.debug('dt.month @@@ '+dt.month());
        system.debug('dt.year @@@ '+dt.year());
        system.debug('dt'+dt);
        system.debug('tm'+tm);
       
        if(tm=='1:00 AM')
        return ('0'+' 0'+' 01' + ' ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year());
        if(tm=='2:00 AM')
        return ('0'+' 0'+' 02' + ' ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year());
        if(tm=='3:00 AM')
        return ('0'+' 0'+' 03' + ' ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year());
        if(tm=='4:00 AM')
        return ('0'+' 0'+' 04' + ' ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year());
        if(tm=='5:00 AM')
        return ('0'+' 0'+' 05' + ' ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year());
        if(tm=='6:00 AM')
        return ('0'+' 0'+' 06' + ' ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year());
        if(tm=='7:00 AM')
        return ('0'+' 0'+' 07' + ' ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year());
        if(tm=='8:00 AM')
        return ('0'+' 0'+' 08' + ' ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year());
        if(tm=='9:00 AM')
        return ('0'+' 0'+' 09' + ' ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year());
        if(tm=='10:00 AM')
        return ('0'+' 0'+' 10' + ' ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year());
        if(tm=='11:00 AM')
        return ('0'+' 0'+' 11' + ' ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year());
        if(tm=='12:00 PM')
        return ('0'+' 0'+' 12' + ' ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year());
        
         
        if(tm=='1:00 PM')
        return ('0'+' 0'+' 13' + ' ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year());
        if(tm=='2:00 PM')
        return ('0'+' 0'+' 14' + ' ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year());
        if(tm=='3:00 PM')
        return ('0'+' 0'+' 15' + ' ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year());
        if(tm=='4:00 PM')
        return ('0'+' 0'+' 16' + ' ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year());
        if(tm=='5:00 PM')
        return ('0'+' 0'+' 17' + ' ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year());
        if(tm=='6:00 PM')
        return ('0'+' 0'+' 18' + ' ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year());
        if(tm=='7:00 PM')
        return ('0'+' 0'+' 19' + ' ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year());
        if(tm=='8:00 PM')
        return ('0'+' 0'+' 20' + ' ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year());
        if(tm=='9:00 PM')
        return ('0'+' 0'+' 21' + ' ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year());
        if(tm=='10:00 PM')
        return ('0'+' 0'+' 22' + ' ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year());
        if(tm=='11:00 PM')
        return ('0'+' 0'+' 23' + ' ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year());
        if(tm=='12:00 AM')
        return ('0'+' 0'+' 00' + ' ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year());

        
        
       //return ('' + dt.second() + ' ' + dt.minute() + ' ' + dt.hour() + ' ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year());
       return '';
    }
    public static void loadTest(){
        Integer i = 0;
    }  

}