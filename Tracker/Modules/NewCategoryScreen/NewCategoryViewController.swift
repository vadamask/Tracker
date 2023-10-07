//
//  NewCategoryViewModel.swift
//  Tracker
//
//  Created by Вадим Шишков on 25.09.2023.
//

import UIKit

final class NewCategoryViewController: UIViewController {
    
    private let oldTitle: String?
    private let viewModel = NewCategoryViewModel(model: NewCategoryModel())
    private let createButton = UIButton()
    private let topLabel = UILabel()
    private let textField = UITextField()
    
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
                let alertController = UIAlertController(
                    title: NSLocalizedString(
                        "newCategory.alertController.title",
                        comment: "Title for alert controller"
                    ),
                    message: NSLocalizedString(
                        "newCategory.alertController.message",
                        comment: "Message for alert controller"
                    ),
                    preferredStyle: .alert
                )
                let action = UIAlertAction(
                    title: NSLocalizedString(
                        "newCategory.alertController.action",
                        comment: "Title for action button"
                    ),
                    style: .default
                )
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
        view.backgroundColor = .whiteYP
        
        topLabel.text = oldTitle == nil ?
        NSLocalizedString("newCategory.topLabelForNew", comment: "Title for top label when new category is creating"):
        NSLocalizedString("newCategory.topLabelForEdit", comment: "Title for top label when category is editing")
        topLabel.textColor = .blackYP
        topLabel.font = .systemFont(ofSize: 16, weight: .medium)
        
        createButton.isEnabled = false
        createButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        createButton.setTitle(NSLocalizedString("newCategory.createButton", comment: "Title for create button"), for: .normal)
        createButton.setTitleColor(.whiteYP, for: .normal)
        createButton.backgroundColor = .grayYP
        createButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        createButton.layer.cornerRadius = 16
        
        textField.text = oldTitle
        textField.delegate = self
        textField.placeholder = NSLocalizedString("newCategory.textField.placeholder", comment: "Text in text field placeholder")
        textField.clearButtonMode = .always
        textField.backgroundColor = .backgroundYP
        textField.layer.cornerRadius = 16
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        textField.returnKeyType = .done
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

extension NewCategoryViewController: UITextFieldDelegate {

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        viewModel.textDidChanged("")
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
