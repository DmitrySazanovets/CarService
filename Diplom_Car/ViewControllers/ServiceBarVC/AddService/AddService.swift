//
//  AddService.swift
//  Diplom_Car
//
//  Created by Дмитрий Сазановец on 7/11/22.
//

import UIKit

protocol AddServiceDelegate: AnyObject {
    func serviseDidSaved()
}

class AddService: UIViewController {
    
    weak var delegate: AddServiceDelegate?
    
    private let model = RealmManager.read(type: TransportVehicleModel.self).first(where: { $0.isSelected })
    private let service = TransportService()
    private var arrayTypeService = ArrayInfoCar()
    private var picker = UIPickerView()
    
    
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
        
    @IBOutlet weak var typeServiceTF: UITextField!
    @IBOutlet weak var dateServiceTF: UITextField!
    @IBOutlet weak var millageServiceTF: UITextField!
    
    @IBOutlet weak var costItemTF: UITextField!
    @IBOutlet weak var costWork: UITextField!
    @IBOutlet weak var costFull: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        closeKeyB()
        
        typeServiceTF.inputView = picker
        dateServiceTF.inputView = datePicker
        picker.dataSource = self
        picker.delegate = self
        dateServiceTF.delegate = self
        costWork.delegate = self
        costItemTF.delegate = self
        
    }
    
    @IBAction func saveServiceAction(_ sender: Any) {
        RealmManager.updating { [weak self] in
            guard let self = self else { return }
            
            
            self.service.mileageService = self.millageServiceTF.text
            self.service.typeService = self.typeServiceTF.text
            self.service.costItem = self.costItemTF.text == "" ? nil : self.costItemTF.text
            self.service.costWork = self.costWork.text == "" ? nil : self.costWork.text
            self.service.costFull = self.costFull.text
            
            self.model?.services.append(self.service)
            
            self.delegate?.serviseDidSaved()
        }
        
      
        navigationController?.popViewController(animated: true)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    private func closeKeyB(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tap)

    }
    
    private func calculateFullCost() {
        guard let itemInt = Int(costItemTF.text!),
              let workInt = Int(costWork.text!) else {
            return
        }
        
        costFull.text = String(itemInt + workInt)
    }

}

extension AddService: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField {
        case dateServiceTF:
            dateServiceTF.text = dateFormatter.string(from: datePicker.date)
            service.dateService = dateServiceTF.text
        case costItemTF, costWork:
            calculateFullCost()
        default:
            break
        }
        
        
    }
}
extension AddService: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayTypeService.typeService.count
    }
    
    
}
extension AddService: UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrayTypeService.typeService[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if arrayTypeService.typeService[row] == arrayTypeService.typeService[15] {
            typeServiceTF.text = ""
//            self.view.endEditing(true)
        } else {
            typeServiceTF.text = arrayTypeService.typeService[row]
        }
    }
}

