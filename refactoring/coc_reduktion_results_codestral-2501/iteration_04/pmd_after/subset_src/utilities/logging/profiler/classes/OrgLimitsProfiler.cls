public without sharing class OrgLimitsProfiler extends Profiler {
    public override void refreshProfiling() {
        Map<String, OrgLimit> orgLimitsMap = OrgLimits.getMap();

        for (String limitName : orgLimitsMap.keySet()) {
            OrgLimit orgLimit = orgLimitsMap.get(limitName);
            addProfilingInfo(limitName, orgLimit.getValue(), orgLimit.getLimit());
        }
    }
}