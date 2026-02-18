public with sharing class Relationship {
    public static final String INVALID_RELATIONSHIP_FIELD = 'The field passed in is not a relationship. Field Value: ';

    public final String referenceFieldName;
    public final String idFieldName;

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
        RelationshipStrategy strategy;

        if (idFieldName.toLowerCase().endsWith('__c')) {
            strategy = new CustomFieldStrategy();
        } else if (idFieldName.toLowerCase().endsWith('id')) {
            strategy = new IdFieldStrategy();
        } else {
            throw new InvalidFieldException(INVALID_RELATIONSHIP_FIELD + idFieldName);
        }

        return strategy.createRelationship(idFieldName);
    }

    private interface RelationshipStrategy {
        Relationship createRelationship(String idFieldName);
    }

    private class CustomFieldStrategy implements RelationshipStrategy {
        public Relationship createRelationship(String idFieldName) {
            String referenceFieldName = idFieldName.replaceAll('(?i)__c', '__r');
            return new Relationship(referenceFieldName, idFieldName);
        }
    }

    private class IdFieldStrategy implements RelationshipStrategy {
        public Relationship createRelationship(String idFieldName) {
            String referenceFieldName = idFieldName.replaceAll('(?i)id', '');
            return new Relationship(referenceFieldName, idFieldName);
        }
    }
}