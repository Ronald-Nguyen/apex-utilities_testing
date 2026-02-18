
public with sharing class LoggerFactory {
    public static Logger createLogger(Type apexClass) {
        return new Logger(apexClass, EventBufferLogAdapter.getInstance());
    }
}
