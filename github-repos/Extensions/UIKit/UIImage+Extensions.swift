//
//  UIImage+Extensions.swift
//  github-repos
//
//  Created by Jon on 9/10/19.
//  Copyright © 2019 Jon Lazar. All rights reserved.
//

import UIKit

extension UIImage {
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
       let rect = CGRect(origin: .zero, size: size)
       UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
       color.setFill()
       UIRectFill(rect)
       let image = UIGraphicsGetImageFromCurrentImageContext()
       UIGraphicsEndImageContext()

       guard let cgImage = image?.cgImage else { return nil }
       self.init(cgImage: cgImage)
   }
}
