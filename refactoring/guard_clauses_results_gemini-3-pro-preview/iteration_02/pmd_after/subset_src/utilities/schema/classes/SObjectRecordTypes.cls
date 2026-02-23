public inherited sharing class SObjectRecordTypes {
    private final Map<String, Schema.RecordTypeInfo> recordTypesByDeveloperName;
    private final Map<Id, Schema.RecordTypeInfo> recordTypesById;
    private RecordTypeInfo defaultRecordTypeInfo;

    @SuppressWarnings('PMD.EagerlyLoadedDescribeSObjectResult')
    public SObjectRecordTypes(final String objectApiName) {
        final SchemaFacade schema = SchemaFacade.getInstance();
        final DescribeSObjectResult objectDescribe = schema.getDescribe(objectApiName);
        recordTypesByDeveloperName = objectDescribe.getRecordTypeInfosByDeveloperName();
        recordTypesById = objectDescribe.getRecordTypeInfosById();
    }

    
    public Id getDefaultId() {
        if (defaultRecordTypeInfo != null) {
            return defaultRecordTypeInfo.getRecordTypeId();
        }

        for (Schema.RecordTypeInfo info : recordTypesByDeveloperName.values()) {
            if (info.isDefaultRecordTypeMapping()) {
                defaultRecordTypeInfo = info;
                break;
            }
        }
        return defaultRecordTypeInfo.getRecordTypeId();
    }

    
    public Id getRecordTypeId(final String developerName) {
        if (!recordTypesByDeveloperName.containsKey(developerName)) {
            return null;
        }
        return recordTypesByDeveloperName.get(developerName).getRecordTypeId();
    }

    
    public String getRecordTypeDeveloperName(final Id recordTypeId) {
        if (!recordTypesById.containsKey(recordTypeId)) {
            return null;
        }
        return recordTypesById.get(recordTypeId).getDeveloperName();
    }
}