//
//  ViewController.swift
//  InfinitScrollNoPaging
//
//  Created by German Pereyra on 7/22/15.
//  Copyright (c) 2015 German Pereyra. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var array = ["A", "B", "C", "D", "E", "F", "G"]
        var infiniteView = InfinitScrollView(frame: CGRect(x: 0, y: 80, width: self.view.bounds.width, height: 300), datasource: array, itemWidth: 320, delegate: self)
        self.view .addSubview(infiniteView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
extension ViewController: InfinitScrollViewDelegate {
    
    func viewForItem(item: AnyObject, inFrame: CGRect) -> UIView {
        var aView = UILabel(frame: inFrame)
        aView.backgroundColor = self.getRandomColor()
        aView.font = UIFont.systemFontOfSize(27)
        aView.textColor = UIColor.whiteColor()
        aView.textAlignment = NSTextAlignment.Center
        aView.text = "\(item)"
        return aView
    }
    
    func getRandomColor() -> UIColor {
        var randomRed:CGFloat = CGFloat(drand48())
        var randomGreen:CGFloat = CGFloat(drand48())
        var randomBlue:CGFloat = CGFloat(drand48())
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
    
    func didSelectItem(item: AnyObject) {
        
    }
}


