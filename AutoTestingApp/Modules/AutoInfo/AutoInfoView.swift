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
    
    private var markTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Марка"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private var distributorTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Производитель"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private var priceTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Цена"
        textField.keyboardType = .decimalPad
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private var powerTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Мощность в л.с."
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private var timeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Время до 100 км/ч в сек."
        textField.keyboardType = .decimalPad
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private var driveTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Привод"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private var lenTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Длина в мм"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private var heightTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Высота в мм"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private var widthTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Ширина в мм"
        textField.borderStyle = .roundedRect
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
        
        vStack.addArrangedSubview(markTextField)
        vStack.addArrangedSubview(distributorTextField)
        vStack.addArrangedSubview(powerTextField)
        vStack.addArrangedSubview(timeTextField)
        vStack.addArrangedSubview(driveTextField)
        vStack.addArrangedSubview(lenTextField)
        vStack.addArrangedSubview(widthTextField)
        vStack.addArrangedSubview(heightTextField)
        vStack.addArrangedSubview(priceTextField)
        
        configPicker()
    }
    
    private func fillInfo() {
        if let auto = viewModel.auto {
            markTextField.text = auto.mark
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
        
        markTextField.rx.text.map({$0 ?? ""}).bind(to: viewModel.markSubject).disposed(by: bag)
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



