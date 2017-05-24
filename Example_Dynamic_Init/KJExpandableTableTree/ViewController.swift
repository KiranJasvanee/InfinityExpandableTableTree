//
//  ViewController.swift
//  KJExpandableTableTree
//
//  Created by KiranJasvanee on 05/12/2017.
//  Copyright (c) 2017 KiranJasvanee. All rights reserved.
//

import UIKit
import KJExpandableTableTree

class ViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    
    // KJ Tree instances -------------------------
    var arrayTree:[Parent] = []
    var kjtreeInstance: KJTree = KJTree()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let filepath: String? = Bundle.main.path(forResource: "Tree", ofType: "json")
        let url = URL(fileURLWithPath: filepath ?? "")
        
        var jsonData: Data?
        do {
            jsonData = try Data(contentsOf: url)
        }catch{
            print("error")
        }
        
        var jsonDictionary: NSDictionary?
        do {
            jsonDictionary = try JSONSerialization.jsonObject(with: jsonData!, options: .init(rawValue: 0)) as? NSDictionary
        }catch{
            print("error")
        }
        
        var arrayParents: NSArray?
        if let treeDictionary = jsonDictionary?.object(forKey: "Tree") as? NSDictionary {
            if let arrayOfParents = treeDictionary.object(forKey: "Parents") as? NSArray {
                arrayParents = arrayOfParents
            }
        }
        
        if let arrayOfParents = arrayParents {
            kjtreeInstance = KJTree(parents: arrayOfParents, childrenKey: "Children", idKey: "Id")
        }
        
        tableview.delegate = self
        tableview.dataSource = self
        tableview.rowHeight = UITableViewAutomaticDimension
        tableview.estimatedRowHeight = 44
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}



extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let total = kjtreeInstance.tableView(tableView, numberOfRowsInSection: section)
        return total
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let node = kjtreeInstance.cellIdentifierUsingTableView(tableView, cellForRowAt: indexPath)
        let indexTuples = node.index.components(separatedBy: ".")
        
        if indexTuples.count == 1  || indexTuples.count == 4 {
            
            // Parents
            let cellIdentifierParents = "ParentsTableViewCellIdentity"
            var cellParents: ParentsTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifierParents) as? ParentsTableViewCell
            if cellParents == nil {
                tableView.register(UINib(nibName: "ParentsTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifierParents)
                cellParents = tableView.dequeueReusableCell(withIdentifier: cellIdentifierParents) as? ParentsTableViewCell
            }
            cellParents?.cellFillUp(indexParam: node.index, tupleCount: indexTuples.count)
            cellParents?.selectionStyle = .none
            
            if node.state == .open {
                cellParents?.buttonState.setImage(UIImage(named: "minus"), for: .normal)
            }else if node.state == .close {
                cellParents?.buttonState.setImage(UIImage(named: "plus"), for: .normal)
            }else{
                cellParents?.buttonState.setImage(nil, for: .normal)
            }
            
            return cellParents!
            
        }else if indexTuples.count == 2{
            
            // Parents
            let cellIdentifierChilds = "Childs2ndStageTableViewCellIdentity"
            var cellChild: Childs2ndStageTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifierChilds) as? Childs2ndStageTableViewCell
            if cellChild == nil {
                tableView.register(UINib(nibName: "Childs2ndStageTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifierChilds)
                cellChild = tableView.dequeueReusableCell(withIdentifier: cellIdentifierChilds) as? Childs2ndStageTableViewCell
            }
            cellChild?.cellFillUp(indexParam: node.index)
            cellChild?.selectionStyle = .none
            
            if node.state == .open {
                cellChild?.buttonState.setImage(UIImage(named: "minus"), for: .normal)
            }else if node.state == .close {
                cellChild?.buttonState.setImage(UIImage(named: "plus"), for: .normal)
            }else{
                cellChild?.buttonState.setImage(nil, for: .normal)
            }
            
            return cellChild!
            
        }else if indexTuples.count == 3{
            
            // Parents
            let cellIdentifierChilds = "Childs3rdStageTableViewCellIdentity"
            var cellChild: Childs3rdStageTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifierChilds) as? Childs3rdStageTableViewCell
            if cellChild == nil {
                tableView.register(UINib(nibName: "Childs3rdStageTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifierChilds)
                cellChild = tableView.dequeueReusableCell(withIdentifier: cellIdentifierChilds) as? Childs3rdStageTableViewCell
            }
            cellChild?.cellFillUp(indexParam: node.index)
            cellChild?.selectionStyle = .none
            
            if node.state == .open {
                cellChild?.buttonState.setImage(UIImage(named: "minus"), for: .normal)
            }else if node.state == .close {
                cellChild?.buttonState.setImage(UIImage(named: "plus"), for: .normal)
            }else{
                cellChild?.buttonState.setImage(nil, for: .normal)
            }
            
            return cellChild!
            
        }else{
            // Childs
            // grab cell
            var tableviewcell = tableView.dequeueReusableCell(withIdentifier: "cellidentity")
            if tableviewcell == nil {
                tableviewcell = UITableViewCell(style: .default, reuseIdentifier: "cellidentity")
            }
            tableviewcell?.textLabel?.text = node.index
            tableviewcell?.backgroundColor = UIColor.yellow
            tableviewcell?.selectionStyle = .none
            return tableviewcell!
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let node = kjtreeInstance.tableView(tableView, didSelectRowAt: indexPath)
        print(node.index)
        print(node.keyIdentity)
        // if you've added any identifier or used indexing format
        print(node.givenIndex)
    }
}

