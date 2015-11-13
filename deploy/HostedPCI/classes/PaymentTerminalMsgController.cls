public with sharing class PaymentTerminalMsgController {
    public String comment { get; private set; }
    public String amount { get; private set; }
    public String cardCVV { get; private set; }
    public String cardType { get; private set; }
    public String merchantRefId { get; private set; }
    public String processorRefId { get; private set; }
    public date payDate { get; private set; }
    public String ccNum { get; private set; }
    public String description { get; set; }
    public String status { get; private set; }
    public String hostedPciMsg { get; private set; }
    public String expiryMonth { get; private set; }      
    public String expiryYear { get; private set; }      
    public String firstName { get; private set; }      
    public String lastName { get; private set; }      
    public String address1 { get; private set; }      
    public String address2 { get; private set; }      
    public String city { get; private set; }      
    public String state { get; private set; }      
    public String zip { get; private set; }      
    public String country{ get; private set; }      
    public String curency { get; private set; }            
    public String paymentProfile { get; private set; }  
    public Map<String,String> hostedPciMsgMap{get; private set; }                    
       
    public Map<String,String> prepareMsgMap(){
        // Setup request param map        
        Map<String,String> hpciRequestParamMap = new Map<String,String>();
        
        // Get request parameters from form (all the attributes that the
        // user inputs
        hpciRequestParamMap.put('pxyCreditCard.cardType', Apexpages.currentPage().getParameters().get('cardType'));
        hpciRequestParamMap.put('pxyCreditCard.creditCardNumber', Apexpages.currentPage().getParameters().get('ccNum'));
        hpciRequestParamMap.put('pxyCreditCard.expirationMonth', Apexpages.currentPage().getParameters().get('expiryMonth'));
        hpciRequestParamMap.put('pxyCreditCard.expirationYear', Apexpages.currentPage().getParameters().get('expiryYear'));
        hpciRequestParamMap.put('pxyCreditCard.cardCodeVerification', Apexpages.currentPage().getParameters().get('ccCVV'));                
        hpciRequestParamMap.put('pxyTransaction.txnAmount', Apexpages.currentPage().getParameters().get('amount'));
        hpciRequestParamMap.put('pxyTransaction.txnCurISO', Apexpages.currentPage().getParameters().get('currency'));
        DateTime timeStamp = DateTime.now();   
        merchantRefId = String.valueOf(timeStamp.millisecond()+ 1000000);
        hpciRequestParamMap.put('pxyTransaction.merchantRefId',merchantRefId);
        hpciRequestParamMap.put('pxyTransaction.txnPayName', Apexpages.currentPage().getParameters().get('paymentProfile'));
        hpciRequestParamMap.put('pxyTransaction.txnComment', Apexpages.currentPage().getParameters().get('comments'));
        hpciRequestParamMap.put('pxyCustomerInfo.email', Apexpages.currentPage().getParameters().get('email'));
        hpciRequestParamMap.put('pxyCustomerInfo.customerId', Apexpages.currentPage().getParameters().get('customerId'));
        hpciRequestParamMap.put('pxyCustomerInfo.billingLocation.firstName', Apexpages.currentPage().getParameters().get('firstName'));
        hpciRequestParamMap.put('pxyCustomerInfo.billingLocation.lastName', Apexpages.currentPage().getParameters().get('lastName'));
        hpciRequestParamMap.put('pxyCustomerInfo.billingLocation.address', Apexpages.currentPage().getParameters().get('address1'));
        hpciRequestParamMap.put('pxyCustomerInfo.billingLocation.address2', Apexpages.currentPage().getParameters().get('address2'));
        hpciRequestParamMap.put('pxyCustomerInfo.billingLocation.city', Apexpages.currentPage().getParameters().get('city'));
        hpciRequestParamMap.put('pxyCustomerInfo.billingLocation.state', Apexpages.currentPage().getParameters().get('state'));
        hpciRequestParamMap.put('pxyCustomerInfo.billingLocation.zipCode', Apexpages.currentPage().getParameters().get('zip'));
        hpciRequestParamMap.put('pxyCustomerInfo.billingLocation.country', Apexpages.currentPage().getParameters().get('country'));
        
        return hpciRequestParamMap;
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
            newPayment.currency__c = curency;            
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
    
    public void HostedPciCallout(){         
        
        String apiTransactionService = Apexpages.currentPage().getParameters().get('apiTransactionService'); 
        // Uses the httpCalloutHostedPci method to initiate the call to HostedPCI using the iframe,
        // It requires the complete url and the populated map       
        if(apiTransactionService!= null && apiTransactionService.length() > 0){  
            if(apiTransactionService == 'auth'){      
                hostedPciMsg = HostedPciServiceUtil.httpCalloutHostedPciAuthOnly(prepareMsgMap());  
                // Uses the parseQueryString method to collect the response from HostedPCI            
                hostedPciMsgMap = HostedPciServiceUtil.parseQueryString(hostedPciMsg);

                processorRefId = hostedPciMsgMap.get('pxyResponse.processorRefId');
            }else if(apiTransactionService == 'capture'){
                hostedPciMsg = HostedPciServiceUtil.httpCalloutHostedPciAuthOnly(prepareMsgMap()); 
                // Uses the parseQueryString method to collect the response from HostedPCI            
                hostedPciMsgMap = HostedPciServiceUtil.parseQueryString(hostedPciMsg);                  
                processorRefId = hostedPciMsgMap.get('pxyResponse.processorRefId');
                
                hostedPciMsg = HostedPciServiceUtil.httpCalloutHostedPciCaptureOnly(processorRefId, prepareMsgMap()); 
                // Uses the parseQueryString method to collect the response from HostedPCI            
                hostedPciMsgMap = HostedPciServiceUtil.parseQueryString(hostedPciMsg);                 
            }else if(apiTransactionService == 'credit'){
                hostedPciMsg = HostedPciServiceUtil.httpCalloutHostedPciSaleOnly(prepareMsgMap()); 
                // Uses the parseQueryString method to collect the response from HostedPCI            
                hostedPciMsgMap = HostedPciServiceUtil.parseQueryString(hostedPciMsg);

                processorRefId = hostedPciMsgMap.get('pxyResponse.processorRefId');
            
                hostedPciMsg = HostedPciServiceUtil.httpCalloutHostedPciCreditOnly(processorRefId, prepareMsgMap()); 
                // Uses the parseQueryString method to collect the response from HostedPCI            
                hostedPciMsgMap = HostedPciServiceUtil.parseQueryString(hostedPciMsg);

                processorRefId = hostedPciMsgMap.get('pxyResponse.processorRefId');
            }else if(apiTransactionService == 'sale'){
                hostedPciMsg = HostedPciServiceUtil.httpCalloutHostedPciSaleOnly(prepareMsgMap()); 
                // Uses the parseQueryString method to collect the response from HostedPCI            
                hostedPciMsgMap = HostedPciServiceUtil.parseQueryString(hostedPciMsg);

                processorRefId = hostedPciMsgMap.get('pxyResponse.processorRefId');
            }else if(apiTransactionService == 'void'){
                hostedPciMsg = HostedPciServiceUtil.httpCalloutHostedPciAuthOnly(prepareMsgMap());  
                // Uses the parseQueryString method to collect the response from HostedPCI            
                hostedPciMsgMap = HostedPciServiceUtil.parseQueryString(hostedPciMsg); 
                processorRefId = hostedPciMsgMap.get('pxyResponse.processorRefId');
                
                hostedPciMsg = HostedPciServiceUtil.httpCalloutHostedPciVoidOnly(processorRefId, prepareMsgMap());  
                // Uses the parseQueryString method to collect the response from HostedPCI            
                hostedPciMsgMap = HostedPciServiceUtil.parseQueryString(hostedPciMsg);                                
            }
        }
     }
     
    public PageReference saveData() {
        //Call HostedPci                       
        HostedPciCallout();
            
        // Postprocess request: gather and validate submitted data                 
        ccNum = Apexpages.currentPage().getParameters().get('ccNum'); 
        status = hostedPciMsgMap.get('pxyResponse.responseStatus.name');
        description = hostedPciMsgMap.get('pxyResponse.responseStatus.description');
                        
        cardType = Apexpages.currentPage().getParameters().get('cardType');
        cardCVV = Apexpages.currentPage().getParameters().get('ccCVV');
        amount = Apexpages.currentPage().getParameters().get('amount');
        comment = Apexpages.currentPage().getParameters().get('comment');
        payDate = Date.today();    
        expiryMonth = Apexpages.currentPage().getParameters().get('expiryMonth');
        expiryYear = Apexpages.currentPage().getParameters().get('expiryYear');
        firstName = Apexpages.currentPage().getParameters().get('firstName');
        lastName = Apexpages.currentPage().getParameters().get('lastName');
        address1 = Apexpages.currentPage().getParameters().get('address1');
        address2 = Apexpages.currentPage().getParameters().get('address2');
        city = Apexpages.currentPage().getParameters().get('city');
        state = Apexpages.currentPage().getParameters().get('state');
        zip = Apexpages.currentPage().getParameters().get('zip');
        country = Apexpages.currentPage().getParameters().get('country');
        curency = Apexpages.currentPage().getParameters().get('currency');
        paymentProfile = Apexpages.currentPage().getParameters().get('paymentProfile');
           
        SaveTransaction();  
        return null;        
    }
    
    public PageReference back(){
        PageReference pageRef = Page.PaymentTerminal;
        return pageRef;
    }                       
}