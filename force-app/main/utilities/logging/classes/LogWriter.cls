
public without sharing class LogWriter extends Triggerable {
    private final List<Log__c> logs = new List<Log__c>();

    public override void register(SObjectTriggerWrapper wrappedSObject) {
        Log_Event__e logEvent = (Log_Event__e) wrappedSObject.getSObject();
        logs.add(
            new Log__c(
                Level__c = logEvent.Level__c,
                Messages__c = logEvent.Messages__c,
                Record_Id__c = logEvent.Record_Id__c,
                Type__c = logEvent.Type__c,
                Quiddity__c = logEvent.Quiddity__c,
                Transaction_Id__c = logEvent.Transaction_Id__c
            )
        );
    }

    public override void performAction() {
        insert logs;
        
    }
}
