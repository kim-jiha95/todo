//
//  ViewController.swift
//  todo
//
//  Created by Jihaha kim on 2023/10/10.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var todoItems = [String]()
    var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        style()
        layout()
        
        navigationController?.navigationBar.isHidden = false

    }

    //MARK: - Style & Layouts
    private func setup() {
        // 테이블 뷰 설정
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
    }

    private func style() {
        // [view]
        view.backgroundColor = .systemBackground

        // "추가" 버튼 생성 및 설정
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTodoItem))
        navigationItem.rightBarButtonItem = addButton
    }

    private func layout() {
        // 테이블 뷰의 제약 조건 추가
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20), // 수정
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    //MARK: - UITableViewDataSource & UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = todoItems[indexPath.row]
        return cell
    }

    // 할 일 추가 버튼 액션
    @objc func addTodoItem() {
        let alertController = UIAlertController(title: "새로운 할 일", message: "", preferredStyle: .alert)

        alertController.addTextField { textField in
            textField.placeholder = "할 일을 입력하세요"
        }

        let addAction = UIAlertAction(title: "추가", style: .default) { [weak self] _ in
            if let textField = alertController.textFields?.first, let text = textField.text, !text.isEmpty {
                self?.todoItems.append(text)
                self?.tableView.reloadData()
            }
        }

        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)

        alertController.addAction(addAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
}



