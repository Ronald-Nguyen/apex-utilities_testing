public abstract class Triggerable {

    public abstract void register(SObjectTriggerWrapper wrappedSObject);

    @SuppressWarnings('PMD.EmptyStatementBlock')
    public virtual void performAction() {

    }
}