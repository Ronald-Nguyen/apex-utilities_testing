public without sharing class SchemaFacade {
    private Map<String, SObjectType> sObjectTypeByObjectNames = Schema.getGlobalDescribe();
    private Map<String, DescribeSObjectResult> sObjectDescribeByObjectNames = new Map<String, DescribeSObjectResult>();
    private Map<String, Map<String, SObjectField>> fieldTypesByNameAndObject = new Map<String, Map<String, SObjectField>>();
    private Map<String, Map<String, DescribeFieldResult>> fieldDescribeByNameAndObject = new Map<String, Map<String, DescribeFieldResult>>();

    private static final SchemaFacade INSTANCE = new SchemaFacade();

    public static SchemaFacade getInstance() {
        return INSTANCE;
    }

    @SuppressWarnings('PMD.EmptyStatementBlock')
    private SchemaFacade() {
    }

    public Boolean isValidSObject(String objectApiName) {
        return sObjectTypeByObjectNames.containsKey(objectApiName);
    }

    public Boolean isNotValidSObject(String objectApiName) {
        return !isValidSObject(objectApiName);
    }

    
    public DescribeSObjectResult getDescribe(String objectApiName) {
        objectApiName = objectApiName.toLowerCase();
        validateObjectApiName(objectApiName);
        if (sObjectDescribeByObjectNames.containsKey(objectApiName)) {
            return sObjectDescribeByObjectNames.get(objectApiName);
        }
        DescribeSObjectResult sObjectDescribe = sObjectTypeByObjectNames.get(objectApiName)
            .getDescribe(SObjectDescribeOptions.FULL);
        sObjectDescribe.fields.getMap();
        sObjectDescribeByObjectNames.put(objectApiName, sObjectDescribe);
        return sObjectDescribe;
    }

    private void validateObjectApiName(String objectApiName) {
        if (isNotValidSObject(objectApiName)) {
            throw new InvalidDescribeException('The field ' + objectApiName + ' does not exist');
        }
    }

    public Boolean isValidField(String objectApiName, String fieldApiName) {
        return isValidSObject(objectApiName) &&
            getFieldsMap(objectApiName).containsKey(fieldApiName);
    }

    public Boolean isNotValidField(String objectApiName, String fieldApiName) {
        return !isValidField(objectApiName, fieldApiName);
    }

    @SuppressWarnings('PMD.EagerlyLoadedDescribeSObjectResult')
    private Map<String, SObjectField> getFieldsMap(String objectApiName) {
        objectApiName = objectApiName.toLowerCase();
        validateObjectApiName(objectApiName);
        if (fieldTypesByNameAndObject.containsKey(objectApiName)) {
            return fieldTypesByNameAndObject.get(objectApiName);
        }
        Map<String, SObjectField> fieldsMap = getDescribe(objectApiName).fields.getMap();
        fieldTypesByNameAndObject.put(objectApiName, fieldsMap);
        return fieldsMap;
    }

    
    @SuppressWarnings('PMD.EagerlyLoadedDescribeSObjectResult')
    public DescribeFieldResult getFieldDescribe(String objectApiName, String fieldApiName) {
        objectApiName = objectApiName.toLowerCase();
        fieldApiName = fieldApiName.toLowerCase();
        validateFieldApiName(objectApiName, fieldApiName);

        Map<String, DescribeFieldResult> fieldDescribeMap = fieldDescribeByNameAndObject.get(objectApiName);
        if (fieldDescribeMap != null && fieldDescribeMap.containsKey(fieldApiName)) {
            return fieldDescribeMap.get(fieldApiName);
        }

        if (fieldDescribeMap == null) {
            fieldDescribeMap = new Map<String, DescribeFieldResult>();
            fieldDescribeByNameAndObject.put(objectApiName, fieldDescribeMap);
        }
        
        DescribeFieldResult describeResult = getFieldsMap(objectApiName).get(fieldApiName).getDescribe();
        fieldDescribeMap.put(fieldApiName, describeResult);
        
        return describeResult;
    }

    private void validateFieldApiName(String objectApiName, String fieldApiName) {
        if (isNotValidField(objectApiName, fieldApiName)) {
            throw new InvalidDescribeException(
                'The field ' +
                fieldApiName +
                ' does not exist on the object ' +
                objectApiName
            );
        }
    }

    public class InvalidDescribeException extends Exception {
    }
}