//
//  UINavigationController+Extensions.swift
//  RappiCodeChallenge
//
//  Created by Vincent Villalta on 11/8/21.
//

import UIKit
extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
