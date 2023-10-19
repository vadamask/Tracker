//
//  NewCategoryViewModel.swift
//  Tracker
//
//  Created by Вадим Шишков on 25.09.2023.
//

import UIKit

final class NewCategoryViewController: UIViewController {
    
    private let analyticsService = AnalyticsService.shared
    private let oldTitle: String?
    private let viewModel = NewCategoryViewModel(model: NewCategoryModel())
    private let createButton = UIButton(type: .system)
    private let topLabel = UILabel()
    private let textField = UITextField()
    private let colors = Colors.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLayout()
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        analyticsService.sendEvent(params: [
            AnalyticsService.Parameters.event.rawValue: AnalyticsService.Event.open.rawValue,
            AnalyticsService.Parameters.screen.rawValue: AnalyticsService.Screen.new_category.rawValue
        ])
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        analyticsService.sendEvent(params: [
            AnalyticsService.Parameters.event.rawValue: AnalyticsService.Event.closed.rawValue,
            AnalyticsService.Parameters.screen.rawValue: AnalyticsService.Screen.new_category.rawValue
        ])
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
            guard let self = self else { return }
            
            if isAllowed {
                createButton.isEnabled = true
                createButton.backgroundColor = colors.blackDynamicYP
                createButton.setTitleColor(colors.whiteDynamicYP, for: .normal)
            } else {
                createButton.isEnabled = false
                createButton.backgroundColor = colors.grayStaticYP
                createButton.setTitleColor(colors.whiteStaticYP, for: .normal)
            }
        }
        
        viewModel.$isSameCategory.bind { [weak self] isSame in
            guard let isSame = isSame else { return }
            
            if isSame {
                let alertController = UIAlertController(
                    title: L10n.Localizable.NewCategoryScreen.AlertController.title,
                    message: L10n.Localizable.NewCategoryScreen.AlertController.message,
                    preferredStyle: .alert
                )
                let action = UIAlertAction(
                    title: L10n.Localizable.NewCategoryScreen.AlertController.action,
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
        
        analyticsService.sendEvent(params: [
            AnalyticsService.Parameters.event.rawValue: AnalyticsService.Event.click.rawValue,
            AnalyticsService.Parameters.screen.rawValue: AnalyticsService.Screen.new_category.rawValue,
            AnalyticsService.Parameters.item.rawValue: AnalyticsService.Item.done.rawValue
        ])
    }
    
    @objc private func textDidChanged() {
        viewModel.textDidChanged(textField.text)
    }
    
    private func setupViews() {
        view.backgroundColor = colors.whiteDynamicYP
        
        topLabel.text = oldTitle == nil ?
        L10n.Localizable.NewCategoryScreen.topLabelForNew :
        L10n.Localizable.NewCategoryScreen.topLabelForEdit
        topLabel.textColor = colors.blackDynamicYP
        topLabel.font = .systemFont(ofSize: 16, weight: .medium)
        
        createButton.isEnabled = false
        createButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        createButton.setTitle(L10n.Localizable.NewCategoryScreen.doneButtonTitle, for: .normal)
        createButton.setTitleColor(colors.whiteStaticYP, for: .normal)
        createButton.backgroundColor = colors.grayStaticYP
        createButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        createButton.layer.cornerRadius = 16
        
        textField.text = oldTitle
        textField.delegate = self
        textField.placeholder = L10n.Localizable.NewCategoryScreen.TextField.placeholder
        textField.clearButtonMode = .always
        textField.backgroundColor = colors.backgroundDynamicYP
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
        analyticsService.sendEvent(params: [
            AnalyticsService.Parameters.event.rawValue: AnalyticsService.Event.click.rawValue,
            AnalyticsService.Parameters.screen.rawValue: AnalyticsService.Screen.new_category.rawValue,
            AnalyticsService.Parameters.item.rawValue: AnalyticsService.Item.clear_textfield.rawValue
        ])
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        analyticsService.sendEvent(params: [
            AnalyticsService.Parameters.event.rawValue: AnalyticsService.Event.click.rawValue,
            AnalyticsService.Parameters.screen.rawValue: AnalyticsService.Screen.new_category.rawValue,
            AnalyticsService.Parameters.item.rawValue: AnalyticsService.Item.hide_keyboard.rawValue
        ])
        
        return view.endEditing(true)
    }
}
