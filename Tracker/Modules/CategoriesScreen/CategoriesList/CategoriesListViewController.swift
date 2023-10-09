//
//  TrackerCategoryView.swift
//  Tracker
//
//  Created by Вадим Шишков on 24.09.2023.
//

import SnapKit
import UIKit

final class CategoriesListViewController: UIViewController {
    
    var completion: ((String?) -> Void)?
    
    private var viewModel: CategoriesListViewModel
    
    private let placeholder = UIImageView(image: UIImage(named: "empty list"))
    private let addButton = UIButton(type: .system)
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let topLabel = UILabel()
    private let placeholderLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLayout()
        bind()
        checkEmptyState()
    }
    
    init(viewModel: CategoriesListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {

        viewModel.$categories.bind { [weak self] categories in
            self?.tableView.reloadData()
            self?.checkEmptyState()
        }
        
        viewModel.$selectedCategory.bind { [weak self] category in
            self?.completion?(category)
        }
    }
    
    private func checkEmptyState() {
        if viewModel.categoriesIsEmpty {
            placeholder.isHidden = false
            placeholderLabel.isHidden = false
        } else {
            placeholder.isHidden = true
            placeholderLabel.isHidden = true
        }
    }
    
    @objc private func addButtonTapped() {
        let vc = NewCategoryViewController()
        present(vc, animated: true)
    }
    
    private func setupViews() {
        view.backgroundColor = .whiteYP
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.identifier)
        tableView.separatorInset = .init(top: 0, left: 20, bottom: 0, right: 20)
        tableView.rowHeight = 75
        tableView.backgroundColor = .whiteYP
        tableView.allowsMultipleSelection = false
        tableView.layer.cornerRadius = 16
        
        placeholderLabel.text = L10n.Localizable.CategoriesScreen.EmptyState.title
        placeholderLabel.numberOfLines = 2
        placeholderLabel.textAlignment = .center
        placeholderLabel.textColor = .blackYP
        placeholderLabel.font = .systemFont(ofSize: 12, weight: .medium)
        
        topLabel.text = L10n.Localizable.CategoriesScreen.TopLabel.title
        topLabel.textColor = .blackYP
        topLabel.font = .systemFont(ofSize: 16, weight: .medium)
        
        addButton.setTitle(L10n.Localizable.CategoriesScreen.Button.addTitle, for: .normal)
        addButton.setTitleColor(.whiteYP, for: .normal)
        addButton.backgroundColor = .blackYP
        addButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        addButton.layer.cornerRadius = 16
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    private func setupLayout() {
        view.addSubview(topLabel)
        view.addSubview(tableView)
        view.addSubview(placeholderLabel)
        view.addSubview(addButton)
        
        tableView.addSubview(placeholder)
        
        topLabel.snp.makeConstraints { make in
            make.top.equalTo(27)
            make.centerX.equalToSuperview()
        }
        
        placeholder.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        placeholderLabel.snp.makeConstraints { make in
            make.top.equalTo(placeholder.snp.bottom).offset(8)
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
        }
        
        addButton.snp.makeConstraints { make in
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(60)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(topLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(addButton.snp.top).offset(-20)
        }
    }
}

// MARK: - UITableViewDelegate

extension CategoriesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRow(at: indexPath)
    }
    
    func tableView(
        _ tableView: UITableView,
        contextMenuConfigurationForRowAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            
            let editAction = UIAction(
                title: L10n.Localizable.CategoriesScreen.editCategoryTitle
            ) { [weak self] _ in
                let title = self?.viewModel.viewModel(at: indexPath)?.title ?? ""
                let vc = NewCategoryViewController(oldTitle: title)
                self?.present(vc, animated: true)
            }
            
            let deleteAction = UIAction(
                title: L10n.Localizable.CategoriesScreen.deleteCategoryTitle,
                attributes: .destructive
            ) { [weak self] _ in
                
                let alertController = UIAlertController(
                    title: nil,
                    message: L10n.Localizable.CategoriesScreen.AlertController.message,
                    preferredStyle: .actionSheet
                )
                
                let deleteAction = UIAlertAction(
                    title: L10n.Localizable.CategoriesScreen.AlertController.delete,
                    style: .destructive
                ) { [weak self] _ in
                    self?.viewModel.deleteCategory(at: indexPath)
                    self?.completion?("")
                }
                
                let cancelAction = UIAlertAction(
                    title: L10n.Localizable.CategoriesScreen.AlertController.cancel,
                    style: .cancel
                )
                
                alertController.addAction(deleteAction)
                alertController.addAction(cancelAction)
                self?.present(alertController, animated: true)
            }
            let menu = UIMenu(title: "", children: [editAction, deleteAction])
            return menu
        }
        return config
    }
}

// MARK: - UITableViewDataSource

extension CategoriesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CategoryCell else {
            return UITableViewCell()
        }
        cell.viewModel = viewModel.viewModel(at: indexPath)
        return cell
    }
}
