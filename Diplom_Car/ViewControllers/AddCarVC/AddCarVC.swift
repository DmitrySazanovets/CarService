//
//  AddCarVC.swift
//  Diplom_Car
//
//  Created by Дмитрий Сазановец on 6/5/22.
//

import UIKit
import RealmSwift
import Combine
import PhotosUI

class AddCarVC: UIViewController {
    
    private var models: [String] = []
    private var selectedModels: [String] = []
    
    private var pickerView = UIPickerView()
    private var arrayInfoCar = ArrayInfoCar()
    
    public var saveBlock: (()->())?
    
    var cancellables = Set<AnyCancellable>()
    var activeDataArray : [String] = []
    
    @IBOutlet var mainTFs: [UITextField]!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var modelTF: UITextField!
    @IBOutlet weak var brandTF: UITextField!
    @IBOutlet weak var mileageTF: UITextField!
    @IBOutlet weak var registrationPlateTF: UITextField!
    @IBOutlet weak var commentTF: UITextField!
    
    @IBOutlet weak var typeTVField: UITextField!
    @IBOutlet weak var ageTVField: UITextField!
    @IBOutlet weak var typeFuelField: UITextField!
    @IBOutlet weak var typeEngineField: UITextField!
    @IBOutlet weak var colorCarField: UITextField!
    
    @IBOutlet weak var addImageButton: UIButton!
    
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Пополнение гаража"
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
//           if brandTF.addGestureRecognizer(tap)
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
        arrayInfoCar.updateArray()
        
        let carList = loadJson(fileName: "cars")
        models = Array(carList!.list!.keys)
        models.sort(){$0 < $1}
        selectedModels = models
        
        
        tableView.reloadData()
        
        mainTFs.forEach {
            $0.layer.cornerRadius = 8
            $0.delegate = self
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.red.cgColor
        }
        
        setupUI()
        
        
        
        let textFieldPublisher = NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: mainTFs[0])
            .map( {($0.object as? UITextField)?.text})
        
        textFieldPublisher
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] value in
                guard let value = value else { return }
                
                let x = self?.models.filter({ $0.localizedStandardContains(value) })
                if x!.isEmpty {
                    self?.selectedModels = self!.models
                    self?.tableView.reloadData()
                } else {
                    self?.selectedModels = x!
                    self?.tableView.reloadData()
                }
            })
            .store(in: &cancellables)
        
    }
    
    @IBAction func addImageDidPressed(_ sender: UIButton) {
        let configuration = PHPickerConfiguration()
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func saveCarActionButton(_ sender: Any) {
        if commentTF.text == "" {
            commentTF.text = "Комментарий"
        } else {commentTF.text = commentTF.text}
        
        DispatchQueue.main.async { [weak self] in
            RealmManager.write(object: TransportVehicleModel(model: self?.modelTF.text,
                                                             brand: self?.brandTF.text,
                                                             mileage: self?.mileageTF.text,
                                                             registrationPlate: self?.registrationPlateTF.text,
                                                             comment: self?.commentTF.text,
                                                             typeVC: self?.typeTVField.text,
                                                             age: self?.ageTVField.text,
                                                             typeFuel: self?.typeFuelField.text,
                                                             typeEngine: self?.typeEngineField.text,
                                                             color: self?.colorCarField.text,
                                                             image: self?.addImageButton.imageView?.image?.jpegData(compressionQuality: 1)
                                                            ))
            self?.saveBlock?()
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    
    
    // MARK: - Private Functions
    // MARK: - UI
//    @objc func dismissKeyboard() {
//        view.endEditing(true)
//    }
//    private func closeKeyB(){
//        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
//        view.addGestureRecognizer(tap)
//
//    }
    
    private func setupUI() {
        setupTableView()
        
        typeTVField.inputView = pickerView
        typeEngineField.inputView = pickerView
        typeFuelField.inputView = pickerView
        colorCarField.inputView = pickerView
        ageTVField.inputView = pickerView
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: String(describing: ListTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ListTableViewCell.self))
        self.tableView.isHidden = true
    }
}


// MARK: - UITableViewDelegate, UITableViewDataSource
extension AddCarVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ListTableViewCell.self), for: indexPath) as? ListTableViewCell else {
            return UITableViewCell()
        }
        
        cell.list = selectedModels[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? ListTableViewCell{
            mainTFs[0].text = cell.list
            self.tableView.isHidden = true
        }
    }
}

// MARK: - UITextFieldDelegate
extension AddCarVC: UITextFieldDelegate {
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeDataArray = []
        if textField == mainTFs[0] {
            tableView.isHidden = false
        }
        if textField == typeTVField {
            activeDataArray = arrayInfoCar.typeTVList
        }
        if textField == typeFuelField {
            activeDataArray = arrayInfoCar.typeFuelTVList
        }
        if textField == typeEngineField {
            activeDataArray = arrayInfoCar.typeEngineList
        }
        if textField == ageTVField {
            activeDataArray = arrayInfoCar.ageTVList
        }
        if textField == colorCarField {
            activeDataArray = arrayInfoCar.colorTVList
        }
        pickerView.reloadAllComponents()
        pickerView.isHidden = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        tableView.isHidden = true
        
        for tf in mainTFs {
            
            tf.layer.borderColor = tf.text == "" ? UIColor.red.cgColor :  UIColor.black.cgColor
            tf.layer.borderWidth = tf.text == "" ? 1 : 0
            saveButton.isEnabled = tf.text == "" ? false : true
        }
        
    }
}
extension AddCarVC: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if typeTVField.isEditing{
            return arrayInfoCar.typeTVList.count
        } else if typeFuelField.isEditing {
            return arrayInfoCar.typeFuelTVList.count
        } else if typeEngineField.isEditing {
            return arrayInfoCar.typeEngineList.count
        } else if colorCarField.isEditing {
            return arrayInfoCar.colorTVList.count
        } else {
            return arrayInfoCar.ageTVList.count
            }
    }
}

extension AddCarVC: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if typeTVField.isEditing {
            let row = arrayInfoCar.typeTVList[row]
            return row
        } else if typeFuelField.isEditing {
            let row = arrayInfoCar.typeFuelTVList[row]
            return row
        } else if typeEngineField.isEditing {
            let row = arrayInfoCar.typeEngineList[row]
            return row
        } else if colorCarField.isEditing {
            let row = arrayInfoCar.colorTVList[row]
            return row
        } else  {
            let row = arrayInfoCar.ageTVList[row]
        return row
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if typeTVField.isEditing{
            typeTVField.text = arrayInfoCar.typeTVList[row]
        } else if  typeFuelField.isEditing {
            typeFuelField.text = arrayInfoCar.typeFuelTVList[row]
//            typeFuelField.endEditing(true)
        } else if typeEngineField.isEditing {
            typeEngineField.text = arrayInfoCar.typeEngineList[row]
//            typeEngineField.endEditing(true)
        } else if colorCarField.isEditing {
            colorCarField.text = arrayInfoCar.colorTVList[row]
//            colorCarField.endEditing(true)
        } else if ageTVField.isEditing {
            ageTVField.text = arrayInfoCar.ageTVList[row]
//            ageTVField.endEditing(true)
            
        }
        
    }
}


extension AddCarVC: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        let itemProviders = results.map(\.itemProvider)
        for item in itemProviders {
            if item.canLoadObject(ofClass: UIImage.self) {
                item.loadObject(ofClass: UIImage.self) { (image, error) in
                    DispatchQueue.main.async {
                        if let image = image as? UIImage {
                            self.addImageButton.setImage(image, for: [])
                        }
                    }
                }
            }
        }
    }
}
