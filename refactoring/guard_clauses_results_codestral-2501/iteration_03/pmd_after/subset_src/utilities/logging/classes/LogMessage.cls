public class LogMessage {
    private final String message;
    private String stackTraceString;

    public LogMessage(String message) {
        this.message = message;
    }

    public LogMessage(Exception exceptionToLog) {
        this.message = exceptionToLog.getMessage();
        this.stackTraceString = exceptionToLog.getStackTraceString();
    }

    public String getStackTraceString() {
        if (String.isBlank(stackTraceString)) {
            stackTraceString = generateStackTraceString();
        }
        return stackTraceString;
    }

    private String generateStackTraceString() {
        List<String> stack = (new DmlException()).getStackTraceString().split('\n');
        while (isLoggingFrameworkClass(stack[0])) {
            stack.remove(0);
        }
        return String.join(stack, '\n');
    }

    private Boolean isLoggingFrameworkClass(String stackLine) {
        if (stackLine == null) {
            return false;
        }

        if (stackLine.startsWith('Class.Logger.')) {
            return true;
        }

        if (stackLine.startsWith('Class.LoggerAdapter.')) {
            return true;
        }

        if (stackLine.startsWith('Class.LogMessage.')) {
            return true;
        }

        return false;
    }

    public override String toString() {
        return String.format(
            '{0}\nStack trace:\n{1}',
            new List<String>{ message, getStackTraceString() }
        );
    }
}