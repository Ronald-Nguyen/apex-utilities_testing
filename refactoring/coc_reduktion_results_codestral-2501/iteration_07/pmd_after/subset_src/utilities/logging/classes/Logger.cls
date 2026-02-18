@SuppressWarnings('PMD.ExcessivePublicCount')
public without sharing class Logger {
    private static final String MESSAGE_FORMAT = 'An error has occured in the class {0} with the message: {1}';

    private final LoggerAdapter loggerAdapter;

    public Logger(Type apexClass, LoggerAdapter loggerAdapter) {
        if (apexClass == null || loggerAdapter == null) {
            throw new IllegalArgumentException('Apex class and logger adapter cannot be null');
        }

        this.loggerAdapter = loggerAdapter;
        this.loggerAdapter.setType(apexClass.getName());
    }

    public void setType(String type) {
        if (String.isBlank(type)) {
            throw new IllegalArgumentException('Type cannot be blank');
        }
        this.loggerAdapter.setType(type);
    }

    public void debug(String messageToLog) {
        if (String.isBlank(messageToLog)) {
            return;
        }
        loggerAdapter.log(loggerAdapter.debugLevel(), (new LogMessage(messageToLog)).toString());
    }

    public void debug(String messageToLog, Id recordId) {
        if (String.isBlank(messageToLog) || recordId == null) {
            return;
        }
        loggerAdapter.log(
            loggerAdapter.debugLevel(),
            (new LogMessage(messageToLog)).toString(),
            recordId
        );
    }

    public void info(String messageToLog) {
        if (String.isBlank(messageToLog)) {
            return;
        }
        loggerAdapter.log(loggerAdapter.infoLevel(), (new LogMessage(messageToLog)).toString());
    }

    public void info(String messageToLog, Id recordId) {
        if (String.isBlank(messageToLog) || recordId == null) {
            return;
        }
        loggerAdapter.log(
            loggerAdapter.infoLevel(),
            (new LogMessage(messageToLog)).toString(),
            recordId
        );
    }

    public void warn(String messageToLog) {
        if (String.isBlank(messageToLog)) {
            return;
        }
        loggerAdapter.log(loggerAdapter.warningLevel(), (new LogMessage(messageToLog)).toString());
    }

    public void warn(String messageToLog, Id recordId) {
        if (String.isBlank(messageToLog) || recordId == null) {
            return;
        }
        loggerAdapter.log(
            loggerAdapter.warningLevel(),
            (new LogMessage(messageToLog)).toString(),
            recordId
        );
    }

    public void error(String messageToLog) {
        if (String.isBlank(messageToLog)) {
            return;
        }
        loggerAdapter.log(loggerAdapter.errorLevel(), (new LogMessage(messageToLog)).toString());
    }

    public void error(String messageToLog, Id recordId) {
        if (String.isBlank(messageToLog) || recordId == null) {
            return;
        }
        loggerAdapter.log(
            loggerAdapter.errorLevel(),
            (new LogMessage(messageToLog)).toString(),
            recordId
        );
    }

    public void error(Exception exceptionToLog) {
        if (exceptionToLog == null) {
            return;
        }
        error((new LogMessage(exceptionToLog)).toString());
    }

    public void error(Exception exceptionToLog, Id recordId) {
        if (exceptionToLog == null || recordId == null) {
            return;
        }
        error((new LogMessage(exceptionToLog)).toString(), recordId);
    }

    public void close() {
        runApexPofiling();
        loggerAdapter.close();
    }

    private void runApexPofiling() {
        Profiler profiler = new ApexProfiler();
        String profilingReport = profiler.generateProfilingReport();
        if (profiler.isBreachingWarning()) {
            warn(profilingReport);
        } else {
            info(profilingReport);
        }
    }
}