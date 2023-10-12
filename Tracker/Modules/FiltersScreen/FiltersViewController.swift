//
//  FiltersViewController.swift
//  Tracker
//
//  Created by Вадим Шишков on 09.10.2023.
//

import UIKit

final class FiltersViewController: UIViewController {
    
    var completion: ((Filter) -> Void)?
    
    private let colors = Colors.shared
    private let viewModel = FiltersViewModel()
    private let topLabel = UILabel()
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupLayout()
        bind()
    }
    
    init(filter: Filter?) {
        super.init(nibName: nil, bundle: nil)
        viewModel.setCheckmark(for: filter)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        viewModel.$filters.bind { [weak self] _ in
            self?.tableView.reloadData()
        }
        
        viewModel.$filter.bind { [weak self] filter in
            guard let filter = filter else { return }
            self?.completion?(filter)
            self?.dismiss(animated: true)
        }
    }
    
    private func setupViews() {
        view.backgroundColor = colors.whiteDynamicYP
        
        topLabel.text = L10n.Localizable.FiltersScreen.TopLabel.title
        topLabel.textColor = colors.blackDynamicYP
        topLabel.font = .systemFont(ofSize: 16, weight: .medium)
        
        tableView.rowHeight = 75
        tableView.backgroundColor = colors.whiteDynamicYP
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
    }
    
    private func setupLayout() {
        view.addSubview(topLabel)
        view.addSubview(tableView)
        topLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(27)
            make.centerX.equalToSuperview()
        }
        tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(topLabel.snp.bottom).offset(14)
        }
    }
}

// MARK: - UITableViewDataSource

extension FiltersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.filters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = FilterCell()
        cell.viewModel = viewModel.filters[indexPath.row]
        return cell
    }
}

// MARK: - UITableViewDelegate

extension FiltersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRow(at: indexPath)
    }
}
