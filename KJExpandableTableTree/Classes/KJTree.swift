//
//  KJTreeView.swift
//  Expandable3
//
//  Created by MAC241 on 25/04/17.
//  Copyright © 2017 KiranJasvanee. All rights reserved.
//

import Foundation
import UIKit

public class KJTree{
    
    // Parent to child collection.
    fileprivate var arrayParents: [Parent] = []
    fileprivate var arrayVisibles: [Node] = []
    
    // Animation property
    public var animation: UITableViewRowAnimation = .fade
    
    public init() {
        
    }
    
    public init(Parents: [Parent]) {
        arrayParents = Parents
    }
    
    
    /*
     Parents, childs creation based on indecies -----------------------------------------------------------------------------------------
     */
    public init(indices: [String]) {
        
        for i in 0..<indices.count{
            
            // index to be processed
            let index = indices[i]
            
            // Components
            var components = index.components(separatedBy: ".")
            
            if arrayParents.contains(where: { $0.givenIndex == components.first }) {
                
                // if parent exists
                let position = arrayParents.index(where: { $0.givenIndex == components.first })
                components.removeFirst()
                let parent = self.arrayParents[position!]
                
                // if there are no subchilds, only a child inside parent.
                if components.count == 1 {
                    if !parent.arrayChilds.contains(where: {$0.givenIndex == components.first}) {
                        // create new child
                        let child = Child()
                        child.givenIndex = index
                        parent.arrayChilds.append(child)
                    }
                    //else considers - value already exists, leave this block blank. don't add again.
                }else{
                    // if there are subchilds.
                    let internalIndex = parent.givenIndex+"."+components.first!
                    if parent.arrayChilds.contains(where: {$0.givenIndex == internalIndex}) {
                        let position = parent.arrayChilds.index(where: { $0.givenIndex == internalIndex })
                        var child = parent.arrayChilds[position!]
                        child.givenIndex = internalIndex
                        components.removeFirst()
                        self.addChild(inChild: &child, components: &components, index: index)
                        
                    }else{
                        // create new child
                        var child = Child()
                        child.givenIndex = index
                        parent.arrayChilds.append(child)
                        components.removeFirst()
                        self.justAddChildsIn(inChild: &child, components: &components)
                    }
                }
            }else{
                // if parent not exists.
                let parent = Parent()
                parent.givenIndex = components.first!
                self.arrayParents.append(parent)
                components.removeFirst()
                
                guard components.count != 0 else {
                    continue
                }
                
                if components.count == 1 {
                    // create new child
                    let child = Child()
                    child.givenIndex = index
                    parent.arrayChilds.append(child)
                }else{
                    // create new child
                    let internalIndex = parent.givenIndex+"."+components.first!
                    var child = Child()
                    child.givenIndex = internalIndex
                    parent.arrayChilds.append(child)
                    components.removeFirst()
                    self.justAddChildsIn(inChild: &child, components: &components)
                }
            }
        }
    }
    func addChild(inChild:inout Child, components:inout [String], index: String) {
        
        // if there are no subchilds, only a child inside parent.
        if components.count == 1 {
            let internalIndex = inChild.givenIndex+"."+components.first!
            if !inChild.arrayChilds.contains(where: {$0.givenIndex == internalIndex}) {
                // create new child
                let child = Child()
                child.givenIndex = internalIndex
                inChild.arrayChilds.append(child)
            }
            //else considers - value already exists, leave this block blank. don't add again.
        }else{
            // if there are subchilds.
            let internalIndex = inChild.givenIndex+"."+components.first!
            if inChild.arrayChilds.contains(where: {$0.givenIndex == internalIndex}) {
                let position = inChild.arrayChilds.index(where: { $0.givenIndex == internalIndex })
                var child = inChild.arrayChilds[position!]
                child.givenIndex = internalIndex
                components.removeFirst()
                self.addChild(inChild: &child, components: &components, index: index)
                
            }else{
                // create new child
                var child = Child()
                child.givenIndex = internalIndex
                inChild.arrayChilds.append(child)
                components.removeFirst()
                self.justAddChildsIn(inChild: &child, components: &components)
            }
        }
    }
    func justAddChildsIn(inChild:inout Child, components:inout [String]) {
        if components.count == 1 {
            // create new child
            let internalIndex = inChild.givenIndex+"."+components.first!
            let child = Child()
            child.givenIndex = internalIndex
            inChild.arrayChilds.append(child)
        }else{
            // create new child
            let internalIndex = inChild.givenIndex+"."+components.first!
            var child = Child()
            child.givenIndex = internalIndex
            inChild.arrayChilds.append(child)
            components.removeFirst()
            self.justAddChildsIn(inChild: &child, components: &components)
        }
    }
    /*
     ----------------------------------------------------------------------------------------------------------------
     */
    
    
    
    /*
     Dynamic tree creation ------------------------------------------------------------------------------------------
     */
    public init(parents: NSArray, childrenKey: String, expandableKey: String? = nil, key: String? = nil) {
        
        for i in 0..<parents.count {
            
            let parent = parents[i] as? NSDictionary
            
            // if parent is not equal to nil
            guard let parentConfirmed = parent else{
                continue
            }
            
            // parent instance
            let parentInstance = Parent()
            
            // get key
            if let idKeyConfirmed = key {
                if let key = parentConfirmed.object(forKey: idKeyConfirmed) as? String {
                    parentInstance.key = key
                }else{
                    if let keyAny = parentConfirmed.object(forKey: idKeyConfirmed) {
                        parentInstance.key = "\(keyAny)"
                    }
                }
            }
            
            // check childs
            guard let childs = parentConfirmed.object(forKey: childrenKey) as? NSArray, childs.count != 0 else{
                arrayParents.append(parentInstance)
                continue
            }
            
            // Check expanded status
            if let expanded = parentConfirmed.object(forKey: expandableKey ?? "") as? Bool, expanded {
                parentInstance.isVisibility = true
            } else if let expanded = parentConfirmed.object(forKey: expandableKey ?? "") as? String, expanded.lowercased() == "true" {
                parentInstance.isVisibility = true
            }
            
            let childsAndExpandedState = self.addChildsInTree(childs: childs, childrenKey: childrenKey, expandableKey: expandableKey, key: key)
            parentInstance.arrayChilds = childsAndExpandedState.0
            if parentInstance.isVisibility {
                parentInstance.expandedRows = childsAndExpandedState.0.count + childsAndExpandedState.1
            }
            
            arrayParents.append(parentInstance)
        }
    }
    func addChildsInTree(childs: NSArray, childrenKey: String, expandableKey: String? = nil, key: String? = nil) -> ([Child], NSInteger){
        
        var arrayOfChilds: [Child] = []
        var countOfExpandableRows = 0
        
        for i in 0..<childs.count {
            
            let child = childs[i] as? NSDictionary
            
            // if parent is not equal to nil
            guard let childConfirmed = child else{
                continue
            }
            
            // get key
            let childInstance = Child()
            if let idKeyConfirmed = key {
                if let key = childConfirmed.object(forKey: idKeyConfirmed) as? String {
                    childInstance.key = key
                }else{
                    if let keyAny = childConfirmed.object(forKey: idKeyConfirmed) {
                        childInstance.key = "\(keyAny)"
                    }
                }
                
            }
            
            // check childs
            guard let childs = child?.object(forKey: childrenKey) as? NSArray, childs.count != 0 else{
                arrayOfChilds.append(childInstance)
                continue
            }
            
            // Check expanded status
            if let expanded = childConfirmed.object(forKey: expandableKey ?? "") as? Bool, expanded {
                childInstance.isVisibility = true
            } else if let expanded = childConfirmed.object(forKey: expandableKey ?? "") as? String, expanded.lowercased() == "true" {
                childInstance.isVisibility = true
            }
            
            // get visible childs
            let childsAndExpandedState = self.addChildsInTree(childs: childs, childrenKey: childrenKey, expandableKey: expandableKey, key: key)
            childInstance.arrayChilds = childsAndExpandedState.0
            if childInstance.isVisibility {
                childInstance.expandedRows = childsAndExpandedState.0.count + childsAndExpandedState.1
                countOfExpandableRows += childInstance.expandedRows
            }
            
            arrayOfChilds.append(childInstance)
        }
        
        return (arrayOfChilds, countOfExpandableRows)
    }
    /*
     ----------------------------------------------------------------------------------------------------------------
     */
    
    
    
    
    
    /*
     numberOfRowsInSection -----------------------------------------------------------------------------------------
     */
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> NSInteger {
        
        arrayVisibles.removeAll() // remove all objects first
        
        for i in 0..<arrayParents.count {
            
            // get parent instance and check childs of it, if yes go through it?
            let parent = arrayParents[i]
            
            let node = Node(index: "\(i)", id: parent.key, givenIndex: parent.givenIndex)
            arrayVisibles.append(node)
            
            var currentState: State = .none // State decision open, close or none.
            if parent.isVisibility {
                if parent.arrayChilds.count != 0{
                    currentState = .open
                    self.calculateVisibileChilds(parentIndex: "\(i)", arrayChilds: parent.arrayChilds)
                }
            }else{
                if parent.arrayChilds.count != 0{
                    currentState = .close
                }
            }
            
            node.state = currentState
        }
        
        return arrayVisibles.count
    }
    func calculateVisibileChilds(parentIndex: String, arrayChilds: [Child]){
        
        for i in 0..<arrayChilds.count {
            
            // get child instance
            let child = arrayChilds[i]
            
            let childIndex = parentIndex + ".\(i)"
            
            let node = Node(index: childIndex, id: child.key, givenIndex: child.givenIndex)
            node.index = childIndex
            arrayVisibles.append(node)
            
            var currentState: State = .none // State decision open, close or none.
            if child.isVisibility {
                if child.arrayChilds.count != 0{
                    currentState = .open
                    self.calculateVisibileChilds(parentIndex: childIndex, arrayChilds: child.arrayChilds)
                }
            }else{
                if child.arrayChilds.count != 0{
                    currentState = .close
                }
            }
            
            node.state = currentState
        }
    }
    /*
     ----------------------------------------------------------------------------------------------------------------
     */
    
    
    
    /*
     cellIdentifierUsingTableView -----------------------------------------------------------------------------------
     */
    public func cellIdentifierUsingTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> Node{
        return arrayVisibles[indexPath.row]
    }
    /*
     ----------------------------------------------------------------------------------------------------------------
     */
    
    
    /*
     cellIdentifierUsingTableView -----------------------------------------------------------------------------------
     */
    enum ExpansionOption {
        case expand, shrink, none
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) -> Node{
        
        let node = arrayVisibles[indexPath.row]
        var cellsToBeUpdated: [NSInteger] = []
        var indices = node.index.components(separatedBy: ".")
        var expansion: ExpansionOption = .none
        
        /*
         
         This works based on . (point) system. if I'm receiving selected index 2 indicates, 3rd row tapped. If I'm receiving 2.0 indicates 0th child in 3rd row tapped. and if I'm receiving 1.2.1 indicates 2nd row -> 3rd child -> 2nd subchild tapped.
         */
        
        if indices.count == 1{
            
            // Why this block?
            // This block will be executed when selected index belongs to parent. Suppose selected index is 2, indicates 3rd parent row selected. For 2.1, 2.0, 2.1.1 or 2.1.4.2 else (child) block will be called.
            
            // get parent instance
            let parent = arrayParents[(indices.first?.integerValue())!]
            
            // if childs are visible, invisible those. and if they are invisible, visible those.
            if parent.isVisibility {
                parent.isVisibility = false
                expansion = .shrink
            }else{
                parent.isVisibility = true
                expansion = .expand
            }
            
            // Go further if there are childs available
            guard parent.arrayChilds.count != 0 else{
                return node
            }
            
            // Expand
            if expansion == .expand {
                // for expansion, append childs of parent, we about to insert this rows in visible list.
                for i in 1...parent.arrayChilds.count{
                    cellsToBeUpdated.append(indexPath.row+i)
                }
                
                
                // Check no. of rows kept default as expanded!
                let lastValue = cellsToBeUpdated.last
                let countOfExpandedRowsInsideTheseChilds = self.detectVisibleSubCells(parent.arrayChilds)
                if countOfExpandedRowsInsideTheseChilds != 0{
                    for i in 1...countOfExpandedRowsInsideTheseChilds {
                        cellsToBeUpdated.append(lastValue! + i)
                    }
                }
                
                // total no. of rows expanded
                parent.expandedRows = cellsToBeUpdated.count
            }else{
                // Shrink
                // for shrink also, append childs of parent, because we about to delete this rows from visible list.
                for i in 1...parent.expandedRows {
                    cellsToBeUpdated.append(indexPath.row+i)
                }
                parent.expandedRows = 0
                self.closeAllVisibleCells(childs: parent.arrayChilds)
            }
        }else{
            // get parent instance and check there are any childs of it, if yes go through it?
            let parent = arrayParents[(indices.first?.integerValue())!]
            indices.removeFirst()
            
            // openNoOfChilds holds no of childs open inside parent. which ultimatey added/removed (based on expansion and shrinking) to expandableRows property of parent. Same will be done at childs to childs.
            let openNoOfChilds = self.visibleChilds(childs: parent.arrayChilds, indices: &indices, index: indexPath.row, cellsUpdatedHolder: &cellsToBeUpdated, expansionOption: &expansion)
            if expansion == .expand {
                parent.expandedRows += openNoOfChilds
            }else{
                parent.expandedRows -= openNoOfChilds
            }
        }
        
        // get indexpath about to insert/remove cells
        var indexpathsInserted: [IndexPath] = []
        // for effects of plus, minus or none based on expand, shrink.
        var updateStateOfRow: NSInteger = -1
        
        
        for row in cellsToBeUpdated {
            // access previous cell, which we will update with effect of plus, minus or none.
            if updateStateOfRow == -1{
                updateStateOfRow = row-1
            }
            let indexpath: IndexPath = IndexPath(row: row, section: 0)
            indexpathsInserted.append(indexpath)
        }
        if expansion == .expand {
            // Insert rows
            tableView.insertRows(at: indexpathsInserted, with: animation)
        }else{
            // remove rows
            tableView.deleteRows(at: indexpathsInserted, with: animation)
        }
        // indicates there is some expansion or shrinking by updating previous cell with plus, minus or none.
        if updateStateOfRow != -1 {
            let indexpath: IndexPath = IndexPath(row: updateStateOfRow, section: 0)
            tableView.reloadRows(at: [indexpath], with: .none)
        }
        
        
        return node
    }
    func visibleChilds(childs: [Child], indices:inout [String], index: NSInteger, cellsUpdatedHolder cellsToBeUpdated:inout [NSInteger], expansionOption expansion: inout ExpansionOption) -> NSInteger {
        
        if indices.count == 1{
            
            // Why this block?
            // This block will be executed when selected index belongs to any child. Suppose selected index is 2.1, indicates 2nd child row of 3rd parent. Here, we won't get parent index, we will get index of child -> subChilds -> further.
            // In above given example, we will get 1 from 2.1, means 2nd child, which will be processed as below.
            // Or if you want to consider a new example, suppose 1.2.1, we will receive 2.1 in this function, whereas else block will be called to perform recursion by removing 2.
            
            let child = childs[(indices.first?.integerValue())!]
            if child.isVisibility {
                child.isVisibility = false
                expansion = .shrink
            }else{
                child.isVisibility = true
                expansion = .expand
            }
            
            // Go further if there are childs available
            guard child.arrayChilds.count != 0 else{
                return 0
            }
            
            // Expand
            if expansion == .expand {
                // for expansion, append subChilds of child, we about to insert this rows in visible list.
                for i in 1...child.arrayChilds.count{
                    cellsToBeUpdated.append(index+i)
                }
                
                // Check no. of rows kept default as expanded!
                let lastValue = cellsToBeUpdated.last
                let countOfExpandedRowsInsideTheseChilds = self.detectVisibleSubCells(child.arrayChilds)
                if countOfExpandedRowsInsideTheseChilds != 0{
                    for i in 1...countOfExpandedRowsInsideTheseChilds {
                        cellsToBeUpdated.append(lastValue! + i)
                    }
                }
                
                // total no. of rows expanded
                child.expandedRows = cellsToBeUpdated.count
                return cellsToBeUpdated.count
            }else{
                // Shrink
                
                // for shrink also, append subChilds of child, because we about to delete this rows from visible list.
                for i in 1...child.expandedRows {
                    cellsToBeUpdated.append(index+i)
                }
                
                let expandableRows = child.expandedRows
                child.expandedRows = 0
                self.closeAllVisibleCells(childs: child.arrayChilds)  // Close all visible childs of shrinking child/parent.
                return expandableRows
                // Why expandable rows should be returned, because you expanded up to 4th level, and you pressed 2nd level to close 3rd and 4th both. So sending 2nd level childs will only contain 3rd level cells not 4th level, whereas expandable rows will contains all the sublevels.
            }
        }else{
            let child = childs[(indices.first?.integerValue())!]
            indices.removeFirst()
            let openNoOfChilds = self.visibleChilds(childs: child.arrayChilds, indices: &indices, index: index, cellsUpdatedHolder: &cellsToBeUpdated, expansionOption: &expansion)
            if expansion == .expand {
                child.expandedRows += openNoOfChilds
            }else{
                child.expandedRows -= openNoOfChilds
            }
            return openNoOfChilds
        }
    }
    func detectVisibleSubCells(_ childs: [Child]) -> NSInteger{
        var count = 0
        for child in childs{
            if child.isVisibility {
                count += child.arrayChilds.count + self.detectVisibleSubCells(child.arrayChilds)
            }
        }
        return count
    }
    func closeAllVisibleCells(childs: [Child]) {
        for child in childs {
            child.isVisibility = false
            child.expandedRows = 0
            
            // Indicates there are childs
            if child.arrayChilds.count != 0{
                self.closeAllVisibleCells(childs: child.arrayChilds)
            }
        }
    }
    
    /*
     ----------------------------------------------------------------------------------------------------------------
     */
    
    
    
    
    public var isInitiallyExpanded = false {
        didSet {
            if isInitiallyExpanded {
                self.expandAllInitiallly()
            }
        }
    }
    
    func expandAllInitiallly() {
        
        for parent in arrayParents {
            
            parent.isVisibility = true
            let count = parent.arrayChilds.count + parent.makeAllChildsExpanded(parent.arrayChilds)
            parent.expandedRows = count
        }
    }
    
    
}

extension String {
    func integerValue() -> NSInteger {
        return (self as NSString).integerValue
    }
}

public enum State{
    case open, close, none
}


public class Node {
    
    fileprivate var arrayChilds: [Child] = []
    
    // identity key
    public var key: String = ""
    
    // Private instances
    fileprivate var isVisibility = false    // This will visible or invisible no of rows based on selection.
    fileprivate var expandedRows = 0        // This will hold a total of visible rows under it.
    
    // Indecies helper property
    public var index = "-1"
    
    // public instances
    public var state: State = .none
    public var id: String = ""
    public var givenIndex: String = ""
    
    public init() {
        
    }
    public init(index: String, id: String, givenIndex: String) {
        self.index = index
        self.id = id
        self.key = id
        self.givenIndex = givenIndex
    }
    
    func grabTotalDefaultExpandedRowsCount(_ childs: [Child]) -> NSInteger {
        var count = 0
        for child in childs {
            if child.isVisibility {
                count = child.arrayChilds.count + self.grabTotalDefaultExpandedRowsCount(child.arrayChilds)
            }
        }
        return count
    }
    
    func makeAllChildsExpanded(_ childs: [Child]) -> NSInteger {
        var count = 0
        for child in childs {
            if child.arrayChilds.count > 0 {
                child.isVisibility = true
                let childCount = child.arrayChilds.count + self.makeAllChildsExpanded(child.arrayChilds)
                child.expandedRows = childCount
                count += childCount
            }
        }
        return count
    }
}

public class Parent: Node{
    
    public override init() {
        super.init()
    }
    public init(expanded: Bool = false, childs: () -> [Child]) {
        super.init()
        super.arrayChilds = childs()
        super.isVisibility = expanded
        if expanded {
            let count = childs().count + super.grabTotalDefaultExpandedRowsCount(childs())
            super.expandedRows = count
        }
        // print(arrayChilds)
    }
    
    public init(key: String){
        super.init()
        super.key = key
    }
    public init(key: String ,expanded: Bool = false, childs: () -> [Child]) {
        super.init()
        super.key = key
        super.arrayChilds = childs()
        super.isVisibility = expanded
        if expanded {
            let count = childs().count + super.grabTotalDefaultExpandedRowsCount(childs())
            super.expandedRows = count
        }
        // print(arrayChilds)
    }
}
public class Child: Node{
    
    public override init() {
        super.init()
    }
    public init(expanded: Bool = false, subChilds: () -> [Child]) {
        super.init()
        super.arrayChilds = subChilds()
        
        // Check expanded status
        super.isVisibility = expanded
        if expanded {
            let count = subChilds().count + super.grabTotalDefaultExpandedRowsCount(subChilds())
            super.expandedRows = count
        }
    }
    public init(key: String){
        super.init()
        super.key = key
    }
    public init(key: String, expanded: Bool = false, subChilds: () -> [Child]) {
        super.init()
        super.key = key
        super.arrayChilds = subChilds()
        
        // Check expanded status
        super.isVisibility = expanded
        if expanded {
            let count = subChilds().count + super.grabTotalDefaultExpandedRowsCount(subChilds())
            super.expandedRows = count
        }
    }
}










