//
//  EasyImagePicker.swift
//  EasyImagePicker
//
//  Created by hatsunem on 2018/10/21.
//

import UIKit
import AudioToolbox.AudioServices

public protocol EasyImagePickerProtocol: UIGestureRecognizerDelegate {
    func picker(_ picker: EasyImagePicker, didForcePress image: UIImage, frame: CGRect)
    func picker(_ picker: EasyImagePicker, didLongPress image: UIImage, frame: CGRect)
}

public class EasyImagePicker {
    public weak var delegate: EasyImagePickerProtocol?
    let gesture: LongAndForcePressGestureRecognizer
    let dragImageView = UIImageView()
    let popView = UIImageView()
    let popImageView = UIImageView()
    
    public init(object: EasyImagePickerProtocol, view: UIView) {
        dragImageView.isHidden = true
        dragImageView.contentMode = .scaleAspectFit
        // TODO: View構造に依存しないようにリファクタ予定
        view.superview?.addSubview(dragImageView)
        
        popImageView.contentMode = .scaleAspectFit
        popView.addSubview(popImageView)
        
        popView.backgroundColor = .white
        popView.layer.borderWidth = 1.0
        popView.layer.borderColor = (UIColor.lightGray).cgColor
        popView.layer.cornerRadius = 10
        popView.clipsToBounds = true
        popView.isHidden = true
        view.superview?.addSubview(popView)
        
        gesture = LongAndForcePressGestureRecognizer()
        gesture.delegate = object
        gesture.minimumPressDuration = 0.2
        gesture.callback = { touch, gesture in
            switch gesture.state {
            case .possible:
                if let imageView = touch.view as? UIImageView, let image = imageView.image {
                    self.dragImageView.image = image
                    self.dragImageView.frame = imageView.superview?.convert(imageView.frame, to: view.superview) ?? imageView.frame
                }
            case .began:
                guard let imageSize = self.dragImageView.image?.size else { return }
                AudioServicesPlaySystemSound(1519)
                let newSize: CGSize
                if imageSize.height > imageSize.width {
                    newSize = CGSize(width: imageSize.width * (200 / imageSize.height), height: 200)
                } else {
                    newSize = CGSize(width: 200, height: imageSize.height * (200 / imageSize.width))
                }
                
                let touchPoint = touch.location(in: view.superview)
                let point = CGPoint(x: touchPoint.x - newSize.width / 2, y: touchPoint.y - newSize.height)
                
                UIView.animate(withDuration: 0.1, animations: {
                    self.dragImageView.isHidden = false
                    self.dragImageView.frame = CGRect(origin: point, size: newSize)
                })
            case .changed:
                let touchPoint = touch.location(in: view.superview)
                let size = self.dragImageView.frame.size
                let point = CGPoint(x: touchPoint.x - size.width / 2, y: touchPoint.y - size.height)
                self.dragImageView.frame = CGRect(origin: point, size: size)
            case .ended:
                if let image = self.dragImageView.image {
                    let touchPoint = touch.location(in: view.superview)
                    let size = self.dragImageView.frame.size
                    let point = CGPoint(x: touchPoint.x - size.width / 2, y: touchPoint.y - size.height)
                    self.delegate?.picker(self, didLongPress: image, frame: CGRect(origin: point, size: size))
                }
                self.dragImageView.isHidden = true
                self.dragImageView.image = nil
            default:
                break
            }
        }
        gesture.callback2 = { touch, gesture in
            guard let image = self.dragImageView.image else { return }
            AudioServicesPlaySystemSound(1520)
            self.dragImageView.isHidden = true
            self.popView.isHidden = false
            self.popImageView.image = image
            self.popView.frame = self.dragImageView.frame
            self.popImageView.frame = CGRect(origin: .zero, size: self.dragImageView.frame.size)
            UIView.animate(withDuration: 0.1, animations: {
                let size = CGSize(width: 340, height: 400)
                let superFrame = view.superview?.frame ?? .zero
                let origin = CGPoint(x: (superFrame.size.width - size.width) / 2, y: (superFrame.size.height - size.height) / 2)
                let frame = CGRect(origin: origin, size: size)
                self.popView.frame = frame
                self.popImageView.frame = CGRect(origin: .zero, size: frame.size)
            })
        }
        view.addGestureRecognizer(gesture)
    }
}
