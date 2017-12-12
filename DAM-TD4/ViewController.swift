//
//  ViewController.swift
//  DAM-TD4
//
//  Created by Bastien Scherrer on 11/12/2017.
//  Copyright © 2017 Bastien Scherrer. All rights reserved.
//

import UIKit
import SWXMLHash

struct Element {
    let name : String
    let image: URL
}

struct Category {
    let name: String
    //let els : Array<Element>
}

class TableCell: UITableViewCell {
   
    @IBOutlet weak var cName: UILabel!
    @IBOutlet weak var eImage: UIImageView!
    @IBOutlet weak var eName: UILabel!
    
}

class ViewController: UIViewController {
    
    var catController = TableViewController()
    
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        let url = "http://fairmont.lanoosphere.com/mobile/getdata?lang=en"
        URLSession.shared.dataTask(with: NSURL(string: url)! as URL, completionHandler: {(data, response, error) -> Void in
            if(error != nil) {
                print(error ?? "No error")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let xml = SWXMLHash.parse(data!)
                var cats = [Category]()
                var elems = [Element]()
                for elem in xml["data"]["categories"]["category"].all{
                    //print(elem["category"])
                    if let name = elem.element?.attribute(by: "name")?.text{
                        "\(name)"
                        let category = Category(name: name)
                        cats.append(category)
                        
                        for el in elem["element"].all{
                            if let elName = el.element?.attribute(by: "name")?.text, let elImage = el.element?.attribute(by: "image")?.text{
                                "\(elName)"
//                                print(elName)
                                if let elImageURL = URL(string: elImage){
                                    "\(elImageURL)"
                                    let element = Element(name: elName, image: elImageURL)
                                    elems.append(element)
                                    
                                }
                            }
                        }
                    }
                }
                let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "second") as! TableViewController
                secondViewController.categories = cats
                self.navigationController?.pushViewController(secondViewController, animated: true)
            })
        }).resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }


}

