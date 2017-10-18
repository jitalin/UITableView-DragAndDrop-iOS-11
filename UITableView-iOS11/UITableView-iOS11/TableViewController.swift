//
//  TableViewController.swift
//  UITableView-iOS11
//
//  Created by 高飞 on 2017/10/17.
//  Copyright © 2017年 高飞. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController,UITableViewDragDelegate,UITableViewDropDelegate {
 
    var images = [#imageLiteral(resourceName: "actor1"), #imageLiteral(resourceName: "actor2"), #imageLiteral(resourceName: "actor3"), #imageLiteral(resourceName: "actor4"), #imageLiteral(resourceName: "actor5"), #imageLiteral(resourceName: "actor6"), #imageLiteral(resourceName: "actor7")]
   
    

    override func viewDidLoad() {
        super.viewDidLoad()
 
      
    
        tableView.separatorInsetReference = .fromAutomaticInsets
    
        tableView.dragDelegate = self
        //YES on iPad and NO on iPhone.
        tableView.dragInteractionEnabled = true
        tableView.dropDelegate = self
        tableView.register(ImageTableViewCell.self, forCellReuseIdentifier: "ImageTableViewCell")
}
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell", for: indexPath) as! ImageTableViewCell
        cell.mainImageView.image = images[indexPath.row]
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
//    if cell == nil {
//        cell = UITableViewCell.init(style: .value1, reuseIdentifier: "cell")
//
//    }
//    cell?.textLabel?.text = "jkljfl二二二恶人尔尔儿4让4他tertiary人regret个个人g"
//    cell?.textLabel?.numberOfLines = 0
//    cell?.detailTextLabel?.text = String(indexPath.row)
//
//
//    return cell!
//
//}
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print(indexPath.row)
    
}
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
}
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    return true
}
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//    //iOS11+ 自适应高度
//    return UITableViewAutomaticDimension
//}
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.width
    }
    //MARK:UITableViewDragDelegate
    //MARK:开始拖动
func tableView(_ tableView: UITableView, dragSessionWillBegin session: UIDragSession) {
    print("dragSessionWillBegin")
}
        //MARK:结束拖动
func tableView(_ tableView: UITableView, dragSessionDidEnd session: UIDragSession) {
    print("dragSessionDidEnd")
}
     //MARK:拖动项的设置
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return dragItems(forRow: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        return dragItems(forRow: indexPath.row)
    }
    //MARK:选中要拖动时候的预览图
    func tableView(_ tableView: UITableView, dragPreviewParametersForRowAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        let parameters = UIDragPreviewParameters()
        let rect = CGRect(x: 0,
                          y: 0,
                          width: tableView.bounds.width,
                          height: tableView.bounds.width)
        parameters.visiblePath = UIBezierPath(roundedRect: rect,
                                              cornerRadius: tableView.bounds.width/2)
//        parameters.visiblePath = UIBezierPath(roundedRect: rect,
//                                              cornerRadius: 20)
        return parameters
    }
    
    private func dragItems(forRow row: Int) -> [UIDragItem] {
        let image = images[row]
        let itemProvider = NSItemProvider(object: image)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = image
        return [dragItem]
    }
    //MARK:UITableViewDropDelegate
    func tableView(_ tableView: UITableView, dropSessionDidEnd session: UIDropSession) {
        print("dropSessionDidEnd")
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, dropSessionDidExit session: UIDropSession) {
              print("dropSessionDidExit")
    }
    func tableView(_ tableView: UITableView, dropSessionDidEnter session: UIDropSession) {
               print("dropSessionDidEnter")
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
     return   UITableViewDropProposal.init(operation: .copy, intent: .automatic)
    }
    //MARK:可以处理drop后的动作,
    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        //呈现原来的占位图片被拖走的效果
        return session.canLoadObjects(ofClass: UIImage.self)
        
    }
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        var destinationIndexPath: IndexPath!

        print(coordinator.destinationIndexPath ?? 2)

        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            let section = tableView.numberOfSections - 1
            let row = tableView.numberOfRows(inSection: section)
            destinationIndexPath = IndexPath(row: row, section: section)
        }

   
        coordinator.session.loadObjects(ofClass: UIImage.self) { items in
            guard let pickedImages = items as? [UIImage] else { return }

            for (index, image) in pickedImages.enumerated() {
                let indexPath = IndexPath(row: destinationIndexPath.row + index, section: destinationIndexPath.section)
                UIView.animate(withDuration: 0.3, animations: {
                    self.images.insert(image, at: index)
                    tableView.reloadData()
                    
                })
            }
     
          
        }

    
     
    }
                
}
