/**
 * @author Gavin Palmer
 * @date 2019-03-13
 *
 **/
@IsTest(isParallel=true)
private class DatabaseUtilsTest {
    @IsTest
    private static void getErrorStringTest() {
        Database.SaveResult insertResult = Database.insert(new Account(), false);

        System.assert(
            DatabaseUtils.getErrorString(insertResult.getErrors()).contains('Required'),
            'The error string should return the missing required fields error'
        );
    }

    @IsTest
    private static void getErrorStringMultipleErrors() {
        List<Account> accounts = new List<Account>{
            new Account(),
            new Account()
        };
        List<Database.SaveResult> results = Database.insert(accounts, false);
        
        for (Database.SaveResult result : results) {
            String errorString = DatabaseUtils.getErrorString(result.getErrors());
            System.assert(
                errorString.contains('Required'),
                'Each error string should contain the required field error'
            );
        }
    }

    @IsTest
    private static void getErrorStringEmptyList() {
        List<Database.Error> emptyErrors = new List<Database.Error>();
        String errorString = DatabaseUtils.getErrorString(emptyErrors);
        
        System.assertEquals(
            '',
            errorString,
            'Empty error list should return empty string'
        );
    }

    @IsTest
    private static void getErrorStringCustomSeparator() {
        String originalSeparator = DatabaseUtils.errorStringSeperator;
        DatabaseUtils.errorStringSeperator = ' | ';
        
        Database.SaveResult insertResult = Database.insert(new Account(), false);
        String errorString = DatabaseUtils.getErrorString(insertResult.getErrors());
        
        DatabaseUtils.errorStringSeperator = originalSeparator;
        
        System.assert(
            errorString.contains('Required'),
            'The error string should contain the error message'
        );
    }

    @IsTest
    private static void getErrorStringSingleError() {
        Contact contact = new Contact(LastName = null);
        Database.SaveResult result = Database.insert(contact, false);
        
        String errorString = DatabaseUtils.getErrorString(result.getErrors());
        
        System.assert(
            !String.isEmpty(errorString),
            'Error string should not be empty for invalid contact'
        );
    }
}
