//
//  UIImage+.swift
//  FocusObservation
//
//  Created by Moyses Miranda do Vale Azevedo on 11/05/23.
//

import SwiftUI
extension UIImage {
    func inCGImage() -> CGImage {
        return self as! CGImage
    }
}


extension CGPoint {
    func normalize(size: CGSize) -> CGPoint {
        let x = self.x * size.width
        let y = self.y * size.height
        
        return CGPoint(x: x, y: y)
    }
}


