//
//  KeyboardViewController.swift
//  GifmojiKeyboard
//
//  Created by Theodore Lipeles on 5/15/15.
//  Copyright (c) 2015 Theodore Lipeles. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController, UIScrollViewDelegate {

    // Variables
    var keyboardView: UIView!
    
    var images: [String] = []

    var collectionView: UICollectionView?
    
    var locations:[Int: CGFloat] = [0: 0, 1: 0, 2: 0, 3: 0, 4: 0, 5: 0]

    
    // Outlets
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var toolbarView: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var nextKeyboard: UIButton!
    // Actions

    
    
    @IBAction func copyImage(sender: UIButton) {
        var image = sender.currentImage
        let imageURL = NSBundle.mainBundle().pathForResource(getImageNameFromUIImage(image!), ofType: "gif")
        var data = NSData(contentsOfURL: NSURL(fileURLWithPath: imageURL!)!);
        UIPasteboard.generalPasteboard().setData(data!, forPasteboardType: "com.compuserve.gif")
        UIView.animateWithDuration(0.3, animations: {self.keyboardView.backgroundColor = UIColor.grayColor()})
        UIView.animateWithDuration(0.3, animations: {self.keyboardView.backgroundColor = UIColor.whiteColor()})
    }
    

    
    // Functions
    override func updateViewConstraints() {
        super.updateViewConstraints()
    
        // Add custom view sizing constraints here
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadInterface()
        
        nextKeyboard.addTarget(self, action: "advanceToNextInputMode", forControlEvents: .TouchUpInside)
        
        
        // Get images
        let filemanager:NSFileManager = NSFileManager.defaultManager()
        let path = NSBundle.mainBundle().resourcePath!
        var bundleFiles = filemanager.contentsOfDirectoryAtPath(path, error: nil) as! [String]
        for file in bundleFiles {
            if file.hasSuffix(".gif") {
                images.append(file)
            }
        }
        
        // Initialize size for scroll view

        scrollView.contentSize.width = CGFloat(8)
        
        
        locations[1] = makeButtonSet("people.gif")
        
        locations[2] = makeButtonSet("food.gif")
        
        locations[3] = makeButtonSet("animals.gif")

        locations[4] = makeButtonSet("utility.gif")
        
        locations[5] = makeButtonSet("hi.gif")
        
        progressView.progress = 0
        
        for var l = 0; l < locations.count; l++ {
            if let location = locations[l] {
                locations[l] = location / scrollView.contentSize.width
            } else {
                println("location = nil")
            }
        }
        
    }

    func loadInterface() {
        // load the nib
        var keyboardViewNib = UINib(nibName: "KeyboardView", bundle: nil)
        // instantiate view
        keyboardView = keyboardViewNib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        // add interface to main view
        view.addSubview(keyboardView)
        
        // Add constraints for keyboardView
        keyboardView.setTranslatesAutoresizingMaskIntoConstraints(false)
        let topConst = NSLayoutConstraint(item: keyboardView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        let bottomConst = NSLayoutConstraint(item: keyboardView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        let leftConst = NSLayoutConstraint(item: keyboardView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        let rightConst = NSLayoutConstraint(item: keyboardView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        view.addConstraints([topConst, bottomConst, leftConst, rightConst])
        // Set scrollView delegate
        scrollView.delegate = self
    }
    
    func getImageNameFromUIImage(image: UIImage) -> String {
        var imageName = ""
        for i in images {
            if image == UIImage(named: i) {
                return i.stringByDeletingPathExtension
            }
        }
        return "Image Not Found"
    }
    
    func makeButtonSet(suffix: String) -> CGFloat{
        var imageSubset:[String] = []
        for image in images {
            if image.hasSuffix(suffix) {
                imageSubset.append(image)
            }
        }
        let lastButtonPosition = scrollView.contentSize.width
        scrollView.contentSize.width += ceil(CGFloat(imageSubset.count) / 2) * 48 + 10
        for (index, image) in enumerate(imageSubset) {
            var y:CGFloat = 0
            var x:CGFloat = 0
            if index % 2 == 0 {
                y = scrollView.frame.height / 2 - 44
                x = CGFloat(index / 2) * 48 + lastButtonPosition
            } else {
                y = scrollView.frame.height / 2 + 4
                x = CGFloat(index / 2) * 48 + lastButtonPosition
            }
            makeButton(image, x: x, y: y)
        }
        return lastButtonPosition
    }
    
    func makeButton(imageNameWithType:String, x:CGFloat, y:CGFloat) {
        var image:UIImage = UIImage(named: imageNameWithType)!
        var button:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        button.frame = CGRectMake(x, y, 40, 40)
        button.setImage(image, forState: UIControlState.Normal)
        button.addTarget(self, action: "copyImage:", forControlEvents: .TouchUpInside)
        scrollView.addSubview(button)
        
        button.setTranslatesAutoresizingMaskIntoConstraints(false)
        let leftConst = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: scrollView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: x)
        var middleYConst = NSLayoutConstraint()
        if y > scrollView.frame.height / 2 {
            middleYConst = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: scrollView, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 24)
        } else {
            middleYConst = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: scrollView, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: -24)
        }
        let heightConst = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 40)
        let widthConst = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 40)
        scrollView.addConstraints([leftConst, middleYConst])
        button.addConstraints([heightConst, widthConst])
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }

    override func textWillChange(textInput: UITextInput) {
        // The app is about to change the document's contents. Perform any preparation here.
    }

    override func textDidChange(textInput: UITextInput) {
        // The app has just changed the document's contents, the document context has been updated.
    }
    

    func scrollViewDidScroll(scrollView: UIScrollView) {
        let viewWidth = view.frame.width
        let scrollDistance = scrollView.contentSize.width - viewWidth
        let scrollOffset = scrollView.contentOffset.x
        
        let newPosition = Float(scrollOffset / scrollDistance)
        updatePosition(newPosition)
    }
    
    
    func updatePosition(newPosition: Float) {
        progressView.setProgress(newPosition, animated: false)
        for var l = 0; l < locations.count; l++ {
            if CGFloat(newPosition) > locations[l] {
                
            }
        }
    }
    
}
