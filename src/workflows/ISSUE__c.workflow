<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Closure_Email</fullName>
        <description>Closure Email</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>ch.ravi@cgi.com.production</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>dell.boomi@sdhc.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jyothi.manniathillath1@cgi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>roy.p.sdhc@cgi.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Closure_email</template>
    </alerts>
    <rules>
        <fullName>Closure email</fullName>
        <actions>
            <name>Closure_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ISSUE__c.Status__c</field>
            <operation>equals</operation>
            <value>Resolved</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Created</fullName>
        <active>false</active>
        <criteriaItems>
            <field>ISSUE__c.Status__c</field>
            <operation>notEqual</operation>
            <value>New</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
