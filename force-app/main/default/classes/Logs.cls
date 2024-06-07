public class Logs {
    
    private static Boolean SF_LEVEL_INFO;
    private static Boolean SF_LEVEL_TRACE;
    private static Boolean SF_LEVEL_DEBUG;
    private static Boolean SF_LEVEL_HTTPRESPONSE;
    
    static{
        SF_LEVEL_INFO=Log_Level__mdt.getInstance('Info').IsActive__c;
        SF_LEVEL_TRACE=Log_Level__mdt.getInstance('Trace').IsActive__c;
        SF_LEVEL_DEBUG=Log_Level__mdt.getInstance('Debug').IsActive__c;
        SF_LEVEL_HTTPRESPONSE=Log_Level__mdt.getInstance('Http_Response').IsActive__c;
    }
    
    public static void setLevel(String level){
        if(Test.isRunningTest()){
            if(level=='Info'){
                SF_LEVEL_INFO = true;
            }
            if(level=='Trace'){
                SF_LEVEL_TRACE = true;
            }
            if(level=='Debug'){
                SF_LEVEL_DEBUG = true;
            }
            if(level=='Http Response'){
                SF_LEVEL_HTTPRESPONSE = true;
            }   
        }
    }

    public static boolean isInfo() { return SF_LEVEL_INFO; }
    
    public static boolean isTrace() { return SF_LEVEL_TRACE; }
    
    public static boolean isDebug() { return SF_LEVEL_DEBUG; }
    
    public static boolean isHttpResponse() { return SF_LEVEL_HTTPRESPONSE;  }
    
    public static String getClassName(String line){
        try {
            if (line.startsWith('Class.'))
                line = line.substringAfter('Class.');
            return line.substringBefore(':').substringBeforeLast('.');
        } catch(Exception error) {
            system.debug(error);
            return '';
        } 
    }  
    
    public static String getMethod(String line){
        try {
            return line.substringBefore(':').substringAfterLast('.');
        } catch(Exception error){
            system.debug(error);
            return '';
        }
    }
    
    public static void logError(String topic,String name,Exception e) {
        try {
            Log__c logs = new Log__c();
            logs.Name = name;
            logs.Topic__c = topic;
            logs.Error__c = e.getMessage();
            logs.Level__c = 'Error';
            logs.Line_number__c = String.valueOf(e.getLineNumber());
            logs.trace__c = e.getStackTraceString();
            //logs.message__c = String.valueOf(e.getMessage());
            logs.Apex_class__c = getClassName(e.getStackTraceString());
            logs.Apex_method__c = getMethod(e.getStackTraceString());
            insert logs; 
        } catch (Exception error) {
            system.debug(error);
        }             
    }
    
    public static void logDebug(String topic,String name,String msg, String apexClass, String method) {
        if(isDebug()) {
            try {
                Log__c logs = new Log__c();
                logs.Name = name;
                logs.Topic__c = topic;
               // logs.Error__c = e.getMessage();
                logs.Level__c = 'Debug';
                //logs.Line_number__c = String.valueOf(e.getLineNumber());
                //logs.trace__c = e.getStackTraceString();
                logs.message__c = msg;
                logs.Apex_class__c = apexClass;
                logs.Apex_method__c = method;
                insert logs; 
            } catch (Exception error) {
                system.debug(error);
            }
        }
    }
    
    public static void logInfo(String topic,String name, String message, String apexClass, String method) {
        if(isInfo()) {
            try {
                Log__c logs = new Log__c();
                logs.Name = name;
                logs.Topic__c = topic;
                //logs.Error__c = e.getMessage();
                logs.Level__c = 'Info';
                //logs.Line_number__c = String.valueOf(e.getLineNumber());
                //logs.trace__c = e.getStackTraceString();
                logs.message__c = message;
                logs.Apex_class__c = apexClass;
                logs.Apex_method__c = method;
                insert logs; 
            } catch (Exception error) {
                system.debug(error);
            }
        }
    }
    
    public static void logTrace(String topic,String name, String message, String apexClass, String method) {
        if(isTrace()) {
            try {
                Log__c logs = new Log__c();
                logs.Name = name;
                logs.Topic__c = topic;
                //logs.Error__c = e.getMessage();
                logs.Level__c = 'Trace';
                //logs.Line_number__c = String.valueOf(e.getLineNumber());
                //logs.trace__c = e.getStackTraceString();
                logs.message__c = message;
                logs.Apex_class__c = apexClass;
                logs.Apex_method__c = method;
                insert logs; 
            } catch (Exception error) {
            
                system.debug(error);
            }
        }
    }
    
    public static void logHttpResponse(String topic, String name, HttpResponse response, String apexClass, String method, HttpRequest request) {
        if(isHttpResponse()) {
            try {
            
                Log__c logs = new Log__c();
                
                logs.Name = name;
                logs.Topic__c = topic;
                //logs.Error__c = e.getMessage();
                logs.Level__c = 'Trace';
                logs.HTTP_Request__c = request.getBody();
                //logs.trace__c = e.getStackTraceString();
                //logs.message__c = String.valueOf(e.getMessage());
                if(response != null){
                    logs.HTTP_Response__c = response.getBody();
                    logs.HTTP_Status_code__c = response.getStatusCode();         
                }
                logs.Apex_class__c = apexClass;
                logs.Apex_method__c = method;
                System.debug('****************************HERE');
                insert logs; 
            } catch (Exception error) {
                system.debug(error);
            }
        }
    }
}