//
//  TrackerSetupViewController.swift
//  Tracker
//
//  Created by Вадим Шишков on 29.08.2023.
//

import SnapKit
import UIKit

protocol TrackerSetupViewControllerDelegate: AnyObject {
    func dismiss()
}

final class TrackerSetupViewController: UIViewController {
    
    weak var delegate: TrackerSetupViewControllerDelegate?
    
    private let analyticsService = AnalyticsService.shared
    private let colors = Colors.shared
    private let viewModel = TrackerSetupViewModel(model: TrackerSetupModel())
    private var model: (TrackerCategory, Int)?
    private var isTracker: Bool
    private var schedule: Set<WeekDay> = []
    private var selectedCategory: String?
    
    private let topLabel = UILabel()
    private let labelInEditingMode = UILabel()
    private let scrollView = UIScrollView()
    private let textField = UITextField()
    private let tableView = UITableView()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let createButton = UIButton(type: .system)
    private let cancelButton = UIButton(type: .system)
    private let warningLabel = UILabel()
    
    private var tableViewTopLabel: Constraint?
    
    init(isTracker: Bool, model: (TrackerCategory, Int)? = nil) {
        self.isTracker = isTracker
        self.model = model
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
        configureScreen()
        if !isTracker {
            viewModel.eventIsSelected()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isTracker {
            analyticsService.sendEvent(params: [
                AnalyticsService.Parameters.event.rawValue: AnalyticsService.Event.open.rawValue,
                AnalyticsService.Parameters.screen.rawValue: AnalyticsService.Screen.setup_tracker.rawValue
            ])
        } else {
            analyticsService.sendEvent(params: [
                AnalyticsService.Parameters.event.rawValue: AnalyticsService.Event.open.rawValue,
                AnalyticsService.Parameters.screen.rawValue: AnalyticsService.Screen.setup_event.rawValue
            ])
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if isTracker {
            analyticsService.sendEvent(params: [
                AnalyticsService.Parameters.event.rawValue: AnalyticsService.Event.closed.rawValue,
                AnalyticsService.Parameters.screen.rawValue: AnalyticsService.Screen.setup_tracker.rawValue
            ])
        } else {
            analyticsService.sendEvent(params: [
                AnalyticsService.Parameters.event.rawValue: AnalyticsService.Event.closed.rawValue,
                AnalyticsService.Parameters.screen.rawValue: AnalyticsService.Screen.setup_event.rawValue
            ])
        }
    }
    
    private func showAlert(_ error: Error) {
        let alertController = UIAlertController(
            title: L10n.Localizable.StatisticsScreen.AlertController.title,
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(
            title: L10n.Localizable.StatisticsScreen.AlertController.ok,
            style: .cancel
        )
        present(alertController, animated: true)
    }
    
    private func configureScreen() {
        if let model = model {
            textField.text = model.0.trackers[0].name
            viewModel.textDidChanged(model.0.trackers[0].name)
            
            selectedCategory = model.0.title
            viewModel.didSelectCategory(model.0.title)
            
            schedule = model.0.trackers[0].schedule
            viewModel.didSelectSchedule(schedule)
            
            labelInEditingMode.text = L10n.Localizable.numberOfDays(model.1)
            labelInEditingMode.textColor = colors.blackDynamicYP
            labelInEditingMode.font = .systemFont(ofSize: 32, weight: .bold)
            
            viewModel.trackerIsPinned(model.0.trackers[0].isPinned)
        }
    }
    
 
    
    private func bind() {
        viewModel.$textTooLong.bind { [weak self] tooLong in
            guard let self = self else { return }
            
            if tooLong {
                warningLabel.isHidden = false
                tableViewTopLabel?.update(offset: 62)
            } else {
                warningLabel.isHidden = true
                tableViewTopLabel?.update(offset: 24)
            }
        }
        
        viewModel.$createButtonIsAllowed.bind { [weak self] isAllowed in
            guard let self = self else { return }
            
            createButton.isEnabled = isAllowed ? true : false
            createButton.backgroundColor = isAllowed ?
            colors.blackDynamicYP :
            colors.grayStaticYP
            createButton.setTitleColor(
                isAllowed ? colors.whiteDynamicYP : colors.whiteStaticYP,
                for: .normal
            )
        }
        
        viewModel.$error.bind { [weak self] error in
            guard let error = error else { return }
            self?.showAlert(error)
        }
    }
    
    private func setupViews() {
        view.backgroundColor = colors.whiteDynamicYP
        self.hideKeyboardWhenTappedAround()
        
        if model == nil {
            topLabel.text = isTracker ?
            L10n.Localizable.SetupTrackerScreen.TopLabel.trackerTitle :
            L10n.Localizable.SetupTrackerScreen.TopLabel.eventTitle
        } else {
            topLabel.text = L10n.Localizable.SetupTrackerScreen.TopLabel.editingMode
        }
        
        topLabel.textColor = colors.blackDynamicYP
        topLabel.font = .systemFont(ofSize: 16, weight: .medium)
        
        textField.delegate = self
        textField.placeholder = L10n.Localizable.SetupTrackerScreen.TextField.placeholder
        textField.clearButtonMode = .always
        textField.backgroundColor = colors.backgroundDynamicYP
        textField.layer.cornerRadius = 16
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        textField.returnKeyType = .done
        textField.addTarget(self, action: #selector(textDidChanged), for: .editingChanged)
        
        warningLabel.isHidden = true
        warningLabel.text = L10n.Localizable.SetupTrackerScreen.WarningLabel.title
        warningLabel.textColor = colors.redStaticYP
        warningLabel.font = .systemFont(ofSize: 17, weight: .regular)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = .init(top: 0, left: 20, bottom: 0, right: 20)
        tableView.rowHeight = 75
        tableView.backgroundColor = colors.whiteDynamicYP
        tableView.layer.cornerRadius = 16
        tableView.isScrollEnabled = false
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(EmojiCell.self, forCellWithReuseIdentifier: EmojiCell.identifier)
        collectionView.register(ColorCell.self, forCellWithReuseIdentifier: ColorCell.identifier)
        collectionView.register(
            TrackerSetupCollectionViewHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TrackerSetupCollectionViewHeader.identifier
        )
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 19, bottom: 24, right: 19)
        collectionView.isScrollEnabled = false
        collectionView.allowsMultipleSelection = true
        
        let title = model == nil ?
        L10n.Localizable.SetupTrackerScreen.CreateButton.title :
        L10n.Localizable.SetupTrackerScreen.SaveButton.title
        createButton.setTitle(title, for: .normal)
        createButton.setTitleColor(colors.whiteStaticYP, for: .normal)
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        createButton.isEnabled = false
        createButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        createButton.backgroundColor = colors.grayStaticYP
        createButton.layer.cornerRadius = 16
        
        cancelButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        cancelButton.setTitle(L10n.Localizable.SetupTrackerScreen.CancelButton.title, for: .normal)
        cancelButton.setTitleColor(colors.redStaticYP, for: .normal)
        cancelButton.backgroundColor = .clear
        cancelButton.layer.cornerRadius = 16
        cancelButton.layer.borderColor = colors.redStaticYP.cgColor
        cancelButton.layer.borderWidth = 1
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
            make.width.equalToSuperview()
        }
        
        if model != nil {
            scrollView.addSubview(labelInEditingMode)
            
            labelInEditingMode.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(38)
            }
        }
        
        textField.snp.makeConstraints { make in
            if model == nil {
                make.top.equalTo(24)
            } else {
                make.top.equalTo(labelInEditingMode.snp.bottom).offset(40)
            }
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
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
    
    @objc private func textDidChanged() {
        guard let text = textField.text else { return }
        viewModel.textDidChanged(text)
    }
    
    @objc private func cancelButtonTapped() {
        delegate?.dismiss()
        
        if isTracker {
            analyticsService.sendEvent(params: [
                AnalyticsService.Parameters.event.rawValue: AnalyticsService.Event.click.rawValue,
                AnalyticsService.Parameters.screen.rawValue: AnalyticsService.Screen.setup_tracker.rawValue,
                AnalyticsService.Parameters.item.rawValue: AnalyticsService.Item.cancel_button.rawValue
            ])
        } else {
            analyticsService.sendEvent(params: [
                AnalyticsService.Parameters.event.rawValue: AnalyticsService.Event.click.rawValue,
                AnalyticsService.Parameters.screen.rawValue: AnalyticsService.Screen.setup_event.rawValue,
                AnalyticsService.Parameters.item.rawValue: AnalyticsService.Item.cancel_button.rawValue
            ])
        }
    }
    
    @objc private func createButtonTapped() {
        if model == nil {
            viewModel.createButtonTapped()
        } else {
            viewModel.saveButtonTapped(model!.0.trackers[0].id)
        }
        delegate?.dismiss()
        
        if isTracker {
            analyticsService.sendEvent(params: [
                AnalyticsService.Parameters.event.rawValue: AnalyticsService.Event.click.rawValue,
                AnalyticsService.Parameters.screen.rawValue: AnalyticsService.Screen.setup_tracker.rawValue,
                AnalyticsService.Parameters.item.rawValue: AnalyticsService.Item.create_button.rawValue
            ])
        } else {
            analyticsService.sendEvent(params: [
                AnalyticsService.Parameters.event.rawValue: AnalyticsService.Event.click.rawValue,
                AnalyticsService.Parameters.screen.rawValue: AnalyticsService.Screen.setup_event.rawValue,
                AnalyticsService.Parameters.item.rawValue: AnalyticsService.Item.create_button.rawValue
            ])
        }
    }
}

// MARK: - UITextFieldDelegate

extension TrackerSetupViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if isTracker {
            analyticsService.sendEvent(params: [
                AnalyticsService.Parameters.event.rawValue: AnalyticsService.Event.click.rawValue,
                AnalyticsService.Parameters.screen.rawValue: AnalyticsService.Screen.setup_tracker.rawValue,
                AnalyticsService.Parameters.item.rawValue: AnalyticsService.Item.textfield.rawValue
            ])
        } else {
            analyticsService.sendEvent(params: [
                AnalyticsService.Parameters.event.rawValue: AnalyticsService.Event.click.rawValue,
                AnalyticsService.Parameters.screen.rawValue: AnalyticsService.Screen.setup_event.rawValue,
                AnalyticsService.Parameters.item.rawValue: AnalyticsService.Item.textfield.rawValue
            ])
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if isTracker {
            analyticsService.sendEvent(params: [
                AnalyticsService.Parameters.event.rawValue: AnalyticsService.Event.click.rawValue,
                AnalyticsService.Parameters.screen.rawValue: AnalyticsService.Screen.setup_tracker.rawValue,
                AnalyticsService.Parameters.item.rawValue: AnalyticsService.Item.hide_keyboard.rawValue
            ])
        } else {
            analyticsService.sendEvent(params: [
                AnalyticsService.Parameters.event.rawValue: AnalyticsService.Event.click.rawValue,
                AnalyticsService.Parameters.screen.rawValue: AnalyticsService.Screen.setup_event.rawValue,
                AnalyticsService.Parameters.item.rawValue: AnalyticsService.Item.hide_keyboard.rawValue
            ])
        }
        
        return view.endEditing(true)
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        viewModel.clearTextButtonTapped()
        
        if isTracker {
            analyticsService.sendEvent(params: [
                AnalyticsService.Parameters.event.rawValue: AnalyticsService.Event.click.rawValue,
                AnalyticsService.Parameters.screen.rawValue: AnalyticsService.Screen.setup_tracker.rawValue,
                AnalyticsService.Parameters.item.rawValue: AnalyticsService.Item.clear_textfield.rawValue
            ])
        } else {
            analyticsService.sendEvent(params: [
                AnalyticsService.Parameters.event.rawValue: AnalyticsService.Event.click.rawValue,
                AnalyticsService.Parameters.screen.rawValue: AnalyticsService.Screen.setup_event.rawValue,
                AnalyticsService.Parameters.item.rawValue: AnalyticsService.Item.clear_textfield.rawValue
            ])
        }
        
        return true
    }
}

// MARK: - UITableViewDataSource

extension TrackerSetupViewController: UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        isTracker ? 2 : 1
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        let cell = ScheduleCategoryCell()
        if model != nil {
            if indexPath.row == 0 {
                cell.detailTextLabel?.text = model!.0.title
            } else {
                cell.setDetailTextLabel(for: model!.0.trackers[0].schedule)
            }
            
        }
        cell.configure(with: indexPath.row, isTracker: isTracker)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension TrackerSetupViewController: UITableViewDelegate {
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            
            let vc = CategoriesListViewController(
                
                viewModel: CategoriesListViewModel(
                    model: CategoriesListModel(),
                    selectedCategory: selectedCategory
                )
            )
            vc.completion = { [weak self] category in
                guard let self = self else { return }
                
                selectedCategory = category
                
                if let category = category {
                    viewModel.didSelectCategory(category)
                } else {
                    viewModel.didDeselectCategory()
                }
                
                let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
                cell?.detailTextLabel?.text = category
            }
            present(vc, animated: true)
            
            if isTracker {
                analyticsService.sendEvent(params: [
                    AnalyticsService.Parameters.event.rawValue: AnalyticsService.Event.click.rawValue,
                    AnalyticsService.Parameters.screen.rawValue: AnalyticsService.Screen.setup_tracker.rawValue,
                    AnalyticsService.Parameters.item.rawValue: AnalyticsService.Item.category.rawValue
                ])
            } else {
                analyticsService.sendEvent(params: [
                    AnalyticsService.Parameters.event.rawValue: AnalyticsService.Event.click.rawValue,
                    AnalyticsService.Parameters.screen.rawValue: AnalyticsService.Screen.setup_event.rawValue,
                    AnalyticsService.Parameters.item.rawValue: AnalyticsService.Item.category.rawValue
                ])
            }
            
        } else {
            
            let vc = ScheduleViewController(viewModel: ScheduleViewModel(schedule: schedule))
            
            vc.completion = { [weak self] schedule in
                guard let self = self else { return }
                
                self.schedule = schedule
                
                schedule.isEmpty ?
                viewModel.didDeselectSchedule() :
                viewModel.didSelectSchedule(schedule)
                
                let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? ScheduleCategoryCell
                cell?.setDetailTextLabel(for: schedule)
            }
            present(vc, animated: true)
          
            analyticsService.sendEvent(params: [
                AnalyticsService.Parameters.event.rawValue: AnalyticsService.Event.click.rawValue,
                AnalyticsService.Parameters.screen.rawValue: AnalyticsService.Screen.setup_tracker.rawValue,
                AnalyticsService.Parameters.item.rawValue: AnalyticsService.Item.new_event.rawValue
            ])
            
        }
    }
}

// MARK: - UICollectionViewDataSource

extension TrackerSetupViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        18
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: EmojiCell.identifier,
                for: indexPath
            ) as? EmojiCell else { return UICollectionViewCell() }
            
            cell.configure(with: viewModel.emojiForCollectionView(at: indexPath))
            
            if model != nil {
                let emoji = model!.0.trackers[0].emoji
                let index = viewModel.emojis.firstIndex(of: emoji)
                if let index = index,
                   index == indexPath.row {
                    cell.backgroundColor = colors.lightGrayStaticYP
                    viewModel.didSelectEmoji(at: IndexPath(row: index, section: 0))
                    collectionView.selectItem(at: IndexPath(row: index, section: 0), animated: false, scrollPosition: .bottom)
                }
            }
            
            return cell
            
        } else {
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ColorCell.identifier,
                for: indexPath
            ) as? ColorCell  else { return UICollectionViewCell() }
            
            cell.configure(with: indexPath.row)
            
            if model != nil {
                let char = model!.0.trackers[0].color.last
                if let char = char,
                   let index = Int(String(char)),
                   index == indexPath.row {
                    cell.itemDidSelect(true)
                    viewModel.didSelectColor(at: IndexPath(row: index, section: 1))
                    collectionView.selectItem(at: IndexPath(row: index, section: 1), animated: false, scrollPosition: .bottom)
                }
            }
            
            return cell
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        
        guard let view = collectionView
            .dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: TrackerSetupCollectionViewHeader.identifier,
                for: indexPath) as? TrackerSetupCollectionViewHeader else { return UICollectionReusableView() }
        
        view.configure(with: indexPath.section)
        return view
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TrackerSetupViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: 52, height: 52)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        5
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        CGSize(width: view.bounds.width, height: 74)
    }
}

// MARK: - UICollectionViewDelegate

extension TrackerSetupViewController {
  
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        if let indexes = collectionView.indexPathsForSelectedItems {
            indexes.filter { $0.section == indexPath.section && $0 != indexPath }.forEach { i in
                    collectionView.deselectItem(at: i, animated: false)
                (collectionView.cellForItem(at: i) as? EmojiCell)?.backgroundColor = .clear
                (collectionView.cellForItem(at: i) as? ColorCell)?.itemDidSelect(false)
            }
        }
        if let cell = collectionView.cellForItem(at: indexPath) as? EmojiCell {
            cell.backgroundColor = colors.lightGrayStaticYP
            viewModel.didSelectEmoji(at: indexPath)
            
            if isTracker {
                analyticsService.sendEvent(params: [
                    AnalyticsService.Parameters.event.rawValue: AnalyticsService.Event.click.rawValue,
                    AnalyticsService.Parameters.screen.rawValue: AnalyticsService.Screen.setup_tracker.rawValue,
                    AnalyticsService.Parameters.item.rawValue: AnalyticsService.Item.emoji.rawValue
                ])
            } else {
                analyticsService.sendEvent(params: [
                    AnalyticsService.Parameters.event.rawValue: AnalyticsService.Event.click.rawValue,
                    AnalyticsService.Parameters.screen.rawValue: AnalyticsService.Screen.setup_event.rawValue,
                    AnalyticsService.Parameters.item.rawValue: AnalyticsService.Item.emoji.rawValue
                ])
            }
        }
        if let cell = collectionView.cellForItem(at: indexPath) as? ColorCell {
            cell.itemDidSelect(true)
            viewModel.didSelectColor(at: indexPath)
            
            if isTracker {
                analyticsService.sendEvent(params: [
                    AnalyticsService.Parameters.event.rawValue: AnalyticsService.Event.click.rawValue,
                    AnalyticsService.Parameters.screen.rawValue: AnalyticsService.Screen.setup_tracker.rawValue,
                    AnalyticsService.Parameters.item.rawValue: AnalyticsService.Item.color.rawValue
                ])
            } else {
                analyticsService.sendEvent(params: [
                    AnalyticsService.Parameters.event.rawValue: AnalyticsService.Event.click.rawValue,
                    AnalyticsService.Parameters.screen.rawValue: AnalyticsService.Screen.setup_event.rawValue,
                    AnalyticsService.Parameters.item.rawValue: AnalyticsService.Item.color.rawValue
                ])
            }
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didDeselectItemAt indexPath: IndexPath
    ) {
        if let cell = collectionView.cellForItem(at: indexPath) as? EmojiCell {
            cell.backgroundColor = .clear
            viewModel.didDeselectEmoji()
        }
        if let cell = collectionView.cellForItem(at: indexPath) as? ColorCell {
            cell.itemDidSelect(false)
            viewModel.didDeselectColor()
        }
    }
}
