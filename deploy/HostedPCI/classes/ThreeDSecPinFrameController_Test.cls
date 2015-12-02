@isTest
public class ThreeDSecPinFrameController_Test {
	static PageReference pageRef;
    static ThreeDSecPinFrameController controller;    
    
    @isTest 
    private static void init(){
        pageRef = Page.ThreeDSecPinFrame;
        Test.setCurrentPage(pageRef);
        //set our mock class for callouts
		Test.setMock(HttpCalloutMock.class, new	mock_HostedPciServiceUtil());
        controller = new ThreeDSecPinFrameController();
    }
    
    public static testMethod void ThreeDSecPinFrameController_ConfigData_Test() {
        init();
		
		//start the test 
		test.StartTest();        	
        	System.assertNotEquals('', controller.SiteId);        	
        	System.assertNotEquals('', controller.fullParentQStr);
        	System.assertNotEquals('', controller.fullParentHost);
        //stoptest
		test.StopTest();        
    }
    
    public static testMethod void ThreeDSecPinFrameController_ProcessPayment_Test(){
        Map<String,String> hostedPciMsgMap;
        String fullMsg;
        
        init();
        
        //start the test 
		test.StartTest();
        	hostedPciMsgMap = ThreeDSecPinFrameController.processPayment('4111000570001111', '200', 'Visa', '01',
                    '2016', 'Test','Test', 'Place', '', 'Toronto', 'On', 'l5k 7o2', 'Canada',
                	'CAD', '10', 'sale', 'DEF','verifyresp','012absd451q');
        	fullMsg = hostedPciMsgMap.get('fullMsg');
        	System.assertNotEquals(null, fullMsg);
        //stoptest
		test.StopTest();
    }      
}