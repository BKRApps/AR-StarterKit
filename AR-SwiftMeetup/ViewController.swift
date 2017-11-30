//
//  ViewController.swift
//  AR-SwiftMeetup
//
//  Created by Birapuram Kumar Reddy on 11/30/17.
//  Copyright © 2017 KRiOSApps. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var items = [Item]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let item1 = Item(name: "Placing Objects", description: "In this example we are going to place the objects in front of the camera. Just tap on the screen, you will be able to see a new object in front of your camera", type: .PlacingObjects)
        items.append(item1)
        let item2 = Item(name: "Plane Detection", description: "In this example we will detect the horizontal planes like tea tables, floors, etc. Once it detects , we will place the objects on the detected plane.", type: .PlaneDetection)
        items.append(item2)
        let item3 = Item(name: "Plane Detection", description: "In this example we will detect the horizontal planes like tea tables, floors, etc. Once it detects , we will place 3D models on the detected plane.", type: .PlaneDectionAnd3DModels)
        items.append(item3)
    }
}

extension ViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemCell
        let item = items[indexPath.row]
        cell.name.text = item.name
        cell.desc.text = item.description
        return cell
    }
}

extension ViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        var viewController:UIViewController
        switch item.type{
        case .PlacingObjects:
            viewController = PlacingObjectsViewController.getViewController()
        case .PlaneDetection:
            viewController = PlaneDetectionViewController.getViewController()
        case .PlaneDectionAnd3DModels:
            viewController = PlaneDetection2ViewController.getViewController()
        }
        navigationController?.pushViewController(viewController, animated: true)
    }
}


struct Item {
    let name:String
    let description:String
    let type:ExampleType
}

enum ExampleType {
    case PlacingObjects
    case PlaneDetection
    case PlaneDectionAnd3DModels
}

class ItemCell:UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var desc: UILabel!

}

