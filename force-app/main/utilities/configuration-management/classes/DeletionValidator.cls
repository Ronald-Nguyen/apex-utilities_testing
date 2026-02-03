
public without sharing class DeletionValidator extends Triggerable {
    @testVisible
    private static final String NOT_ALLOWED_DELETE = 'You do not have the correct permissions to delete this record. Please contact your system administrator';

    public override void register(SObjectTriggerWrapper wrappedSObject) {
        if (ConfigurationManager.getInstance().isNotAllowedDelete()) {
            wrappedSObject.getSObject().addError(NOT_ALLOWED_DELETE);
        }
    }
}
