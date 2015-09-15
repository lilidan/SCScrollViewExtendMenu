//
//  ExtendMenuView.swift
//  SCScrollViewExtendMenu
//
//  Created by sgcy on 15/9/14.
//  Copyright (c) 2015年 sgcy. All rights reserved.
//

import UIKit
class ExtendMenuView: UIView,UIGestureRecognizerDelegate
{
    
    let SHOW_TRIGGER_POINT:CGFloat = -20
    
    var elements:[ExtendMenuElement]!

    func setUp(elements:[ExtendMenuElement])
    {
        assert(self.superview!.isKindOfClass(UIScrollView), "must be UIScrollView")
      
        self.elements = elements
        
        self.superview!.addObserver(self, forKeyPath:"contentOffset", options: NSKeyValueObservingOptions.New, context: &mycontext)
        
        panGr = UIPanGestureRecognizer(target: self, action:"pan:")
        panGr.cancelsTouchesInView = false
        panGr.delegate = self
        self.superview!.addGestureRecognizer(panGr)
        
        let scrollViewPanGr:UIGestureRecognizer = self.superview!.gestureRecognizers![0] as! UIGestureRecognizer
        scrollViewPanGr.delegate = self
    }
    
   
    // MARK: - actions

    func showElementsViews()
    {
        if self.subviews.count > 0{
            return
        }
        
        
        let elementWidth = self.frame.size.width / CGFloat(elements.count)
        for index in 0...elements.count-1
        {
            let elementView = UIView(frame: CGRect(x: CGFloat(index) * elementWidth, y: -self.frame.size.height*2, width: elementWidth, height: self.frame.size.height))
            self.addSubview(elementView)
            
            var imgframe = elementView.bounds
            imgframe.size.height = imgframe.width
            let imgView = UIImageView(frame: imgframe)
            imgView.image = elements[index].image
            elementView.addSubview(imgView)
            imgView.backgroundColor = UIColor.lightGrayColor()
            
            var labelFrame = elementView.bounds
            labelFrame.size.height = labelFrame.height - labelFrame.width
            labelFrame.origin.y = labelFrame.width
            let label = UILabel(frame: labelFrame)
            label.text = elements[index].text
            label.font = UIFont.systemFontOfSize(13)
            label.textAlignment = NSTextAlignment.Center
            elementView.addSubview(label)
            
            let delay:Double = Double(index) * 0.1
            UIView.animateWithDuration(0.2, delay:delay, usingSpringWithDamping: 0.7, initialSpringVelocity: 20, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                elementView.frame.origin.y = 0
            }, completion: nil)
        }
    }
    
    func stickElementsViews(contentOffsetY:CGFloat)
    {
        self.frame.origin.y = -self.frame.size.height - (-contentOffsetY - self.frame.size.height)*2/3
    }
    
    func removeElementsViews()
    {
        if self.subviews.count == 0{
            return
        }

        for view in self.subviews as! [UIView]
        {
            view.removeFromSuperview()
        }
    }
    
    func toggleElementView(trans:CGFloat)
    {
        let width = self.frame.size.width /  CGFloat(self.subviews.count)
        let index = Int(trans / width)
        
        currentIndex =  originIndex + index
        
        if currentIndex < 0
        {
            currentIndex == 0
        }
        else if currentIndex > self.subviews.count - 1
        {
            currentIndex = self.subviews.count - 1
        }
        setUpElementView(currentIndex)
    }
    
    func setUpElementView(index:Int)
    {
        currentIndex = index
        for index in 0...self.subviews.count-1
        {
            if let view = self.subviews[index] as? UIView
            {
                view.backgroundColor = (index == currentIndex ? UIColor.yellowColor() : UIColor.clearColor())
            }
        }
    }
    
    private var currentIndex = 0
    private var originIndex = 0

    // MARK: - panGr
    
    private var panGr:UIPanGestureRecognizer!
    
    func pan(panGr:UIPanGestureRecognizer)
    {
        if self.subviews.count == 0
        {
            return
        }
        
        if panGr.state == UIGestureRecognizerState.Ended
        {
            originIndex = currentIndex
        }
        else
        {
        toggleElementView(panGr.translationInView(self.superview!).x)
        }
    }
    
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
    // MARK: - handle scrollView
    
    private var mycontext = 0
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>)
    {
        if object as? NSObject == self.superview && context == &mycontext
        {
            let scrollView = self.superview as! UIScrollView
            scrollViewDidScroll(scrollView)
        }
    }
    
    private var lastContentOffsetY:CGFloat = 0
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        if scrollView.contentOffset.y < SHOW_TRIGGER_POINT && scrollView.contentOffset.y < lastContentOffsetY
        {
            self.showElementsViews()
        }
        
        if scrollView.contentOffset.y == 0 && scrollView.contentOffset.y > lastContentOffsetY
        {
            self.removeElementsViews()
        }
        
        if scrollView.contentOffset.y < -self.frame.size.height
        {
            self.stickElementsViews(scrollView.contentOffset.y)
        }

        lastContentOffsetY = scrollView.contentOffset.y
    }
}
