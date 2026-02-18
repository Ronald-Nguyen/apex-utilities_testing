public class PicklistValueSet {
    private final Map<String, String> apiNameByValues = new Map<String, String>();
    private final Map<String, String> valuesByApiNames = new Map<String, String>();
    private final DescribeFieldResult fieldDefinition;

    public PicklistValueSet(DescribeFieldResult fieldDefinition) {
        if (fieldDefinition == null) {
            throw new IllegalArgumentException('Field definition cannot be null');
        }

        this.fieldDefinition = fieldDefinition;
        for (Schema.PicklistEntry value : fieldDefinition.getPickListValues()) {
            if (value == null) {
                continue;
            }

            String valueLower = value.getValue().toLowerCase();
            String labelLower = value.getLabel().toLowerCase();

            apiNameByValues.put(valueLower, value.getLabel());
            valuesByApiNames.put(labelLower, value.getValue());
        }
    }

    public String getValue(String label) {
        if (String.isBlank(label)) {
            return null;
        }
        return valuesByApiNames.get(label.toLowerCase());
    }

    public String getLabel(String value) {
        if (String.isBlank(value)) {
            return null;
        }
        return apiNameByValues.get(value.toLowerCase());
    }
}