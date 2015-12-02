public class ThreeDSecPinFrameController {
    public string SiteId{get ; set;}
    public string fullParentQStr{get; set;}
    public string fullParentHost{get; set;}
	public string authTxnId{get; set;}
    public string ccNum{get; set;}
    public string ccCVV{get; set;}
    public string cardType{get; set;}
    public string expiryMonth{get; set;}
    public string expiryYear{get; set;}
    public string firstName{get; set;}
    public string lastName{get; set;}
    public string address1{get; set;}
    public string address2{get; set;}
    public string city{get; set;}
    public string state{get; set;}
    public string zip{get; set;}
    public string country{get; set;}
    public string hpciCurrency{get; set;}
    public string paymentAmount{get; set;}
    public string paymentComments{get; set;}
    public string paymentProfile{get; set;}
    
    public ThreeDSecPinFrameController(){
        SiteId = HostedPCISettings__c.getInstance().siteId__c;
        fullParentQStr = Page.ThreeDSecPinFrame.getUrl();
        fullParentHost = ApexPages.currentPage().getHeaders().get('Host');
        authTxnId = ApexPages.currentPage().getParameters().get('authTxnId');
        ccNum = ApexPages.currentPage().getParameters().get('ccNum');
        ccCVV = ApexPages.currentPage().getParameters().get('ccCVV');                
        cardType = ApexPages.currentPage().getParameters().get('cardType');
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
        hpciCurrency = ApexPages.currentPage().getParameters().get('currency');
        paymentAmount = ApexPages.currentPage().getParameters().get('amount');
        paymentComments = ApexPages.currentPage().getParameters().get('comment');
        paymentProfile = ApexPages.currentPage().getParameters().get('paymentProfile');                       
    }

    @RemoteAction
    public static Map<String,String> processPayment(String ccToken, String cvvToken, String cardType,
           String expiryMonth, String expiryYear, String firstName, String lastName, String address1,
           String address2, String city, String state, String zip, String country, String hpciCurrency,
           String paymentAmount, String paymentComments, String paymentProfile, String action3DSec,
           String authTxnId){           	
                        
        // Setup request param map        
        Map<String,String> hpciRequestParamMap = new Map<String,String>();
              
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
        
        //3D secure params
        hpciRequestParamMap.put('pxyThreeDSecAuth.actionName', action3DSec);                        
		hpciRequestParamMap.put('pxyThreeDSecAuth.authTxnId',authTxnId);
	    hpciRequestParamMap.put('pxyThreeDSecAuth.authSignComboList[0]', 'YY');
		hpciRequestParamMap.put('pxyThreeDSecAuth.authSignComboList[1]', 'AY');
		hpciRequestParamMap.put('pxyThreeDSecAuth.authSignComboList[2]', 'UY');
     	
        String hostedPciMsg = HostedPciServiceUtil.httpCalloutHostedPciAuthOnly(hpciRequestParamMap);
        Map<String,String> hostedPciMsgMap = HostedPciServiceUtil.parseQueryString(hostedPciMsg);
        
        SaveTransaction(ccToken, cardType, firstName, lastName, expiryMonth, expiryYear,
                        address1, address2, paymentAmount, city, country, hpciCurrency, 
                        hostedPciMsgMap.get('pxyResponse.processorRefId'), merchantRefId, paymentComments, paymentProfile,
                        state, zip, hostedPciMsg);
               
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
            
            upsert newPayment;            
        } catch (DmlException e) {
            System.debug(e.getMessage());
            ApexPages.addMessages(e);
        }               
    } 
    
    public PageReference back(){
        PageReference pageRef = Page.PaymentTerminal;
        return pageRef;
    } 
    
}