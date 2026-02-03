public inherited sharing class TriggerHandler extends Triggerable {
    private final List<Triggerable> triggerActions;

    public TriggerHandler(List<Triggerable> triggerActions) {
        this.triggerActions = triggerActions;
    }

    public override void register(SObjectTriggerWrapper wrappedSObject) {
        for (Triggerable action : triggerActions) {
            action.register(wrappedSObject);
        }
    }

    public override void performAction() {
        for (Triggerable action : triggerActions) {
            action.performAction();
        }
    }
}