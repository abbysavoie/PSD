<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>upadteapplnmemo</fullName>
        <field>newdate__c</field>
        <formula>NOW()</formula>
        <name>upadteapplnmemo</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Applications__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>memo validate</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Memo__c.Status__c</field>
            <operation>equals</operation>
            <value>Memo,Scheduled,In Process,Completed,Cancelled</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>upadte appln_memo</fullName>
        <actions>
            <name>upadteapplnmemo</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR( ISNEW(), ISCHANGED(Name),  ISCHANGED(Date_and_Time__c),ISCHANGED(Type__c), ISCHANGED(Status__c),ISCHANGED(Result__c), ISCHANGED(Notes__c),ISCHANGED(	Wait_List_Type__c), ISCHANGED(Activity__c), 	ISCHANGED(APP_HMY__c),ISCHANGED(Contact_HMY__c) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
