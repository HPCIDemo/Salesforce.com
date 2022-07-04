@isTest
global class mock_HostedPciServiceUtil implements HttpCalloutMock{
	global HttpResponse respond(HttpRequest req){
    	system.debug(req);
        string reqBody = req.getBody();
        system.debug('reqBody:\n' + reqBody);
        
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
     	
        string responseEnrolled = 'status=error&errId=&errParamName=&errParamValue=&pxyResponse.threeDSEnrolled=Y'
            + '&pxyResponse.threeDSAcsUrl=https%3A%2F%2F1eafstag.cardinalcommerce.com%2FEAFService%2Fjsp%2Fv1%2Fredirect'
            + '&pxyResponse.threeDSActionName=verifyenroll&pxyResponse.threeDSErrorDesc=&pxyResponse.processorRefId='
            + '&pxyResponse.processorType=3dsecResponse&pxyResponse.threeDSMessageId=&pxyResponse.cardOnFileIssuerId='
            + '&pxyResponse.threeDSDDCPageData=&pxyResponse.threeDSOrderId=&pxyResponse.gatewayToken.status='
            + '&pxyResponse.threeDSErrorSubId=&pxyResponse.responseStatus.name=&pxyResponse.threeDSReasonDesc='
            + '&pxyResponse.responseAVS2=&pxyResponse.responseStatus=3dsecure&pxyResponse.gatewayToken=&pxyResponse.responseAVS1='
            + '&pxyResponse.responseAVS4=&pxyResponse.responseStatus.description=&pxyResponse.responseAVS3='
            + '&pxyResponse.gatewayToken.fullNativeResp=&pxyResponse.threeDSXid=nsX4LZhEX5Q7tr7XZPs1&pxyResponse.responseStatus.reasonCode='
            + '&pxyResponse.threeDSPARequest=P.3c7564060a90c3790d2f94cedfd3437cc20f73e770ebebb0eec5702f8c6b0a4315c5b63b3def097'
            + '6e045ce661c45e74f3abe08db320b1c20b6251d0c04128ded&pxyResponse.threeDSDDCUrl=&pxyResponse.responseCVV1='
            + '&pxyResponse.responseCVV2=&pxyResponse.cardOnFileSettlementDate=&pxyResponse.fullNativeResp='
            + '&pxyResponse.threeDSErrorSubIdType=&pxyResponse.threeDSAcsPageData=&pxyResponse.gatewaySubToken2='
            + '&pxyResponse.threeDSTransactionId=nsX4LZhEX5Q7tr7XZPs1&pxyResponse.gatewaySubToken1=&pxyResponse.gatewaySubToken3='
            + '&pxyResponse.threeDSCavvAlgorithm=&pxyResponse.merchantRefId=&pxyResponse.threeDSErrorId=0&pxyResponse.responseStatus.code='
            + '&pxyResponse.threeDSUCAF=&pxyResponse.threeDSReasonCode=&pxyResponse.threeDSDirSrvTransactionId=';
        
        string responseVerifyResp = 'status=success&operId=&authId=731442887&pxyResponse.threeDSEnrolled=&pxyResponse.threeDSAcsUrl='
            + '&pxyResponse.threeDSErrorDesc=&pxyResponse.processorRefId=40094795063&pxyResponse.processorType=anetResponse'
            + '&pxyResponse.threeDSMessageId=&pxyResponse.threeDSSessionId=&pxyResponse.cardOnFileIssuerId='
            + '&pxyResponse.mappedParams=txnResponse.ccTypeEst%3DVISA&pxyResponse.threeDSDDCPageData=&pxyResponse.threeDSARS=Y'
            + '&pxyResponse.threeDSOrderId=&pxyResponse.gatewayToken.status=&pxyResponse.threeDSErrorSubId='
            + '&pxyResponse.responseStatus.name=APPROVED&pxyResponse.threeDSReasonDesc=&pxyResponse.responseAVS2='
            + '&pxyResponse.responseStatus=approved&pxyResponse.gatewayToken=&pxyResponse.responseAVS1=Y&pxyResponse.responseAVS4='
            + '&pxyResponse.responseStatus.description=This+transaction+has+been+approved.'
            + '&pxyResponse.threeDSCAVV=AAABAWFlmQAAAABjRWWZEEFgFz8%3D&pxyResponse.responseAVS3=&pxyResponse.gatewayToken.fullNativeResp='
            + '&pxyResponse.threeDSXid=bnNYNExaaEVYNVE3dHI3WFpQczE%3D&pxyResponse.threeDSProtoVersion='
            + '&pxyResponse.responseStatus.reasonCode=1&pxyResponse.threeDSPARequest=&pxyResponse.threeDSDDCUrl='
            + '&pxyResponse.responseCVV1=P&pxyResponse.threeDSECI=05&pxyResponse.responseCVV2=&pxyResponse.cardOnFileSettlementDate='
            + '&pxyResponse.fullNativeResp=txnResponse.target.transactionId%3D40094795063%26txnResponse.declined%3DN%26txnResponse'
            + '.review%3DN%26txnResponse.responseReasonCode.notes%3D%26txnResponse.approved%3DY%26txnResponse.responseReasonCode'
            + '.reasonText%3DThis%2Btransaction%2Bhas%2Bbeen%2Bapproved.%26txnResponse.responseText%3DThis%2Btransaction%2Bhas%2Bbeen%2Bapproved'
            + '.%26txnResponse.responseCode.name%3DAPPROVED%26txnResponse.error%3DN%26txnResponse.responseCode.code%3D1%26txnResponse'
            + '.responseCode.description%3DThis%2Btransaction%2Bhas%2Bbeen%2Bapproved.%26txnResponse.target'
            + '.authorizationCode%3DSWLW9L%26txnResponse.responseReasonCode.responseReasonCode%3D1&pxyResponse.threeDSErrorSubIdType='
            + '&pxyResponse.threeDSAcsPageData=&pxyResponse.gatewaySubToken2=&pxyResponse.threeDSTransactionId=nsX4LZhEX5Q7tr7XZPs1'
            + '&pxyResponse.gatewaySubToken1=&pxyResponse.gatewaySubToken3=&pxyResponse.threeDSCavvAlgorithm=&pxyResponse.merchantRefId='
            + '&pxyResponse.threeDSErrorId=0&pxyResponse.txnPayName=DEF_3DSEC&pxyResponse.responseStatus.code=1'
            + '&pxyResponse.threeDSReasonCode=&pxyResponse.threeDSSRS=Y';
        
        if (String.isNotBlank(reqBody) && reqBody.contains('pxyThreeDSecAuth.actionName=verifyenroll')) {
            System.debug('verifyenroll: true');
            res.setBody(responseEnrolled); 
        } 
        else if (String.isNotBlank(reqBody) && reqBody.contains('pxyThreeDSecAuth.actionName=verifyresp')) {
            System.debug('verifyresp: true');
            res.setBody(responseVerifyResp); 
        }
        else {
        	res.setBody(response); 
    	}
	 	return res;   
    }
}