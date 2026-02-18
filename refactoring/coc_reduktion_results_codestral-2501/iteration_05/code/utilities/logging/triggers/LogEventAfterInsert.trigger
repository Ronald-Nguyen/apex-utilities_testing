trigger LogEventAfterInsert on Log_Event__e(after insert) {
    if (Trigger.isAfter && Trigger.isInsert) {
        TriggerDispatcher.run(new List<Triggerable>{ new LogWriter() });
    }
}