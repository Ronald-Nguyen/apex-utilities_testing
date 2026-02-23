public class CsvBuilder {
    public static final String WINDOWS_LINE_ENDING = '\r\n';
    public static final String UNIX_LINE_ENDING = '\n';

    @testVisible
    private final Map<String, Map<Integer, String>> headerToValues = new Map<String, Map<Integer, String>>();
    private Integer currentRow = 0;
    private final String lineEnding;

    public CsvBuilder(String lineEnding) {
        this.lineEnding = lineEnding;
    }

    public CsvBuilder() {
        this(UNIX_LINE_ENDING);
    }

    
    public CsvBuilder appendField(String headerName, String fieldValue) {
        headerName = String.isBlank(headerName) ? 'null' : headerName;
        fieldValue = String.isBlank(fieldValue) ? 'null' : fieldValue;
        
        if (!headerToValues.containsKey(headerName)) {
            headerToValues.put(headerName, new Map<Integer, String>());
        }
        headerToValues.get(headerName).put(currentRow, fieldValue);
        
        return this;
    }

    
    public CsvBuilder newRow() {
        currentRow++;
        return this;
    }

    public Integer totalRows() {
        return headerToValues.values() != null ? headerToValues.values().size() : 0;
    }

    public override String toString() {
        ColumnBuilder csvDocument = new ColumnBuilder(lineEnding);
        RowBuilder headerRow = new RowBuilder();
        RowBuilder[] rows = new List<RowBuilder>(totalRows());
        for (String headerName : headerToValues.keySet()) {
            headerRow.append(headerName);
            Map<Integer, String> values = headerToValues.get(headerName);
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
            csvDocument.append(row);
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
            setSeparator(lineEnding);
        }

        public ColumnBuilder append(RowBuilder rowToAdd) {
            if (numberOfColumns != null && rowToAdd.capacity() != numberOfColumns) {
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