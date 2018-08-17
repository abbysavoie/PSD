public class SandiegoHousingCommissionLogoControllers {
public String LogoUrl {
    get {
        id orgId = UserInfo.getOrganizationId();
        String idDocumentoCityLogo = SDHCLOGO__c.getInstance().Document_ID__c;
        return this.SfInstance + '/servlet/servlet.ImageServer?id=' + idDocumentoCityLogo   + '&oid=' + orgId ;
    }
}
public String SfInstance
{
    get{      
        string SFInstance = URL.getSalesforceBaseUrl().toExternalForm();
        return SFInstance;
    }
}
}