@isTest
public class PaymentTerminalController_Test {
    static PageReference pageRef;
    static PaymentTerminalController controller;    
    
    @isTest 
    private static void init(){
        pageRef = Page.PaymentTerminal;
        Test.setCurrentPage(pageRef);
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

}