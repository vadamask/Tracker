//
//  TrackerSetupViewController.swift
//  Tracker
//
//  Created by Вадим Шишков on 29.08.2023.
//

import UIKit

protocol TrackerSetupViewControllerDelegate: AnyObject {
    func didTapCancelButton()
    func didCreate(_ tracker: Tracker, with title: String)
}

final class TrackerSetupViewController: UIViewController {
    
    weak var delegate: TrackerSetupViewControllerDelegate?
    
    private let categoryStore = TrackerCategoryStore()
    private var isTracker: Bool
    private let emoji = ["🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶", "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝️", "😪"]
    private var selectedColor = ""
    private var selectedEmoji = ""
    private var categoryTitle = "test"
    
    private var emojiIsSet: Bool = false {
        didSet {
            checkCreateButtonActivation(textField.text)
        }
    }
    
    private var colorIsSet = false {
        didSet {
            checkCreateButtonActivation(textField.text)
        }
    }
    
    private var scheduleIsSet = false {
        didSet {
            checkCreateButtonActivation(textField.text)
        }
    }
    
    private var schedule: Set<WeekDay> = []
    private let constraintLabel = UILabel(
        text: "Ограничение 38 символов",
        textColor: .redYP,
        font: .systemFont(ofSize: 17, weight: .regular)
    )
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private var topLabel = UILabel(text: "", textColor: .blackYP, font: .systemFont(ofSize: 16, weight: .medium))
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Введите название трекера"
        textField.clearButtonMode = .always
        textField.backgroundColor = .backgroundYP
        textField.layer.cornerRadius = 16
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        textField.returnKeyType = .done
        return textField
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorInset = .init(top: 0, left: 20, bottom: 0, right: 20)
        tableView.rowHeight = 75
        tableView.backgroundColor = .whiteYP
        tableView.layer.cornerRadius = 16
        return tableView
    }()
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInset = UIEdgeInsets(top: 24, left: 18, bottom: 24, right: 18)
        collectionView.isScrollEnabled = false
        collectionView.allowsMultipleSelection = true
        return collectionView
    }()
    
    private let createButton: UIButton = {
        let button = UIButton(title: "Создать", backgroundColor: .grayYP)
        button.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton(title: "Отменить", textColor: .redYP, backgroundColor: .clear)
        button.layer.borderColor = UIColor.redYP.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    }()
    
    init(isTracker: Bool) {
        self.isTracker = isTracker
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        view.backgroundColor = .whiteYP
        constraintLabel.isHidden = true
        self.hideKeyboardWhenTappedAround()
        
        topLabel.text = isTracker ? "Новая привычка" : "Новое нерегулярное событие"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TrackerSetupTableViewCell.self, forCellReuseIdentifier: "cell")
        
        textField.delegate = self
        textField.becomeFirstResponder()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TrackerSetupEmojiCell.self, forCellWithReuseIdentifier: TrackerSetupEmojiCell.identifier)
        collectionView.register(TrackerSetupColorCell.self, forCellWithReuseIdentifier: TrackerSetupColorCell.identifier)
        collectionView.register(
            TrackerSetupSupView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TrackerSetupSupView.identifier
        )
    }
    
    private func setupConstraints() {
        view.addSubview(topLabel)
        view.addSubview(scrollView)
        scrollView.addSubview(textField)
        scrollView.addSubview(constraintLabel)
        scrollView.addSubview(tableView)
        scrollView.addSubview(collectionView)
        scrollView.addSubview(cancelButton)
        scrollView.addSubview(createButton)
        
        NSLayoutConstraint.activate([
            topLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            topLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            scrollView.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 14),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.contentLayoutGuide.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            textField.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 24),
            textField.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 75),
            
            constraintLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 8),
            constraintLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 62),
            tableView.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: isTracker ? 150 : 75),
            
            collectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 500),
            
            cancelButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 16),
            cancelButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            cancelButton.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -16),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            
            createButton.centerYAnchor.constraint(equalTo: cancelButton.centerYAnchor),
            createButton.heightAnchor.constraint(equalTo: cancelButton.heightAnchor),
            createButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor),
            createButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 8),
            createButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func cancelButtonTapped() {
        delegate?.didTapCancelButton()
    }
    
    @objc private func createButtonTapped() {
        let tracker = Tracker(uuid: UUID(), name: textField.text!, color: selectedColor, emoji: selectedEmoji, schedule: schedule)
        do {
            try categoryStore.add(categoryTitle) // FIXME: - убрать
            delegate?.didCreate(tracker, with: categoryTitle)
        } catch {
            assertionFailure("Failure with adding tracker")
        }
    }
    
    private func checkCreateButtonActivation(_ text: String?) {
        if let text = text {
            createButton.isEnabled = isTracker ?
            !text.isEmpty && scheduleIsSet && emojiIsSet && colorIsSet :
            !text.isEmpty && emojiIsSet && colorIsSet
        }
        createButton.backgroundColor = createButton.isEnabled ? .blackYP : .grayYP
    }
}

// MARK: - UITableViewDataSource

extension TrackerSetupViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isTracker ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") {
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 16
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Категория"
                cell.layer.maskedCorners = isTracker ?
                [.layerMinXMinYCorner, .layerMaxXMinYCorner] :
                [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
                
                if !isTracker {
                    cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 400)
                }
            case 1:
                cell.textLabel?.text = "Расписание"
                cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
                cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 400)
            default:
                break
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

// MARK: - UITableViewDelegate

extension TrackerSetupViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            
        } else {
            let vc = TrackerScheduleViewController(delegate: self, schedule: schedule)
            present(vc, animated: true)
        }
    }
}

// MARK: - ScheduleViewControllerDelegate

extension TrackerSetupViewController: TrackerScheduleViewControllerDelegate {
    func didSelectedDays(in schedule: Set<WeekDay>) {
        self.schedule = schedule
        
        let selectedDays = schedule
            .sorted(by: {$0.rawValue < $1.rawValue})
            .map { WeekDay.shortName(for: $0.rawValue)}
        
        scheduleIsSet = selectedDays.isEmpty ? false : true
        
        let indexPath = IndexPath(row: 1, section: 0)
        let cell = tableView.cellForRow(at: indexPath)
        cell?.detailTextLabel?.text = selectedDays.count < 7 ? selectedDays.joined(separator: ", ") : "Каждый день"
        dismiss(animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension TrackerSetupViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let range = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: range, with: string)
        checkCreateButtonActivation(updatedText)
        if updatedText.count <= 38 {
            constraintLabel.isHidden = true
            return true
        } else {
            constraintLabel.isHidden = false
            return false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        checkCreateButtonActivation("")
        constraintLabel.isHidden = true
        return true
    }
}

// MARK: - UICollectionViewDataSource

extension TrackerSetupViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       18
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TrackerSetupEmojiCell.identifier,
                for: indexPath
            ) as? TrackerSetupEmojiCell else { return UICollectionViewCell() }
            
            cell.configure(with: emoji[indexPath.row])
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
        
        if let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TrackerSetupSupView.identifier, for: indexPath) as? TrackerSetupSupView {
            view.configure(with: indexPath.section)
            return view
        } else {
            return UICollectionReusableView()
        }
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
            emojiIsSet = true
            selectedEmoji = emoji[indexPath.row]
        }
        if let cell = collectionView.cellForItem(at: indexPath) as? TrackerSetupColorCell {
            cell.itemDidSelect(true)
            colorIsSet = true
            selectedColor = "Color selection \(indexPath.row)"
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? TrackerSetupEmojiCell {
            cell.backgroundColor = .clear
            emojiIsSet = false
        }
        if let cell = collectionView.cellForItem(at: indexPath) as? TrackerSetupColorCell {
            cell.itemDidSelect(false)
            colorIsSet = false
        }
    }
}

