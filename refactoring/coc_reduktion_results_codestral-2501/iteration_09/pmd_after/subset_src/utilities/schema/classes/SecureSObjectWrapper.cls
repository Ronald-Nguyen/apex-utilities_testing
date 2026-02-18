public class SecureSObjectWrapper extends SObjectWrapper {
    public SecureSObjectWrapper(SObject sObjectToWrap) {
        super(sObjectToWrap);
    }

    public override Object get(String fieldApiName) {
        if (String.isBlank(fieldApiName)) {
            return null;
        }

        DescribeFieldResult field = describe(fieldApiName);
        if (field.isAccessible()) {
            return super.get(fieldApiName);
        }
        return null;
    }

    public override void put(String fieldApiName, Object fieldValue) {
        if (String.isBlank(fieldApiName) || fieldValue == null) {
            return;
        }

        DescribeFieldResult field = describe(fieldApiName);
        if (field.isCreateable() && field.isUpdateable()) {
            super.put(fieldApiName, fieldValue);
        }
    }
}