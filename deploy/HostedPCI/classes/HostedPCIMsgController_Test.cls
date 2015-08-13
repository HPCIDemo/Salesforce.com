@isTest
public class HostedPCIMsgController_Test {
    static PageReference pageRef;
    static HostedPCIMsgController controller;
    
    private static void init(){
        pageRef = PrepareParamMap();
        Test.setCurrentPage(pageRef);
        //set our mock class for callouts
		Test.setMock(HttpCalloutMock.class, new	mock_HostedPciServiceUtil());
        controller = new HostedPCIMsgController();
    }
    
    public static testMethod void HostedPCIMsgController_AuthOnly_Test(){
        init();                        
        // Add parameters to page URL 
        pageRef.getParameters().put('apiTransactionService','auth');      
                
        //start the test and separate DML flow
        test.StartTest();
            controller.saveData();        
        //stoptest
        test.StopTest();
    }
    
    public static testMethod void HostedPCIMsgController_CaptureOnly_Test(){
        init();                       
        // Add parameters to page URL 
        pageRef.getParameters().put('apiTransactionService','capture');      
                
        //start the test and separate DML flow
        test.StartTest();
            controller.saveData();        
        //stoptest
        test.StopTest();
    }
    
    public static testMethod void HostedPCIMsgController_CreditOnly_Test(){
        init();                                                
        // Add parameters to page URL 
        pageRef.getParameters().put('apiTransactionService','credit');      
        
        //start the test and separate DML flow
        test.StartTest();
            controller.saveData();        
        //stoptest
        test.StopTest();
    }
    
    public static testMethod void HostedPCIMsgController_SaleOnly_Test(){
        init();                       
        // Add parameters to page URL 
        pageRef.getParameters().put('apiTransactionService','sale');      
                
        //start the test and separate DML flow
        test.StartTest();
            controller.saveData();        
        //stoptest
        test.StopTest();
    }
    
    public static testMethod void HostedPCIMsgController_VoidOnly_Test(){
        init();                                                
        // Add parameters to page URL 
        pageRef.getParameters().put('apiTransactionService','void');      
                
        //start the test and separate DML flow
        test.StartTest();
            controller.saveData();        
        //stoptest
        test.StopTest();
    }
    
    public static PageReference  PrepareParamMap(){
        PageReference pageReference = Page.PaymentTerminalMsg;
        
        // Add parameters to page URL         
        pageReference.getParameters().put('cardType','Visa');
        pageReference.getParameters().put('ccNum','4111111111111111');
        pageReference.getParameters().put('expiryMonth','01');
        pageReference.getParameters().put('expiryYear','2016');
        pageReference.getParameters().put('ccCVV','325');                
        pageReference.getParameters().put('amount','35');
        pageReference.getParameters().put('currency','Canadian Dollar');
        pageReference.getParameters().put('merchantRefId','123456');
        pageReference.getParameters().put('paymentProfile','DEF-currency:USD');
        pageReference.getParameters().put('comments','Auth');
        pageReference.getParameters().put('email','email@email.com');
        pageReference.getParameters().put('customerId','111');
        pageReference.getParameters().put('firstName','Test');
        pageReference.getParameters().put('lastName','Test');
        pageReference.getParameters().put('address1','Place');
        pageReference.getParameters().put('address2','');
        pageReference.getParameters().put('city','Toronto');
        pageReference.getParameters().put('state','On');
        pageReference.getParameters().put('zip','l5k 7o2');
        pageReference.getParameters().put('country','Canada');
        
        return pageReference;       
    }    
}