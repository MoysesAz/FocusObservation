//
//  Rect+.swift
//  FocusObservation
//
//  Created by Moyses Miranda do Vale Azevedo on 16/05/23.
//

import Foundation

extension CGRect {
    public func convertNormalizedRect(imageSize: CGSize) -> CGRect {
        let origin = CGPoint(x: self.origin.x * imageSize.width,
                             y: self.origin.y * imageSize.height)
        let size = CGSize(width: self.size.width * imageSize.width,
                          height: self.size.height * imageSize.height)
        return CGRect(origin: origin, size: size)
    }
}
