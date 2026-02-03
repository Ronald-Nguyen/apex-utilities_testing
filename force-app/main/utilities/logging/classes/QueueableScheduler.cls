
public inherited sharing class QueueableScheduler extends LoggedSchedulable {
    private final LoggedQueueable queueableToRun;
    private Id runningQueueableId;

    public QueueableScheduler(LoggedQueueable queueableToRun) {
        this.queueableToRun = queueableToRun;
    }

    public override void execute() {
        runningQueueableId = queueableToRun.enqueue();
    }

    public Id getRunningQueueableId() {
        return runningQueueableId;
    }
}
