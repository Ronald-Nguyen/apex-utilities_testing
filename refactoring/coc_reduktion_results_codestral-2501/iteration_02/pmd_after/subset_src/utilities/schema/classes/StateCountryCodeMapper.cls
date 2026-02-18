public with sharing class StateCountryCodeMapper extends Triggerable {
    @SuppressWarnings('PMD.EagerlyLoadedDescribeSObjectResult')
    private final PicklistValueSet stateValueSet = new PicklistValueSet(
        Account.BillingStateCode.getDescribe()
    );
    @SuppressWarnings('PMD.EagerlyLoadedDescribeSObjectResult')
    private final PicklistValueSet countryValueSet = new PicklistValueSet(
        Account.BillingCountryCode.getDescribe()
    );

    public override void register(SObjectTriggerWrapper wrappedSObject) {
        if (wrappedSObject == null || wrappedSObject.getSObject() == null) {
            return;
        }

        Account accountRecord = (Account) wrappedSObject.getSObject();
        if (accountRecord == null) {
            return;
        }

        accountRecord.BillingState = stateValueSet.getLabel(accountRecord.BillingStateCode);
        accountRecord.BillingCountry = countryValueSet.getLabel(accountRecord.BillingCountryCode);
    }
}