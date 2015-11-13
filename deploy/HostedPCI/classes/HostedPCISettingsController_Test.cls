@isTest
public class HostedPCISettingsController_Test {
    static PageReference pageRef;
    static HostedPCISettingsController controller;
    static HostedPCISettings__c testConf;
    static HostedPCISettings__c hostedPciConf;
    
    private static void init(){
        pageRef = Page.HostedPCISettings;
        Test.setCurrentPage(pageRef);
        controller = new HostedPCISettingsController();
        
        testConf = new HostedPCISettings__c();
        testConf.userName__c = 'test user';
        testConf.apiType__c ='pxyhpci';
        testConf.apiVersion__c ='1.0.1';
        testConf.endPointAuth__c='/iSynSApp/paymentAuth.action';
        testConf.endPointBaseUrl__c='https://api-sampqa1stg.c1.hostedpci.com/iSynSApp/paymentAuth.action/';
        testConf.endPointCapture__c='/iSynSApp/paymentCapture.action';
        testConf.endPointCapture__c='/iSynSApp/paymentCapture.action';        	
        testConf.endPointSale__c='/iSynSApp/paymentSale.action';
        testConf.endPointVoid__c='/iSynSApp/paymentVoid.action';
        testConf.locationName__c='javasample1';
        testConf.siteId__c='528160';
        testConf.userPassKey__c='.OQdIHVtVJSg-W-Zr40QQGY1xyhvGjUH';
        insert testConf;        
    }
	static testmethod void  HostedPCISettingsController_Getters_Test(){
     	init();
        //Start the test
        test.StartTest();        	        	
        	controller.getUserName();
        	controller.getUserPassKey();
        	controller.getEndPointBaseUrl();
        	controller.getSiteId();
        	controller.getLocationName();        	
        //Stop the test
		test.StopTest();
    }
    
    static testmethod void  HostedPCISettingsController_closePopup_Test(){
     	init();
        //Start the test
        test.StartTest();        	        	
        	controller.newValue = 'UserName';
        	controller.closePopup();
        	String newValue = controller.newValue;
        	// Verify that  newValue equals empty string after closing dialog window
        	System.assertEquals('',newValue);
        	// Verify that displayPopup  equals false after closing dialog window
        	System.assertEquals(false,controller.displayPopup);
        //Stop the test
		test.StopTest();
    }
    
    static testmethod void  HostedPCISettingsController_showPopup_Test(){
     	init();
        //Start the test
        test.StartTest();        	
        	controller.buttonId = 'UserName';        
        	controller.showPopup();
        	String modalTitle = controller.getModalTitle();
        	// Verify that  modalTitle equals 'Edit mode: UserName' after showing dialog window
        	System.assertEquals('Edit mode: UserName' , modalTitle);        	
        //Stop the test
		test.StopTest();
    }
    
    static testmethod void  HostedPCISettingsController_save_Test(){
     	init();
        //Start the test        
         test.StartTest();     
        	//Test user name 
        	controller.buttonId = 'userName'; 
        	controller.newValue = 'user';
        	//Save userName; 
        	controller.save();
        	hostedPciConf = HostedPCISettings__c.getOrgDefaults();	
        	String user = hostedPciConf.userName__c;        	
        	// Verify that  userName equals  'user' after saving
        	System.assertEquals('user' , user); 
        	
        	//Test user passKey
        	controller.buttonId = 'userPassKey'; 
        	controller.newValue = 'secret';
        	//Save userPassKey 
        	controller.save();
        	hostedPciConf = HostedPCISettings__c.getOrgDefaults();	
        	String pass = hostedPciConf.userPassKey__c;        	
        	// Verify that  userPasskey equals  'secret' after saving
        	System.assertEquals('secret' , pass); 
        	
  			//Test endPointBaseUrl
        	controller.buttonId = 'endPointBaseUrl'; 
        	controller.newValue = 'https://api-sampqa1stg.c1.hostedpci.com/iSynSApp/paymentAuth.action';
        	//Save endPointBaseUrl; 
        	controller.save();
        	hostedPciConf = HostedPCISettings__c.getOrgDefaults();	
        	String endPointBaseUrl = hostedPciConf.endPointBaseUrl__c;        	
        	// Verify that  endPointBaseUrl equals  'https://api-sampqa1stg.c1.hostedpci.com/iSynSApp/paymentAuth.action' after saving
        	System.assertEquals('https://api-sampqa1stg.c1.hostedpci.com/iSynSApp/paymentAuth.action' , endPointBaseUrl); 
        	
			//Test siteId
        	controller.buttonId = 'siteId'; 
        	controller.newValue = '61360';
        	//Save siteId; 
        	controller.save();
        	hostedPciConf = HostedPCISettings__c.getOrgDefaults();	
        	String siteId = hostedPciConf.siteId__c;        	
        	// Verify that  siteId equals  '61360' after saving
        	System.assertEquals('61360' , siteId); 
        
        	//Test locationName
        	controller.buttonId = 'locationName'; 
        	controller.newValue = 'salesforceexample1';
        	//Save locationName; 
        	controller.save();
        	hostedPciConf = HostedPCISettings__c.getOrgDefaults();	
        	String LocationName = hostedPciConf.locationName__c;        	
        	// Verify that  locationName equals  'salesforceexample1' after saving
        	System.assertEquals('salesforceexample1' , locationName); 
        //Stop the test
		test.StopTest();		
    }
}