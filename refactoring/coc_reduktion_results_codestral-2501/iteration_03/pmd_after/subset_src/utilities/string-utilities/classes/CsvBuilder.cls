public class CsvBuilder {
    public static final String WINDOWS_LINE_ENDING = '\r\n';
    public static final String UNIX_LINE_ENDING = '\n';

    @testVisible
    private final Map<String, Map<Integer, String>> headerToValues = new Map<String, Map<Integer, String>>();
    private Integer currentRow = 0;
    private final String lineEnding;

    public CsvBuilder(String lineEnding) {
        if (String.isBlank(lineEnding)) {
            throw new IllegalArgumentException('Line ending cannot be blank');
        }
        this.lineEnding = lineEnding;
    }

    public CsvBuilder() {
        this(UNIX_LINE_ENDING);
    }

    public CsvBuilder appendField(String headerName, String fieldValue) {
        if (String.isBlank(headerName)) {
            headerName = 'null';
        }

        if (String.isBlank(fieldValue)) {
            fieldValue = 'null';
        }

        Map<Integer, String> column = headerToValues.containsKey(headerName)
            ? headerToValues.get(headerName)
            : new Map<Integer, String>();
        column.put(currentRow, fieldValue);
        headerToValues.put(headerName, column);
        return this;
    }

    public CsvBuilder newRow() {
        currentRow++;
        return this;
    }

    public Integer totalRows() {
        if (headerToValues == null || headerToValues.isEmpty()) {
            return 0;
        }

        Integer maxRow = 0;
        for (Map<Integer, String> values : headerToValues.values()) {
            if (values != null && !values.isEmpty()) {
                Integer currentMax = Collections.max(values.keySet());
                if (currentMax > maxRow) {
                    maxRow = currentMax;
                }
            }
        }
        return maxRow + 1;
    }

    public override String toString() {
        if (headerToValues == null || headerToValues.isEmpty()) {
            return '';
        }

        ColumnBuilder csvDocument = new ColumnBuilder(lineEnding);
        RowBuilder headerRow = new RowBuilder();
        RowBuilder[] rows = new List<RowBuilder>(totalRows());

        for (String headerName : headerToValues.keySet()) {
            if (String.isBlank(headerName)) {
                continue;
            }

            headerRow.append(headerName);
            Map<Integer, String> values = headerToValues.get(headerName);

            if (values == null) {
                continue;
            }

            for (Integer rowIterator = 0; rowIterator <= currentRow; rowIterator++) {
                String value = values.containsKey(rowIterator) ? values.get(rowIterator) : '';

                RowBuilder row = rows[rowIterator];
                if (row == null) {
                    row = new RowBuilder();
                }

                row.append(value);
                rows[rowIterator] = row;
            }
        }

        csvDocument.append(headerRow);
        for (RowBuilder row : rows) {
            if (row != null) {
                csvDocument.append(row);
            }
        }

        return csvDocument.toString();
    }

    private class RowBuilder extends StringBuilder {
        public RowBuilder() {
            setSeparator(',');
        }
    }

    private class ColumnBuilder extends StringBuilder {
        private Integer numberOfColumns;

        public ColumnBuilder(String lineEnding) {
            if (String.isBlank(lineEnding)) {
                throw new IllegalArgumentException('Line ending cannot be blank');
            }
            setSeparator(lineEnding);
        }

        public ColumnBuilder append(RowBuilder rowToAdd) {
            if (rowToAdd == null) {
                return this;
            }

            Boolean isAddedRowValid =
                numberOfColumns == null ||
                rowToAdd.capacity() == numberOfColumns;

            if (!isAddedRowValid) {
                throw new InvalidRowException(
                    'The number of columns provided does not match those already in the csv'
                );
            }

            numberOfColumns = rowToAdd.capacity();
            append(rowToAdd.toString());
            return this;
        }
    }

    public class InvalidRowException extends Exception {
    }
}