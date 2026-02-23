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
            return new Relationship(
                referenceFieldName,
                referenceFieldName.replaceAll('(?i)__r', '__c')
            );
        }
        
        return new Relationship(referenceFieldName, referenceFieldName + 'Id');
    }

    public static Relationship fromIdField(String idFieldName) {
        if (idFieldName.toLowerCase().endsWith('__c')) {
            return new Relationship(
                idFieldName.replaceAll('(?i)__c', '__r'),
                idFieldName
            );
        }
        if (idFieldName.toLowerCase().endsWith('id')) {
            
            return new Relationship(
                idFieldName.replaceAll('(?i)id', ''),
                idFieldName
            );
        }
        throw new InvalidFieldException(INVALID_RELATIONSHIP_FIELD + idFieldName);
    }
}