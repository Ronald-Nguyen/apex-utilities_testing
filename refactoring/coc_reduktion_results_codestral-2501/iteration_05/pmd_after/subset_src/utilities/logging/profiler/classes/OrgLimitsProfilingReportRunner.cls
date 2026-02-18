public without sharing class OrgLimitsProfilingReportRunner extends LoggedSchedulable {
    public static final String JOB_NAME = 'Profiling Report';
    public static final String LOG_TYPE = 'Org Limits Profiling Report';

    private final Profiler profiler = new OrgLimitsProfiler();

    public OrgLimitsProfilingReportRunner() {
        setJobName(JOB_NAME);
    }

    public override void execute() {
        log.setType(LOG_TYPE);
        if (profiler.isBreachingWarning()) {
            log.warn(profiler.generateProfilingReport());
        } else {
            log.info(profiler.generateProfilingReport());
        }
        log.close();
    }
}