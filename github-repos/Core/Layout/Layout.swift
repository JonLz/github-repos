//
//  Layout.swift
//  github-repos
//
//  Created by Jon on 9/10/19.
//  Copyright © 2019 Jon Lazar. All rights reserved.
//

import UIKit

// MARK: - Layout schema

enum Layout {
    enum Color {}
    enum Component {
        enum Button {}
        enum Label {}
        enum TextField {}
    }
    enum Constant {
        enum Screen {}
    }
}

// MARK: - Buttons

extension Layout.Component.Button {
    static func makePrimaryButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        
        let primaryColor = Layout.Color.green
        button.setBackgroundImage(UIImage(color: primaryColor), for: .normal)
        button.setBackgroundImage(UIImage(color: primaryColor.withAlphaComponent(0.9)), for: .highlighted)
        
        return button
    }
}

// MARK: - TextField Components

extension Layout.Component.TextField {
    static func makeUsernameEntry() -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.placeholder = "Username or email address"
        styleBorderRounded(textField)
        return textField
    }
    
    static func makePasswordEntry() -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.isSecureTextEntry = true
        textField.placeholder = "Password"
        styleBorderRounded(textField)
        return textField
    }
    
    static let styleBorderRounded: (UITextField) -> Void = {
        $0.layer.borderColor = UIColor.black.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 2
    }
}

// MARK: - Label Components

extension Layout.Component.Label {
    static func makeSubtitle() -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .black
        return label
    }
    
    static func makeTitle() -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        return label
    }
    
    static func makeBoldTitle() -> UILabel {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .black
        return label
    }
    
    static func makeBoldStatistic() -> UILabel {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textAlignment = .center
        label.textColor = .blue
        return label
    }
}
        
// MARK: - Color

extension Layout.Color {
    static let green = rgbColor(45, 175, 75)
    static let grey = rgbColor(250, 250, 250)
    
    /// Returns a color given integer literals that correspond to RGB percentages
    /// Values should be between 0 - 255
    private static func rgbColor(_ r: Int, _ g: Int, _ b: Int) -> UIColor {
        return UIColor(red: CGFloat(r)/255.0,
                       green: CGFloat(g)/255.0,
                       blue: CGFloat(b)/255.0,
                       alpha: 1)
    }
}

extension Layout.Constant.Screen {
    
    /// Margins representing default padding for elements from edges of the screen
    static let edgeMargins: UIEdgeInsets = UIEdgeInsets(top: 20,
                                                        left: 20,
                                                        bottom: 20,
                                                        right: 20)
    
    static var horizontalMargins: CGFloat {
        return edgeMargins.left
    }
    
    static var verticalMargins: CGFloat {
        return edgeMargins.top
    }
}
