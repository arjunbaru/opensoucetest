//
//  UIView+Extension.swift
//  ResizableController
//
//  Created by Arjun Baru on 22/10/20.
//  Copyright © 2020 Paytm Money 🚀. All rights reserved.
//

import UIKit

extension UIView {

    public func roundedCorners(withRadius radius: CGFloat) {
        layer.cornerRadius = radius
    }

    public func edgesToSuperView(insets: UIEdgeInsets = .zero) {

        guard let superView = superview else { return }
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: superView.topAnchor, constant: insets.top),
            self.bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: insets.bottom),
            self.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: insets.left),
            self.trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: insets.right)
        ])
    }
}

public struct ResizableConstants {
    public static let maximumTopOffset = UIScreen.main.bounds.height * 0.08
    public static let animationDuration: TimeInterval = 0.3
}
