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
        Relationship execute(String idFieldName);
    }

    private static class CustomFieldStrategy implements IdFieldStrategy {
        public Relationship execute(String idFieldName) {
            String referenceFieldName = idFieldName.replaceAll('(?i)__c', '__r');
            return new Relationship(referenceFieldName, idFieldName);
        }
    }

    private static class StandardFieldStrategy implements IdFieldStrategy {
        public Relationship execute(String idFieldName) {
            String referenceFieldName = idFieldName.replaceAll('(?i)id', '');
            return new Relationship(referenceFieldName, idFieldName);
        }
    }

    private static class InvalidFieldStrategy implements IdFieldStrategy {
        public Relationship execute(String idFieldName) {
            throw new InvalidFieldException(INVALID_RELATIONSHIP_FIELD + idFieldName);
        }
    }

    private static Map<String, IdFieldStrategy> STRATEGIES = new Map<String, IdFieldStrategy>{
        '__c' => new CustomFieldStrategy(),
        'id'  => new StandardFieldStrategy()
    };

    public static Relationship fromIdField(String idFieldName) {
        String strategyKey = idFieldName.toLowerCase().endsWith('__c') ? '__c' :
                            idFieldName.toLowerCase().endsWith('id') ? 'id' : null;

        if (STRATEGIES.containsKey(strategyKey)) {
            return STRATEGIES.get(strategyKey).execute(idFieldName);
        }
        return new InvalidFieldStrategy().execute(idFieldName);
    }
}