//
//  Date+.swift
//  BaseRxSwift
//
//  Created by Lương Mạnh on 14/03/2022.
//

import Foundation

enum Format: String {
    /// yyyy-MM-dd'T'HH:mm:ss.SSSZ
    case fullTimeFromServerFirst = "YYYY-MM-dd'T'HH:mm:ss.SSSZ"
    /// "yyyy-MM-dd'T'HH:mm:SSZ"
    case fullTimeFromServerSecond = "YYYY-MM-dd'T'HH:mm:SSZ"
    /// HH:mm dd/MMMM/yyyy
    case hourDayMonthYear = "HH:mm MMMM/dd/yyyy"
    /// HH:mm YYYY/MM/DD
    case hourDayMonthYearHistory = "HH:mm YYYY/MM/dd"
    /// "hh:mm E"
    case hourMinuteAndDay = "HH:mm E"
    /// "hh:mm"
    case hourMinute = "HH:mm"
    /// "MM/dd/yyyy"
    case dayMonthYear = "MM/dd/yyyy"
    /// "yyyy-MM-dd"
    case yearMonthDay = "yyyy-MM-dd"
    /// "YYYY/MM/DD"
    case yearMonthDay2 = "YYYY/MM/dd"
    /// "YYYY/MM/DD"
    case yearMonthDay3 = "yyyy/MM/dd"
    /// "E YYYY-MMM-dd HH:mm"
    case japanseDateTimeFormat = "YYYY年MMMMdd日 (E) HH:mm"
    /// "E YYYY-MMM-dd HH:mm"
    case japanseDateFormat = "YYYY年MMMMdd日"
    /// "YYYY年"
    case year = "YYYY"
    /// "MM"
    case month = "MM"
    /// "dd日"
    case day = "dd"

    var instance: DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: Calendar.Identifier.japanese)
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateStyle = .medium
        formatter.dateFormat = rawValue
        return formatter
    }
}

extension Date {
    func string(format: Format) -> String {
        return format.instance.string(from: self)
    }
    
    func datetimeFormatFromSever(dateString: String, format: Format) -> Date? {
        return format.instance.date(from: dateString)
    }
}

extension String {
    func date(format: Format) -> Date? {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateStyle = .medium
        formatter.dateFormat = format.rawValue
        return formatter.date(from: self)
    }
}
