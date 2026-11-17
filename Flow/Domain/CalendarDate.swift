/// A concrete date in the proleptic Gregorian calendar, with no time or timezone.
struct CalendarDate: Equatable, Hashable, Sendable {
    let year: Int
    let month: Int
    let day: Int

    init(year: Int, month: Int, day: Int) throws {
        guard year > 0,
              (1...12).contains(month),
              (1...Self.days(in: month, year: year)).contains(day)
        else {
            throw CalendarDateError.invalidComponents
        }

        self.year = year
        self.month = month
        self.day = day
    }

    private static func days(in month: Int, year: Int) -> Int {
        switch month {
        case 2:
            return isLeapYear(year) ? 29 : 28
        case 4, 6, 9, 11:
            return 30
        default:
            return 31
        }
    }

    private static func isLeapYear(_ year: Int) -> Bool {
        year.isMultiple(of: 400) || (year.isMultiple(of: 4) && !year.isMultiple(of: 100))
    }
}

enum CalendarDateError: Error, Equatable {
    case invalidComponents
}
