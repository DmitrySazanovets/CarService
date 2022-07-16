//
//  GarageCell.swift
//  Diplom_Car
//
//  Created by Дмитрий Сазановец on 6/4/22.
//

import UIKit

class GarageCell: UITableViewCell {
    
    weak var model: TransportVehicleModel? { didSet {
        setupInfo(model)
    }}

    @IBOutlet weak var modelName: UILabel!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var registrationPlate: UILabel!
    @IBOutlet weak var imageCarNat: UIImageView!
    @IBOutlet weak var mileage: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    private func setupInfo(_ model: TransportVehicleModel?) {
        guard let modelTransport = model?.model,
              let brand = model?.brand else {
            return
        }
        
        modelName.text = "\(modelTransport) \(brand)"
        registrationPlate.text = model?.registrationPlate
        mileage.text = model?.mileage
        comment.text = model?.comment
    }
    
}
