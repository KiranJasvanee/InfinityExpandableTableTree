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
    
    // KJ Tree instances -------------------------
    var arrayTree:[Parent] = []
    var kjtreeInstance: KJTree = KJTree()
    
    // Tableview instance
    @IBOutlet weak var tableview: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        kjtreeInstance = KJTree(indices:
            ["1.1",
             
             "2.1.1",
             "2.1.2.1",
             "2.1.3.2",
             "2.1.3.3",
             
             
             "3.1",
             "3.2",
             "3.3"]
        )
        
        
        tableview.dataSource = self
        tableview.delegate = self
        tableview.rowHeight = UITableViewAutomaticDimension
        tableview.estimatedRowHeight = 44
        tableview.tableFooterView = UIView(frame: .zero)
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
        
        if node.givenIndex == "1" || node.givenIndex == "2" || node.givenIndex == "3"{
            
            let cellIdentifier = "_dot1_TableViewCellIdentity"
            var cell: _dot1_TableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? _dot1_TableViewCell
            if cell == nil {
                tableView.register(UINib(nibName: "_dot1_TableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
                cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? _dot1_TableViewCell
            }
            cell?.cellFillUp(indexParam: node.givenIndex)
            cell?.selectionStyle = .none
            
            if node.state == .open {
                cell?.buttonState.setImage(UIImage(named: "minus"), for: .normal)
            }else if node.state == .close {
                cell?.buttonState.setImage(UIImage(named: "plus"), for: .normal)
            }else{
                cell?.buttonState.setImage(nil, for: .normal)
            }
            
            return cell!
        }
        
        if node.givenIndex == "1.1" {
            
            
            let cellIdentifier = "index_1_1_TableViewCellIdentity"
            var cell: index_1_1_TableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? index_1_1_TableViewCell
            if cell == nil {
                tableView.register(UINib(nibName: "index_1-1_TableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
                cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? index_1_1_TableViewCell
            }
            cell?.cellFillUp(indexParam: node.givenIndex)
            cell?.selectionStyle = .none
            
            return cell!
        }
        
        if node.givenIndex == "2.1" || node.givenIndex == "2.1.2" || node.givenIndex == "2.1.3"{
            
            
            let cellIdentifier = "index_2_1_TableViewCellIdentity"
            var cell: index_2_1_TableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? index_2_1_TableViewCell
            if cell == nil {
                tableView.register(UINib(nibName: "index_2_1_TableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
                cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? index_2_1_TableViewCell
            }
            cell?.selectionStyle = .none
            
            if node.givenIndex == "2.1" {
                cell?.imageviewBackground.image = UIImage(named: "expand_me")
            }else if node.givenIndex == "2.1.2" {
                cell?.imageviewBackground.image = UIImage(named: "more_expansion")
            }else if node.givenIndex == "2.1.3" {
                cell?.imageviewBackground.image = UIImage(named: "more_expansion_2")
            }
            
            if node.state == .open {
                cell?.buttonState.setImage(UIImage(named: "minus"), for: .normal)
            }else if node.state == .close {
                cell?.buttonState.setImage(UIImage(named: "plus"), for: .normal)
            }else{
                cell?.buttonState.setImage(nil, for: .normal)
            }
            
            return cell!
        }
        
        if node.givenIndex == "2.1.1" {
            let cellIdentifier = "stepperTableViewCell"
            var cell: stepperTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? stepperTableViewCell
            if cell == nil {
                tableView.register(UINib(nibName: "stepperTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
                cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? stepperTableViewCell
            }
            cell?.selectionStyle = .none
            
            return cell!
        }
        
        if node.givenIndex == "2.1.2.1" {
            let cellIdentifier = "segmentTableViewCell"
            var cell: segmentTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? segmentTableViewCell
            if cell == nil {
                tableView.register(UINib(nibName: "segmentTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
                cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? segmentTableViewCell
            }
            cell?.selectionStyle = .none
            
            return cell!
        }
        
        if node.givenIndex == "2.1.3.2" {
            let cellIdentifier = "sliderTableViewCell"
            var cell: sliderTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? sliderTableViewCell
            if cell == nil {
                tableView.register(UINib(nibName: "sliderTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
                cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? sliderTableViewCell
            }
            cell?.selectionStyle = .none
            
            return cell!
        }
        
        if node.givenIndex == "2.1.3.3" {
            let cellIdentifier = "progressbarTableViewCell"
            var cell: progressbarTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? progressbarTableViewCell
            if cell == nil {
                tableView.register(UINib(nibName: "progressbarTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
                cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? progressbarTableViewCell
            }
            cell?.selectionStyle = .none
            
            return cell!
        }
        
        
        let cellIdentifier = "index_3_Leaf_TableViewCell"
        var cell: index_3_Leaf_TableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? index_3_Leaf_TableViewCell
        if cell == nil {
            tableView.register(UINib(nibName: "index_3_Leaf_TableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
            cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? index_3_Leaf_TableViewCell
        }
        cell?.selectionStyle = .none
        cell?.labelIndex.text = "Index: \(node.givenIndex)"
        
        return cell!

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let node = kjtreeInstance.tableView(tableView, didSelectRowAt: indexPath)
        print(node.index)
        // if you've added any identifier or used indexing format
        print(node.givenIndex)
    }
}

