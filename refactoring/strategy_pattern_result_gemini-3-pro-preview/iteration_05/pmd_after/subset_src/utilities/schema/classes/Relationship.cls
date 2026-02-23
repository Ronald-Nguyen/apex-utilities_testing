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

    private interface RelationshipStrategy {
        Boolean isApplicable(String idFieldName);
        String getReferenceFieldName(String idFieldName);
    }

    private class CustomRelationshipStrategy implements RelationshipStrategy {
        public Boolean isApplicable(String idFieldName) {
            return idFieldName.toLowerCase().endsWith('__c');
        }

        public String getReferenceFieldName(String idFieldName) {
            return idFieldName.replaceAll('(?i)__c', '__r');
        }
    }

    private class StandardRelationshipStrategy implements RelationshipStrategy {
        public Boolean isApplicable(String idFieldName) {
            return idFieldName.toLowerCase().endsWith('id');
        }

        public String getReferenceFieldName(String idFieldName) {
            return idFieldName.replaceAll('(?i)id', '');
        }
    }

    private static final List<RelationshipStrategy> STRATEGIES = new List<RelationshipStrategy>{
        new CustomRelationshipStrategy(),
        new StandardRelationshipStrategy()
    };

    public static Relationship fromIdField(String idFieldName) {
        for (RelationshipStrategy strategy : STRATEGIES) {
            if (strategy.isApplicable(idFieldName)) {
                return new Relationship(strategy.getReferenceFieldName(idFieldName), idFieldName);
            }
        }
        throw new InvalidFieldException(INVALID_RELATIONSHIP_FIELD + idFieldName);
    }
}