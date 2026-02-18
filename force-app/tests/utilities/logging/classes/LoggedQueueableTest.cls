/**
 * @author Gavin Palmer
 * @date 2019-02-06
 *
 **/
@IsTest(isParallel=true)
private class LoggedQueueableTest {
    private static final String LOG_MESSAGE = 'My test message';

    private class TestLog extends LoggedQueueable {
        protected override void execute() {
            log.error(LOG_MESSAGE);
        }
    }

    @IsTest
    private static void runTestLogWritten() {
        LoggedQueueable testQueueable = new TestLog();
        Test.startTest();
        testQueueable.enqueue();
        Test.stopTest();
        List<Log__c> logs = [SELECT Messages__c FROM Log__c];
        System.assertEquals(
            1,
            logs.size(),
            'A message should have been written when the queueable is ran'
        );
        Assert.contains(logs[0].Messages__c, LOG_MESSAGE);
    }

    private class TestExceptionQueueable extends LoggedQueueable {
        protected override void execute() {
            throw new IllegalArgumentException('Test exception');
        }
    }

    @IsTest
    private static void runTestExceptionHandling() {
        LoggedQueueable testQueueable = new TestExceptionQueueable();
        Test.startTest();
        testQueueable.enqueue();
        Test.stopTest();
        List<Log__c> logs = [SELECT Messages__c, Level__c FROM Log__c];
        System.assertEquals(
            1,
            logs.size(),
            'An error log should have been written when exception is thrown'
        );
        System.assert(
            logs[0].Messages__c.contains('Test exception'),
            'Log should contain the exception message'
        );
    }

    @IsTest
    private static void enqueueReturnsId() {
        LoggedQueueable testQueueable = new TestLog();
        Test.startTest();
        Id jobId = testQueueable.enqueue();
        Test.stopTest();
        System.assertNotEquals(
            null,
            jobId,
            'Enqueue should return a valid job ID'
        );
    }
}
