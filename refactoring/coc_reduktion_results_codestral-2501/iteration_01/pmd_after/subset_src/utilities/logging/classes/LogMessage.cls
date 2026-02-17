public class LogMessage {
    private final String message;
    private String stackTraceString;

    public LogMessage(String message) {
        this.message = message;
    }

    public LogMessage(Exception exceptionToLog) {
        if (exceptionToLog == null) {
            throw new IllegalArgumentException('Exception cannot be null');
        }

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
        if (String.isBlank(stackLine)) {
            return false;
        }

        return stackLine.startsWith('Class.Logger.') ||
            stackLine.startsWith('Class.LoggerAdapter.') ||
            stackLine.startsWith('Class.LogMessage.');
    }

    public override String toString() {
        return String.format(
            '{0}\nStack trace:\n{1}',
            new List<String>{ message, getStackTraceString() }
        );
    }
}