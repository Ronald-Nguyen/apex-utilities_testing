/**
 * @author Gavin Palmer
 * @date 2020-10-06
 *
 **/
@IsTest(isParallel=true)
private class OrgLimitsProfilingReportRunnerTest {
    // negative tests not currently written for breached warnings or not as this would require some mocking to be written into the
    @IsTest
    private static void testExecute() {
        Set<String> possibleLogLevels = new Set<String>{
            EventBufferLogAdapter.WARNING,
            EventBufferLogAdapter.INFO
        };
        EventBufferLogAdapter.LOGGING_LEVELS.addAll(possibleLogLevels);

        Test.startTest();
        OrgLimitsProfilingReportRunner report = new OrgLimitsProfilingReportRunner();
        report.execute();
        Test.stopTest();

        List<Log__c> logs = [
            SELECT Level__c
            FROM Log__c
            WHERE Type__c = :OrgLimitsProfilingReportRunner.LOG_TYPE
        ];
        System.assertEquals(
            2,
            logs.size(),
            'A single log record should have been created containing the profiling report for the org, and one for the transactional logs'
        );
        System.assert(
            possibleLogLevels.contains(logs[0].Level__c),
            'The log created should either be a warning or info, recieved ' + logs[0].Level__c
        );
    }

    @IsTest
    private static void testJobName() {
        OrgLimitsProfilingReportRunner report = new OrgLimitsProfilingReportRunner();
        System.assertEquals(
            OrgLimitsProfilingReportRunner.JOB_NAME,
            'Profiling Report',
            'Job name should be set correctly'
        );
    }

    @IsTest
    private static void testLogType() {
        EventBufferLogAdapter.LOGGING_LEVELS.add(EventBufferLogAdapter.INFO);
        OrgLimitsProfilingReportRunner report = new OrgLimitsProfilingReportRunner();
        
        Test.startTest();
        report.execute();
        Test.stopTest();
        
        List<Log__c> logs = [
            SELECT Type__c
            FROM Log__c
            WHERE Type__c = :OrgLimitsProfilingReportRunner.LOG_TYPE
        ];
        System.assert(
            logs.size() > 0,
            'Logs should be created with correct type'
        );
        for (Log__c log : logs) {
            System.assertEquals(
                OrgLimitsProfilingReportRunner.LOG_TYPE,
                log.Type__c,
                'Log type should match the constant'
            );
        }
    }
}
