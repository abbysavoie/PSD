<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>PASS_THROUGH</fullName>
        <field>Current_Status__c</field>
        <literalValue>Selected</literalValue>
        <name>PASS THROUGH</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reason_code_update</fullName>
        <field>Reason__c</field>
        <literalValue>System Selection</literalValue>
        <name>Reason code update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reasoncode_update</fullName>
        <field>Reason__c</field>
        <literalValue>Income Targeting</literalValue>
        <name>Reasoncode update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Reason_Value</fullName>
        <field>Reason__c</field>
        <literalValue>Dropped</literalValue>
        <name>Set Reason Value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Updating_Status_to_Removed</fullName>
        <field>Current_Status__c</field>
        <literalValue>Removed</literalValue>
        <name>Updating Status to Removed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>YARDI_Wait_List_Type</fullName>
        <field>YARDI_Wait_List_Type__c</field>
        <literalValue>9</literalValue>
        <name>YARDI Wait List Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>upadte_appln_waitlist</fullName>
        <field>newdate__c</field>
        <formula>NOW()</formula>
        <name>upadte appln_waitlist</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Applications__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>PASS THROUGH</fullName>
        <actions>
            <name>PASS_THROUGH</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>YARDI_Wait_List_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Enrolled_Wait_List__c.PASS_THROUGH__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>When an application gets set up with Wait List option “PASS THROUGH,” the status on the waitlist shall be automatically updated to “Selected.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Reason Codefor ModRehab</fullName>
        <actions>
            <name>Reason_code_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>IF(  Wait_List_Type__r.Name = &apos;Mod Rehab&apos; , true, false)  &amp;&amp;  ISPICKVAL(Current_Status__c, &apos;Selected&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Reason code for Other WL</fullName>
        <actions>
            <name>Reasoncode_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>OR(IF(  Wait_List_Type__r.Name = &apos;NED&apos; , true, false),  IF(  Wait_List_Type__r.Name = &apos;Public Housing&apos; , true, false),  IF(  Wait_List_Type__r.Name = &apos;Section 8&apos; , true, false),  IF(  Wait_List_Type__r.Name = &apos;Project Based&apos; , true, false),  IF(  Wait_List_Type__r.Name = &apos;Project Based Single&apos; , true, false)  )  &amp;&amp;  ISPICKVAL(Current_Status__c, &apos;Selected&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Removed Reason</fullName>
        <actions>
            <name>Set_Reason_Value</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Enrolled_Wait_List__c.Current_Status__c</field>
            <operation>equals</operation>
            <value>Removed</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Status</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Enrolled_Wait_List__c.Current_Status__c</field>
            <operation>equals</operation>
            <value>Selected</value>
        </criteriaItems>
        <criteriaItems>
            <field>Enrolled_Wait_List__c.Applicant_Confirmation_Received__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Updating_Status_to_Removed</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>upadte appln_waitlist</fullName>
        <actions>
            <name>upadte_appln_waitlist</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>OR( ISNEW(), ISCHANGED(Wait_List_Type__c),ISCHANGED(Current_Status__c), ISCHANGED(Portal_Status__c), ISCHANGED(Reason__c), ISCHANGED(RAD_Preference_Group__c), ISCHANGED(RAD_Applied_Date_and_Time__c), ISCHANGED(RAD_Date_and_Time_with_Seconds__c), ISCHANGED(Current_Status_Date_Time__c), ISCHANGED(Prefernce_Point__c), ISCHANGED(Limit__c),ISCHANGED(reason_out_of_order__c), ISCHANGED(Lottery__c) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
