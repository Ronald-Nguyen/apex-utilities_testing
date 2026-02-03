
trigger LogEventAfterInsert on Log_Event__e(after insert) {
    TriggerDispatcher.run(new List<Triggerable>{ new LogWriter() });
}
