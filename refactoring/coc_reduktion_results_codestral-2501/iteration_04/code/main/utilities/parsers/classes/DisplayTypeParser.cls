public class DisplayTypeParser implements Parsable {
    private static final Map<DisplayType, Parser> PARSERS = new Map<DisplayType, Parser>{
        DisplayType.BOOLEAN => new BooleanParser(),
        DisplayType.DOUBLE => new DecimalParser(),
        DisplayType.CURRENCY => new DecimalParser(),
        DisplayType.PERCENT => new DecimalParser(),
        DisplayType.INTEGER => new DecimalParser(),
        DisplayType.DATE => new DateParser(),
        DisplayType.DATETIME => new DatetimeParser(),
        DisplayType.ID => new IdParser(),
        DisplayType.REFERENCE => new IdParser(),
        null => new StringParser()
    };

    private final Parser parser;

    public DisplayTypeParser(DisplayType type) {
        parser = PARSERS.containsKey(type) ? PARSERS.get(type) : PARSERS.get(null);
    }

    public Object parse(String value) {
        return parser.parse(value);
    }

    private abstract class Parser {
        public Object parse(String value) {
            Object parsedValue;

            if (String.isNotBlank(value)) {
                parsedValue = parseSafe(value);
            }

            return parsedValue;
        }

        protected abstract Object parseSafe(String value);
    }

    private class BooleanParser extends Parser {
        protected override Object parseSafe(String value) {
            return Boolean.valueOf(value);
        }
    }

    private class DecimalParser extends Parser {
        protected override Object parseSafe(String value) {
            return Decimal.valueOf(value);
        }
    }

    private class DateParser extends Parser {
        protected override Object parseSafe(String value) {
            return Date.valueOf(value);
        }
    }

    private class DatetimeParser extends Parser {
        protected override Object parseSafe(String value) {
            return Datetime.valueOf(value);
        }
    }

    private class IdParser extends Parser {
        protected override Object parseSafe(String value) {
            return Id.valueOf(value);
        }
    }

    private class StringParser extends Parser {
        protected override Object parseSafe(String value) {
            return String.valueOf(value);
        }
    }
}