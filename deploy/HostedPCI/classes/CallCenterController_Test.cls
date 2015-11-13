@isTest
public class CallCenterController_Test {
    static PageReference pageRef;
	
    @isTest 
    private static void init(){
        pageRef = Page.CallCenter;
        Test.setCurrentPage(pageRef);
        //set our mock class for callouts
		Test.setMock(HttpCalloutMock.class, new	mock_HostedPciServicePhoneAPIUtil());  
    }
    
    public static testMethod void CallCenterController_GetSessionKey_Test(){
        Map<String,String> hostedPciMsgMap;
        String status;
        
        init();
        
        //start the test 
		test.StartTest();
        	hostedPciMsgMap = CallCenterController.getSessionKey();
        	status = hostedPciMsgMap.get('status');
        	System.assertEquals('success', status);
        //stoptest
		test.StopTest();
    }
    
    public static testMethod void CallCenterController_GetStatus_Test(){
        Map<String,String> hostedPciMsgMap;
        String status;
        
        init();
        
        //start the test 
		test.StartTest();
        	hostedPciMsgMap = CallCenterController.getStatus('status');
        	status = hostedPciMsgMap.get('status');
        	System.assertEquals('success', status);
        //stoptest
		test.StopTest();
    }
    
    public static testMethod void CallCenterController_ProcessPayment_Test(){
        Map<String,String> hostedPciMsgMap;
        String fullMsg;
        
        init();
        
        //start the test 
		test.StartTest();
        	hostedPciMsgMap = CallCenterController.processpayment('4111000570001111', '200', 'Visa', '01',
                    '2016', 'Test','Test', 'Place', '', 'Toronto', 'On', 'l5k 7o2', 'Canada',
                	'Canadian Dollar', '10', 'sale', 'DEF-currency:USD');
        	fullMsg = hostedPciMsgMap.get('fullMsg');
        	System.assertNotEquals(null, fullMsg);
        //stoptest
		test.StopTest();
    }        
}