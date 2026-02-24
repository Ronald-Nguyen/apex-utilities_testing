/**
 * @author Gavin Palmer
 * @date 2019-03-11
 *
 **/
@IsTest(isParallel=true)
private class QueueableSchedulerTest {
    private class TestQueueable extends LoggedQueueable {
        private final Logger log = new Logger(
            QueueableSchedulerTest.class,
            new LoggerAdapter.DebugLogAdapter()
        );
        public override void execute() {
            log.debug('Do nothing');
        }
    }

    @IsTest
    private static void executeTest() {
        Test.startTest();
        QueueableScheduler scheduler = new QueueableScheduler(new TestQueueable());
        scheduler.execute();
        Id queableId = scheduler.getRunningQueueableId();
        System.assertNotEquals(
            null,
            queableId,
            'The id should have been assigned when the queable is scheduled in the queueable'
        );
        Test.stopTest();
    }

    @IsTest
    private static void executeMultipleTimes() {
        Test.startTest();
        QueueableScheduler scheduler = new QueueableScheduler(new TestQueueable());
        scheduler.execute();
        Id firstId = scheduler.getRunningQueueableId();
        System.assertNotEquals(
            null,
            firstId,
            'The first queueable ID should be assigned'
        );
        Test.stopTest();
    }

    @IsTest
    private static void getQueueableIdBeforeExecute() {
        QueueableScheduler scheduler = new QueueableScheduler(new TestQueueable());
        Id queueableId = scheduler.getRunningQueueableId();
        System.assertEquals(
            null,
            queueableId,
            'The queueable ID should be null before execute is called'
        );
    }
}
