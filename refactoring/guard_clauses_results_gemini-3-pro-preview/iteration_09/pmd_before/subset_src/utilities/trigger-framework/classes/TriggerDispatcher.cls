
public with sharing class TriggerDispatcher {
    private static final Stack TRIGGER_STACK = new Stack();
    private static Boolean unknownExceptionLogged = false;
    private static final Set<String> DISABLED_TRIGGERS = new Set<String>();

    private final Triggerable handler;
    private final List<SObject> newSObjects;
    private final Map<Id, SObject> oldMap;
    private final String currentTriggerAction;
    private final Logger log = LoggerFactory.createLogger(TriggerDispatcher.class);

    @SuppressWarnings('PMD.ExcessiveParameterList')
    @TestVisible
    private TriggerDispatcher(
        List<Triggerable> actions,
        List<SObject> newSObjects,
        Map<Id, SObject> oldMap,
        TriggerOperation operation
    ) {
        this.handler = new TriggerHandler(actions);
        
        this.newSObjects = newSObjects == null ? oldMap.values() : newSObjects;
        this.oldMap = oldMap;
        this.currentTriggerAction = getTriggerAction(newSObjects.getSObjectType(), operation);
    }

    
    public static void run(List<Triggerable> actions) {
        (new TriggerDispatcher(actions, Trigger.new, Trigger.oldMap, Trigger.operationType)).run();
    }

    public static void disable(SObjectType objectType, TriggerOperation operation) {
        DISABLED_TRIGGERS.add(getTriggerAction(objectType, operation));
    }

    public static void enable(SObjectType objectType, TriggerOperation operation) {
        DISABLED_TRIGGERS.remove(getTriggerAction(objectType, operation));
    }

    private static String getTriggerAction(SObjectType objectType, TriggerOperation operation) {
        return (operation + '-' + objectType).toUpperCase();
    }

    public void run() {
        if (triggersAreActive()) {
            try {
                TRIGGER_STACK.push(currentTriggerAction);
                executeTriggerables();
                TRIGGER_STACK.pop(); 
            } catch (Stack.UnderflowException underflowException) {
                logUnknownException('Stack underflow');
                throw underflowException; 
            } catch (Exception exceptionToHandle) {
                logUnknownException(exceptionToHandle.getMessage());
                TRIGGER_STACK.pop(); 
                throw exceptionToHandle;
            } finally {
                if (TRIGGER_STACK.isEmpty()) {
                    log.close();
                }
            }
        }
    }

    private void executeTriggerables() {
        for (SObject newSObject : newSObjects) {
            
            SObject oldSObject = oldMap != null ? oldMap.get(newSObject.Id) : null;
            SObjectTriggerWrapper wrappedSObject = new SObjectTriggerWrapper(
                newSObject,
                oldSObject
            );
            handler.register(wrappedSObject);
        }
        handler.performAction();
    }

    private Boolean triggersAreActive() {
        return ConfigurationManager.getInstance().areTriggersOn() &&
            !DISABLED_TRIGGERS.contains(currentTriggerAction);
    }

    private void logUnknownException(String exceptionMessage) {
        
        if (!unknownExceptionLogged) {
            log.error(
                'Unhandled exception within trigger: ' +
                exceptionMessage +
                '\n' +
                'Trigger Stack: ' +
                TRIGGER_STACK.toString()
            );
            unknownExceptionLogged = true;
        }
    }
}
