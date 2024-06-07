@isTest
public class Logs_Test {

    public Logs_Test() {}

    private class TestException extends Exception {}
    

    // log Info
    @IsTest static void testlogInfo(){
        Logs.setlevel('Info');

        Test.startTest();
        Logs.logInfo('Topics', 'nameInfo', 'This is message info log','Class','Method');       
        Test.stopTest(); 

        List<Log__c> logs = new List<Log__c>();
        logs = [Select id from Log__c];
    	System.assertEquals(1, logs.size());
    }
     // log Debug
    @IsTest static void testlogDebug(){
        Logs.setlevel('Debug');

        Test.startTest();
        Logs.logDebug('Topics', 'nameDebug', 'This is message Debug log','Class','Method');       
        Test.stopTest(); 

        List<Log__c> logs = new List<Log__c>();
        logs = [Select id from Log__c];
    	System.assertEquals(1, logs.size());
    }
    // log Trace
    @IsTest static void testlogTrace(){
        Logs.setlevel('Trace');

        Test.startTest();
        Logs.logTrace('Topics', 'name Trace', 'This is message Trace log','Class','Method');       
        Test.stopTest(); 

        List<Log__c> logs = new List<Log__c>();
        logs = [Select id from Log__c];
    	System.assertEquals(1, logs.size());
    }
        // log Error
    @IsTest static void testlogError(){
        TestException e = new TestException('This is message error log');
        

        Test.startTest();
        Logs.logError('Topics', 'nameError', e);       
        Test.stopTest(); 

        List<Log__c> logs = new List<Log__c>();
        logs = [Select id from Log__c];
    	System.assertEquals(1, logs.size());
    }
    
    @IsTest static void testlogHttpResp(){
        TestException e = new TestException('This is message error log');
        

        Test.startTest();
        Logs.logHttpResponse('Topics', 'nameError', new HttpResponse() , 'Class','Method',new HttpRequest());       
        Test.stopTest(); 

        List<Log__c> logs = new List<Log__c>();
        logs = [Select id from Log__c];
    	System.assertEquals(1, logs.size());
    }
   
}