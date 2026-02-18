public without sharing class DateUtils {
    private static Datetime now;
    private static Date today;

    public static Datetime getNow() {
        if (now == null) {
            now = Datetime.now();
        }
        return now;
    }

    public static Date getToday() {
        if (today == null) {
            today = Date.today();
        }
        return today;
    }

    @testVisible
    private static void setNow(Datetime newNow) {
        now = newNow;
    }

    @testVisible
    private static void setToday(Date newToday) {
        today = newToday;
    }

    public static Date toEndOfMonth(final Date input) {
        if (input == null) {
            return null;
        }

        final Integer lastDayOfMonth = Date.daysInMonth(input.year(), input.month());
        return Date.newInstance(input.year(), input.month(), lastDayOfMonth);
    }
}