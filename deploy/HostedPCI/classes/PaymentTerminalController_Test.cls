@isTest
public class PaymentTerminalController_Test {
    static PageReference pageRef;
    static PaymentTerminalController controller;    
    
    @isTest 
    private static void init(){
        pageRef = Page.PaymentTerminal;
        
        pageRef.getParameters().put('authTxnId', 'YmRnU3l3M0IyeTJsaHhPb1UwVTA');
        pageRef.getParameters().put('ccNum', '4111000570001111');
        pageRef.getParameters().put('ccCVV', '200');
        pageRef.getParameters().put('cardType', 'Visa');           
        pageRef.getParameters().put('expiryMonth', '01');           
        pageRef.getParameters().put('expiryYear', '2016');           
        pageRef.getParameters().put('firstName', 'Test');           
        pageRef.getParameters().put('lastName', 'Test');           
        pageRef.getParameters().put('address1', 'Place');           
        pageRef.getParameters().put('address2', '');           
        pageRef.getParameters().put('city', 'Toronto');           
        pageRef.getParameters().put('state', 'On');           
		pageRef.getParameters().put('zip', 'l5k 7o2');           
        pageRef.getParameters().put('country', 'Canada');           
        pageRef.getParameters().put('currency', 'CAD');           
        pageRef.getParameters().put('amount', '10');           
        pageRef.getParameters().put('comment', 'sale');           
        pageRef.getParameters().put('paymentProfile', 'DEF');
        
        Test.setCurrentPage(pageRef);
        //set our mock class for callouts
		Test.setMock(HttpCalloutMock.class, new	mock_HostedPciServiceUtil());
        controller = new PaymentTerminalController();
    }
    
    public static testMethod void PaymentTerminalController_PopulateData_Test() {
        init();
		
		//start the test and separate DML flow
		test.StartTest();
        	controller.populateData();
        	System.assertNotEquals('', controller.SiteId);
        	System.assertNotEquals('', controller.LocationName);
        	System.assertNotEquals('', controller.fullParentQStr);
        	System.assertNotEquals('', controller.fullParentHost);
        //stoptest
		test.StopTest();        
    }
    
    public static testMethod void PaymentTerminalController_ProcessPayment_Test(){
        Map<String,String> hostedPciMsgMap;
        String fullMsg;
        
        init();
        
        //start the test 
		test.StartTest();
        	hostedPciMsgMap = PaymentTerminalController.processPayment('4111000570001111', '200', 'Visa', '01',
                    '2016', 'Test','Test', 'Place', '', 'Toronto', 'On', 'l5k 7o2', 'Canada',
                	'CAD', '10', 'sale', 'DEF','');
        	fullMsg = hostedPciMsgMap.get('fullMsg');
        	System.assertNotEquals(null, fullMsg);
        //stoptest
		test.StopTest();
    }
    
    public static testMethod void PaymentTerminalController_ProcessPayment_VerifyEnrollTest(){
        Map<String,String> hostedPciMsgMap;
        String fullMsg;
        
        init();
        
        //start the test 
		test.StartTest();
        	hostedPciMsgMap = PaymentTerminalController.processPayment('4111000570001111', '200', 'Visa', '01',
                    '2016', 'Test','Test', 'Place', '', 'Toronto', 'On', 'l5k 7o2', 'Canada',
                	'CAD', '10', 'sale', 'DEF','verifyenroll');
        	fullMsg = hostedPciMsgMap.get('fullMsg');
        	System.assertNotEquals(null, fullMsg);
        //stoptest
		test.StopTest();
    }
    
    public static testMethod void PaymentTerminalController_ProcessThreeDSecPayment_Test(){
        String pageName;        
        
        init();
        
        //start the test 
		test.StartTest();        	
        	PageReference nextPage = controller.processThreeDSecPayment();
        	pageName = nextPage.getUrl();        	
        	System.assertEquals(true, pageName.containsIgnoreCase('ThreeDSecPinFrame'));
        //stoptest
		test.StopTest();
    }
}