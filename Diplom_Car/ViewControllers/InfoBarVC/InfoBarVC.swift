//
//  InfoBarVC.swift
//  Diplom_Car
//
//  Created by Дмитрий Сазановец on 6/5/22.
//

import UIKit
import PhotosUI


class InfoBarVC: UIViewController {
    
    private let model = RealmManager.read(type: TransportVehicleModel.self).first(where: { $0.isSelected })
    private var pickerView = UIPickerView()
    private var arrayInfoCar = ArrayInfoCar()

    @IBOutlet weak var carImageView: UIImageView!
    @IBOutlet weak var commentUpdateTF: UITextField!
    @IBOutlet weak var mileageUpdateTF: UITextField!
    @IBOutlet var mainInfoLabels: [UILabel]!
    
    @IBOutlet var secondInfoFields: [UITextField]!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInfoLabels()
        addImageGesture()
        closeKeyB()
        
        pickerView.dataSource = self
        pickerView.delegate = self
        arrayInfoCar.updateArray()
        
        let swiping = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(sender:)))
        swiping.direction = .left
        view.addGestureRecognizer(swiping)
    }
    @IBAction func updateInfoActionButton(_ sender: Any) {
        updateInfo()
    }
    
    func addImageGesture(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageViewDidPressed))
        carImageView.isUserInteractionEnabled = true
        carImageView.addGestureRecognizer(tap)
    }
    
    @objc func imageViewDidPressed() {
        let configuration = PHPickerConfiguration()
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc func handleSwipes(sender:UISwipeGestureRecognizer) {
        switch sender.direction {
        case .left:
            self.tabBarController?.selectedIndex = (self.tabBarController?.selectedIndex ?? 0) + 1
        default: break
        }
    }
    private func closeKeyB(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tap)

    }
    
    private func setupInfoLabels(){
        if let imageData = model?.image {
            carImageView.image = UIImage(data: imageData)
        }
        
        mainInfoLabels[0].text = model?.model
        mainInfoLabels[1].text = model?.brand
        mainInfoLabels[2].text = model?.registrationPlate
        mileageUpdateTF.text = model?.mileage
        commentUpdateTF.text = model?.comment
        secondInfoFields[0].text = model?.typeVC
        secondInfoFields[1].text = model?.age
        secondInfoFields[2].text = model?.typeFuel
        secondInfoFields[3].text = model?.typeEngine
        secondInfoFields[4].text = model?.color

        secondInfoFields[0].inputView = pickerView
        secondInfoFields[1].inputView = pickerView
        secondInfoFields[2].inputView = pickerView
        secondInfoFields[3].inputView = pickerView
        secondInfoFields[4].inputView = pickerView
        
        mileageUpdateTF.layer.borderWidth = 1
        mileageUpdateTF.layer.cornerRadius = 8
        commentUpdateTF.layer.borderWidth = 1
        commentUpdateTF.layer.cornerRadius = 8
        
        secondInfoFields.forEach {
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 8
        }
        
    }
    private func updateInfo() {
        RealmManager.updating { [weak self] in
            self?.model?.mileage = self?.mileageUpdateTF.text
            self?.model?.comment = self?.commentUpdateTF.text
            self?.model?.typeVC = self?.secondInfoFields[0].text
            self?.model?.age = self?.secondInfoFields[1].text
            self?.model?.typeFuel = self?.secondInfoFields[2].text
            self?.model?.typeEngine = self?.secondInfoFields[3].text
            self?.model?.color = self?.secondInfoFields[4].text
            self?.model?.image = self?.carImageView.image?.jpegData(compressionQuality: 1)
        }
    }
}
extension InfoBarVC: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if secondInfoFields[0].isEditing{
            return arrayInfoCar.typeTVList.count
        } else if secondInfoFields[2].isEditing {
            return arrayInfoCar.typeFuelTVList.count
        } else if secondInfoFields[3].isEditing {
            return arrayInfoCar.typeEngineList.count
        } else if secondInfoFields[4].isEditing {
            return arrayInfoCar.colorTVList.count
        } else {
            return arrayInfoCar.ageTVList.count
        }
    }
}

extension InfoBarVC: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if secondInfoFields[0].isEditing {
            let row = arrayInfoCar.typeTVList[row]
            return row
        } else if secondInfoFields[2].isEditing {
            let row = arrayInfoCar.typeFuelTVList[row]
            return row
        } else if secondInfoFields[3].isEditing {
            let row = arrayInfoCar.typeEngineList[row]
            return row
        } else if secondInfoFields[4].isEditing {
            let row = arrayInfoCar.colorTVList[row]
            return row
        } else {
            let row = arrayInfoCar.ageTVList[row]
            return row
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if secondInfoFields[0].isEditing {
            
            secondInfoFields[0].text = arrayInfoCar.typeTVList[row]

//            secondInfoFields[0].endEditing(true)
            
        } else if secondInfoFields[2].isEditing {
            
            secondInfoFields[2].text = arrayInfoCar.typeFuelTVList[row]
//            secondInfoFields[2].endEditing(true)
            
        } else if secondInfoFields[3].isEditing {
            
            secondInfoFields[3].text = arrayInfoCar.typeEngineList[row]
//            secondInfoFields[3].endEditing(true)
            
        } else if secondInfoFields[4].isEditing {
            
            secondInfoFields[4].text = arrayInfoCar.colorTVList[row]
//            secondInfoFields[4].endEditing(true)
            
        } else {
            secondInfoFields[1].text = arrayInfoCar.ageTVList[row]
//            secondInfoFields[1].endEditing(true)

        }
        
    }
}
extension InfoBarVC: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        let itemProviders = results.map(\.itemProvider)
        for item in itemProviders {
            if item.canLoadObject(ofClass: UIImage.self) {
                item.loadObject(ofClass: UIImage.self) { (image, error) in
                    DispatchQueue.main.async {
                        if let image = image as? UIImage {
                            self.carImageView.image = image
                        }
                    }
                }
            }
        }
    }
}
