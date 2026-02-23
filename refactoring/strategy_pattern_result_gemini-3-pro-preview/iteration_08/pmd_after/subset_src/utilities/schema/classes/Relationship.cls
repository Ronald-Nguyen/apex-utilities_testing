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

    private interface IdFieldStrategy {
        Boolean matches(String fieldName);
        String getReferenceFieldName(String fieldName);
    }

    private class CustomIdFieldStrategy implements IdFieldStrategy {
        public Boolean matches(String fieldName) {
            return fieldName.toLowerCase().endsWith('__c');
        }

        public String getReferenceFieldName(String fieldName) {
            return fieldName.replaceAll('(?i)__c', '__r');
        }
    }

    private class StandardIdFieldStrategy implements IdFieldStrategy {
        public Boolean matches(String fieldName) {
            return fieldName.toLowerCase().endsWith('id');
        }

        public String getReferenceFieldName(String fieldName) {
            return fieldName.replaceAll('(?i)id', '');
        }
    }

    private static final List<IdFieldStrategy> ID_FIELD_STRATEGIES = new List<IdFieldStrategy>{
        new CustomIdFieldStrategy(),
        new StandardIdFieldStrategy()
    };

    public static Relationship fromIdField(String idFieldName) {
        for (IdFieldStrategy strategy : ID_FIELD_STRATEGIES) {
            if (strategy.matches(idFieldName)) {
                return new Relationship(strategy.getReferenceFieldName(idFieldName), idFieldName);
            }
        }
        throw new InvalidFieldException(INVALID_RELATIONSHIP_FIELD + idFieldName);
    }
}