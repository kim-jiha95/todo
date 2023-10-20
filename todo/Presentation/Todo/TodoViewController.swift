import UIKit

final class TodoViewController: UIViewController, UITableViewDelegate {
    private var todoItems: [String] = []
    private var isAddingItem: Bool = false
    
    /// UITableViewCell -> TodoCell
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: UITableViewCell.reusableIdentifier
        )
        return tableView
    }()
    
    private lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "메모 추가"
        textField.returnKeyType = .done
        textField.delegate = self
        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        configureUI()
        setupKeyboardObservers()
    }

    private func configureUI() {
        view.addSubview(tableView)
        view.addSubview(inputTextField)

        let spacing: CGFloat = 0

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: inputTextField.topAnchor, constant: -spacing),
            
            inputTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            inputTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            inputTextField.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        let toolbar = UIToolbar()
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toolbar)
        
        let label = UIBarButtonItem(title: "새로운 미리 알림", style: .plain, target: nil, action: nil)
        label.tintColor = .orange
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        addButton.tintColor = .orange
        addButton.style = .plain
        toolbar.barTintColor = .white
        toolbar.items = [label, addButton]
        
        NSLayoutConstraint.activate([
            toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolbar.bottomAnchor.constraint(equalTo: inputTextField.topAnchor),
        ])
    }

    private func style() {
        view.backgroundColor = .white
    }

    func editTodoItem(at indexPath: IndexPath) {
        let alertController = UIAlertController(
            title: "할 일 수정",
            message: nil,
            preferredStyle: .alert
        )
        alertController.addTextField { (textField) in
            textField.text = self.todoItems[indexPath.row]
        }
        alertController.addAction(
            UIAlertAction(title: "확인", style: .default) { [weak self] _ in
                if let text = alertController.textFields?.first?.text, !text.isEmpty {
                    self?.todoItems[indexPath.row] = text
                    self?.tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }
        )
        alertController.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

    func deleteTodoItem(at indexPath: IndexPath) {
        todoItems.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }

    /// setNeedsLayout -> next run loop , layoutIfNeeded -> in this loop(direct)
    @objc private func adjustForKeyboard(_ notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }

        let bottomSpace = keyboardSize.height - view.safeAreaInsets.bottom

        if notification.name == UIResponder.keyboardWillHideNotification {
            tableView.contentInset = .zero
            tableView.contentOffset = .zero
        } else {
            let inset = UIEdgeInsets(top: 0, left: 0, bottom: bottomSpace, right: 0)
            tableView.contentInset = inset
            tableView.contentOffset = CGPoint(x: 0, y: max(0, tableView.contentSize.height - tableView.frame.size.height + tableView.contentInset.bottom))
        }
        view.layoutIfNeeded()
    }

    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(adjustForKeyboard),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(adjustForKeyboard),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }
    
    @objc private func addButtonTapped() {
        if isAddingItem {
            if let text = inputTextField.text, !text.isEmpty {
                todoItems.append(text)
                inputTextField.text = ""
                tableView.reloadData()
                
                let lastIndexPath = IndexPath(row: todoItems.count - 1, section: 0)
                tableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: true)
            }
        }
        
        isAddingItem.toggle()
        inputTextField.isHidden = !isAddingItem
        
        if isAddingItem {
            inputTextField.becomeFirstResponder()
        } else {
            inputTextField.resignFirstResponder()
        }
    }
}

extension TodoViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addButtonTapped()
        return true
    }
}

extension TodoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems.count
    }

    /// cell이 dequeue, 재사용되는 과정 ->  Cell Identifier --> Dequeue Cell: -> Configure Cell -> Handle Nil Data: Custom Cell Configuration: -> Performance Considerations
    /// 그래서 무엇을 유의해야하는지
    /// reusableIdentifier -> // newer dequeue method guarantees a cell is returned and resized properly, assuming identifier is registered
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: UITableViewCell.reusableIdentifier,
            for: indexPath
        )

        guard
            let todoItem = todoItems[safe: indexPath.row]
        else { return cell }
        cell.textLabel?.text = todoItem

        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "수정") { [weak self] (_, _, completion) in
            self?.editTodoItem(at: indexPath)
            completion(true)
        }
        editAction.backgroundColor = .blue

        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { [weak self] (_, _, completion) in
            self?.deleteTodoItem(at: indexPath)
            completion(true)
        }

        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
}




