//
//  ServiceCell.swift
//  Diplom_Car
//
//  Created by Дмитрий Сазановец on 7/11/22.
//

import UIKit

class ServiceCell: UITableViewCell {
    
    weak var service: TransportService? {
        didSet {
            setupInfo()
        }
    }
    
    @IBOutlet private weak var typeService: UILabel!
    @IBOutlet private weak var mileageService: UILabel!
    @IBOutlet private weak var dateService: UILabel!
    @IBOutlet private weak var fullCost: UILabel!
    @IBOutlet private weak var costItem: UILabel!
    @IBOutlet private weak var costWork: UILabel!
    
    private func setupInfo() {
        typeService.text = service?.typeService
        mileageService.text = service?.mileageService
        dateService.text =  service?.dateService
        fullCost.text = service?.costFull
        costItem.text = service?.costItem
        costWork.text = service?.costWork
    }
}
