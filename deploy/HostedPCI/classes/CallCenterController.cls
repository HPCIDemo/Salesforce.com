public with sharing class CallCenterController {       
    
    public static Map<String,String> prepareMsgMap(String command){
        // Setup request param map        
        Map<String,String> hpciRequestParamMap = new Map<String,String>();
        
        // Get request parameters from form (all the attributes that the
        // user inputs
        hpciRequestParamMap.put('cmd', command);
        hpciRequestParamMap.put('promptLang', 'en_US');
        hpciRequestParamMap.put('cvvEntry', '');
        hpciRequestParamMap.put('sessionKeyType', 'venue');
        hpciRequestParamMap.put('userMarker1', 'any');
        hpciRequestParamMap.put('userMarker2', 'any');                
        hpciRequestParamMap.put('userMarker3', 'any');
        
        return hpciRequestParamMap;
    }
    
    @RemoteAction
    public static Map<String,String> getSessionKey(){       
    	String cmd = 'createsession';
        
        String hostedPciMsg = HostedPciServiceUtil.httpCalloutHostedPciManageCCMApPhoneAPI(prepareMsgMap(cmd));
        Map<String,String> hostedPciMsgMap = HostedPciServiceUtil.parseQueryString(hostedPciMsg);
        
        hostedPciMsgMap.put('fullMsg',hostedPciMsg);
        return hostedPciMsgMap;
    }
    
    @RemoteAction
    public static Map<String,String> getStatus(String sessionId){       
    	String cmd = 'showprogress';
        Map<String,String> MsgMap = prepareMsgMap(cmd);
        
        MsgMap.put('selectedPcsId', sessionId);
        String hostedPciMsg = HostedPciServiceUtil.httpCalloutHostedPciManageCCMApPhoneAPI(MsgMap);
        Map<String,String> hostedPciMsgMap = HostedPciServiceUtil.parseQueryString(hostedPciMsg);
        
        hostedPciMsgMap.put('fullMsg',hostedPciMsg);
        return hostedPciMsgMap;
    }
    
    
    @RemoteAction
    public static Map<String,String> processPayment(String ccToken, String cvvToken, String cardType,
           String expiryMonth, String expiryYear, String firstName, String lastName, String address1,
           String address2, String city, String state, String zip, String country, String hpciCurrency,
           String paymentAmount, String paymentComments, String paymentProfile){           	
        
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
        
        String merchantRefId = String.valueOf(System.currentTimeMillis());
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
        
        
        String hostedPciMsg = HostedPciServiceUtil.httpCalloutHostedPciSaleOnly(hpciRequestParamMap);
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
            //Check if the user has create access
            if (!Schema.sObjectType.Token__c.isCreateable()){
                  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,
	                                                    'Insufficient access')); 
	     		return;
			}
            upsert newToken newToken.ccNum__c;
            
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

}