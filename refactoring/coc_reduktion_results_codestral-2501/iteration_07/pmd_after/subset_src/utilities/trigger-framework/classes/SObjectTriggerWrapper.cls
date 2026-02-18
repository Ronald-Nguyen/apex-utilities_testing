public inherited sharing class SObjectTriggerWrapper {
    private final SObject newSObject;
    private final SObject oldSObject;

    public SObjectTriggerWrapper(SObject newSObject, SObject oldSObject) {
        if (newSObject == null) {
            throw new IllegalArgumentException('New SObject cannot be null');
        }

        this.newSObject = newSObject;
        this.oldSObject = oldSObject;
    }

    public Boolean hasChanged(String fieldName) {
        if (String.isBlank(fieldName)) {
            return false;
        }

        return oldSObject == null || oldSObject.get(fieldName) != newSObject.get(fieldName);
    }

    public Boolean hasChanged(Schema.SObjectField field) {
        if (field == null) {
            return false;
        }

        return oldSObject == null || oldSObject.get(field) != newSObject.get(field);
    }

    public Boolean hasChangedTo(String fieldName, Object fieldValue) {
        if (String.isBlank(fieldName) || fieldValue == null) {
            return false;
        }

        return hasChanged(fieldName) && newSObject.get(fieldName) == fieldValue;
    }

    public Boolean hasChangedTo(Schema.SObjectField field, Object fieldValue) {
        if (field == null || fieldValue == null) {
            return false;
        }

        return hasChanged(field) && newSObject.get(field) == fieldValue;
    }

    public SObject getSObject() {
        return newSObject;
    }
}