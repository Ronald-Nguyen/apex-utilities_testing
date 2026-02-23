public with sharing class Relationship {
    public static final String INVALID_RELATIONSHIP_FIELD = 'The field passed in is not a relationship. Field Value: ';

    public final String referenceFieldName;
    public final String idFieldName;

    private Relationship(String referenceFieldName, String idFieldName) {
        this.referenceFieldName = referenceFieldName;
        this.idFieldName = idFieldName;
    }

    public static Relationship fromRefrenceField(String referenceFieldName) {
        if (referenceFieldName.toLowerCase().endsWith('__r')) {
            return new Relationship(referenceFieldName, referenceFieldName.replaceAll('(?i)__r', '__c'));
        }
        return new Relationship(referenceFieldName, referenceFieldName + 'Id');
    }

    public static Relationship fromIdField(String idFieldName) {
        String referenceFieldName;
        if (idFieldName.toLowerCase().endsWith('__c')) {
            referenceFieldName = idFieldName.replaceAll('(?i)__c', '__r');
            return new Relationship(referenceFieldName, idFieldName);
        } 
        if (idFieldName.toLowerCase().endsWith('id')) {
            referenceFieldName = idFieldName.replaceAll('(?i)id', '');
            return new Relationship(referenceFieldName, idFieldName);
        }
        throw new InvalidFieldException(INVALID_RELATIONSHIP_FIELD + idFieldName);
    }
}