/* ---------------- About This Class ---------------------------------------------------------------------------- 
@ Project        : Housing Commision Rental Assistance
@ Description    : HC date time change controller.
@ Author         : Vishnu Priya Duggineni
@ Date           : 12-28-2017
@ Reviewer       : Roy Poystila
------------------------------------------------------------------------------------------------------------------------------- */
public class HC_FormatDateTime {
    public DateTime dateTimeValue { get; set; }
    public DateTime orgdateTimeValue { get; set; }
    public DateTime curdateTimeValue { get; set; }
    public Boolean blnReadOnly { get; set; }
    
    public String getTimeZoneValue() {
        if( dateTimeValue != null ) {
            String localeFormatDT = dateTimeValue.format('MM/dd/YYYY hh:mm:ss a');
            return localeFormatDT;
        }
        return null;
    }
     public String getOrgTimeZoneValue() {
        if( orgdateTimeValue != null ) {
            String localeFormatDT = orgdateTimeValue.format('MM/dd/YYYY hh:mm:ss a');
            return localeFormatDT;
        }
        return null;
    }
     public String getCurTimeZoneValue() {
        if( curdateTimeValue != null ) {
            String localeFormatDT = curdateTimeValue.format('MM/dd/YYYY hh:mm:ss a');
            return localeFormatDT;
        }
        return null;
    }
}