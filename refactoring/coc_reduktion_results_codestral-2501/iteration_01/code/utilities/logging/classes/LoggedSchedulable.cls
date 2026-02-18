public abstract inherited sharing class LoggedSchedulable implements Schedulable {
    private static final String DAILY_CRON_EXPRESSION = '0 0 0 ? * * *';
    public static final String DEFAULT_JOB_NAME = 'Schedule Job';

    protected SchedulableContext context;
    protected final Logger log = LoggerFactory.createLogger(LoggedSchedulable.class);
    private String jobName = DEFAULT_JOB_NAME;

    public void execute(SchedulableContext context) {
        if (context == null) {
            return;
        }

        this.context = context;
        try {
            execute();
        } catch (Exception exceptionToHandle) {
            log.error(exceptionToHandle);
        } finally {
            log.close();
        }
    }

    protected abstract void execute();

    public Id scheduleDaily() {
        return schedule(DAILY_CRON_EXPRESSION);
    }

    public Id schedule(String cronExpression) {
        if (String.isBlank(cronExpression)) {
            throw new IllegalArgumentException('Cron expression cannot be blank');
        }
        return System.schedule(getJobName(), cronExpression, this);
    }

    public void setJobName(String jobName) {
        if (String.isBlank(jobName)) {
            throw new IllegalArgumentException('Job name cannot be blank');
        }
        this.jobName = jobName;
    }

    protected String getJobName() {
        return jobName;
    }
}