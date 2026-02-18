public inherited sharing class DatabaseUtils {

    public static String errorStringSeperator = '\n';

    public static String getErrorString(List<Database.Error> errors) {
        if (errors == null || errors.isEmpty()) {
            return '';
        }

        final StringBuilder fullErrors = new StringBuilder();
        fullErrors.setSeparator(errorStringSeperator);

        for (Database.Error error : errors) {
            if (error != null) {
                fullErrors.append(error.getMessage());
            }
        }

        return fullErrors.toString();
    }
}