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
                if (info.isDefaultRecordTypeMapping()) {
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
            return recordTypesByDeveloperName.get(developerName).getRecordTypeId();
        }
        return null;
    }

    public String getRecordTypeDeveloperName(final Id recordTypeId) {
        if (recordTypeId == null) {
            return null;
        }

        if (recordTypesById.containsKey(recordTypeId)) {
            return recordTypesById.get(recordTypeId).getDeveloperName();
        }
        return null;
    }
}