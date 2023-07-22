//
//  Date+Extension.swift
//  YandexToDoListSwiftUI
//
//  Created by Герман Кунин on 22.07.2023.
//

import Foundation

private let dateFormatter: DateFormatter = {
     let dateFormatter = DateFormatter()
     dateFormatter.locale = Locale(identifier: "Ru_ru")
     dateFormatter.dateFormat = "dd MMMM yyyy"
     return dateFormatter
}()

private let dateFormatterWithoutYear: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "Ru_ru")
    dateFormatter.dateFormat = "dd MMMM"
    return dateFormatter
}()

extension Date {
    var toString: String { dateFormatter.string(from: self) }
    var toStringWithoutYear: String { dateFormatterWithoutYear.string(from: self) }
}
