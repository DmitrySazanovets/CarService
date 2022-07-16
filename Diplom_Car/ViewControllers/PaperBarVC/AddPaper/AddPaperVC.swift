//
//  AddPaperVC.swift
//  Diplom_Car
//
//  Created by Дмитрий Сазановец on 7/11/22.
//

import UIKit

protocol AddPaperVCDelegate: AnyObject {
    func paperDidSaved()
}

class AddPaperVC: UIViewController {
    
    weak var delegate: AddPaperVCDelegate?
    
    private let model = RealmManager.read(type: TransportVehicleModel.self).first(where: { $0.isSelected })
    
    private let paper = TransportPaper()
    private var picker = UIPickerView()
    private var arrayTypeDock = ArrayInfoCar()
    
    private lazy var datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        dp.preferredDatePickerStyle = .wheels
        
        return dp
    }()
    
    private lazy var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "d.M.y"
        
        return df
    }()
    
    @IBOutlet weak var typeDock: UITextField!
    @IBOutlet weak var beginDock: UITextField!
    @IBOutlet weak var endDock: UITextField!
    @IBOutlet weak var costDock: UITextField!
    @IBOutlet weak var commentDock: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        closeKeyB()
        setupUI()
        
    }

    @IBAction func saveDockButtonAction(_ sender: Any) {
        
        RealmManager.updating { [weak self] in
            guard let self = self else { return }
            
            self.paper.typeDock = self.typeDock.text
            self.paper.beginDock = self.beginDock.text
            self.paper.endDock = self.endDock.text == "" ? nil : self.endDock.text
            self.paper.costDock = self.costDock.text == "" ? nil : self.costDock.text
            self.paper.commentDock = self.commentDock.text
            
            self.model?.papers.append(self.paper)
            
            self.delegate?.paperDidSaved()
        }
        navigationController?.popViewController(animated: true)
    }
    private func setupUI(){
        typeDock.inputView = picker
        beginDock.inputView = datePicker
        endDock.inputView = datePicker
        picker.dataSource = self
        picker.delegate = self
        beginDock.delegate = self
        endDock.delegate = self
        
        typeDock.layer.borderWidth = 1
        typeDock.layer.cornerRadius = 8
        beginDock.layer.borderWidth = 1
        beginDock.layer.cornerRadius = 8
        endDock.layer.borderWidth = 1
        endDock.layer.cornerRadius = 8
        costDock.layer.borderWidth = 1
        costDock.layer.cornerRadius = 8
        commentDock.layer.borderWidth = 1
        commentDock.layer.cornerRadius = 8

    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    private func closeKeyB(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tap)

    }
}

extension AddPaperVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField {
        case beginDock:
            beginDock.text = dateFormatter.string(from: datePicker.date)
            paper.beginDock = beginDock.text
        case endDock:
            endDock.text = dateFormatter.string(from: datePicker.date)
            paper.endDock = endDock.text
        default:
            break
        }
        
        
    }
}
extension AddPaperVC: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayTypeDock.typeDock.count
    }
    
    
}
extension AddPaperVC: UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrayTypeDock.typeDock[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if arrayTypeDock.typeDock[row] == arrayTypeDock.typeDock[6] {
            typeDock.text = ""
//            self.view.endEditing(true)
        } else {
            typeDock.text = arrayTypeDock.typeDock[row]
        }
    }
}
