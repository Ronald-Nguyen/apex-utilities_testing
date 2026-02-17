public class SecureSObjectWrapper extends SObjectWrapper {
    public SecureSObjectWrapper(SObject sObjectToWrap) {
        super(sObjectToWrap);
    }

    public override Object get(String fieldApiName) {
        DescribeFieldResult field = describe(fieldApiName);
        if (!field.isAccessible()) {
            return null;
        }
        return super.get(fieldApiName);
    }

    public override void put(String fieldApiName, Object fieldValue) {
        DescribeFieldResult field = describe(fieldApiName);
        if (!field.isCreateable() || !field.isUpdateable()) {
            return;
        }
        super.put(fieldApiName, fieldValue);
    }
}