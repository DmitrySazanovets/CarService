//
//  ParcingJSON.swift
//  Diplom_Car
//
//  Created by Дмитрий Сазановец on 6/12/22.
//

import Foundation

//struct CarList: Decodable {
//    let id, name, group: String?
//    let list: [String: [String]]?
//}

struct CarList: Decodable {
    let list: [String: [String]]?
}


//func loadJson(filename fileName: String) -> [CarList]? {
//    if let path = Bundle.main.path(forResource: "cars", ofType: "json") {
//        do {
//            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
//            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
//            if let jsonResult = jsonResult as? Dictionary<String, AnyObject>, let person = jsonResult["person"] as? [Any] {
//                // do stuff
//            }
//        } catch {
//            // handle error
//        }
//        return nil
//    }
//}

func loadJson(fileName: String) -> CarList? {
   guard
        let url = Bundle.main.url(forResource: fileName, withExtension: "json"),
        let data = try? Data(contentsOf: url),
        let car = try? JSONDecoder().decode(CarList.self, from: data)
   else {
        return nil
   }

   return car
}

