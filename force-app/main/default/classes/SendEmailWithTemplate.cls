/**
 * @description       :
 * @author            : walid.abidi.SFDoc
 * @group             :
 * @last modified on  : 05-24-2024
 * @last modified by  : walid.abidi.SFDoc
 **/
public class SendEmailWithTemplate {
	/**
	 * @description
	 * @author walid.abidi.SFDoc | 05-24-2024
	 **/
	Public static void sendNotification(Integer statusCode,String responseBody)
	{
		
		
        String emailSenderList   = ListEmailForRetry__mdt.getInstance('EmailList').EmailList__c;
		String[] emailAddresses = emailSenderList.split(';');
		EmailTemplate emailTemplate =[Select Id,Subject,Description,
		HtmlValue,DeveloperName,Body
		from EmailTemplate where name ='RetryRestCalloutTemplate'];
		//Get templete id for set the templete.
		
		
		String subject = emailTemplate.Subject;
		String htmlBody = emailTemplate.HtmlValue;
		
		htmlBody = htmlBody.replace('{!StatusCode}', String.valueOf(statusCode));
		
		htmlBody = htmlBody.replace('{!ResponseBody}', responseBody);
		htmlBody = htmlBody.replace('{!User.Name}', UserInfo.getFirstName());
		
		
		Messaging.SingleEmailMessage message = new   Messaging.SingleEmailMessage();
		message.setHtmlBody(htmlBody);
		//message.setTemplateID(emailTemplate.Id);
		message.setTargetObjectId(UserInfo.getUserId());
		message.setSenderDisplayName('Walid Abidi');
		message.setReplyTo('no-reply@devoteam.com');
		message.setUseSignature(false);
		message.setBccSender(false);
		message.setSaveAsActivity(false);
		message.setSubject(subject);
		
		
		message.toAddresses =  emailAddresses;
		
		Messaging.SingleEmailMessage[] messages = new
		List<Messaging.SingleEmailMessage> {message};
		
		Messaging.SendEmailResult[] results =   Messaging.sendEmail(messages);
		
		if (results[0].success)
		{
			System.debug('The email was sent successfully.');
		}
		else
		{
			System.debug('The email failed to send: ' +   results[0].errors[0].message);
		}
	}
	public static String replaceTemplateParams(String section ,String params,String value){
		return section.replace('{!'+params+'}', value);
	}
}