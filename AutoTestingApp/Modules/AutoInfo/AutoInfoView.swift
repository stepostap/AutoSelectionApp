//
//  AutoInfoView.swift
//  AutoTestingApp
//
//  Created by Stepan Ostapenko on 07.08.2023.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class AutoInfoView: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillInfo()
        configView()
        setObservables()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    init(viewModel: AutoInfoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var modelTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите модель..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private var distributorTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите производителя..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private var priceTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите цену..."
        textField.keyboardType = .decimalPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private var powerTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите л.с..."
        textField.keyboardType = .decimalPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private var timeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Время в сек..."
        textField.keyboardType = .decimalPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private var driveTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Выберите привод..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private var lenTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите длину..."
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private var heightTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите высоту..."
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private var widthTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите ширину..."
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private var viewModel: AutoInfoViewModel
    private var bag = DisposeBag()
    private let picker = UIPickerView()
    private var saveButton: UIBarButtonItem!
    
    // MARK: - Private methods
    
    @objc private func resignPicker() {
        driveTextField.resignFirstResponder()
    }
    
    @objc private func save() {
        viewModel.save()
        navigationController?.popViewController(animated: true)
    }
    
    private func configPicker() {
        picker.delegate = self
        picker.dataSource = self
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.systemBlue
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.resignPicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        driveTextField.inputView = picker
        driveTextField.inputAccessoryView = toolBar
    }
    
    private func configView() {
        view.backgroundColor = .systemBackground
    
        if let auto = viewModel.auto {
            navigationItem.title = "\(auto.distributor ?? "") \(auto.mark ?? "")"
        } else {
            navigationItem.title = "Добавить автомобиль"
        }
        
        saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
        navigationItem.rightBarButtonItem = saveButton
        
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.distribution = .fillEqually
        vStack.spacing = 20
        view.addSubview(vStack)
        
        vStack.snp.makeConstraints({ make in
            make.top.left.equalTo(view.safeAreaLayoutGuide).offset(15)
            make.bottom.trailing.equalTo(view.safeAreaLayoutGuide).offset(-15)
        })
        
        let modelStack = UIStackView()
        modelStack.distribution = .fill
        modelStack.axis = .horizontal
        modelTextField.font = UIFont.systemFont(ofSize: getRelativeWidth(22))
        modelStack.addArrangedSubview(getLabel(width: 90, text: "Модель:"))
        modelStack.addArrangedSubview(modelTextField)
        vStack.addArrangedSubview(modelStack)
        
        let distributorStack = UIStackView()
        distributorStack.distribution = .fill
        distributorStack.axis = .horizontal
        distributorStack.addArrangedSubview(getLabel(width: 80, text: "Марка:"))
        distributorTextField.font = UIFont.systemFont(ofSize: getRelativeWidth(22))
        distributorStack.addArrangedSubview(distributorTextField)
        vStack.addArrangedSubview(distributorStack)
        
        let powerStack = UIStackView()
        powerStack.distribution = .fill
        powerStack.axis = .horizontal
        powerTextField.font = UIFont.systemFont(ofSize: getRelativeWidth(22))
        powerStack.addArrangedSubview(getLabel(width: 170, text: "Мощность в л.с.:"))
        powerTextField.font = UIFont.systemFont(ofSize: getRelativeWidth(22))
        powerStack.addArrangedSubview(powerTextField)
        vStack.addArrangedSubview(powerStack)
        
        let timeStack = UIStackView()
        timeStack.distribution = .fill
        timeStack.axis = .horizontal
        powerTextField.font = UIFont.systemFont(ofSize: getRelativeWidth(22))
        timeStack.addArrangedSubview(getLabel(width: 200, text: "Время до 100км/ч:"))
        timeTextField.font = UIFont.systemFont(ofSize: getRelativeWidth(22))
        timeStack.addArrangedSubview(timeTextField)
        vStack.addArrangedSubview(timeStack)
        
        let driveStack = UIStackView()
        driveStack.distribution = .fill
        driveStack.axis = .horizontal
        powerTextField.font = UIFont.systemFont(ofSize: getRelativeWidth(22))
        driveStack.addArrangedSubview(getLabel(width: 140, text: "Тип привода:"))
        driveTextField.font = UIFont.systemFont(ofSize: getRelativeWidth(22))
        driveStack.addArrangedSubview(driveTextField)
        vStack.addArrangedSubview(driveStack)
        
        let lenStack = UIStackView()
        lenStack.distribution = .fill
        lenStack.axis = .horizontal
        powerTextField.font = UIFont.systemFont(ofSize: getRelativeWidth(22))
        lenStack.addArrangedSubview(getLabel(width: 140, text: "Длина в мм.:"))
        lenTextField.font = UIFont.systemFont(ofSize: getRelativeWidth(22))
        lenStack.addArrangedSubview(lenTextField)
        vStack.addArrangedSubview(lenStack)
        
        let widthStack = UIStackView()
        widthStack.distribution = .fill
        widthStack.axis = .horizontal
        powerTextField.font = UIFont.systemFont(ofSize: getRelativeWidth(22))
        widthStack.addArrangedSubview(getLabel(width: 150, text: "Ширина в мм.:"))
        widthTextField.font = UIFont.systemFont(ofSize: getRelativeWidth(22))
        widthStack.addArrangedSubview(widthTextField)
        vStack.addArrangedSubview(widthStack)
        
        let heightStack = UIStackView()
        heightStack.distribution = .fill
        heightStack.axis = .horizontal
        powerTextField.font = UIFont.systemFont(ofSize: getRelativeWidth(22))
        heightStack.addArrangedSubview(getLabel(width: 145, text: "Высота в мм.:"))
        heightTextField.font = UIFont.systemFont(ofSize: getRelativeWidth(22))
        heightStack.addArrangedSubview(heightTextField)
        vStack.addArrangedSubview(heightStack)
        
        let priceStack = UIStackView()
        priceStack.distribution = .fill
        priceStack.axis = .horizontal
        powerTextField.font = UIFont.systemFont(ofSize: getRelativeWidth(22))
        priceStack.addArrangedSubview(getLabel(width: 160, text: "Стоимость в ₽:"))
        priceTextField.font = UIFont.systemFont(ofSize: getRelativeWidth(22))
        priceStack.addArrangedSubview(priceTextField)
        vStack.addArrangedSubview(priceStack)
                
        configPicker()
    }
    
    private func getLabel(width: CGFloat, text: String) -> UILabel {
        let label = UILabel()
        label.snp.makeConstraints({ $0.width.equalTo(getRelativeWidth(width)) })
        label.text = text
        label.font = UIFont.systemFont(ofSize: getRelativeWidth(22))
        return label
    }
    
    private func getRelativeWidth(_ size: CGFloat) -> CGFloat {
        return size * (CGFloat(UIScreen.main.bounds.width) / 375.0)
    }
    
    private func fillInfo() {
        if let auto = viewModel.auto {
            modelTextField.text = auto.mark
            distributorTextField.text = auto.distributor
            powerTextField.text = auto.power.description
            widthTextField.text = auto.width.description
            heightTextField.text = auto.height.description
            lenTextField.text = auto.length.description
            timeTextField.text = auto.acceleration.description
            driveTextField.text = auto.driveType.description
            priceTextField.text = auto.price.description
        }
    }
    
    private func setObservables() {
        modelTextField.rx.text.map({$0 ?? ""}).bind(to: viewModel.markSubject).disposed(by: bag)
        distributorTextField.rx.text.map({$0 ?? ""}).bind(to: viewModel.distributorSubject).disposed(by: bag)
        powerTextField.rx.text.map({$0 ?? ""}).bind(to: viewModel.powerSubject).disposed(by: bag)
        widthTextField.rx.text.map({$0 ?? ""}).bind(to: viewModel.widthSubject).disposed(by: bag)
        lenTextField.rx.text.map({$0 ?? ""}).bind(to: viewModel.lenSubject).disposed(by: bag)
        heightTextField.rx.text.map({$0 ?? ""}).bind(to: viewModel.heightSubject).disposed(by: bag)
        timeTextField.rx.text.map({$0 ?? ""}).bind(to: viewModel.accelerationSubject).disposed(by: bag)
        priceTextField.rx.text.map({$0 ?? ""}).bind(to: viewModel.priceSubject).disposed(by: bag)
        driveTextField.rx.text.map({ _ in
            DriveType(rawValue: Int16(self.picker.selectedRow(inComponent: 0))) ?? .front
        }).bind(to: viewModel.driveTypeSubject).disposed(by: bag)
        
        viewModel.validInfo.bind(to: saveButton.rx.isEnabled).disposed(by: bag)
    }
}

// MARK: - PickerView
extension AutoInfoView: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        DriveType.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.text = DriveType(rawValue: Int16(row))?.description
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        driveTextField.text = DriveType(rawValue: Int16(row))?.description
    }
}


// MARK: - Keyboard
extension AutoInfoView {
    @objc func keyboardWillShow(sender: NSNotification) {
        guard let userInfo = sender.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
              let currentTextField = UIResponder.currentFirst() as? UITextField else { return }

        let keyboardTopY = keyboardFrame.cgRectValue.origin.y
        let convertedTextFieldFrame = view.convert(currentTextField.frame, from: currentTextField.superview)
        let textFieldBottomY = convertedTextFieldFrame.origin.y + convertedTextFieldFrame.size.height

        if textFieldBottomY > keyboardTopY {
            view.frame.origin.y = (view.frame.maxY - keyboardTopY) * -1
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
           view.frame.origin.y = 0
    }
}

