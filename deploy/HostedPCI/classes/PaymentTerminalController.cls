public with sharing class PaymentTerminalController {
    public string SiteId{get ; set;}
    public string LocationName{get; set;}
    public string fullParentQStr{get; set;}
    public string fullParentHost{get; set;}
    public string iFrameSrc{get; set;}    

    @RemoteAction
    public static Map<String,String> processPayment(String ccToken, String cvvToken, String cardType,
           String expiryMonth, String expiryYear, String firstName, String lastName, String address1,
           String address2, String city, String state, String zip, String country, String hpciCurrency,
           String paymentAmount, String paymentComments, String paymentProfile, String action3DSec){

        // Setup request param map
        Map<String,String> hpciRequestParamMap = new Map<String,String>();

        // Get request parameters from form (all the attributes that the
        // user inputs
        hpciRequestParamMap.put('pxyCreditCard.cardType', cardType);
        hpciRequestParamMap.put('pxyCreditCard.creditCardNumber', ccToken);
        hpciRequestParamMap.put('pxyCreditCard.expirationMonth', expiryMonth);
        hpciRequestParamMap.put('pxyCreditCard.expirationYear', expiryYear);
        hpciRequestParamMap.put('pxyCreditCard.cardCodeVerification', cvvToken);
        hpciRequestParamMap.put('pxyTransaction.txnAmount', paymentAmount);
        hpciRequestParamMap.put('pxyTransaction.txnCurISO', hpciCurrency);
        DateTime timeStamp = DateTime.now();
        String merchantRefId = String.valueOf(timeStamp.millisecond()+ 1000000);
        hpciRequestParamMap.put('pxyTransaction.merchantRefId',merchantRefId);
        hpciRequestParamMap.put('pxyTransaction.txnPayName', paymentProfile);
        hpciRequestParamMap.put('pxyTransaction.txnComment', paymentComments);
        hpciRequestParamMap.put('pxyCustomerInfo.billingLocation.firstName', firstName);
        hpciRequestParamMap.put('pxyCustomerInfo.billingLocation.lastName', lastName);
        hpciRequestParamMap.put('pxyCustomerInfo.billingLocation.address', address1);
        hpciRequestParamMap.put('pxyCustomerInfo.billingLocation.address2', address2);
        hpciRequestParamMap.put('pxyCustomerInfo.billingLocation.city', city);
        hpciRequestParamMap.put('pxyCustomerInfo.billingLocation.state', state);
        hpciRequestParamMap.put('pxyCustomerInfo.billingLocation.zipCode', zip);
        hpciRequestParamMap.put('pxyCustomerInfo.billingLocation.country', country);

        if(action3DSec =='verifyenroll'){
                   hpciRequestParamMap.put('pxyThreeDSecAuth.actionName', action3DSec);
        }

        String hostedPciMsg = HostedPciServiceUtil.httpCalloutHostedPciAuthOnly(hpciRequestParamMap);
        Map<String,String> hostedPciMsgMap = HostedPciServiceUtil.parseQueryString(hostedPciMsg);

        if(hostedPciMsgMap.get('pxyResponse.threeDSEnrolled') != 'Y'){
            SaveTransaction(ccToken, cardType, firstName, lastName, expiryMonth, expiryYear,
                            address1, address2, paymentAmount, city, country, hpciCurrency,
                            hostedPciMsgMap.get('pxyResponse.processorRefId'), merchantRefId, paymentComments, paymentProfile,
                            state, zip, hostedPciMsg);
            }

        hostedPciMsgMap.put('fullMsg',hostedPciMsg);
        return hostedPciMsgMap;
    }

    public static void SaveTransaction(String ccNum, String cardType, String firstName, String lastName,
                                String expiryMonth, String expiryYear, String address1, String address2,
                                String amount, String city, String country, String hpciCurrency,
                                String processorRefId, String merchantRefId, String comment, String paymentProfile,
                                String state, String zip, String hostedPciMsg){
        Token__c newToken = new Token__c();
        Payment__c newPayment = new Payment__c();

        newToken.Name = ccNum;
        newToken.ccNum__c = ccNum;
        newToken.cardType__c = cardType;
        newToken.firstName__c = firstName;
        newToken.lastName__c = lastName;
        newToken.expiryMonth__c = expiryMonth;
        newToken.expiryYear__c = expiryYear;

        try {
            upsert newToken newToken.ccNum__c;

            // Once the token is inserted, the sObject will be
            // populated with an ID.
            ID newTokenID = newToken.ID;

            DateTime timeStamp = DateTime.now();
            if(processorRefId == '0'){
                newPayment.Name = String.valueOf(timeStamp.millisecond());
            }else{
                newPayment.Name = processorRefId + '-' + String.valueOf(timeStamp.millisecond());
            }

            newPayment.address1__c = address1;
            newPayment.address2__c = address2;
            newPayment.amount__c = amount;
            newPayment.city__c = city;
            newPayment.country__c = country;
            newPayment.currency__c = hpciCurrency;
            newPayment.merchantRefId__c = merchantRefId;
            newPayment.processorRefId__c = processorRefId;
            newPayment.comment__c = comment;
            newPayment.paymentProfile__c = paymentProfile;
            newPayment.state__c = state;
            newPayment.zip__c =  zip;
            newPayment.HostedPci_Response__c = hostedPciMsg;
            newPayment.Token__c = newTokenID;

            //Check if the user has create access
            if (!Schema.sObjectType.Payment__c.isCreateable()){
                  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,
	                                                    'Insufficient access'));
	     		return;
			}
            upsert newPayment;
        } catch (DmlException e) {
            System.debug(e.getMessage());
            ApexPages.addMessages(e);
        }
    }

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
                hostedPciConf.endPointBaseUrl__c = 'https://apiservice.hostedpci.com';
                hostedPciConf.endPointSale__c = '/iSynSApp/paymentSale.action';
                hostedPciConf.endPoint_manageCCMapPhoneAPI__c = '/iSynSApp/manageCCMapPhoneAPI.action';
                hostedPciConf.siteId__c = '528160';

                //Check if the user has create access
                if (!Schema.sObjectType.HostedPCISettings__c.isCreateable()){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,
	                                                    'Insufficient access'));
	      			return null;
			    }
                insert hostedPciConf;

                SiteId = HostedPCISettings__c.getInstance().siteId__c;
                LocationName = HostedPCISettings__c.getInstance().locationName__c;
                iFrameSrc = 'https://ccframe.hostedpci.com/iSynSApp/showPxyPage!ccFrame.action?pgmode1=prod&'
            			+'locationName='+ LocationName
            			+'&sid=' + SiteId
            			+'&pluginMode=jq2'
            			+'&fullParentHost=https://' + fullParentHost
            			+'&fullParentQStr=' + fullParentQStr;

            }catch (DmlException e) {
                System.debug(e.getMessage());
                ApexPages.addMessages(e);
            }
        }else{
            iFrameSrc = 'https://ccframe.hostedpci.com/iSynSApp/showPxyPage!ccFrame.action?pgmode1=prod&'
            			+'locationName='+ LocationName
            			+'&sid=' + SiteId
            			+'&pluginMode=jq2'
            			+'&fullParentHost=https://' + fullParentHost
            			+'&fullParentQStr=' + fullParentQStr;
        }
        return null;
    }
    
    public PageReference processThreeDSecPayment() {
       	PageReference nextPage = Page.ThreeDSecPinFrame;

        nextPage.getParameters().put('authTxnId', ApexPages.currentPage().getParameters().get('authTxnId'));
        nextPage.getParameters().put('ccNum', ApexPages.currentPage().getParameters().get('ccNum'));
        nextPage.getParameters().put('ccCVV', ApexPages.currentPage().getParameters().get('ccCVV'));
        nextPage.getParameters().put('cardType', ApexPages.currentPage().getParameters().get('cardType'));           
        nextPage.getParameters().put('expiryMonth', ApexPages.currentPage().getParameters().get('expiryMonth'));           
        nextPage.getParameters().put('expiryYear', ApexPages.currentPage().getParameters().get('expiryYear'));           
        nextPage.getParameters().put('firstName', ApexPages.currentPage().getParameters().get('firstName'));           
        nextPage.getParameters().put('lastName', ApexPages.currentPage().getParameters().get('lastName'));           
        nextPage.getParameters().put('address1', ApexPages.currentPage().getParameters().get('address1'));           
        nextPage.getParameters().put('address2', ApexPages.currentPage().getParameters().get('address2'));           
        nextPage.getParameters().put('city', ApexPages.currentPage().getParameters().get('city'));           
        nextPage.getParameters().put('state', ApexPages.currentPage().getParameters().get('state'));           
		nextPage.getParameters().put('zip', ApexPages.currentPage().getParameters().get('zip'));           
        nextPage.getParameters().put('country', ApexPages.currentPage().getParameters().get('country'));           
        nextPage.getParameters().put('currency', ApexPages.currentPage().getParameters().get('currency'));           
        nextPage.getParameters().put('amount', ApexPages.currentPage().getParameters().get('amount'));           
        nextPage.getParameters().put('comment', ApexPages.currentPage().getParameters().get('comment'));           
        nextPage.getParameters().put('paymentProfile', ApexPages.currentPage().getParameters().get('paymentProfile'));           
        
        return nextPage; 
    }

}