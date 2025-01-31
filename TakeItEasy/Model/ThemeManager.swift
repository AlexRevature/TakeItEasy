//
//  AppearanceManager.swift
//  TakeItEasy
//
//  Created by Alex Cabrera on 1/13/25.
//

import UIKit

class ThemeManager {
    static let primaryColor: UIColor = .init(named: "CustomPrimary") ?? .black
    static let secondaryColor: UIColor = .init(named: "CustomSecondary") ?? .black
    static let backColor: UIColor = .init(named: "BackColor") ?? .black
    static let normalText: UIColor = .init(named: "NormalText") ?? .black
    static let alternateText: UIColor = .white
    static let boldText: UIColor = .init(named: "BoldText") ?? .black

    // Currently unused, but meant to transform single byte RGB values into cgColors
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
