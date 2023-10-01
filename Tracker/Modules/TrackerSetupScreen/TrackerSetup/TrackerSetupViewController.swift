//
//  TrackerSetupViewController.swift
//  Tracker
//
//  Created by Вадим Шишков on 29.08.2023.
//

import SnapKit
import UIKit

final class TrackerSetupViewController: UIViewController {
    
    private let viewModel = TrackerSetupViewModel(model: TrackerSetupModel())
    private var isTracker: Bool
    private var schedule: Set<WeekDay> = []
    private var selectedCategory: String?
    
    private var topLabel = UILabel(text: "", textColor: .blackYP, font: .systemFont(ofSize: 16, weight: .medium))
    private let scrollView = UIScrollView()
    private let textField = UITextField()
    private let tableView = UITableView()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let createButton = UIButton(title: "Создать", backgroundColor: .grayYP)
    private let cancelButton = UIButton(title: "Отменить", textColor: .redYP, backgroundColor: .clear)
    private let warningLabel = UILabel(text: "Ограничение 38 символов",
                                       textColor: .redYP,
                                       font: .systemFont(ofSize: 17, weight: .regular))
    
    private var tableViewTopLabel: Constraint?
    
    init(isTracker: Bool = true) {
        self.isTracker = isTracker
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLayout()
        bind()
        if !isTracker {
            viewModel.eventIsSelected()
        }
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func createButtonTapped() {
        viewModel.createButtonTapped()
    }
    
    private func bind() {
        viewModel.$textTooLong.bind { [weak self] tooLong in
            if tooLong {
                self?.warningLabel.isHidden = false
                self?.tableViewTopLabel?.update(offset: 62)
            } else {
                self?.warningLabel.isHidden = true
                self?.tableViewTopLabel?.update(offset: 24)
            }
        }
        
        viewModel.$createButtonIsAllowed.bind { [weak self] isAllowed in
            self?.createButton.isEnabled = isAllowed ? true : false
            self?.createButton.backgroundColor = isAllowed ? .blackYP : .grayYP
        }
    }
    
    @objc private func textDidChanged() {
        guard let text = textField.text else { return }
        viewModel.textDidChanged(text)
    }
    
    private func setupViews() {
        view.backgroundColor = .whiteYP
        self.hideKeyboardWhenTappedAround()
        
        topLabel.text = isTracker ? "Новая привычка" : "Новое нерегулярное событие"
        
        textField.delegate = self
        textField.placeholder = "Введите название трекера"
        textField.clearButtonMode = .always
        textField.backgroundColor = .backgroundYP
        textField.layer.cornerRadius = 16
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        textField.returnKeyType = .done
        textField.addTarget(self, action: #selector(textDidChanged), for: .editingChanged)
        
        warningLabel.isHidden = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TrackerSetupTableViewCell.self, forCellReuseIdentifier: TrackerSetupTableViewCell.identifier)
        tableView.separatorInset = .init(top: 0, left: 20, bottom: 0, right: 20)
        tableView.rowHeight = 75
        tableView.backgroundColor = .whiteYP
        tableView.layer.cornerRadius = 16
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TrackerSetupEmojiCell.self, forCellWithReuseIdentifier: TrackerSetupEmojiCell.identifier)
        collectionView.register(TrackerSetupColorCell.self, forCellWithReuseIdentifier: TrackerSetupColorCell.identifier)
        collectionView.register(TrackerSetupSupView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: TrackerSetupSupView.identifier)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 19, bottom: 24, right: 19)
        collectionView.isScrollEnabled = false
        collectionView.allowsMultipleSelection = true
        
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        createButton.isEnabled = false
        
        cancelButton.layer.borderColor = UIColor.redYP.cgColor
        cancelButton.layer.borderWidth = 1
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }
    
    private func setupLayout() {
        view.addSubview(topLabel)
        view.addSubview(scrollView)
        scrollView.addSubview(textField)
        scrollView.addSubview(warningLabel)
        scrollView.addSubview(tableView)
        scrollView.addSubview(collectionView)
        scrollView.addSubview(cancelButton)
        scrollView.addSubview(createButton)
        
        topLabel.snp.makeConstraints { make in
            make.top.equalTo(27)
            make.centerX.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(topLabel.snp.bottom).offset(14)
        }
        
        scrollView.contentLayoutGuide.snp.makeConstraints { make in
            make.width.equalTo(scrollView)
        }
        
        textField.snp.makeConstraints { make in
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.top.equalTo(24)
            make.height.equalTo(75)
        }
        
        warningLabel.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            tableViewTopLabel = make.top.equalTo(textField.snp.bottom).offset(24).constraint
            make.leading.trailing.equalTo(textField)
            make.height.equalTo(isTracker ? 150 : 75)
        }
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(tableView.snp.bottom)
            make.height.equalTo(492)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(16)
            make.leading.equalTo(20)
            make.bottom.equalToSuperview()
            make.height.equalTo(60)
        }
        
        createButton.snp.makeConstraints { make in
            make.centerY.size.equalTo(cancelButton)
            make.leading.equalTo(cancelButton.snp.trailing).offset(8)
            make.trailing.equalTo(-20)
        }
    }
}

// MARK: - UITextFieldDelegate

extension TrackerSetupViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        viewModel.clearTextButtonTapped()
        return true
    }
}

// MARK: - UITableViewDataSource

extension TrackerSetupViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRowsInTableView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TrackerSetupTableViewCell.identifier) as? TrackerSetupTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: indexPath.row, isTracker: isTracker)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension TrackerSetupViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            
            let vc = CategoriesListView(
                viewModel: CategoriesListViewModel(model: CategoriesListModel(), selectedCategory: selectedCategory)
            )
            vc.completion = { [weak self] category in
                self?.selectedCategory = category
                
                if let category = category {
                    self?.viewModel.didSelectCategory(category)
                } else {
                    self?.viewModel.didDeselectCategory()
                }
                
                let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
                cell?.detailTextLabel?.text = category
            }
            present(vc, animated: true)
            
        } else {
            
            let vc = ScheduleView(viewModel: ScheduleViewModel(schedule: schedule))
            
            vc.completion = { [weak self] schedule in
                self?.schedule = schedule
                
                if schedule.isEmpty {
                    self?.viewModel.didDeselectSchedule()
                } else {
                    self?.viewModel.didSelectSchedule(schedule)
                }
                
                let selectedDays = schedule
                    .sorted(by: {$0.rawValue < $1.rawValue})
                    .map { $0.shortName }
                
                let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? TrackerSetupTableViewCell
                cell?.setDetailTextLabel(for: selectedDays)
            }
            present(vc, animated: true)
        }
    }
}

// MARK: - UICollectionViewDataSource

extension TrackerSetupViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.numberOfSectionsInCollectionView
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfRowsInCollectionView
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TrackerSetupEmojiCell.identifier,
                for: indexPath
            ) as? TrackerSetupEmojiCell else { return UICollectionViewCell() }
            
            cell.configure(with: viewModel.emojiForCollectionView(at: indexPath))
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TrackerSetupColorCell.identifier,
                for: indexPath
            ) as? TrackerSetupColorCell  else { return UICollectionViewCell() }
            
            cell.configure(with: indexPath.row)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let view = collectionView
            .dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: TrackerSetupSupView.identifier,
                for: indexPath) as? TrackerSetupSupView else { return UICollectionReusableView() }
        
        view.configure(with: indexPath.section)
        return view
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TrackerSetupViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 52, height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: view.bounds.width, height: 74)
    }
}

// MARK: - UICollectionViewDelegate

extension TrackerSetupViewController {
  
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let indexes = collectionView.indexPathsForSelectedItems {
            indexes.filter { $0.section == indexPath.section && $0 != indexPath }.forEach { i in
                    collectionView.deselectItem(at: i, animated: false)
                (collectionView.cellForItem(at: i) as? TrackerSetupEmojiCell)?.backgroundColor = .clear
                (collectionView.cellForItem(at: i) as? TrackerSetupColorCell)?.itemDidSelect(false)
            }
        }
        if let cell = collectionView.cellForItem(at: indexPath) as? TrackerSetupEmojiCell {
            cell.backgroundColor = .lightGrayYP
            viewModel.didSelectEmoji(at: indexPath)
        }
        if let cell = collectionView.cellForItem(at: indexPath) as? TrackerSetupColorCell {
            cell.itemDidSelect(true)
            viewModel.didSelectColor(at: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? TrackerSetupEmojiCell {
            cell.backgroundColor = .clear
            viewModel.didDeselectEmoji()
        }
        if let cell = collectionView.cellForItem(at: indexPath) as? TrackerSetupColorCell {
            cell.itemDidSelect(false)
            viewModel.didDeselectColor()
        }
    }
}
