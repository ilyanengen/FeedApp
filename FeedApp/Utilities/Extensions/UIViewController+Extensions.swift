//
//  UIViewController+Extensions.swift
//  FeedApp
//
//  Created by Илья Билтуев on 12.03.2022.
//

import UIKit

extension UIViewController {
    func add(_ child: UIViewController) {
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func remove() {
        guard self.parent != nil else { return }
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
}
