//
//  String+Extension.swift
//  YandexToDoList
//
//  Created by Герман Кунин on 01.07.2023.
//

import UIKit

extension String {
    var strikedText: NSMutableAttributedString {
        let formattedString = NSMutableAttributedString(string: self)
        formattedString.addAttribute(
            NSAttributedString.Key.strikethroughStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: NSRange(location: 0, length: formattedString.length)
        )
        formattedString.addAttribute(
            NSAttributedString.Key.foregroundColor,
            value: UIColor.labelTertiary,
            range: NSRange(location: 0, length: formattedString.length)
        )
        return formattedString
    }

    var attributedString: NSMutableAttributedString {
        return NSMutableAttributedString(string: self)
    }

}
