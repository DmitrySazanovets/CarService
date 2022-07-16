//
//  PaperBarVC.swift
//  Diplom_Car
//
//  Created by Дмитрий Сазановец on 6/5/22.
//

import UIKit

class PaperBarVC: UIViewController {
    
    private let vechicleModel = RealmManager.read(type: TransportVehicleModel.self).first(where: { $0.isSelected })
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emptyLabel.isHidden = !(vechicleModel?.services.isEmpty ?? true) ? true : false
        tableView.rowHeight = 70
        setupTableView()
    }
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: String(describing: PaperCell.self), bundle: nil), forCellReuseIdentifier: String(describing: PaperCell.self))
    }
    
    @IBAction func addDockButtonAction(_ sender: Any) {
        let vc = AddPaperVC(nibName: String(describing: AddPaperVC.self), bundle: nil)
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    

}
extension PaperBarVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vechicleModel?.papers.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PaperCell.self), for: indexPath) as? PaperCell else {
            return UITableViewCell()
        }
        
        cell.paper = vechicleModel?.papers[indexPath.row]
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.cell
//        RealmManager.delete(object: TransportPaper[indexPath.row])
        }
    
    
}

extension PaperBarVC: AddPaperVCDelegate {
    func paperDidSaved() {
        tableView.reloadData()
    }
}
