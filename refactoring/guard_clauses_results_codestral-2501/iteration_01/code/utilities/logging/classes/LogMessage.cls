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

        // Guard Clause: Remove logging framework classes from stack trace
        while (isLoggingFrameworkClass(stack[0])) {
            stack.remove(0);

            // Guard Clause: Exit if stack is empty
            if (stack.isEmpty()) {
                return '';
            }
        }

        // Happy Path: Join remaining stack trace lines
        return String.join(stack, '\n');
    }

    private Boolean isLoggingFrameworkClass(String stackLine) {
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