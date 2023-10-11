//
//  ViewController.swift
//  todo
//
//  Created by Jihaha kim on 2023/10/10.
//

import UIKit

/// 테스트코드를 짜려면
/// 1. 어떤 것을 테스트해야할지 명확해야하고
/// 2. 그것을 테스트하기 위해 역할분리, 의존성 주입 등등이 필요하고
/// 3. 객체간의 역할분리
/// 계산기를 했으면 좀 더 짜기 쉬웠을 텐데
/// 지금은 조금 애매해서
/// 기능 구현이 끝나고 나서 짜는것도 괜찮을거 같아요

/// Lint
/// 1. 프로젝트에 넣는 방식
///   -> 바이너리가 커져요 (앱사이즈)
/// 2. mac에 까는 방식
///   -> build script (스크립트가 린트를 실행)
/// 기본적인 린트만 지키다가 입사하시면 그 회사꺼 따라 가시면 될 듯 해요
///
/// 뷰컨트롤러 -> 액션 -> TODO를 담당하는 객체 -> 액션에 맞는 로직을 실행하고 -> 결과를 다시 뷰컨트롤러에 반환한다.

/// 1. final
/// 상속을 하게 하지 않는다.
/// 장점: vtable, dynamic dispatch -> static dispatch로 바꿔서 런타임에 성능을 향상시키는 이점이 있다.
final class TodoViewController: UIViewController {
    /// 2. private은 default
    ///
    /// Todo -> String x `Todo` model을 생성
    /// `Todo`를 추가, 수정, 삭제 할 수 있는 객체를 생성해서, 그 객체가 어떤 역할을 할지
    /// 가위바위보에서 모델, 객체들을 분리
    /// input -> output 기능들을 쪼개서 재사용하고
    private var todoItems: [String] = .init()
    private var isAddingItem: Bool = false // 추가 중인지 여부를 나타내는 변수
    
    /// 3. UI는 class
    /// 4. 변하지 않는 애는 let
    /// 5. 타입 명시 = 컴파일 시간이 줄어든다.
    /// 7. closure == 이름이 없는 함수
    /// 8. lazy == init이 되고 나서 쓰일 일이 있으면 메모리에 올라간다.
    /// 단점: tableview가 variable이 되어서, 휴먼에러로 tableView가 바뀔 수 있어요.
    /// 무조건 메모리에 올라갈 프로퍼티인데 lazy로 선언되어서 코드 시그니처가 조금 안맞다.
    /// 장점: 테이블뷰를 구성하는 코드들이 한 곳에 모여있어서 관리하고 읽기 편하다.
    private lazy var tableView: UITableView = {
        let tableView: UITableView = .init()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    private lazy var inputTextField: UITextField = {
        let textField: UITextField = .init()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "할 일을 입력하세요"
        textField.returnKeyType = .done
        textField.delegate = self
        return textField
    }()
    
    /// 숙제: 뷰컨트롤러의 라이프 사이클 공부하기
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        configureUI()
    }
    
    // MARK: - Style & Layouts
    
    /// 6. 주석: 히스토리를 유추하기 힘들 경우
    /// 비지니스로직이 복잡해서 코드만보고 유추하기 힘들경우
    /// 함수명, 변수명으로 잘 읽혀야 좋은 코드
    ///
    /// 숙제:
    /// 대충 찾아보는게 아니라, HIG이랑 공식문서 위주로 찾아보면 좋을듯 합니다.
    /// safeArea가 무엇인지?
    /// 왜 써야하는지?
    private func configureUI() {
        view.addSubview(tableView)
        view.addSubview(inputTextField)
        
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

    private func style() {
        view.backgroundColor = .systemBackground
        /// 파라미터 3개이상 줄바꿈
        /// 무엇을 할지 -> 어떤 행동이 일어났는지
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonTapped)
        )
        navigationItem.rightBarButtonItem = addButton
        navigationController?.navigationBar.isHidden = false
    }
    
    /// 숙제: 키보드 올렸을 때 보이도록
    @objc func addButtonTapped() {
        if isAddingItem {
            // 이미 추가 중이라면 입력을 완료하고 배열에 추가
            if let text = inputTextField.text, !text.isEmpty {
                todoItems.append(text)
                inputTextField.text = ""
                tableView.reloadData()
            }
            isAddingItem = false
            inputTextField.resignFirstResponder()
        } else {
            // 추가 중이 아니라면 입력 행을 보여줌
            isAddingItem = true
            inputTextField.becomeFirstResponder()
        }
    }
}

extension TodoViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addButtonTapped()
        return true
    }
}

//MARK: - UITableViewDataSource & UITableViewDelegate

extension TodoViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return todoItems.count
    }

    /// identifier = "cell"
    /// cell 몇백가지 cell이 생길 수 있어요
    /// TodoCell
    /// TodoEditCell
    /// TodoEditingCell...
    /// 휴먼에러를 방지할 수 있는 방법 == protocol
    /// 숙제: 프로토콜로 reuseIdentifier 정의
    ///
    /// index
    /// 비어있는 배열에 indexPath.row == 1이 들어올 경우
    /// crash가 납니다.
    /// 안전하게 꺼내올 필요가 있다.
    /// 숙제: safe 하게 index를 접근하는 방법
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = todoItems[indexPath.row]
        return cell
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

    /// 숙제: deprecated api 수정
    /// 숙제: 수정 = 빨간색이죠?
    /// 숙제: 기능 수정 (눌렀을 때 selected되지 않도록, 수정 가능하도록)
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .default, title: "수정") { [weak self] (_, indexPath) in
            self?.editTodoItem(at: indexPath)
        }
        let deleteAction = UITableViewRowAction(style: .destructive, title: "삭제") { [weak self] (_, indexPath) in
            self?.deleteTodoItem(at: indexPath)
        }

        return [deleteAction, editAction]
    }
}

