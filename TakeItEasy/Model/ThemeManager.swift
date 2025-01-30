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
    
    static let lightTheme = Theme(
        primaryColor: .init(named: "CustomPrimary") ?? .black,
        secondaryColor: .init(named: "CustomSecondary") ?? .black,
        backColor: .init(named: "BackColor") ?? .black,
        normalText: .init(named: "NormalText") ?? .black,
        alternateText: .white,
        boldText: .init(named: "BoldText") ?? .black
    )
    
    static private func customColor(r: Int, g: Int, b: Int) -> UIColor {
        return UIColor(cgColor: CGColor(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: 1.0))
    }

}

class SectionLabel: UILabel {}
class TitleLabel: UILabel {}
class ActionButton: UIButton {}
class AlternateButton: UIButton {}
class CustomSwitch: UISwitch {}
class ErrorLabel: UILabel {}
