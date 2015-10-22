public with  sharing class PaymentTerminalController {
    public string SiteId{get ; set;}
    public string LocationName{get; set;}
    public string fullParentQStr{get; set;}
    public string fullParentHost{get; set;}

    public PageReference populateData(){
        fullParentQStr = ApexPages.currentPage().getUrl();
        fullParentHost = ApexPages.currentPage().getHeaders().get('Host');

        SiteId = HostedPCISettings__c.getInstance().siteId__c;
        LocationName = HostedPCISettings__c.getInstance().locationName__c;
        if((String.isEmpty(SiteId))&&(String.isEmpty(LocationName))){
            try{
                HostedPCISettings__c hostedPciConf = HostedPCISettings__c.getOrgDefaults();

                hostedPciConf.userName__c = 'sampqa1stgAdmAPI';
                hostedPciConf.apiType__c = 'pxyhpci';
                hostedPciConf.userPassKey__c = '.OQdIHVtVJSg-W-Zr40QQGY1xyhvGjUH';
                hostedPciConf.endPointVoid__c = '/iSynSApp/paymentVoid.action';
                hostedPciConf.endPointCapture__c = '/iSynSApp/paymentCapture.action';
                hostedPciConf.endPointCredit__c = '/iSynSApp/paymentCredit.action';
                hostedPciConf.locationName__c = 'javasample1';
                hostedPciConf.apiVersion__c = '1.0.1';
                hostedPciConf.endPointAuth__c = '/iSynSApp/paymentAuth.action';
                hostedPciConf.endPointBaseUrl__c = 'https://api-sampqa1stg.c1.hostedpci.com';
                hostedPciConf.endPointSale__c = '/iSynSApp/paymentSale.action';
                hostedPciConf.siteId__c = '528160';

                insert hostedPciConf;

                SiteId = HostedPCISettings__c.getInstance().siteId__c;
                LocationName = HostedPCISettings__c.getInstance().locationName__c;
            }catch (DmlException e) {
            	System.debug(e.getMessage());
            	ApexPages.addMessages(e);
        	}
        }
        return null;
    }
}
