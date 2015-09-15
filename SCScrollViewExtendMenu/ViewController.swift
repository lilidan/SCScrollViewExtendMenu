//
//  ViewController.swift
//  SCScrollViewExtendMenu
//
//  Created by sgcy on 15/9/14.
//  Copyright (c) 2015年 sgcy. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
    
    @IBOutlet weak var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addExtendMenuWithElements([generateElement(),generateElement(),generateElement(),generateElement(),generateElement()])
    }

    func generateElement()->ExtendMenuElement{
        return ExtendMenuElement(image:UIImage(),hightlighted:UIImage(),text:"btn")
    }
    
    
}

