//
//  Cell + Extension.swift
//  todo
//
//  Created by Jihaha kim on 2023/10/19.
//

import UIKit

/// 숙제: 복습
/// 프로토콜이란?
/// 객체들이 준수해야할 특정 형식이나 규약
/// eg. func, var
/// var -> { get set }
/// associatedType
/// ObjectOrientedProgramming -> ProtocomOrientedProgramming
/// struct + procotol -> memory
/// protocol의 extension
protocol ReuseIdentifable {
    static var reusableIdentifier: String { get }
}

extension ReuseIdentifable {
    static var reusableIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReuseIdentifable { }
extension UICollectionViewCell: ReuseIdentifable { }

