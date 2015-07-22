//
//  InfinitScrollView.swift
//  InfinitScrollNoPaging
//
//  Created by German Pereyra on 7/22/15.
//  Copyright (c) 2015 German Pereyra. All rights reserved.
//

import UIKit


protocol InfinitScrollViewDelegate {
    func viewForItem(item: AnyObject, inFrame: CGRect) -> UIView
    func didSelectItem(item: AnyObject)
}

class InfiniteScrollItemView: UIView {
    var object:AnyObject!
    var innerView:UIView!
    init(frame: CGRect, object: AnyObject, innerView: UIView) {
        super.init(frame: frame)
        self.innerView = innerView;
        self.object = object;
        self.addSubview(innerView)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class InfinitScrollView: UIView {
    let scroll : UIScrollView = UIScrollView()
    private var datasource : Array<AnyObject>!
    private var itemsCount : Int!
    private var itemWidth : Float!
    private var startingPoint : CGFloat!
    private var endingPoint : CGFloat!
    private var fakeEndingPoint : CGFloat!
    private var itemsLength : CGFloat!
    private var secondLoop: Bool = false
    
    var delegate: InfinitScrollViewDelegate!
    
    init(frame: CGRect, datasource: Array<AnyObject>, itemWidth: Float, delegate: InfinitScrollViewDelegate) {
        super.init(frame: frame)
        self.datasource = datasource;
        self.itemWidth = itemWidth;
        self.itemsCount = self.datasource.count;
        self.startingPoint = CGFloat(self.itemWidth * Float(self.itemsCount));
        self.endingPoint = CGFloat((self.itemWidth * Float(self.itemsCount)) * Float(2));
        self.fakeEndingPoint = self.endingPoint;
        self.itemsLength = CGFloat(self.itemWidth * Float(self.itemsCount));
        self.delegate = delegate;
        scroll.frame = self.bounds
        scroll.delegate = self;
        self.initialize()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    func initialize() {
        scroll.delegate = self
        self.scroll.contentSize = CGSizeMake(CGFloat(self.itemWidth * Float(self.itemsCount) * 3), CGFloat(self.scroll.bounds.size.height))
        self.scroll.contentOffset = CGPointMake(self.startingPoint, CGFloat(0))
        self.addSubview(scroll)
        self.renderizeScroll()
    }
    
    func renderizeScroll () {
        var leftPosX = CGFloat(0);
        for (var j = 0; j < 3; j++) {
            for (var i = 0; i < self.itemsCount; i++) {
                var frame = CGRect(x: leftPosX, y: 0, width: CGFloat(self.itemWidth), height: self.scroll.bounds.size.height)
                var innerView = self.delegate.viewForItem(self.datasource[i], inFrame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
                var itemView = InfiniteScrollItemView(frame: frame, object: self.datasource[i], innerView: innerView)
                leftPosX += CGFloat(self.itemWidth)
                
                var button = UIButton(frame: itemView.bounds)
                button .addTarget(self, action:"itemSelectionEvent:", forControlEvents:UIControlEvents.TouchUpInside)
                itemView .addSubview(button)
                
                self.scroll.addSubview(itemView)
            }
        }
    }
    
    func itemSelectionEvent(sender:UIButton!) {
        if let itemView = sender.superview as? InfiniteScrollItemView {
            self.delegate .didSelectItem(itemView.object)
        }
    }
}

extension InfinitScrollView : UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.scroll.userInteractionEnabled = true
        if (self.scroll.contentOffset.x > self.endingPoint) {
            self.scroll.contentOffset = CGPoint(x: self.scroll.contentOffset.x - CGFloat(self.itemWidth * Float(self.itemsCount)), y: 0)
            self.scroll.contentSize = CGSizeMake(CGFloat(self.itemWidth * Float(self.itemsCount) * 3), CGFloat(self.scroll.bounds.size.height))
        }
        if (self.scroll.contentOffset.x < self.startingPoint) {
            self.scroll.contentOffset = CGPoint(x: self.scroll.contentOffset.x + CGFloat(self.itemWidth * Float(self.itemsCount)), y: 0)
            self.scroll.contentSize = CGSizeMake(CGFloat(self.itemWidth * Float(self.itemsCount) * 3), CGFloat(self.scroll.bounds.size.height))
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.x > self.fakeEndingPoint {
            moveItemsToRight()
        }
    }
    
    func moveItemsToRight () {
        
        if (!secondLoop) {
            secondLoop = true;
        } else
        {
            print ("aca");
        }
        
        var allViewsInScroll = Array(self.scroll.subviews)
        allViewsInScroll.sort({$0.frame.origin.x < $1.frame.origin.x })
        
        var i = 0
        var leftXPos = self.scroll.contentSize.width
        var movedItems = 0
        while movedItems < self.itemsCount {
            if let item = allViewsInScroll[i] as? InfiniteScrollItemView {
                item.frame = CGRect(x: leftXPos, y: item.frame.origin.y, width: item.frame.size.width, height: item.frame.size.height)
                leftXPos += item.frame.size.width;
                movedItems++;
            }
            i++;
        }
        self.scroll.contentSize = CGSize(width: self.scroll.contentSize.width + self.itemsLength, height: self.scroll.contentSize.height);
        self.fakeEndingPoint = self.fakeEndingPoint + self.itemsLength;
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        print("isDecelerating: \(scrollView.decelerating) velocity: \(velocity)")
    }
    
}