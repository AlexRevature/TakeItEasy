//
//  AppearanceManager.swift
//  TakeItEasy
//
//  Created by Alex Cabrera on 1/13/25.
//

import UIKit

struct Theme {
    let primaryColor: UIColor
    let secondaryColor: UIColor
    let backColor: UIColor
    let normalText: UIColor
    let alternateText: UIColor
    let boldText: UIColor
    
}

class ThemeManager {
    
    static var isLightEnabled = true
    
    static let ligthTheme = Theme(
        primaryColor: UIColor(cgColor: CGColor(red: 92, green: 98, blue: 173, alpha: 1.0)),
        secondaryColor: UIColor(cgColor: CGColor(red: 116, green: 120, blue: 185, alpha: 1.0)),
        backColor: UIColor.white,
        normalText: UIColor.black,
        alternateText: UIColor.white,
        boldText: UIColor(cgColor: CGColor(red: 56, green: 61, blue: 94, alpha: 1.0))
    )
    
    static let darkTheme = Theme(
        primaryColor: UIColor(cgColor: CGColor(red: 92, green: 98, blue: 173, alpha: 1.0)),
        secondaryColor: UIColor(cgColor: CGColor(red: 116, green: 120, blue: 185, alpha: 1.0)),
        backColor: UIColor.white,
        normalText: UIColor.black,
        alternateText: UIColor.white,
        boldText: UIColor(cgColor: CGColor(red: 56, green: 61, blue: 94, alpha: 1.0))
    )

}
