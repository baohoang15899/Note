//
//  UIView.swift
//  Note
//
//  Created by Toi Nguyen on 20/05/2022.
//

import Foundation
import UIKit

extension UIView {
    func fadeIn(completion:@escaping ((Bool) -> Void)) {
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
            self.alpha = 0.5
        }, completion: completion)
    }
    
    func fadeOut(completion:@escaping ((Bool) -> Void)) {
        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseIn, animations: {
            self.alpha = 1
        }, completion: completion)
    }

}
