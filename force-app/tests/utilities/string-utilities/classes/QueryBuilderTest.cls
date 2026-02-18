/**
 * @author Gavin Palmer
 * @date 2019-06-04
 *
 */
@IsTest(isParallel=true)
private class QueryBuilderTest {
    @IsTest
    private static void buildQueryTest() {
        QueryBuilder accountQuery = QueryBuilder.fromObject('Account').selectField('Id');

        System.assertEquals(
            'select id from account',
            accountQuery.toString().toLowerCase(),
            'The query has not been generated correctly'
        );
    }

    @IsTest
    private static void buildQueryMultipleFields() {
        QueryBuilder accountQuery = QueryBuilder.fromObject('Account')
            .selectField('Id')
            .selectField('Name')
            .selectField('Industry');

        String query = accountQuery.toString().toLowerCase();
        System.assert(
            query.contains('id') && query.contains('name') && query.contains('industry'),
            'The query should contain all selected fields'
        );
    }

    @IsTest
    private static void buildQueryWithFieldsList() {
        List<String> fields = new List<String>{'Id', 'Name', 'Type'};
        QueryBuilder accountQuery = QueryBuilder.fromObject('Account').selectFields(fields);

        String query = accountQuery.toString().toLowerCase();
        System.assert(
            query.contains('id') && query.contains('name') && query.contains('type'),
            'The query should contain all fields from the list'
        );
    }

    @IsTest
    private static void buildQueryAllAccessibleFields() {
        QueryBuilder accountQuery = QueryBuilder.fromObject('Account').selectAllAccessibleFields();

        String query = accountQuery.toString();
        System.assert(
            query.contains('FIELDS(ALL)'),
            'The query should include FIELDS(ALL) for all accessible fields'
        );
    }

    @IsTest
    private static void buildQueryInvalidObject() {
        try {
            QueryBuilder.fromObject('InvalidObject123');
            Assert.fail('Should throw QueryException for invalid object');
        } catch (QueryBuilder.QueryException e) {
            System.assert(
                e.getMessage().contains('not valid'),
                'Exception message should indicate invalid object'
            );
        }
    }

    @IsTest
    private static void buildQueryNoFieldsSelected() {
        QueryBuilder accountQuery = QueryBuilder.fromObject('Account');
        
        try {
            accountQuery.toString();
            Assert.fail('Should throw QueryException when no fields selected');
        } catch (QueryBuilder.QueryException e) {
            System.assert(
                e.getMessage().contains('No fields'),
                'Exception should indicate no fields were added'
            );
        }
    }

    @IsTest
    private static void buildQueryDuplicateFields() {
        QueryBuilder accountQuery = QueryBuilder.fromObject('Account')
            .selectField('Id')
            .selectField('Id')
            .selectField('Name');

        String query = accountQuery.toString().toLowerCase();
        System.assert(
            query.contains('id') && query.contains('name'),
            'The query should handle duplicate field selections'
        );
    }

    @IsTest
    private static void buildQueryCaseInsensitiveFields() {
        QueryBuilder accountQuery = QueryBuilder.fromObject('Account')
            .selectField('ID')
            .selectField('NAME');

        String query = accountQuery.toString();
        System.assert(
            query.contains('id') && query.contains('name'),
            'Field names should be case insensitive'
        );
    }
}
