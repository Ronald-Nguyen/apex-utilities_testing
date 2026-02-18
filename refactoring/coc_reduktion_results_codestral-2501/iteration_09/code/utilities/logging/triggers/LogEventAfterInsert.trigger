trigger LogEventAfterInsert on Log_Event__e(after insert) {
    if (Trigger.new == null || Trigger.new.isEmpty()) {
        return;
    }

    TriggerDispatcher.run(new List<Triggerable>{ new LogWriter() });
}