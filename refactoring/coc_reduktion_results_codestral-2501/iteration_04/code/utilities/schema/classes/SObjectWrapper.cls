public virtual class SObjectWrapper {
    public static final String INVALID_PARENT_MESSAGE = 'The provided field is not a valid relationship field';
    public static final String NON_INITIALISED_RELATIONSHIP = 'The relationship field that is attempting to be accessed has not been initialised.';

    private final SObject wrappedSObject;
    private final String objectApiName;
    private final SchemaFacade schema = SchemaFacade.getInstance();

    public SObjectWrapper(SObject sObjectToWrap) {
        wrappedSObject = sObjectToWrap;
        objectApiName = String.valueOf(sObjectToWrap.getSObjectType());
    }

    public virtual Object get(String fieldApiName) {
        if (isRelatedField(fieldApiName)) {
            return getParentField(wrappedSObject, fieldApiName);
        }

        return wrappedSObject.get(fieldApiName);
    }

    public virtual void put(String fieldApiName, Object fieldValue) {
        wrappedSObject.put(fieldApiName, fieldValue);
    }

    private static Boolean isRelatedField(String fieldApiName) {
        return fieldApiName.contains('.');
    }

    private static Object getParentField(SObject childSObject, String fieldApiName) {
        RelationshipField field = new RelationshipField(fieldApiName);
        SObject parentSObject;

        try {
            parentSObject = childSObject.getSobject(field.relationshipApiName);
        } catch (NullPointerException exceptionToHandle) {
            throw new InvalidFieldException(NON_INITIALISED_RELATIONSHIP);
        }

        if (isRelatedField(field.relatedFieldName)) {
            return getParentField(parentSObject, field.relatedFieldName);
        }

        return parentSObject.get(field.relatedFieldName);
    }

    public DescribeFieldResult describe(String fieldApiName) {
        if (isRelatedField(fieldApiName)) {
            return describeParentField(fieldApiName);
        }

        return describeField(fieldApiName);
    }

    private DescribeFieldResult describeParentField(String fieldApiName) {
        RelationshipField relatedField = new RelationshipField(fieldApiName);
        String parentObjectName = getRelatedObjectName(relatedField.relationshipApiName);

        if (isRelatedField(relatedField.relatedFieldName)) {
            return describeParentField(relatedField.relatedFieldName);
        }

        return schema.getFieldDescribe(parentObjectName, relatedField.relatedFieldName);
    }

    @testVisible
    private String getRelatedObjectName(String relationshipApiName) {
        String relationshipFieldName = Relationship.fromRefrenceField(relationshipApiName)
            .idFieldName;
        DescribeFieldResult relationshipField = schema.getFieldDescribe(
            objectApiName,
            relationshipFieldName
        );

        return relationshipField.getReferenceTo()[0]
            .getDescribe(SObjectDescribeOptions.DEFERRED)
            .getName();
    }

    private DescribeFieldResult describeField(String fieldApiName) {
        return schema.getFieldDescribe(objectApiName, fieldApiName);
    }

    @testVisible
    private class RelationshipField {
        public final String relationshipApiName;
        public final String relatedFieldName;

        public RelationshipField(String fieldApiName) {
            validateParentField(fieldApiName);
            final List<String> parentRelationshipAndField = fieldApiName.split('\\.', 2);
            relationshipApiName = parentRelationshipAndField[0];
            relatedFieldName = parentRelationshipAndField[1];
        }

        private void validateParentField(String fieldApiName) {
            if (!isRelatedField(fieldApiName)) {
                throw new InvalidFieldException(INVALID_PARENT_MESSAGE);
            }
        }
    }
}