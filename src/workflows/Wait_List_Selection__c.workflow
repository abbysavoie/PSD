<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send_email_notification_of_upcoming_selection</fullName>
        <description>Send email notification of upcoming selection</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>unfiled$public/Notification_of_upcoming_selection_run</template>
    </alerts>
    <fieldUpdates>
        <fullName>Update_eli30</fullName>
        <field>Applicant_at_eli_30_75__c</field>
        <formula>CEILING((Number_to_Select_from_List__c / 100) * 75)</formula>
        <name>Update eli30</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_vli30</fullName>
        <field>Applicant_at_vli_50_25__c</field>
        <formula>FLOOR((Number_to_Select_from_List__c / 100) * 25)</formula>
        <name>Update vli30</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Set up Selection Notification email</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Wait_List_Selection__c.Scheduled_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Send_email_notification_of_upcoming_selection</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Wait_List_Selection__c.Scheduled_Date__c</offsetFromField>
            <timeLength>-1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Update eli30 vli50</fullName>
        <actions>
            <name>Update_eli30</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_vli30</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1</booleanFilter>
        <criteriaItems>
            <field>Wait_List_Selection__c.Number_of_vacancies_to_fill__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
