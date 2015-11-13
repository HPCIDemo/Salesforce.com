@isTest
global class mock_HostedPciServicePhoneAPIUtil implements HttpCalloutMock{
    
    global HttpResponse respond(HttpRequest req){
    	system.debug(req);
		HttpResponse res = new HttpResponse();
     	res.setStatusCode(200);
     	res.setStatus('Ok');                
        
        string response = 'status=success&sessionId=1536677&sessionType=ccmap&'
			+'promptLang=en_US&sessionStatus=complete&sessionKey=9353661778&'
 			+'sessionTaskCount=3&sessionTask[1].type=sessionsetup&sessionTask[1].status=success&'
			+'sessionTask[1].promptCode=created_entersession&sessionTask[1].completionCode=success&'
			+'sessionTask[1].respToken1=&sessionTask[1].respToken2=&sessionTask[1].respToken3=&'
			+'sessionTask[1].exceptionId=&sessionTask[1].exceptionMsg=&sessionTask[1].comment=&'
			+'sessionTask[1].paramName=&sessionTask[1].paramValue=&'
			+'sessionTask[1].createTS=2015-11-10+03%3A31%3A22+PM+EST&'
			+'sessionTask[2].type=ccmapsetup&sessionTask[2].status=success&'
			+'sessionTask[2].promptCode=created_enterccnum&sessionTask[2].completionCode=success&'
			+'sessionTask[2].respToken1=&sessionTask[2].respToken2=&sessionTask[2].respToken3=&'
			+'sessionTask[2].exceptionId=&sessionTask[2].exceptionMsg=&sessionTask[2].comment=&'
			+'sessionTask[2].paramName=mappedcc&sessionTask[2].paramValue=4111000005701111&'
			+'sessionTask[2].createTS=2015-11-10+03%3A32%3A37+PM+EST&sessionTask[3].type=cccvvsetup&'
			+'sessionTask[3].status=success&sessionTask[3].promptCode=created_entercccvv&'
			+'sessionTask[3].completionCode=success&sessionTask[3].respToken1=200&'
			+'sessionTask[3].respToken2=&sessionTask[3].respToken3=&sessionTask[3].exceptionId=&'
			+'sessionTask[3].exceptionMsg=&sessionTask[3].comment=Masked+CVV%3A200&'
			+'sessionTask[3].paramName=&sessionTask[3].paramValue=&'
			+'sessionTask[3].createTS=2015-11-10+03%3A32%3A57+PM+EST';
                
     	res.setBody(response);
	 	return res;   
    }

}