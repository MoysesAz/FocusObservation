//
//  CGPoint+.swift
//  FocusObservation
//
//  Created by Moyses Miranda do Vale Azevedo on 16/05/23.
//

import Foundation

extension CGPoint {
    public func normalize(size: CGSize) -> CGPoint {
        let x = self.x * size.width
        let y = self.y * size.height

        return CGPoint(x: x, y: y)
    }
}

