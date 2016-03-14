@isTest
global class mock_HostedPciServiceUtil implements HttpCalloutMock{
	global HttpResponse respond(HttpRequest req){
    	system.debug(req);
		HttpResponse res = new HttpResponse();
     	res.setStatusCode(200);
     	res.setStatus('Ok');
        
        string response = 'status%3Dsuccess%26operId%3D%26authId%3D146675799%26pxyResponse.threeDSEnrolled%3D%2'
            +'6pxyResponse.threeDSARS%3D%26pxyResponse.threeDSAcsUrl%3D%26pxyResponse.responseStatus.code%3D1%'
            +'26pxyResponse.threeDSErrorId%3D%26pxyResponse.processorType%3DanetResponse%26pxyResponse.threeDSECI'
            +'%3D%26pxyResponse.mappedParams%3DtxnResponse.ccTypeEst%253DVISA%26pxyResponse.fullNativeResp%'
            +'3DtxnResponse.target.authorizationCode%253DZE3DBS%2526txnResponse.responseReasonCode.'
            +'responseReasonCode%253D1%2526txnResponse.error%253DN%2526txnResponse.target.transactionId'
            +'%253D2236882926%2526txnResponse.approved%253DY%2526txnResponse.responseReasonCode.notes%'
            +'253D%2526txnResponse.responseCode.description%253DThis%252Btransaction%252Bhas%252Bbeen%252Bapproved.'
            +'%2526txnResponse.review%253DN%2526txnResponse.responseText%253DThis%252Btransaction%252Bhas%252Bbeen%'
            +'252Bapproved.%2526txnResponse.responseCode.name%253DAPPROVED%2526txnResponse.responseReasonCode.'
            +'reasonText%253DThis%252Btransaction%252Bhas%252Bbeen%252Bapproved.%2526txnResponse.responseCode.code'
            +'%253D1%2526txnResponse.declined%253DN%26pxyResponse.gatewayToken%3D%26pxyResponse.threeDSXid%3D%'
            +'26pxyResponse.threeDSCAVV%3D%26pxyResponse.merchantRefId%3D%26pxyResponse.responseCVV1%3DP%26pxyResponse.'
            +'responseCVV2%3D%26pxyResponse.txnPayName%3DDEF%26pxyResponse.threeDSErrorDesc%3D%26pxyResponse.'
            +'responseStatus.reasonCode%3D1%26pxyResponse.responseStatus.name%3DAPPROVED%26pxyResponse.'
            +'processorRefId%3D2236882926%26pxyResponse.threeDSTransactionId%3D%26pxyResponse.responseStatus.'
            +'description%3DThis%2Btransaction%2Bhas%2Bbeen%2Bapproved.%26pxyResponse.threeDSSRS%3D%26pxyResponse.'
            +'responseStatus%3Dapproved%26pxyResponse.threeDSOrderId%3D%26pxyResponse.responseAVS2%3D%26pxyResponse.'
            +'responseAVS1%3DY%26pxyResponse.responseAVS4%3D%26pxyResponse.responseAVS3%3D%26pxyResponse.'
            +'threeDSPARequest%3D';
     	res.setBody(response);        
	 	return res;   
    }
}