public without sharing class HostedPCICheckoutController { //CRUD/FLS False Positive: required for Sites user with Create/Read permissions.
	public String firstName { get; set; }
    public String lastName { get; set; }
    public String address1 { get; set; }
    public String address2 { get; set; }
    public String city { get; set; }
    public String state { get; set; }
    public String zip { get; set; }
    public String comment { get; set; }
    public String hostedPCICurrency { get; set; }
    public String amount { get; set; }
    public String paymentProfile { get; set; }
    public String country{ get; set; }
    public String cardType { get; set; }
    public String expiryMonth { get; set; }
    public String expiryYear { get; set; }
    public String SiteId{get ; set;}
    public String LocationName{get; set;}
    public String fullParentQStr{get; set;}
    public String fullParentHost{get; set;}
    public String iFrameSrc{get; set;}
    public String ccBIN{get; set;}
    public String ccNum{get; set;}
    public String ccCVV{get; set;}
    public date payDate { get; private set; }
    public String status { get; private set; }
    public String description { get; set; }
    public String merchantRefId { get; private set; }
    public String processorRefId { get; private set; }
    public String hostedPciMsg { get; private set; }
    public Map<String,String> hostedPciMsgMap{get; private set; }
    //3Dsecurity parameters
	public String action3DSec { get; set; }
    public string authTxnId{get; set;}

    public PageReference processPayment() {
        PageReference nextPage;        
        	
        //Call HostedPCI
        HostedPciCallout();        

        // Postprocess request: gather and validate submitted data
        status = hostedPciMsgMap.get('status');
        description = hostedPciMsgMap.get('pxyResponse.responseStatus.description');		
        
        payDate = Date.today();
		SaveTransaction();
        
        if(hostedPciMsgMap.get('pxyResponse.threeDSEnrolled') != 'Y'){            
			nextPage = Page.HostedPCICheckoutMsg;
        }else if(hostedPciMsgMap.get('pxyResponse.threeDSEnrolled') == 'Y'){
            authTxnId= hostedPciMsgMap.get('pxyResponse.threeDSTransactionId');
            nextPage = Page.ThreeDSecPin;
            
            fullParentQStr = ApexPages.currentPage().getUrl();
        	fullParentHost = ApexPages.currentPage().getHeaders().get('Host');
        	SiteId = HostedPCIConfigurations__c.getInstance().siteId__c;
        }        
        
        nextPage.getParameters().put('authTxnId', 'authTxnId');
        nextPage.getParameters().put('ccNum', ccNum);
        nextPage.getParameters().put('ccCVV', ccCVV);
        nextPage.getParameters().put('cardType', cardType);
        nextPage.getParameters().put('expiryMonth', expiryMonth);
        nextPage.getParameters().put('expiryYear', expiryYear);
        nextPage.getParameters().put('firstName', firstName);
        nextPage.getParameters().put('lastName', lastName);
        nextPage.getParameters().put('address1', address1);
        nextPage.getParameters().put('address2', address2);
        nextPage.getParameters().put('city', city);
        nextPage.getParameters().put('state', state);
		nextPage.getParameters().put('zip', zip);
        nextPage.getParameters().put('country', country);
        nextPage.getParameters().put('currency', hostedPCICurrency);
        nextPage.getParameters().put('amount', amount);
        nextPage.getParameters().put('comment', comment);
        nextPage.getParameters().put('paymentProfile', paymentProfile);
        
        return nextPage;
    }
       
    public PageReference processThreeDSecPayment() {
       	PageReference nextPage = Page.HostedPCICheckoutMsg;

        //Call HostedPCI
        HostedPciCallout();

        // Postprocess request: gather and validate submitted data
        status = hostedPciMsgMap.get('status');
        description = hostedPciMsgMap.get('pxyResponse.responseStatus.description');
        if( !String.isNotBlank(description) && String.isNotBlank(status) && status.equals('error')) {
            String errId = hostedPciMsgMap.get('errId');
            if (String.isNotBlank(errId)) {
                description = errId;
            }
        }

        payDate = Date.today();

        SaveTransaction();

        return nextPage;
    }

    public PageReference populateData(){
        fullParentQStr = ApexPages.currentPage().getUrl();
        fullParentHost = ApexPages.currentPage().getHeaders().get('Host');
        SiteId = HostedPCIConfigurations__c.getInstance().siteId__c;
        LocationName = HostedPCIConfigurations__c.getInstance().locationName__c;
                
        if ((String.isEmpty(SiteId))&&(String.isEmpty(LocationName))) {
            try{
                HostedPCIConfigurations__c hostedPciConf = HostedPCIConfigurations__c.getInstance();
                
                hostedPciConf.apiType__c = 'pxyhpci';                
                hostedPciConf.endPointVoid__c = '/iSynSApp/paymentVoid.action';
                hostedPciConf.endPointCapture__c = '/iSynSApp/paymentCapture.action';
                hostedPciConf.endPointCredit__c = '/iSynSApp/paymentCredit.action';
                hostedPciConf.locationName__c = 'salesforce1';
                hostedPciConf.apiVersion__c = '1.0.1';
                hostedPciConf.endPointAuth__c = '/iSynSApp/paymentAuth.action';
                hostedPciConf.endPointBaseUrl__c = 'https://apiservice.hostedpci.com';
                hostedPciConf.endPointSale__c = '/iSynSApp/paymentSale.action';
                hostedPciConf.endPoint_manageCCMapPhoneAPI__c = '/iSynSApp/manageCCMapPhoneAPI.action';
                hostedPciConf.siteId__c = '528160';
                
                //Check if the user has create access
                if (!Schema.sObjectType.HostedPCIConfigurations__c.fields.apiType__c.isCreateable() ||
                   		!Schema.sObjectType.HostedPCIConfigurations__c.fields.endPointVoid__c.isCreateable() ||
                   		!Schema.sObjectType.HostedPCIConfigurations__c.fields.endPointCapture__c.isCreateable() ||
                   		!Schema.sObjectType.HostedPCIConfigurations__c.fields.endPointCredit__c.isCreateable() ||
                   		!Schema.sObjectType.HostedPCIConfigurations__c.fields.locationName__c.isCreateable() ||
                   		!Schema.sObjectType.HostedPCIConfigurations__c.fields.apiVersion__c.isCreateable() ||
                   		!Schema.sObjectType.HostedPCIConfigurations__c.fields.endPointAuth__c.isCreateable() ||
                   		!Schema.sObjectType.HostedPCIConfigurations__c.fields.endPointBaseUrl__c.isCreateable() ||
                   		!Schema.sObjectType.HostedPCIConfigurations__c.fields.endPointSale__c.isCreateable() ||
                   		!Schema.sObjectType.HostedPCIConfigurations__c.fields.endPoint_manageCCMapPhoneAPI__c.isCreateable() ||
                   		!Schema.sObjectType.HostedPCIConfigurations__c.fields.siteId__c.isCreateable()){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,
	                                                    'Insufficient access'));
	      			return null;
			    }
                insert hostedPciConf;               

                SiteId = HostedPCIConfigurations__c.getInstance().siteId__c;
                LocationName = HostedPCIConfigurations__c.getInstance().locationName__c;
                iFrameSrc = 'https://ccifrm01.hostedpci.com/iSynSApp/showPxyPage!ccFrame.action?pgmode1=prod&'
            			+'locationName='+ LocationName
            			+'&sid=' + SiteId
            			+'&pluginMode=jq3'
            			+'&fullParentHost=https://' + fullParentHost
            			+'&fullParentQStr=' + fullParentQStr;

            } catch (DmlException e) {
                System.debug(e.getMessage());
                ApexPages.addMessages(e);
            }
        } else {
            iFrameSrc = 'https://ccifrm01.hostedpci.com/iSynSApp/showPxyPage!ccFrame.action?pgmode1=prod&'
            			+'locationName='+ LocationName
            			+'&sid=' + SiteId
            			+'&pluginMode=jq3'
            			+'&fullParentHost=https://' + fullParentHost
            			+'&fullParentQStr=' + fullParentQStr;
        }
        return null;
    }

    public PageReference back(){
        PageReference pageRef = Page.HostedPCICheckout;
        pageRef.setRedirect(true);

        return pageRef;
    }

    public Map<String,String> prepareMsgMap(){
        // Setup request param map
        Map<String,String> hpciRequestParamMap = new Map<String,String>();

        // Get request parameters from form (all the attributes that the
        // user inputs
        ccNum = ApexPages.currentPage().getParameters().get('ccNum');
        ccCVV = ApexPages.currentPage().getParameters().get('ccCVV');
        cardType  = ApexPages.currentPage().getParameters().get('cardType');
        expiryMonth = ApexPages.currentPage().getParameters().get('expiryMonth');
        expiryYear = ApexPages.currentPage().getParameters().get('expiryYear');
        firstName = ApexPages.currentPage().getParameters().get('firstName');
        lastName = ApexPages.currentPage().getParameters().get('lastName');
        address1 = ApexPages.currentPage().getParameters().get('address1');
        address2 = ApexPages.currentPage().getParameters().get('address2');
        city = ApexPages.currentPage().getParameters().get('city');
        state = ApexPages.currentPage().getParameters().get('state');
		zip = ApexPages.currentPage().getParameters().get('zip');
        country = ApexPages.currentPage().getParameters().get('country');
        hostedPCICurrency = ApexPages.currentPage().getParameters().get('currency');
        amount = ApexPages.currentPage().getParameters().get('amount');
        comment = ApexPages.currentPage().getParameters().get('comment');
        paymentProfile = ApexPages.currentPage().getParameters().get('paymentProfile'); 
        action3DSec = ApexPages.currentPage().getParameters().get('action3DSec'); 
        merchantRefId = String.valueOf(System.currentTimeMillis()); 
        
        hpciRequestParamMap.put('pxyCreditCard.cardType', cardType);
        hpciRequestParamMap.put('pxyCreditCard.creditCardNumber', ccNum);
        hpciRequestParamMap.put('pxyCreditCard.expirationMonth', expiryMonth);
        hpciRequestParamMap.put('pxyCreditCard.expirationYear', expiryYear);
        hpciRequestParamMap.put('pxyCreditCard.cardCodeVerification', ccCVV);
        hpciRequestParamMap.put('pxyTransaction.txnAmount', amount);
        hpciRequestParamMap.put('pxyTransaction.txnCurISO', hostedPCICurrency);                       
        hpciRequestParamMap.put('pxyTransaction.merchantRefId',merchantRefId);        
        hpciRequestParamMap.put('pxyTransaction.txnPayName', paymentProfile);
        hpciRequestParamMap.put('pxyTransaction.txnComment', comment);
        hpciRequestParamMap.put('pxyCustomerInfo.email', Apexpages.currentPage().getParameters().get('email'));
        hpciRequestParamMap.put('pxyCustomerInfo.customerId', Apexpages.currentPage().getParameters().get('customerId'));
        hpciRequestParamMap.put('pxyCustomerInfo.billingLocation.firstName', firstName);
        hpciRequestParamMap.put('pxyCustomerInfo.billingLocation.lastName', lastName);
        hpciRequestParamMap.put('pxyCustomerInfo.billingLocation.address', address1);
        hpciRequestParamMap.put('pxyCustomerInfo.billingLocation.address2', address2);
        hpciRequestParamMap.put('pxyCustomerInfo.billingLocation.city', city);
        hpciRequestParamMap.put('pxyCustomerInfo.billingLocation.state', state);
        hpciRequestParamMap.put('pxyCustomerInfo.billingLocation.zipCode', zip);
        hpciRequestParamMap.put('pxyCustomerInfo.billingLocation.country', country);
        //3DSec step1
        if(action3DSec =='verifyenroll'){
        	hpciRequestParamMap.put('pxyThreeDSecAuth.actionName', action3DSec);
        }
        //3DSec step2
        if(action3DSec =='verifyresp'){
            hpciRequestParamMap.put('pxyThreeDSecAuth.actionName', action3DSec);
            hpciRequestParamMap.put('pxyThreeDSecAuth.authTxnId',authTxnId);
            hpciRequestParamMap.put('pxyThreeDSecAuth.authSignComboList[0]', 'YY');
            hpciRequestParamMap.put('pxyThreeDSecAuth.authSignComboList[1]', 'AY');
            hpciRequestParamMap.put('pxyThreeDSecAuth.authSignComboList[2]', 'UY');
        }

        return hpciRequestParamMap;
    }

    public void HostedPciCallout(){
        // Uses the httpCalloutHostedPci methods to initiate the call to HostedPCI using the iframe,
        // It requires the complete url and the populated map
        hostedPciMsg = HostedPciServiceUtil.httpCalloutHostedPciAuthOnly(prepareMsgMap());
        // Uses the parseQueryString method to collect the response from HostedPCI
        hostedPciMsgMap = HostedPciServiceUtil.parseQueryString(hostedPciMsg);

        processorRefId = hostedPciMsgMap.get('pxyResponse.processorRefId');
    }

    public void SaveTransaction(){
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
            //Check if the user has create access
            if (!Schema.sObjectType.Token__c.isCreateable()){
                  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,
	                                                    'Insufficient access'));
	     		return;
			}
            
            try {
            	upsert newToken newToken.ccNum__c;
            } catch (DmlException e) {
                System.debug(e.getMessage());
            }

            // Once the token is inserted, the sObject will be
            // populated with an ID.
            ID newTokenID = newToken.ID;

            if(processorRefId == '0' || String.isBlank(processorRefId)){
                processorRefId = '';
                newPayment.Name = String.valueOf(System.currentTimeMillis());
            }else{
                newPayment.Name = processorRefId + '-' + String.valueOf(System.currentTimeMillis());
            }

            newPayment.address1__c = address1;
            newPayment.address2__c = address2;
            newPayment.amount__c = amount;
            newPayment.city__c = city;
            newPayment.country__c = country;
            newPayment.currency__c = hostedPCICurrency;
            newPayment.merchantRefId__c = merchantRefId;
            newPayment.processorRefId__c = processorRefId;
            newPayment.comment__c = comment;
            newPayment.paymentProfile__c = paymentProfile;
            newPayment.state__c = state;
            newPayment.zip__c =  zip;
            newPayment.HostedPci_Response__c = hostedPciMsg;
            newPayment.Token__c = newTokenID;
                        
            //Check if the user has create access
            if (!Schema.sObjectType.Payment__c.fields.Name.isCreateable() ||
               		!Schema.sObjectType.Payment__c.fields.address1__c.isCreateable() ||
               		!Schema.sObjectType.Payment__c.fields.address2__c.isCreateable() ||
               		!Schema.sObjectType.Payment__c.fields.amount__c.isCreateable() ||
               		!Schema.sObjectType.Payment__c.fields.city__c.isCreateable() ||
               		!Schema.sObjectType.Payment__c.fields.country__c.isCreateable() ||
               		!Schema.sObjectType.Payment__c.fields.currency__c.isCreateable() ||
               		!Schema.sObjectType.Payment__c.fields.merchantRefId__c.isCreateable() ||
               		!Schema.sObjectType.Payment__c.fields.processorRefId__c.isCreateable() ||
               		!Schema.sObjectType.Payment__c.fields.comment__c.isCreateable() ||
               		!Schema.sObjectType.Payment__c.fields.paymentProfile__c.isCreateable() ||
               		!Schema.sObjectType.Payment__c.fields.state__c.isCreateable() ||
               		!Schema.sObjectType.Payment__c.fields.zip__c.isCreateable() ||
               		!Schema.sObjectType.Payment__c.fields.HostedPci_Response__c.isCreateable() ||
               		!Schema.sObjectType.Payment__c.fields.Token__c.isCreateable()) {
                  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,
	                                                    'Insufficient access'));
	     		return;
			}
            insert newPayment;
        } catch (DmlException e) {
            System.debug(e.getMessage());
            ApexPages.addMessages(e);
        }
    }

}