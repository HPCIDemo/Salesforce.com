public class HostedPCISettingsController {
    public String userName;
    public String userPassKey;
    public String endPointBaseUrl;
    public String siteId;
    public String locationName;
    public boolean displayPopup {get; set;} 
    public String modalTitle ;
    public String buttonId {get;set;}
    public String newValue{get;set;}
    HostedPCISettings__c hostedPciSet;
    
    public HostedPCISettingsController(){
        hostedPciSet = HostedPCISettings__c.getInstance();                        
        userName = hostedPciSet.userName__c;
        userPassKey = hostedPciSet.userPassKey__c;
        endPointBaseUrl = hostedPciSet.endPointBaseUrl__c;
        siteId = hostedPciSet.siteId__c;
        locationName = hostedPciSet.locationName__c;
    }
    
    public string getUserName(){
        return userName;        
    }
    private void setUserName(){
        if(newValue.length()>0 &&(userName!=newValue)){
            try{
                HostedPCISettings__c hostedPciConf = HostedPCISettings__c.getOrgDefaults();
                hostedPciConf.userName__c = newValue;
                update hostedPciConf;
                userName = newValue;
            }catch (DmlException e) {
            	System.debug(e.getMessage());
            	ApexPages.addMessages(e);
        	} 
        }
            
    }
        
    public string getUserPassKey(){        
        return userPassKey;
    }
    private void setUserPassKey(){
        if(newValue.length()>0 &&(userName!=newValue)){
            try{
                HostedPCISettings__c hostedPciConf = HostedPCISettings__c.getOrgDefaults();
                hostedPciConf.userPassKey__c = newValue;
                update hostedPciConf;
                userPassKey = newValue;
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
                HostedPCISettings__c hostedPciConf = HostedPCISettings__c.getOrgDefaults();
                hostedPciConf.endPointBaseUrl__c = newValue;
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
                HostedPCISettings__c hostedPciConf = HostedPCISettings__c.getOrgDefaults();
                hostedPciConf.siteId__c = newValue;
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
                HostedPCISettings__c hostedPciConf = HostedPCISettings__c.getOrgDefaults();
                hostedPciConf.locationName__c = newValue;
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