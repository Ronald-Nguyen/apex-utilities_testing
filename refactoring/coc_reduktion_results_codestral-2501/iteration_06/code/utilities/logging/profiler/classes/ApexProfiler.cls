public without sharing class ApexProfiler extends Profiler {
    public override void refreshProfiling() {
        addProfilingInfo('AggregateQueries', Limits.getAggregateQueries(), Limits.getLimitAggregateQueries());
        addProfilingInfo('Callouts', Limits.getCallouts(), Limits.getLimitCallouts());
        addProfilingInfo('CpuTime', Limits.getCpuTime(), Limits.getLimitCpuTime());
        addProfilingInfo('DatabaseTime', Limits.getDatabaseTime(), Limits.getLimitDatabaseTime());
        addProfilingInfo('DmlRows', Limits.getDmlRows(), Limits.getLimitDmlRows());
        addProfilingInfo('DmlStatements', Limits.getDmlStatements(), Limits.getLimitDmlStatements());
        addProfilingInfo('EmailInvocations', Limits.getEmailInvocations(), Limits.getLimitEmailInvocations());
        addProfilingInfo('FindSimilarCalls', Limits.getFindSimilarCalls(), Limits.getLimitFindSimilarCalls());
        addProfilingInfo('FutureCalls', Limits.getFutureCalls(), Limits.getLimitFutureCalls());
        addProfilingInfo('HeapSize', Limits.getHeapSize(), Limits.getLimitHeapSize());
        addProfilingInfo('MobilePushApexCalls', Limits.getMobilePushApexCalls(), Limits.getLimitMobilePushApexCalls());
        addProfilingInfo('Queries', Limits.getQueries(), Limits.getLimitQueries());
        addProfilingInfo('QueryLocatorRows', Limits.getQueryLocatorRows(), Limits.getLimitQueryLocatorRows());
        addProfilingInfo('QueryRows', Limits.getQueryRows(), Limits.getLimitQueryRows());
        addProfilingInfo('QueueableJobs', Limits.getQueueableJobs(), Limits.getLimitQueueableJobs());
        addProfilingInfo('RunAs', Limits.getRunAs(), Limits.getLimitRunAs());
        addProfilingInfo('SavepointRollbacks', Limits.getSavepointRollbacks(), Limits.getLimitSavepointRollbacks());
        addProfilingInfo('Savepoints', Limits.getSavepoints(), Limits.getLimitSavepoints());
        addProfilingInfo('SoslQueries', Limits.getSoslQueries(), Limits.getLimitSoslQueries());
        addProfilingInfo('PublishImmediateDML', Limits.getPublishImmediateDML(), Limits.getLimitPublishImmediateDML());
    }
}