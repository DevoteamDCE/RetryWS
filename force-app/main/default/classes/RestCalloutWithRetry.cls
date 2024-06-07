/**
 * @description       :
 * @author            : walid abidi.SFDoc
 * @group             :
 * @last modified on  : 05-24-2024
 * @last modified by  : walid abidi.SFDoc
 **/
public class RestCalloutWithRetry {
	
	/**
	 * @description
	 * @author walid abidi.SFDoc | 05-24-2024
	 * @param header
	 * @param url
	 * @param method
	 * @param body
	 * @param timeout
	 * @return HttpResponse
	 **/
	public static HttpResponse sendCalloutWithRetry(Map<String, String> header,String url, String method, String body,Integer timeout) {
		Boolean isloggedResponse=false;
		HttpResponse response;
		HttpRequest request = new HttpRequest();
		request.setEndpoint(url);
		request.setMethod(method);
		if(timeout != null) request.setTimeout(timeout);
		if(body != null) request.setBody(body);
		
		for(String singleHeader : header.keySet()){
			request.setHeader(singleHeader, header.get(singleHeader));
		}
		Integer numAttempts = Integer.ValueOf(Retry_Config__mdt.getInstance('retryWSParam').numAttempts__c); // Maximum number of retry attempts
		Integer delayInMilliseconds = Integer.ValueOf(Retry_Config__mdt.getInstance('retryWSParam').delay_In_Milliseconds__c); // One-second delay between attempts
		while (numAttempts > 0) {
			Long startingTime = System.now().getTime();
			try {
				
				
				Http http = new Http();
				
				response = http.send(request);
				
				if (response.getStatusCode() >= 200 && response.getStatusCode() < 300) {
					// Callout was successful, return response
					Logs.logHttpResponse('Callout success', 'Http Callout', response, 'HttpCallout', 'send', request);
					return response;
				}
				// Callout was not successful, decrement attempts and retry
				numAttempts--;
				if(!isloggedResponse){
					Logs.logHttpResponse('Callout failed', 'Http Callout', response, 'HttpCallout', 'send', request);
					SendEmailWithTemplate.sendNotification(response!=null?response.getStatusCode():1,response!=null?response.getBody():'');

                    isloggedResponse=true;
				}
				//waiting for delayInMilliseconds before retry
				while (System.now().getTime() - startingTime < delayInMilliseconds)  {
					// Do nothing until desired delay has passed
				}
			} catch (Exception ex) {
				// An exception occurred during the callout, decrement attempts and retry
				numAttempts--;
				
				if(!isloggedResponse){
					Logs.logError('Callout failed','Http Callout',ex);
					Logs.logHttpResponse('Callout failed', 'Http Callout', response, 'HttpCallout', 'send', request);
					SendEmailWithTemplate.sendNotification(response!=null?response.getStatusCode():1,response!=null?response.getBody():'');

                    isloggedResponse=true;
				}
				
				
				//waiting for delayInMilliseconds before retry
				while (System.now().getTime() - startingTime < delayInMilliseconds)  {
					// Do nothing until desired delay has passed
				}
			}
		}
				// Maximum number of retry attempts reached, return null
		return response;
	}
	public static void logResponse(HttpResponse response, HttpRequest request){
		Logs.logHttpResponse('Callout failed', 'Http Callout', response, 'HttpCallout', 'send', request);
	}
}