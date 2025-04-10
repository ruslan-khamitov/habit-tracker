//
//  AddHabbitVC.swift
//  HabbitTracker
//
//  Created by Ruslan Khamitov on 08.04.2025.
//

import UIKit
import Combine

protocol AddHabbitVCDelegate: AnyObject {
    func onAddHabbitDismiss() -> Void
}

class AddHabbitVC: UIViewController {
    // Components
    let titleComponent = UILabel()
    let textField = UITextField()
    var colorPicker: HabbitColorPicker!
    let button = UIButton()
    
    weak var delegate: AddHabbitVCDelegate?

    // State
    let colorSubject = CurrentValueSubject<HabbitColors, Never>(.red)
    var habbitName = ""
    
    let habbitsInteractor = AppContainer.habbitsInteractor
    
    init() {
        colorPicker = HabbitColorPicker(selectedColor: colorSubject)
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorPicker = HabbitColorPicker(selectedColor: colorSubject)

        // Do any additional setup after loading the view.
        configureSubviews()
        configureComponents()
        stylize()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        delegate?.onAddHabbitDismiss()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureSubviews() {
        titleComponent.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        colorPicker.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleComponent)
        view.addSubview(textField)
        view.addSubview(colorPicker)
        view.addSubview(button)
        
        let horizontalPadding: CGFloat = 12
        
        NSLayoutConstraint.activate([
            titleComponent.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            titleComponent.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            titleComponent.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding),
            titleComponent.heightAnchor.constraint(equalToConstant: 100),
            
            textField.topAnchor.constraint(equalTo: titleComponent.bottomAnchor, constant: 16),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding),
            textField.heightAnchor.constraint(equalToConstant: 50),
            
            colorPicker.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 16),
            colorPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            colorPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding),
            colorPicker.heightAnchor.constraint(equalToConstant: 50),
            
            button.topAnchor.constraint(equalTo: colorPicker.bottomAnchor, constant: 16),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configureComponents() {
        textField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        updateButtonOnTextChanged()
        
        let action = UIAction {[weak self] _ in
            self?.addNewHabbit()
        }
        button.addAction(action, for: .touchUpInside)
    }
    
    private func updateButtonOnTextChanged() {
        button.isEnabled = !habbitName.isEmpty
    }
    
    private func stylize() {
        titleComponent.text = "Add new habbit"
        titleComponent.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        
        textField.placeholder = "Enter new habbit name"
        
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Add"
        configuration.baseBackgroundColor = .systemBlue
        configuration.baseForegroundColor = .white
        button.configuration = configuration

        view.backgroundColor = .systemBackground
    }
    
    @objc private func textChanged() {
        let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        habbitName = text
        updateButtonOnTextChanged()
    }
    
    private func addNewHabbit() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let ctx = delegate.persistentContainer.viewContext
        
        habbitsInteractor.saveHabbit(withName: habbitName, andColor: colorSubject.value)
        
        dismiss(animated: true)
    }

}
