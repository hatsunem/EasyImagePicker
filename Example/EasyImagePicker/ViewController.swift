//
//  ViewController.swift
//  EasyImagePicker
//
//  Created by hatsunem on 10/21/2018.
//  Copyright (c) 2018 hatsunem. All rights reserved.
//

import UIKit
import EasyImagePicker

class ViewController: UIViewController, EasyImagePickerProtocol {
    let photoView = UIView()
    let imageView1 = UIImageView()
    let imageView2 = UIImageView()
    var dragImageView = UIImageView()
    var popImageView = UIImageView()
    var popView = UIView()
    var cameraLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let height = self.view.frame.height
        let width = self.view.frame.width
        photoView.frame = CGRect(x: 0, y: height - 200, width: width, height: 200)
        photoView.backgroundColor = .white
        view.addSubview(photoView)
        
        cameraLabel.text = "カメラロール"
        cameraLabel.textAlignment = .center
        let color = UIColor(red: 153/255, green: 255/255, blue: 204/255, alpha: 1)
        cameraLabel.backgroundColor = color
        cameraLabel.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 30)
        photoView.addSubview(cameraLabel)
        
        imageView1.image = UIImage(named: "flower1")
        imageView1.clipsToBounds = true
        imageView1.frame = CGRect(x: 0, y: 30, width: 100, height: 100)
        imageView1.contentMode = .scaleAspectFill
        imageView1.isUserInteractionEnabled = true
        photoView.addSubview(imageView1)
        
        imageView2.image = UIImage(named: "flower2")
        imageView2.clipsToBounds = true
        imageView2.frame = CGRect(x: 105, y: 30, width: 100, height: 100)
        imageView2.contentMode = .scaleAspectFill
        imageView2.isUserInteractionEnabled = true
        photoView.addSubview(imageView2)
        
        let picker = EasyImagePicker(object: self, view: photoView)
        picker.delegate = self
        
        //        self.dragImageView.isHidden = true
        //        self.dragImageView.contentMode = .scaleAspectFit
        //        self.view.addSubview(self.dragImageView)
        //
        //        self.popImageView.contentMode = .scaleAspectFit
        //        self.popImageView.frame = CGRect(x: 10, y: 10, width: 300, height: 300)
        //        self.popView.addSubview(popImageView)
        //
        //        self.popView.backgroundColor = .red
        //        self.popView.isHidden = true
        //        self.view.addSubview(popView)
    }
    
    func picker(_ picker: EasyImagePicker, didForcePress image: UIImage, frame: CGRect) {
        print("force")
    }
    
    func picker(_ picker: EasyImagePicker, didLongPress image: UIImage, frame: CGRect) {
        let imageView = UIImageView(image: image)
        imageView.frame = frame
        view.addSubview(imageView)
    }
}

