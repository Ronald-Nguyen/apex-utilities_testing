public with sharing class LoggerFactory {
    public static Logger createLogger(Type apexClass) {
        if (apexClass == null) {
            throw new IllegalArgumentException('Apex class cannot be null');
        }
        return new Logger(apexClass, EventBufferLogAdapter.getInstance());
    }
}