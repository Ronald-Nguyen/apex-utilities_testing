public abstract inherited sharing class LoggedQueueable implements Queueable {
    protected QueueableContext context;
    protected final Logger log = LoggerFactory.createLogger(LoggedQueueable.class);

    public void execute(QueueableContext context) {
        if (context == null) {
            return;
        }

        this.context = context;
        try {
            execute();
        } catch (Exception exceptionToHandle) {
            if (exceptionToHandle != null) {
                log.error(exceptionToHandle);
            }
        } finally {
            log.close();
        }
    }

    protected abstract void execute();

    public Id enqueue() {
        return System.enqueueJob(this);
    }
}