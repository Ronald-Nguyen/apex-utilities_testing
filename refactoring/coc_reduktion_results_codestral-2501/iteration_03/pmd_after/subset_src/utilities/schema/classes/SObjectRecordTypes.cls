public inherited sharing class SObjectRecordTypes {
    private final Map<String, Schema.RecordTypeInfo> recordTypesByDeveloperName;
    private final Map<Id, Schema.RecordTypeInfo> recordTypesById;
    private RecordTypeInfo defaultRecordTypeInfo;

    @SuppressWarnings('PMD.EagerlyLoadedDescribeSObjectResult')
    public SObjectRecordTypes(final String objectApiName) {
        if (String.isBlank(objectApiName)) {
            throw new IllegalArgumentException('Object API name cannot be blank');
        }

        final SchemaFacade schema = SchemaFacade.getInstance();
        final DescribeSObjectResult objectDescribe = schema.getDescribe(objectApiName);
        recordTypesByDeveloperName = objectDescribe.getRecordTypeInfosByDeveloperName();
        recordTypesById = objectDescribe.getRecordTypeInfosById();
    }

    public Id getDefaultId() {
        if (defaultRecordTypeInfo == null) {
            for (Schema.RecordTypeInfo info : recordTypesByDeveloperName.values()) {
                if (info != null && info.isDefaultRecordTypeMapping()) {
                    defaultRecordTypeInfo = info;
                    break;
                }
            }
        }
        return defaultRecordTypeInfo != null ? defaultRecordTypeInfo.getRecordTypeId() : null;
    }

    public Id getRecordTypeId(final String developerName) {
        if (String.isBlank(developerName)) {
            return null;
        }

        if (recordTypesByDeveloperName.containsKey(developerName)) {
            Schema.RecordTypeInfo info = recordTypesByDeveloperName.get(developerName);
            return info != null ? info.getRecordTypeId() : null;
        }
        return null;
    }

    public String getRecordTypeDeveloperName(final Id recordTypeId) {
        if (recordTypeId == null) {
            return null;
        }

        if (recordTypesById.containsKey(recordTypeId)) {
            Schema.RecordTypeInfo info = recordTypesById.get(recordTypeId);
            return info != null ? info.getDeveloperName() : null;
        }
        return null;
    }
}