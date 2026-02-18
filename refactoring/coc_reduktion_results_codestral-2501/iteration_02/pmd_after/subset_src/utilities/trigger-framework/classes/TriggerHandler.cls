public inherited sharing class TriggerHandler extends Triggerable {
    private final List<Triggerable> triggerActions;

    public TriggerHandler(List<Triggerable> triggerActions) {
        if (triggerActions == null || triggerActions.isEmpty()) {
            throw new IllegalArgumentException('Trigger actions list cannot be null or empty');
        }

        this.triggerActions = triggerActions;
    }

    public override void register(SObjectTriggerWrapper wrappedSObject) {
        if (wrappedSObject == null) {
            return;
        }

        for (Triggerable action : triggerActions) {
            if (action != null) {
                action.register(wrappedSObject);
            }
        }
    }

    public override void performAction() {
        for (Triggerable action : triggerActions) {
            if (action != null) {
                action.performAction();
            }
        }
    }
}