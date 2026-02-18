
public inherited sharing class DatabaseUtils {
    
    public static String errorStringSeperator = '\n';

    
    public static String getErrorString(List<Database.Error> errors) {
        final StringBuilder fullErrors = new StringBuilder();
        fullErrors.setSeparator(errorStringSeperator);
        for (Database.Error error : errors) {
            fullErrors.append(error.getMessage());
        }
        return fullErrors.toString();
    }
}
