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

    public HostedPCISettingsController(){
        hostedPciSet = HostedPCIConfigurations__c.getInstance();
        userName = hostedPciSet.userName__c;
        userPassKey = hostedPciSet.userPassKey__c;
        endPointBaseUrl = hostedPciSet.endPointBaseUrl__c;
        siteId = hostedPciSet.siteId__c;
        locationName = hostedPciSet.locationName__c;
    }

    public string getUserName(){
		List<String> UserNameList = new List<String>();
        String user;

        for( integer i =0; i<userName.length();i++)
            UserNameList.add('*');
        user = string.join(UserNameList,'');

        return user;
    }
    private void setUserName(){
        if(newValue.length()>0 &&(userName!=newValue)){
            try{
                HostedPCIConfigurations__c hostedPciConf = HostedPCIConfigurations__c.getOrgDefaults();
                hostedPciConf.userName__c = newValue;
                //Check if the user has create access
                if (!Schema.sObjectType.HostedPCIConfigurations__c.isUpdateable()){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,
	                                                    'Insufficient access'));
	      			return;
			    }
                update hostedPciConf;
                userName = newValue;
                userPassKey = hostedPciConf.userPassKey__c;
            }catch (DmlException e) {
                System.debug(e.getMessage());
                ApexPages.addMessages(e);
            }
        }

    }

    public string getUserPassKey(){
        List<String> UserPassList = new List<String>();
        String userPass;

        for( integer i =0; i<userPassKey.length();i++)
            UserPassList.add('*');
        userPass = string.join(UserPassList,'');

        return userPass;
    }
    private void setUserPassKey(){
        if(newValue.length()>0 &&(userName!=newValue)){
            try{
                HostedPCIConfigurations__c hostedPciConf = HostedPCIConfigurations__c.getOrgDefaults();
                hostedPciConf.userPassKey__c = newValue;
                //Check if the user has create access
                if (!Schema.sObjectType.HostedPCIConfigurations__c.isUpdateable()){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,
	                                                    'Insufficient access'));
	      			return;
			    }
                update hostedPciConf;
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
        if(newValue.length()>0 &&(userName!=newValue)){
            try{
                HostedPCIConfigurations__c hostedPciConf = HostedPCIConfigurations__c.getOrgDefaults();
                hostedPciConf.endPointBaseUrl__c = newValue;
                if (!Schema.sObjectType.HostedPCIConfigurations__c.isUpdateable()){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,
	                                                    'Insufficient access'));
	      			return;
			    }
                update hostedPciConf;
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
    private void setSiteId(){
       if(newValue.length()>0 &&(userName!=newValue)){
            try{
                HostedPCIConfigurations__c hostedPciConf = HostedPCIConfigurations__c.getOrgDefaults();
                hostedPciConf.siteId__c = newValue;
                if (!Schema.sObjectType.HostedPCIConfigurations__c.isUpdateable()){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,
	                                                    'Insufficient access'));
	      			return;
			    }
                update hostedPciConf;
                siteId = newValue;
            }catch (DmlException e) {
                System.debug(e.getMessage());
                ApexPages.addMessages(e);
            }
        }
    }

    public string getLocationName(){
        return locationName;
    }
    private void setLocationName(){
        if(newValue.length()>0 &&(userName!=newValue)){
            try{
                HostedPCIConfigurations__c hostedPciConf = HostedPCIConfigurations__c.getOrgDefaults();
                hostedPciConf.locationName__c = newValue;
                if (!Schema.sObjectType.HostedPCIConfigurations__c.isUpdateable()){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,
	                                                    'Insufficient access'));
	      			return;
			    }
                update hostedPciConf;
                locationName = newValue;
            }catch (DmlException e) {
                System.debug(e.getMessage());
                ApexPages.addMessages(e);
            }
        }
    }

    public void setModalTitle(String newModalTitle){
        modalTitle = newModalTitle;
    }
    public String getModalTitle(){
        return 'Edit mode: ' + modalTitle ;
    }

    public PageReference save(){
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