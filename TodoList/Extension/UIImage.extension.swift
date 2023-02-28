//
//  UIImage.extension.swift
//  TodoList
//
//  Created by Gabriel Campos on 27/2/23.
//

import UIKit

extension UIButton {
    func setImageWithColor(iconName: String, color: UIColor) {
        if let image = UIImage(systemName: iconName) {
            let tintedImage = image.withTintColor(color, renderingMode: .alwaysOriginal)
            self.setImage(tintedImage, for: .normal)
        }
    }
}
