//
//  Date+Helpers.swift
//  Asana
//
//  Created by Kiran T C on 22/09/25.
//

import Foundation

extension Date {
    var startOfDay: Date { Calendar.current.startOfDay(for: self)}
    
    var isoDateString: String {
        let f = DateFormatter()
        f.calendar = Calendar(identifier: .gregorian)
        f.timeZone = TimeZone(secondsFromGMT: 0)
        f.dateFormat = "yyyy-MM-dd"
        return f.string(from:self.startOfDay)
    }
    
    func isSameDay(as other: Date) -> Bool{
        Calendar.current.isDate(self, inSameDayAs: other)
    }
    
    var yesterdayStartOfDay: Date {
        Calendar.current.date(byAdding: .day, value: -1, to: self.startOfDay)!
    }
    
}
