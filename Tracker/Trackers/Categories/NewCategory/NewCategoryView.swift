//
//  NewCategoryViewModel.swift
//  Tracker
//
//  Created by Вадим Шишков on 25.09.2023.
//

import UIKit

final class NewCategoryView: UIViewController {
    
    private let oldTitle: String?
    private let viewModel = NewCategoryViewModel(model: NewCategoryModel())
    private let createButton = UIButton(title: "Готово", backgroundColor: .grayYP)
    
    private let topLabel = UILabel()
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название категории"
        textField.clearButtonMode = .always
        textField.backgroundColor = .backgroundYP
        textField.layer.cornerRadius = 16
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        textField.returnKeyType = .done
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLayout()
        bind()
    }
    
    init(oldTitle: String? = nil) {
        self.oldTitle = oldTitle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        
        viewModel.$isAllowed.bind { [weak self] isAllowed in
            if isAllowed {
                self?.createButton.isEnabled = true
                self?.createButton.backgroundColor = .blackYP
            } else {
                self?.createButton.isEnabled = false
                self?.createButton.backgroundColor = .grayYP
            }
        }
        
        viewModel.$isSameCategory.bind { [weak self] isSame in
            guard let isSame = isSame else { return }
            
            if isSame {
                let alertController = UIAlertController(title: "Ошибка", message: "Такое название уже есть", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ок", style: .default)
                alertController.addAction(action)
                self?.present(alertController, animated: true)
            } else {
                self?.dismiss(animated: true)
            }
        }
    }
    
    @objc private func doneButtonTapped() {
        guard let newTitle = textField.text else { return }
        viewModel.updateCategory(oldTitle, with: newTitle)
    }
    
    @objc private func textDidChanged() {
        viewModel.textDidChanged(textField.text)
    }
    
    private func setupViews() {
        topLabel.text = oldTitle == nil ? "Новая категория" : "Редактирование категории"
        topLabel.textColor = .blackYP
        topLabel.font = .systemFont(ofSize: 16, weight: .medium)
        
        view.backgroundColor = .whiteYP
        
        createButton.isEnabled = false
        createButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        
        textField.text = oldTitle
        textField.delegate = self
        textField.addTarget(self, action: #selector(textDidChanged), for: .editingChanged)
    }
    
    private func setupLayout() {
        view.addSubview(topLabel)
        view.addSubview(textField)
        view.addSubview(createButton)
        
        topLabel.snp.makeConstraints { make in
            make.top.equalTo(27)
            make.centerX.equalToSuperview()
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(topLabel.snp.bottom).offset(38)
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.height.equalTo(75)
        }
        
        createButton.snp.makeConstraints { make in
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(60)
        }
    }
}

// MARK: - UITextFieldDelegate

extension NewCategoryView: UITextFieldDelegate {

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        viewModel.textDidChanged("")
        return true
    }
}
