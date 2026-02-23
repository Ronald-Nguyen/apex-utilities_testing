public with sharing class Relationship {
    public static final String INVALID_RELATIONSHIP_FIELD = 'The field passed in is not a relationship. Field Value: ';

    public final String referenceFieldName;
    public final String idFieldName;

    private Relationship(String referenceFieldName, String idFieldName) {
        this.referenceFieldName = referenceFieldName;
        this.idFieldName = idFieldName;
    }

    public static Relationship fromRefrenceField(String referenceFieldName) {
        String idFieldName = resolveIdFieldName(referenceFieldName);
        return new Relationship(referenceFieldName, idFieldName);
    }

    private static String resolveIdFieldName(String referenceFieldName) {
        if (referenceFieldName.toLowerCase().endsWith('__r')) {
            return referenceFieldName.replaceAll('(?i)__r', '__c');
        }
        return referenceFieldName + 'Id';
    }

    public static Relationship fromIdField(String idFieldName) {
        String referenceFieldName = resolveReferenceFieldName(idFieldName);
        return new Relationship(referenceFieldName, idFieldName);
    }

    private static String resolveReferenceFieldName(String idFieldName) {
        String lowerIdField = idFieldName.toLowerCase();
        if (lowerIdField.endsWith('__c')) {
            return idFieldName.replaceAll('(?i)__c', '__r');
        }
        if (lowerIdField.endsWith('id')) {
            return idFieldName.replaceAll('(?i)id', '');
        }
        throw new InvalidFieldException(INVALID_RELATIONSHIP_FIELD + idFieldName);
    }
}