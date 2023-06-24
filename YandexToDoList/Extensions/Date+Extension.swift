//
//  Date+Extension.swift
//  YandexToDoList
//
//  Created by Герман Кунин on 24.06.2023.
//

import Foundation

private let dateFormatter: DateFormatter = {
     let dateFormatter = DateFormatter()
     dateFormatter.locale = Locale(identifier: "Ru_ru")
     dateFormatter.dateFormat = "dd MMMM yyyy"
     return dateFormatter
 }()

extension Date {
    var toString: String { dateFormatter.string(from: self) }
}
