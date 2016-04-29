@isTest
public class HostedPCICheckoutController_Test {
    static PageReference pageRef;
    static HostedPCICheckoutController controller;
    
    @isTest 
    private static void init(){
        pageRef = Page.HostedPCICheckout;
        Test.setCurrentPage(pageRef);                        
        //set our mock class for callouts
		Test.setMock(HttpCalloutMock.class, new	mock_HostedPciServiceUtil());
        controller = new HostedPCICheckoutController();
        //Set the checkout form values
        controller.firstName = 'Test';
        controller.lastName = 'Test';
       	controller.address1 = 'Place';
       	controller.address2 = '';
	    controller.city = 'Toronto';
       	controller.state = 'On';
       	controller.zip = 'l5k 7o2';
        controller.comment = 'auth';
       	controller.hostedPCICurrency = 'CAD';
       	controller.amount = '10';
	    controller.paymentProfile = 'DEF';
      	controller.country = 'Canada';
       	controller.cardType = 'Visa';
        controller.expiryMonth = '2017';
       	controller.expiryYear = '01';
       	controller.ccNum = '4111000570001111';
        controller.ccCVV = '200';
       	controller.ccBIN = '';
    }
    
    public static testMethod void HostedPCICheckoutController_PopulateData_Test() {
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
    
	public static testMethod void HostedPCICheckoutController_ProcessPayment_Test(){        
        String fullMsg, pageName;
        
        init();
        
        //start the test 
		test.StartTest();
        	PageReference nextPage = controller.processPayment();
        	fullMsg = controller.hostedPciMsg;
        	System.assertNotEquals(null, fullMsg);
        	//Check the redirection to hostedPCICheckoutMsg page
        	pageName = nextPage.getUrl();        	
        	System.assertEquals(true, pageName.containsIgnoreCase('hostedpcicheckoutmsg'));
        //stoptest
		test.StopTest();
    }    
	
	public static testMethod void HostedPCICheckoutController_ProcessThreeDSecPayment_Test(){        
        String fullMsg, pageName;
        
        init();
        
        //start the test 
		test.StartTest();
        	controller.authTxnId = 'YmRnU3l3M0IyeTJsaHhPb1UwVTA';
        	PageReference nextPage = controller.processThreeDSecPayment();
        	fullMsg = controller.hostedPciMsg;
        	System.assertNotEquals(null, fullMsg);
        	//Check the redirection to hostedPCICheckoutMsg page
        	pageName = nextPage.getUrl();        	
        	System.assertEquals(true, pageName.containsIgnoreCase('hostedpcicheckoutmsg'));
        //stoptest
		test.StopTest();
    }
    
    public static testMethod void HostedPCICheckoutController_Back_Test(){        
        String pageName;
        
        init();
        
        //start the test 
		test.StartTest();        	
        	PageReference nextPage = controller.back();        	
        	//Check the redirection to hostedPCICheckout page
        	pageName = nextPage.getUrl();        	
        	System.assertEquals(true, pageName.containsIgnoreCase('hostedpcicheckout'));
        //stoptest
		test.StopTest();
    }
}