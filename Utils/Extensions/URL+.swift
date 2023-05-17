//
//  URL+.swift
//  Utils
//
//  Created by Moyses Miranda do Vale Azevedo on 17/05/23.
//

import Foundation

extension URL {
    var isDirectory: Bool {
       (try? resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true
    }
}



