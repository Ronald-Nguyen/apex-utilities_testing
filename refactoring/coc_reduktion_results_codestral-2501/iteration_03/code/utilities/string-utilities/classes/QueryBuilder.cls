public virtual class QueryBuilder {
    private static final String SOQL_QUERY_STRUCTURE = 'SELECT {0} FROM {1}';
    protected final String objectName;
    private final Set<String> fieldsToQuery = new Set<String>();
    protected final SchemaFacade schema = SchemaFacade.getInstance();
    protected final DescribeSObjectResult objectDescribe;

    @SuppressWarnings('PMD.EagerlyLoadedDescribeSObjectResult')
    protected QueryBuilder(String objectName) {
        if (String.isBlank(objectName)) {
            throw new IllegalArgumentException('Object name cannot be blank');
        }

        validateObjectName(objectName);
        this.objectName = objectName;
        objectDescribe = schema.getDescribe(objectName);
    }

    public static QueryBuilder fromObject(String objectName) {
        if (String.isBlank(objectName)) {
            throw new IllegalArgumentException('Object name cannot be blank');
        }
        return new QueryBuilder(objectName);
    }

    private void validateObjectName(String objectName) {
        if (schema.isNotValidSObject(objectName)) {
            throw new QueryException('The object name \'' + objectName + '\' is not valid');
        }
    }

    public QueryBuilder selectField(String field) {
        if (String.isBlank(field)) {
            return this;
        }

        fieldsToQuery.add(field.toLowerCase());
        return this;
    }

    public QueryBuilder selectFields(List<String> fields) {
        if (fields == null || fields.isEmpty()) {
            return this;
        }

        for (String field : fields) {
            selectField(field);
        }
        return this;
    }

    public QueryBuilder selectFieldSet(String fieldSetName) {
        if (String.isBlank(fieldSetName)) {
            return this;
        }

        Map<String, Schema.FieldSet> fieldSets = objectDescribe.FieldSets.getMap();
        if (fieldSets == null || !fieldSets.containsKey(fieldSetName)) {
            return this;
        }

        for (Schema.FieldSetMember member : fieldSets.get(fieldSetName).getFields()) {
            if (member != null && String.isNotBlank(member.getFieldPath())) {
                selectField(member.getFieldPath());
            }
        }
        return this;
    }

    public QueryBuilder selectAllFields() {
        if (objectDescribe == null || objectDescribe.fields == null) {
            return this;
        }

        Map<String, SObjectField> fieldsMap = objectDescribe.fields.getMap();
        if (fieldsMap == null || fieldsMap.isEmpty()) {
            return this;
        }

        for (String field : fieldsMap.keySet()) {
            selectField(field);
        }
        return this;
    }

    public QueryBuilder selectAllAccessibleFields() {
        selectField('FIELDS(ALL)');
        return this;
    }

    public override String toString() {
        validateFields();
        return String.format(
            SOQL_QUERY_STRUCTURE,
            new List<String>{ String.join(new List<String>(fieldsToQuery), ','), objectName }
        );
    }

    private void validateFields() {
        if (fieldsToQuery.isEmpty()) {
            throw new QueryException(
                'No fields have been added into the query so it cannot be executed'
            );
        }
    }

    public class QueryException extends Exception {
    }
}