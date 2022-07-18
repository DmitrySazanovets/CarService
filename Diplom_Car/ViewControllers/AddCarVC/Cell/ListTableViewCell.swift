//
//  ListTableViewCell.swift
//  Diplom_Car
//
//  Created by Дмитрий Сазановец on 6/12/22.
//

import UIKit



class ListTableViewCell: UITableViewCell {
    
    public var list: String? { didSet {
        listLabel.text = list
    }}

    @IBOutlet weak var listLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
