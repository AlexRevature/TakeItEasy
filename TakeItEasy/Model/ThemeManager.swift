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
    
    static var isLightEnabled = true // 56 61 94
    
    static let lightTheme = Theme(
        primaryColor: customColor(r: 92, g: 98, b: 173),
        secondaryColor: customColor(r: 116, g: 120, b: 185),
        backColor: UIColor.white,
        normalText: UIColor.black,
        alternateText: UIColor.white,
        boldText: customColor(r: 56, g: 61, b: 94)
    )
    
    static let darkTheme = Theme(
        primaryColor: customColor(r: 92, g: 98, b: 173),
        secondaryColor: customColor(r: 116, g: 120, b: 185),
        backColor: UIColor.white,
        normalText: UIColor.black,
        alternateText: UIColor.white,
        boldText: customColor(r: 56, g: 61, b: 94)
    )
    
    static private func customColor(r: Int, g: Int, b: Int) -> UIColor {
        return UIColor(cgColor: CGColor(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: 1.0))
    }

}

class SectionLabel: UILabel {}
class TitleLabel: UILabel {}
class ActionButton: UIButton {}
class CustomSwitch: UISwitch {}
class ErrorLabel: UILabel {}
