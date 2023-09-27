//
//  TrackerCategoryView.swift
//  Tracker
//
//  Created by Вадим Шишков on 24.09.2023.
//

import SnapKit
import UIKit

final class CategoryListView: UIViewController {
    
    var completion: ((String) -> Void)?
    
    private var viewModel = CategoryListViewModel(model: CategoryListModel())
    
    private let placeholder = UIImageView(image: UIImage(named: "empty list"))
    private let addButton = UIButton(title: "Добавить категорию")
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    private let topLabel = UILabel(
        text: "Категория",
        textColor: .blackYP,
        font: .systemFont(ofSize: 16, weight: .medium)
    )
    
    private let placeholderLabel = UILabel(
        text: "Привычки и события можно\nобъединить по смыслу",
        textColor: .blackYP,
        font: .systemFont(ofSize: 12, weight: .medium)
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLayout()
        bind()
    }
    
    private func bind() {

        viewModel.$categories.bind { [weak self] categories in
            self?.tableView.reloadData()
            
            guard let categories = categories else { return }
            
            if categories.isEmpty {
                self?.placeholder.isHidden = false
                self?.placeholderLabel.isHidden = false
            } else {
                self?.placeholder.isHidden = true
                self?.placeholderLabel.isHidden = true
            }
        }
        
        viewModel.getCategories()
    }
    
    @objc private func addButtonTapped() {
        guard let categories = viewModel.categories else { return }
        
        if categories.isEmpty {
            
            let vc = NewCategoryView()
            present(vc, animated: true)
            
        } else {
            
            if let _ = categories.firstIndex(where: {$0.selected}) {
                dismiss(animated: true)
            } else {
                let vc = NewCategoryView()
                present(vc, animated: true)
            }
        }
    }
    
    private func setupViews() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CategoryCellView.self, forCellReuseIdentifier: CategoryCellView.identifier)
        tableView.separatorInset = .init(top: 0, left: 20, bottom: 0, right: 20)
        tableView.rowHeight = 75
        tableView.backgroundColor = .whiteYP
        tableView.allowsMultipleSelection = false
        tableView.layer.cornerRadius = 16
        
        placeholderLabel.numberOfLines = 2
        placeholderLabel.textAlignment = .center
        view.backgroundColor = .whiteYP
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    private func setupLayout() {
        view.addSubview(topLabel)
        view.addSubview(tableView)
        tableView.addSubview(placeholder)
        view.addSubview(placeholderLabel)
        view.addSubview(addButton)
        
        
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

extension CategoryListView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let categories = viewModel.categories,
           let index = categories.firstIndex(where: {$0.selected}) {
            
            if index == indexPath.row {
                viewModel.categories?[indexPath.row].selected.toggle()
                completion?("")
            } else {
                viewModel.categories?.forEach {$0.selected = false}
                viewModel.categories?[indexPath.row].selected.toggle()
                completion?(viewModel.categories?[indexPath.row].title ?? "")
            }
        } else {
            viewModel.categories?[indexPath.row].selected.toggle()
            completion?(viewModel.categories?[indexPath.row].title ?? "")
        }
    }
}

// MARK: - UITableViewDataSource

extension CategoryListView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.categories?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CategoryCellView else {
            return UITableViewCell()
        }
        cell.viewModel = viewModel.categories?[indexPath.row]
        return cell
    }
    
    
}
