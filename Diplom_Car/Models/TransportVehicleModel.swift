//
//  TransportVehicleModel.swift
//  Diplom_Car
//
//  Created by Дмитрий Сазановец on 6/12/22.
//

import Foundation
import RealmSwift

class TransportVehicleModel: Object {
    @objc dynamic var isSelected = false
    
    @objc dynamic var model: String?
    @objc dynamic var brand: String?
    @objc dynamic var mileage: String?
    @objc dynamic var registrationPlate: String?
    @objc dynamic var comment: String?
    @objc dynamic var typeVC: String?
    @objc dynamic var age: String?
    @objc dynamic var typeFuel: String?
    @objc dynamic var typeEngine: String?
    @objc dynamic var color: String?
    @objc dynamic var image: Data?


    
    let services = RealmSwift.List<TransportService>()
    var papers = RealmSwift.List<TransportPaper>()

   convenience init(model: String? = nil,
                    brand: String? = nil,
                    mileage: String? = nil,
                    registrationPlate: String? = nil,
                    comment: String? = nil,
                    typeVC: String? = nil,
                    age: String? = nil,
                    typeFuel: String? = nil,
                    typeEngine: String? = nil,
                    color: String? = nil,
                    image: Data? = nil) {
       self.init()
       self.model = model
       self.brand = brand
       self.mileage = mileage
       self.registrationPlate = registrationPlate
       self.comment = comment
       self.typeVC = typeVC
       self.age = age
       self.typeFuel = typeFuel
       self.typeEngine = typeEngine
       self.color = color
       self.image = image
    }
}

class TransportService: Object {
    @objc dynamic var mileageService: String?
    @objc dynamic var typeService: String?
    @objc dynamic var dateService: String?
    @objc dynamic var costItem: String?
    @objc dynamic var costWork: String?
    @objc dynamic var costFull: String?
}
class TransportPaper: Object {
    @objc dynamic var typeDock: String?
    @objc dynamic var beginDock: String?
    @objc dynamic var endDock: String?
    @objc dynamic var costDock: String?
    @objc dynamic var commentDock: String?

}
