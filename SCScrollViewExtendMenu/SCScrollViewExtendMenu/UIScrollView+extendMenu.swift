//
//  UIScrollView+extendMenu.swift
//  SCScrollViewExtendMenu
//
//  Created by sgcy on 15/9/14.
//  Copyright (c) 2015年 sgcy. All rights reserved.
//

import UIKit
public struct ExtendMenuElement{
    let image: UIImage
    let hightlighted: UIImage
    let text: String
}

private let MENU_HEIGHT:CGFloat = 90
private let SCREEN_WIDTH:CGFloat = UIScreen.mainScreen().bounds.size.width

public extension UIScrollView{
    
    public func addExtendMenuWithElements(elements:[ExtendMenuElement]){
        let menuView = ExtendMenuView();
        menuView.backgroundColor = UIColor.redColor()
        menuView.frame = CGRect(x: 0, y: -MENU_HEIGHT, width: SCREEN_WIDTH, height: MENU_HEIGHT);
        self.addSubview(menuView)
        menuView.setUp(elements)
    }

}