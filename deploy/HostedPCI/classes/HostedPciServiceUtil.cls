public class HostedPciServiceUtil{    
          
    public static String httpCalloutHostedPciAuthOnly(Map<String,String> hpciRequestParamMap){
        // Assuming the full request param map is ready
        // Url Endpoint is made of the api url which is given by
        // HostedPCI + "/iSynSApp/paymentAuth.action"                
        string endPoint = HostedPCISettings__c.getInstance().endPointAuth__c;
        string resultMsg = callUrl(endPoint, hpciRequestParamMap);
        
        return resultMsg; 
    }
    
    public static String httpCalloutHostedPciCaptureOnly(String processorRefId, Map<String,String> hpciRequestParamMap){
        // Assuming the full request param map is ready
        // Url Endpoint is made of the api url which is given by
        // HostedPCI + "/iSynSApp/paymentCapture.action"                                
        string endPoint = HostedPCISettings__c.getInstance().endPointCapture__c;
        hpciRequestParamMap.put('pxyTransaction.processorRefId', processorRefId);
        string resultMsg = callUrl(endPoint, hpciRequestParamMap);
        
        return resultMsg; 
    }
    
    public static String httpCalloutHostedPciCreditOnly(String processorRefId, Map<String,String> hpciRequestParamMap){
        // Assuming the full request param map is ready
        // Url Endpoint is made of the api url which is given by
        // HostedPCI + "/iSynSApp/paymentCredit.action"                
        string endPoint = HostedPCISettings__c.getInstance().endPointCredit__c;
        hpciRequestParamMap.put('pxyTransaction.processorRefId', processorRefId);
        string resultMsg = callUrl(endPoint, hpciRequestParamMap);
        
        return resultMsg; 
    }
    
    public static String httpCalloutHostedPciSaleOnly(Map<String,String> hpciRequestParamMap){        
        // Assuming the full request param map is ready
        // Url Endpoint is made of the api url which is given by
        // HostedPCI + "/iSynSApp/paymentSale.action"                
        string endPoint = HostedPCISettings__c.getInstance().endPointSale__c;
        string resultMsg = callUrl(endPoint, hpciRequestParamMap);
        
        return resultMsg; 
    }
    
    public static String httpCalloutHostedPciVoidOnly(String processorRefId, Map<String,String> hpciRequestParamMap){        
        // Assuming the full request param map is ready
        // Url Endpoint is made of the api url which is given by
        // HostedPCI + "/iSynSApp/paymentVoid.action"  
        string endPoint = HostedPCISettings__c.getInstance().endPointVoid__c;
        hpciRequestParamMap.put('pxyTransaction.processorRefId', processorRefId);
        string resultMsg = callUrl(endPoint, hpciRequestParamMap);
        
        return resultMsg;        
    }
    
    public static String httpCalloutHostedPciManageCCMApPhoneAPI(Map<String,String> hpciRequestParamMap){        
        // Assuming the full request param map is ready
        // Url Endpoint is made of the api url which is given by
        // HostedPCI + "/iSynSApp/manageCCMapPhoneAPI.action"  
        string endPoint = HostedPCISettings__c.getInstance().endPoint_manageCCMapPhoneAPI__c;
        string resultMsg = callUrl(endPoint, hpciRequestParamMap);
        
        return resultMsg;        
    }
    
    public static String callUrl(String urlEndPoint, Map<String, String> hpciRequestParamMap) {
        //Get connection settings from HostedPCISettings__c Custom Settings Class
        HostedPCISettings__c hostedPciSet = HostedPCISettings__c.getInstance();   
        
        // Populate hpciRequestParamMap with all the needed pairs of information
        hpciRequestParamMap.put('apiVersion', hostedPciSet.apiVersion__c);
        hpciRequestParamMap.put('apiType', hostedPciSet.apiType__c);
        // The username is given by HostedPCI
        hpciRequestParamMap.put('userName', hostedPciSet.userName__c);
        // The passkey is given by HostedPCI
        hpciRequestParamMap.put('userPassKey', hostedPciSet.userPassKey__c);     
        
        Http httpConn = new Http();
        HttpRequest httpReq = new HttpRequest();
        httpReq.setMethod('POST');      
        httpReq.setBody(encodeMsg(hpciRequestParamMap));
        httpReq.setEndpoint(hostedPciSet.endPointBaseUrl__c + urlEndPoint);
        HttpResponse httpRes = new HttpResponse();
        httpRes = httpConn.send(httpReq);
       
        return httpRes.getBody();
    }
    
    public static String encodeMsg(Map<String,String> hpciRequestParamMap){
        String encodedMsg = '';
        
        for (string msgKey : hpciRequestParamMap.keySet()){
            string msgValue = hpciRequestParamMap.get(msgKey);
            //fix null values
            if (string.isblank(msgValue)) msgValue='';
            encodedMsg += msgKey+'='+
            EncodingUtil.urlEncode(msgValue, 'UTF-8')+'&';
            //debug message value being added
            system.debug('TRACE: message bit '+msgKey+' added');
        }
        //add message termination
         encodedMsg += 'endofdata';
         
         return encodedMsg;
    }
    
    public static Map<String, String> parseQueryString(String queryStr) {
        Map<String, String> mapMsg = new Map<String, String>();
        if (queryStr == null)
          return mapMsg;
        List <String> params = queryStr.split('&'); 
        for (String param : params) {
          String name = '';
          String value = '';
          List<String> paramPair = param.split('=');
          if (paramPair != null && paramPair.size() > 0) {
            name = paramPair[0];
            if (paramPair.size() > 1 && paramPair[1] != null) {
              try {
                value = EncodingUtil.urlDecode(paramPair[1], 'UTF-8');
              } catch (StringException e) {
                system.debug('Could not decode:' + paramPair[1]);
              }
            }
          }
          mapMsg.put(name, value);
        } 
        return mapMsg; 
    } //END: parseQueryString
}