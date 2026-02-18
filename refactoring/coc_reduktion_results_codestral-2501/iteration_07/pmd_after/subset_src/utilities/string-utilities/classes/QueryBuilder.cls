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
            throw new IllegalArgumentException('Field cannot be blank');
        }
        fieldsToQuery.add(field.toLowerCase());
        return this;
    }

    public QueryBuilder selectFields(List<String> fields) {
        if (fields == null || fields.isEmpty()) {
            throw new IllegalArgumentException('Fields list cannot be null or empty');
        }

        for (String field : fields) {
            if (String.isNotBlank(field)) {
                selectField(field);
            }
        }
        return this;
    }

    public QueryBuilder selectFieldSet(String fieldSetName) {
        if (String.isBlank(fieldSetName)) {
            throw new IllegalArgumentException('Field set name cannot be blank');
        }

        if (objectDescribe.FieldSets == null || objectDescribe.FieldSets.getMap() == null) {
            throw new QueryException('Field sets not available for this object');
        }

        Schema.FieldSet fieldSet = objectDescribe.FieldSets.getMap().get(fieldSetName);
        if (fieldSet == null) {
            throw new QueryException('Field set ' + fieldSetName + ' not found');
        }

        for (Schema.FieldSetMember member : fieldSet.getFields()) {
            if (member != null && String.isNotBlank(member.getFieldPath())) {
                selectField(member.getFieldPath());
            }
        }
        return this;
    }

    public QueryBuilder selectAllFields() {
        if (objectDescribe.fields == null || objectDescribe.fields.getMap() == null) {
            throw new QueryException('Fields not available for this object');
        }

        for (String field : objectDescribe.fields.getMap().keySet()) {
            if (String.isNotBlank(field)) {
                selectField(field);
            }
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