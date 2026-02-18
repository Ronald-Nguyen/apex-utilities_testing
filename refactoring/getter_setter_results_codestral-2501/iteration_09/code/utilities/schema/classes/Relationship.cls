public with sharing class Relationship {
    public static final String INVALID_RELATIONSHIP_FIELD = 'The field passed in is not a relationship. Field Value: ';

    private final String referenceFieldName;
    private final String idFieldName;

    private Relationship(String referenceFieldName, String idFieldName) {
        this.referenceFieldName = referenceFieldName;
        this.idFieldName = idFieldName;
    }

    public static Relationship fromRefrenceField(String referenceFieldName) {
        String idFieldName;
        if (referenceFieldName.toLowerCase().endsWith('__r')) {
            idFieldName = referenceFieldName.replaceAll('(?i)__r', '__c');
        } else {
            idFieldName = referenceFieldName + 'Id';
        }
        return new Relationship(referenceFieldName, idFieldName);
    }

    public static Relationship fromIdField(String idFieldName) {
        String referenceFieldName;
        if (idFieldName.toLowerCase().endsWith('__c')) {
            referenceFieldName = idFieldName.replaceAll('(?i)__c', '__r');
        } else if (idFieldName.toLowerCase().endsWith('id')) {
            referenceFieldName = idFieldName.replaceAll('(?i)id', '');
        } else {
            throw new InvalidFieldException(INVALID_RELATIONSHIP_FIELD + idFieldName);
        }
        return new Relationship(referenceFieldName, idFieldName);
    }

    public String getReferenceFieldName() {
        return referenceFieldName;
    }

    public String getIdFieldName() {
        return idFieldName;
    }

    public void setReferenceFieldName(String value) {
        referenceFieldName = value;
    }

    public void setIdFieldName(String value) {
        idFieldName = value;
    }
}