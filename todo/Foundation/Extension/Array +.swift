//
//  Array +.swift
//  todo
//
//  Created by Jihaha kim on 2023/10/19.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
