public without sharing class OrgLimitsProfiler extends Profiler {
    public override void refreshProfiling() {
        Map<String, OrgLimit> orgLimitsMap = OrgLimits.getMap();
        if (orgLimitsMap == null || orgLimitsMap.isEmpty()) {
            return;
        }

        for (String limitName : orgLimitsMap.keySet()) {
            if (String.isBlank(limitName)) {
                continue;
            }

            OrgLimit orgLimit = orgLimitsMap.get(limitName);
            if (orgLimit == null) {
                continue;
            }

            addProfilingInfo(limitName, orgLimit.getValue(), orgLimit.getLimit());
        }
    }
}