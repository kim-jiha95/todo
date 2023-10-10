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
    var inputTextField: UITextField!
    var isAddingItem = false // 추가 중인지 여부를 나타내는 변수

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

        // 입력 창 설정
        inputTextField = UITextField()
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        inputTextField.placeholder = "할 일을 입력하세요"
        inputTextField.returnKeyType = .done
        inputTextField.delegate = self
        view.addSubview(inputTextField)
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
            inputTextField.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            inputTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            inputTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: inputTextField.topAnchor, constant: -20) // 입력 행 위에 위치
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

    // 수정 기능
    func editTodoItem(at indexPath: IndexPath) {
        let alertController = UIAlertController(title: "할 일 수정", message: nil, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.text = self.todoItems[indexPath.row]
        }
        alertController.addAction(UIAlertAction(title: "확인", style: .default) { [weak self] (_) in
            if let text = alertController.textFields?.first?.text, !text.isEmpty {
                self?.todoItems[indexPath.row] = text
                self?.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        })
        alertController.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

    // 삭제 기능
    func deleteTodoItem(at indexPath: IndexPath) {
        todoItems.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }

    // 스와이프하여 수정 및 삭제 기능 추가
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .default, title: "수정") { [weak self] (_, indexPath) in
            self?.editTodoItem(at: indexPath)
        }
        let deleteAction = UITableViewRowAction(style: .destructive, title: "삭제") { [weak self] (_, indexPath) in
            self?.deleteTodoItem(at: indexPath)
        }

        return [deleteAction, editAction]
    }

    // 입력 창에서 리턴 키를 누를 때 호출되는 메서드
    @objc func addTodoItem() {
        if isAddingItem {
            // 이미 추가 중이라면 입력을 완료하고 배열에 추가
            if let text = inputTextField.text, !text.isEmpty {
                todoItems.append(text)
                inputTextField.text = ""
                tableView.reloadData()
            }
            isAddingItem = false
            inputTextField.resignFirstResponder() // 입력 행 포커스 해제
        } else {
            // 추가 중이 아니라면 입력 행을 보여줌
            isAddingItem = true
            inputTextField.becomeFirstResponder() // 입력 행 포커스 설정
        }
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addTodoItem()
        return true
    }
}



