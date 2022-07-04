public with sharing class HostedPCISettingsController {
    public transient String userName;
    public transient String userPassKey;
    public String endPointBaseUrl;
    public String siteId;
    public String locationName;
    public boolean displayPopup {get; set;}
    public String modalTitle ;
    public String buttonId {get;set;}
    public String newValue{get;set;}
    HostedPCIConfigurations__c hostedPciSet;

    public HostedPCISettingsController() {
        hostedPciSet = HostedPCIConfigurations__c.getInstance();
        userName = hostedPciSet.userName__c;
        userPassKey = hostedPciSet.userPassKey__c;
        endPointBaseUrl = hostedPciSet.endPointBaseUrl__c;
        siteId = hostedPciSet.siteId__c;
        locationName = hostedPciSet.locationName__c;
    }

    public string getUserName() {
        hostedPciSet = HostedPCIConfigurations__c.getInstance();
        userName = hostedPciSet.userName__c;
		List<String> UserNameList = new List<String>();
        String user;

        for( integer i =0; i < userName.length(); i++)
            UserNameList.add('*');
        user = string.join(UserNameList,'');

        return user;
    }
    
    private void setUserName() {
        hostedPciSet = HostedPCIConfigurations__c.getInstance();
        userName = hostedPciSet.userName__c;
        if (!String.isBlank(newValue) && !userName.equals(newValue)) {
            try{
                HostedPCIConfigurations__c hostedPciConf = HostedPCIConfigurations__c.getInstance(System.UserInfo.getUserId());                
                //Check if the user has access
                if (!Schema.sObjectType.HostedPCIConfigurations__c.fields.userName__c.isUpdateable() ||
                   		!Schema.sObjectType.HostedPCIConfigurations__c.fields.userName__c.isCreateable()){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,
	                                                    'Insufficient access'));
	      			return;
			    }
                hostedPciConf.userName__c = newValue;
                upsert hostedPciConf;
                
                userName = newValue;
                userPassKey = hostedPciConf.userPassKey__c;
            }catch (DmlException e) {
                System.debug(e.getMessage());
                ApexPages.addMessages(e);
            }
        }
    }

    public string getUserPassKey() {
        hostedPciSet = HostedPCIConfigurations__c.getInstance();
        userPassKey = hostedPciSet.userPassKey__c;
        List<String> UserPassList = new List<String>();
        String userPass;

        for( integer i = 0; i < userPassKey.length(); i++)
            UserPassList.add('*');
        userPass = string.join(UserPassList,'');

        return userPass;
    }
    
    private void setUserPassKey(){
        hostedPciSet = HostedPCIConfigurations__c.getInstance();
        userPassKey = hostedPciSet.userPassKey__c;
        if (!String.isBlank(newValue) && !userPassKey.equals(newValue)) {
            try{
                HostedPCIConfigurations__c hostedPciConf = HostedPCIConfigurations__c.getInstance(System.UserInfo.getUserId());
                
                //Check if the user has access
                if (!Schema.sObjectType.HostedPCIConfigurations__c.fields.userPassKey__c.isUpdateable() ||
                   		!Schema.sObjectType.HostedPCIConfigurations__c.fields.userPassKey__c.isCreateable()){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,
	                                                    'Insufficient access'));
	      			return;
			    }
                hostedPciConf.userPassKey__c = newValue;
                upsert hostedPciConf;
                
                userPassKey = newValue;
                userName = hostedPciConf.userName__c;
            }catch (DmlException e) {
                System.debug(e.getMessage());
                ApexPages.addMessages(e);
            }
        }
    }

    public string getEndPointBaseUrl(){
        return endPointBaseUrl;
    }
    
    private void setEndPointBaseUrl(){
        hostedPciSet = HostedPCIConfigurations__c.getInstance();
        endPointBaseUrl = hostedPciSet.endPointBaseUrl__c;
        if (!String.isBlank(newValue) && !endPointBaseUrl.equals(newValue)) {
            try{
                HostedPCIConfigurations__c hostedPciConf = HostedPCIConfigurations__c.getInstance(System.UserInfo.getUserId());
                
                if (!Schema.sObjectType.HostedPCIConfigurations__c.fields.endPointBaseUrl__c.isUpdateable() ||
                   		!Schema.sObjectType.HostedPCIConfigurations__c.fields.endPointBaseUrl__c.isCreateable()){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,
	                                                    'Insufficient access'));
	      			return;
			    }
                hostedPciConf.endPointBaseUrl__c = newValue;
                upsert hostedPciConf;
                
                endPointBaseUrl = newValue;
            }catch (DmlException e) {
                System.debug(e.getMessage());
                ApexPages.addMessages(e);
            }
        }
    }

    public string getSiteId(){
        return siteId;
    }
    
    private void setSiteId() {
       hostedPciSet = HostedPCIConfigurations__c.getInstance();
       siteId = hostedPciSet.siteId__c;
       if (!String.isBlank(newValue) && !siteId.equals(newValue)) {
            try{
                HostedPCIConfigurations__c hostedPciConf = HostedPCIConfigurations__c.getInstance(System.UserInfo.getUserId());
                
                if (!Schema.sObjectType.HostedPCIConfigurations__c.fields.siteId__c.isUpdateable() ||
                   		!Schema.sObjectType.HostedPCIConfigurations__c.fields.siteId__c.isCreateable()){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,
	                                                    'Insufficient access'));
	      			return;
			    }
                hostedPciConf.siteId__c = newValue;
                upsert hostedPciConf;
                
                siteId = newValue;
            }catch (DmlException e) {
                System.debug(e.getMessage());
                ApexPages.addMessages(e);
            }
        }
    }

    public string getLocationName() {
        return locationName;
    }
    
    private void setLocationName() {
        hostedPciSet = HostedPCIConfigurations__c.getInstance();
        locationName = hostedPciSet.locationName__c;
        if (!String.isBlank(newValue) && !locationName.equals(newValue)) {
            try{
                HostedPCIConfigurations__c hostedPciConf = HostedPCIConfigurations__c.getInstance(System.UserInfo.getUserId());
                
                if (!Schema.sObjectType.HostedPCIConfigurations__c.fields.locationName__c.isUpdateable() ||
                   		!Schema.sObjectType.HostedPCIConfigurations__c.fields.locationName__c.isCreateable()) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,
	                                                    'Insufficient access'));
	      			return;
			    }
                hostedPciConf.locationName__c = newValue;
                upsert hostedPciConf;
                
                locationName = newValue;
            }catch (DmlException e) {
                System.debug(e.getMessage());
                ApexPages.addMessages(e);
            }
        }
    }

    public void setModalTitle(String newModalTitle) {
        modalTitle = newModalTitle;
    }
    
    public String getModalTitle() {
        return 'Edit mode: ' + modalTitle ;
    }

    public PageReference save() {
        if(buttonId=='userName')
            setUserName();
        if(buttonId=='userPassKey')
            setUserPassKey();
        if(buttonId=='endPointBaseUrl')
            setEndPointBaseUrl();
        if(buttonId=='siteId')
            setSiteId();
        if(buttonId=='locationName')
            setLocationName();
        displayPopup = false;
        newValue='';
        
        return null;
    }
    
    public void closePopup() {
        newValue='';
        displayPopup = false;
    }
    
    public void showPopup() {
        setModalTitle(buttonId);
        displayPopup = true;
    }
}