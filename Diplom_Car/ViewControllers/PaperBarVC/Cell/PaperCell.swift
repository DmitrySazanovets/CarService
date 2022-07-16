//
//  PaperCell.swift
//  Diplom_Car
//
//  Created by Дмитрий Сазановец on 7/11/22.
//

import UIKit

class PaperCell: UITableViewCell {
    
    weak var paper: TransportPaper? {
        didSet {
            setupInfo()
        }
    }
    
    @IBOutlet weak var typeDock: UILabel!
    @IBOutlet weak var beginTimeDock: UILabel!
    @IBOutlet weak var endTimeDock: UILabel!
    @IBOutlet weak var costDock: UILabel!
    @IBOutlet weak var commentDock: UILabel!
    
    private func setupInfo(){
        typeDock.text = paper?.typeDock
        beginTimeDock.text = paper?.beginDock
        endTimeDock.text = paper?.endDock
        costDock.text = paper?.costDock
        commentDock.text = paper?.commentDock
    }

}
