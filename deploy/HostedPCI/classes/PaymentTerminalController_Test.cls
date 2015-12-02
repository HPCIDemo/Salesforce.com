@isTest
public class PaymentTerminalController_Test {
    static PageReference pageRef;
    static PaymentTerminalController controller;    
    
    @isTest 
    private static void init(){
        pageRef = Page.PaymentTerminal;
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
    
    public static testMethod void PaymentTerminalController_ProcessPayment3DSec_Test(){
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
}