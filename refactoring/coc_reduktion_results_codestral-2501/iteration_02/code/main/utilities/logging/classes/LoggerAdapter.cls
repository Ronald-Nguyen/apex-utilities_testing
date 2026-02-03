@SuppressWarnings('PMD.ExcessivePublicCount')
public abstract class LoggerAdapter {
    protected String logType;

    public virtual void setType(String type) {
        logType = type;
    }

    public abstract void log(Object logLevel, String message);

    public virtual void log(Object logLevel, String message, Id recordId) {
        message = 'Record Id: ' + recordId + ' message: ' + message;
        log(logLevel, message);
    }

    public abstract Object errorLevel();
    public abstract Object warningLevel();
    public abstract Object infoLevel();
    public abstract Object debugLevel();

    @SuppressWarnings('PMD.EmptyStatementBlock')
    public virtual void close() {

    }

    public class DebugLogAdapter extends LoggerAdapter {
        @SuppressWarnings('PMD.AvoidDebugStatements')
        public override void log(Object logLevel, String message) {
            System.debug((LoggingLevel) logLevel, message);
        }

        public override Object errorLevel() {
            return LoggingLevel.ERROR;
        }

        public override Object warningLevel() {
            return LoggingLevel.WARN;
        }

        public override Object infoLevel() {
            return LoggingLevel.INFO;
        }

        public override Object debugLevel() {
            return LoggingLevel.DEBUG;
        }
    }
}