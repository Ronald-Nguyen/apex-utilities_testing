public virtual inherited sharing class StringBuilder {
    @testVisible
    private final List<String> buffer;
    @testVisible
    private String separator = '';
    private Integer count = 0;

    @SuppressWarnings('PMD.EmptyStatementBlock')
    public StringBuilder() {
        buffer = new List<String>();
    }

    public StringBuilder(Object value) {
        this();
        append(value);
    }

    public StringBuilder append(String value) {
        if (value != null) {
            buffer.add(value);
            count += value.length();
        }

        return this;
    }

    public StringBuilder append(Object value) {
        String stringValue = String.valueOf(value);
        return append(stringValue);
    }

    public StringBuilder append(StringBuilder stringBuilder) {
        if (stringBuilder == null) {
            return append('null');
        }

        count += stringBuilder.count;
        buffer.addAll(stringBuilder.buffer);

        return this;
    }

    public void setSeparator(String separator) {
        if (String.isNotEmpty(separator)) {
            this.separator = separator;
        }
    }

    public Integer capacity() {
        return buffer.size();
    }

    public Integer length() {
        return count + (separator.length() * (capacity() - 1));
    }

    public override String toString() {
        return String.join(buffer, separator);
    }
}