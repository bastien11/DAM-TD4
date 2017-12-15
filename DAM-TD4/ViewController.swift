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
    let image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
        
    }
}

struct Category {
    let name: String
    //let els : Array<Element>
    
    init(name: String){
        self.name = name
    }
}

class TableCell: UITableViewCell {
   
    @IBOutlet weak var cName: UILabel!
    @IBOutlet weak var eImage: UIImageView!
    @IBOutlet weak var eName: UILabel!
    
    func setImageUrl(urlStr: String) {
        URLSession.shared.dataTask(with: NSURL(string: urlStr)! as URL, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print(error ?? "No Error")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.eImage.image = image
            })
            
        }).resume()
    }
    
}

class ViewController: UIViewController {
    
    
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
                                "\(elImage)"
                                let element = Element(name: elName, image: elImage)
                                elems.append(element)
                            }
                        }
                    }
                }
                sleep(3)
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "second") as! TableViewController
                newViewController.categories = cats
                newViewController.elements = elems
                print(elems)
                self.present(newViewController, animated: true, completion: nil)
            })
        }).resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }


}

