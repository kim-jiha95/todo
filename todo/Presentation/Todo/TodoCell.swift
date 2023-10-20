//
//  TodoCell.swift
//  todo
//
//  Created by Jihaha kim on 2023/10/11.
//

import UIKit

/// swift custom cell programmatically
final class TodoCell: UITableViewCell {
    
    static let cellId = "CellId"
    let title = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder: NSCoder) {
        fatalError("Error")
    }
    
    func layout() {
        self.addSubview(title)
    }
    // 우리만의 셀을 커스텀해서 쓴다.
}
