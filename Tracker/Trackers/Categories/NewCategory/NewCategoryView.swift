//
//  NewCategoryViewModel.swift
//  Tracker
//
//  Created by Вадим Шишков on 25.09.2023.
//

import UIKit

final class NewCategoryView: UIViewController {
    
    @Observable var categoryTitle: String?
    
    private let viewModel = NewCategoryViewModel(model: NewCategoryModel())
    private let createButton = UIButton(title: "Готово", backgroundColor: .grayYP)
    
    private let topLabel = UILabel(
        text: "Новая категория",
        textColor: .blackYP,
        font: .systemFont(ofSize: 16, weight: .medium)
    )
    
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
    }
    
    @objc private func doneButtonTapped() {
        categoryTitle = textField.text
    }
    
    @objc private func textDidChanged() {
        viewModel.didChange(text: textField.text)
    }
    
    private func setupViews() {
        view.backgroundColor = .whiteYP
        
        createButton.isEnabled = false
        createButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        
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
        viewModel.didChange(text: "")
        return true
    }
}
