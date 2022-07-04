@isTest
public class HostedPCICheckoutController_Test {
    static PageReference pageRef;
    static HostedPCICheckoutController controller;
    static HostedPCIConfigurations__c testConf;
    
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
    
    public static testMethod void HostedPCICheckoutController_PopulateData_negative_Test() {
        init();
		
		//start the test and separate DML flow
		test.StartTest();
        	String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        	// This code runs as the system user
        	Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        	User newUser = new User(Alias = 'standt', Email='standarduser@testorg.com',
       	 		EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        		LocaleSidKey='en_US', ProfileId = p.Id,
        		TimeZoneSidKey='America/Los_Angeles', UserName=uniqueUserName);
        	
        	System.runAs(newUser) {
        		controller.populateData();
        		System.assert(ApexPages.hasMessages(ApexPages.severity.FATAL));
            }
        //stoptest
		test.StopTest();        
    }
    
    public static testMethod void HostedPCICheckoutController_PopulateData2_Test() {
        init();
		
		//start the test and separate DML flow
		test.StartTest();
        	testConf = new HostedPCIConfigurations__c();
            testConf.userName__c = 'test user';
            testConf.apiType__c ='pxyhpci';
            testConf.apiVersion__c ='1.0.1';
            testConf.endPointAuth__c='/iSynSApp/paymentAuth.action';
            testConf.endPointBaseUrl__c='https://apiservice.hostedpci.com/iSynSApp/paymentAuth.action/';
            testConf.endPointCapture__c='/iSynSApp/paymentCapture.action';
            testConf.endPointCapture__c='/iSynSApp/paymentCapture.action';
            testConf.endPointSale__c='/iSynSApp/paymentSale.action';
            testConf.endPointVoid__c='/iSynSApp/paymentVoid.action';
            testConf.locationName__c='salesforce1';
            testConf.siteId__c='528160';
            testConf.userPassKey__c='Test password';
            insert testConf;
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

	public static testMethod void HostedPCICheckoutController_Verify3DEnrollment_Test(){        
        String fullMsg, pageName;
        
        init();
        
        //start the test 
		test.StartTest();        	        	
            pageRef.getParameters().put('firstName', 'Test');
            pageRef.getParameters().put('lastName', 'Test');
            pageRef.getParameters().put('address1', 'Place');
            pageRef.getParameters().put('address2', '');
            pageRef.getParameters().put('city', 'Toronto');
            pageRef.getParameters().put('state', 'On');
            pageRef.getParameters().put('zip', 'l5k 7o2');
            pageRef.getParameters().put('comment', 'auth');
            pageRef.getParameters().put('currency', 'CAD');
            pageRef.getParameters().put('amount', '10');
            pageRef.getParameters().put('paymentProfile', 'DEF');
            pageRef.getParameters().put('country', 'Canada');
            pageRef.getParameters().put('cardType', 'Visa');
            pageRef.getParameters().put('expiryMonth', '2026');
            pageRef.getParameters().put('expiryYear', '01');
            pageRef.getParameters().put('ccNum','4111000570001111');
            pageRef.getParameters().put('ccCVV', '200');
        	pageRef.getParameters().put('action3DSec', 'verifyenroll');            
        
        	PageReference nextPage = controller.processPayment();
        	fullMsg = controller.hostedPciMsg;
        	System.assertNotEquals(null, fullMsg);
        	//Check the redirection to ThreeDSecPin page
        	pageName = nextPage.getUrl();
        	System.assertEquals(true, pageName.containsIgnoreCase('ThreeDSecPin'));
        //stoptest
		test.StopTest();
    }
    
    public static testMethod void HostedPCICheckoutController_Verify3DResponse_Test(){        
        String fullMsg, pageName;
        
        init();
        
        //start the test 
		test.StartTest();        	        	
            pageRef.getParameters().put('firstName', 'Test');
            pageRef.getParameters().put('lastName', 'Test');
            pageRef.getParameters().put('address1', 'Place');
            pageRef.getParameters().put('address2', '');
            pageRef.getParameters().put('city', 'Toronto');
            pageRef.getParameters().put('state', 'On');
            pageRef.getParameters().put('zip', 'l5k 7o2');
            pageRef.getParameters().put('comment', 'auth');
            pageRef.getParameters().put('currency', 'CAD');
            pageRef.getParameters().put('amount', '10');
            pageRef.getParameters().put('paymentProfile', 'DEF');
            pageRef.getParameters().put('country', 'Canada');
            pageRef.getParameters().put('cardType', 'Visa');
            pageRef.getParameters().put('expiryMonth', '2026');
            pageRef.getParameters().put('expiryYear', '01');
            pageRef.getParameters().put('ccNum','4111000570001111');
            pageRef.getParameters().put('ccCVV', '200');
        	pageRef.getParameters().put('action3DSec', 'verifyresp'); 
            pageRef.getParameters().put('authTxnId', 'YmRnU3l3M0IyeTJsaHhPb1UwVTA');
        
        	PageReference nextPage = controller.processThreeDSecPayment();
        	fullMsg = controller.hostedPciMsg;
        	System.assertNotEquals(null, fullMsg);
        	System.assert(true, fullMsg.contains('pxyResponse.threeDSCAVV'));
        	//Check the redirection to HostedPCICheckoutMsg page
        	pageName = nextPage.getUrl();
        	System.assertEquals(true, pageName.containsIgnoreCase('HostedPCICheckoutMsg'));
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
        	System.assertEquals(true, pageName.containsIgnoreCase('hostedPCICheckoutMsg'));
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