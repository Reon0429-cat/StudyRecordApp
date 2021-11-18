//
//  Date+Extension.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/21.
//

import Foundation

extension Date {

    var calendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = .current
        calendar.locale = .current
        return calendar
    }

    func fixed(year: Int? = nil,
               month: Int? = nil,
               day: Int? = nil,
               hour: Int? = nil,
               minute: Int? = nil,
               second: Int? = nil) -> Date {
        var component = DateComponents()
        component.year = year ?? calendar.component(.year, from: self)
        component.month = month ?? calendar.component(.month, from: self)
        component.day = day ?? calendar.component(.day, from: self)
        component.hour = hour ?? calendar.component(.hour, from: self)
        component.minute = minute ?? calendar.component(.minute, from: self)
        component.second = second ?? calendar.component(.second, from: self)
        return calendar.date(from: component) ?? Date()
    }

    init(year: Int? = nil,
         month: Int? = nil,
         day: Int? = nil,
         hour: Int? = nil,
         minute: Int? = nil,
         second: Int? = nil) {
        self.init(
            timeIntervalSince1970: Date().fixed(
                year: year,
                month: month,
                day: day,
                hour: hour,
                minute: minute,
                second: second
            ).timeIntervalSince1970
        )
    }

    var year: Int {
        return calendar.component(.year, from: self)
    }

    var month: Int {
        return calendar.component(.month, from: self)
    }

    var day: Int {
        return calendar.component(.day, from: self)
    }

    var hour: Int {
        return calendar.component(.hour, from: self)
    }

    var minute: Int {
        return calendar.component(.minute, from: self)
    }

    var second: Int {
        return calendar.component(.second, from: self)
    }

}
