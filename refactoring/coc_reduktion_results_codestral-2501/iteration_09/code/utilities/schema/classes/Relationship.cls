public with sharing class Relationship {
    public static final String INVALID_RELATIONSHIP_FIELD = 'The field passed in is not a relationship. Field Value: ';

    public final String referenceFieldName;
    public final String idFieldName;

    private Relationship(String referenceFieldName, String idFieldName) {
        if (String.isBlank(referenceFieldName) || String.isBlank(idFieldName)) {
            throw new IllegalArgumentException('Reference field name and ID field name cannot be blank');
        }

        this.referenceFieldName = referenceFieldName;
        this.idFieldName = idFieldName;
    }

    public static Relationship fromRefrenceField(String referenceFieldName) {
        if (String.isBlank(referenceFieldName)) {
            throw new IllegalArgumentException('Reference field name cannot be blank');
        }

        String idFieldName;
        if (referenceFieldName.toLowerCase().endsWith('__r')) {
            idFieldName = referenceFieldName.replaceAll('(?i)__r', '__c');
        } else {
            idFieldName = referenceFieldName + 'Id';
        }
        return new Relationship(referenceFieldName, idFieldName);
    }

    public static Relationship fromIdField(String idFieldName) {
        if (String.isBlank(idFieldName)) {
            throw new IllegalArgumentException('ID field name cannot be blank');
        }

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
}