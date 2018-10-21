//
//  LongAndForcePressGestureRecognizer.swift
//  EasyImagePicker
//
//  Created by hatsunem on 2018/10/21.
//

import UIKit

class LongAndForcePressGestureRecognizer: UILongPressGestureRecognizer {
    
    var callback: ((UITouch, UIGestureRecognizer) -> Void)?
    var callback2: ((UITouch, UIGestureRecognizer) -> Void)?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        let touch = touches.first!
        if let callback = self.callback {
            callback(touch, self)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        let touch = touches.first!
        if let callback = self.callback {
            callback(touch, self)
        }
        if #available(iOS 9.0, *) {
            if touch.force / touch.maximumPossibleForce > 0.75 {
                if let callback2 = self.callback2 {
                    callback2(touch, self)
                    state = .ended
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        let touch = touches.first!
        if let callback = self.callback {
            callback(touch, self)
        }
    }
    
}

