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
    private func commonInit() {
            title.translatesAutoresizingMaskIntoConstraints = false
            addSubview(title)

            NSLayoutConstraint.activate([
                title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                title.centerYAnchor.constraint(equalTo: centerYAnchor),
            ])
        }
}
