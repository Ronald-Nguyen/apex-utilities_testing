/**
 * @author Gavin Palmer
 * @date 2019-04-20
 *
 **/
@IsTest(isParallel=true)
private class LogWriterTest {
    @IsTest
    private static void testAction() {
        Log_Event__e logEvent = new Log_Event__e(
            Level__c = 'Error',
            Messages__c = 'test2',
            Record_Id__c = 'test3',
            Type__c = 'test4'
        );

        Triggerable triggerAction = new LogWriter();
        triggerAction.register(new SObjectTriggerWrapper(logEvent, logEvent));
        triggerAction.performAction();
        List<Log__c> createdLogs = [
            SELECT Level__c, Messages__c, Record_Id__c, Type__c
            FROM Log__c
        ];

        System.assertEquals(
            1,
            createdLogs.size(),
            'A single log should have been created during the conversion process'
        );
        System.assertEquals(
            logEvent.Level__c,
            createdLogs[0].Level__c,
            'The level field has not been converted correctly'
        );
        System.assertEquals(
            logEvent.Messages__c,
            createdLogs[0].Messages__c,
            'The messages field has not been converted correctly'
        );
        System.assertEquals(
            logEvent.Record_Id__c,
            createdLogs[0].Record_Id__c,
            'The record id field has not been converted correctly'
        );
        System.assertEquals(
            logEvent.Type__c,
            createdLogs[0].Type__c,
            'The type field has not been converted correctly'
        );
    }

    @IsTest
    private static void testMultipleLogs() {
        List<Log_Event__e> logEvents = new List<Log_Event__e>{
            new Log_Event__e(Level__c = 'Error', Messages__c = 'Error message', Type__c = 'Type1'),
            new Log_Event__e(Level__c = 'Warning', Messages__c = 'Warning message', Type__c = 'Type2'),
            new Log_Event__e(Level__c = 'Info', Messages__c = 'Info message', Type__c = 'Type3')
        };

        LogWriter triggerAction = new LogWriter();
        for (Log_Event__e evt : logEvents) {
            triggerAction.register(new SObjectTriggerWrapper(evt, evt));
        }
        triggerAction.performAction();
        
        List<Log__c> createdLogs = [SELECT Id FROM Log__c];
        System.assertEquals(
            3,
            createdLogs.size(),
            'Three logs should have been created'
        );
    }

    @IsTest
    private static void testLogWithQuiddity() {
        Log_Event__e logEvent = new Log_Event__e(
            Level__c = 'Debug',
            Messages__c = 'Debug message',
            Quiddity__c = 'VF'
        );

        LogWriter triggerAction = new LogWriter();
        triggerAction.register(new SObjectTriggerWrapper(logEvent, logEvent));
        triggerAction.performAction();
        
        List<Log__c> createdLogs = [SELECT Quiddity__c FROM Log__c];
        System.assertEquals(
            1,
            createdLogs.size(),
            'A log should have been created'
        );
        System.assertEquals(
            logEvent.Quiddity__c,
            createdLogs[0].Quiddity__c,
            'The Quiddity field should be set correctly'
        );
    }

    @IsTest
    private static void testLogWithTransactionId() {
        Log_Event__e logEvent = new Log_Event__e(
            Level__c = 'Info',
            Messages__c = 'Transaction log',
            Transaction_Id__c = 'TXN123456'
        );

        LogWriter triggerAction = new LogWriter();
        triggerAction.register(new SObjectTriggerWrapper(logEvent, logEvent));
        triggerAction.performAction();
        
        List<Log__c> createdLogs = [SELECT Transaction_Id__c FROM Log__c];
        System.assertEquals(
            1,
            createdLogs.size(),
            'A log should have been created'
        );
        System.assertEquals(
            logEvent.Transaction_Id__c,
            createdLogs[0].Transaction_Id__c,
            'The Transaction_Id field should be set correctly'
        );
    }
}
