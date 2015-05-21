//
//  KeyboardViewController.swift
//  GifmojiKeyboard
//
//  Created by Theodore Lipeles on 5/15/15.
//  Copyright (c) 2015 Theodore Lipeles. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController {

    // Variables
    var keyboardView: UIView!
    
    var images: [String] = []

    
    // Outlets
    
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

        scrollView.contentSize.width = CGFloat(images.count * 48 + 8)
        
        
        makeButtonSet("80.gif")
    }

    func loadInterface() {
        // load the nib
        var keyboardViewNib = UINib(nibName: "KeyboardView", bundle: nil)
        // instantiate view
        keyboardView = keyboardViewNib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        // add interface to main view
        view.addSubview(keyboardView)
        
        keyboardView.setTranslatesAutoresizingMaskIntoConstraints(false)
        let topConst = NSLayoutConstraint(item: keyboardView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        let bottomConst = NSLayoutConstraint(item: keyboardView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        let leftConst = NSLayoutConstraint(item: keyboardView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        let rightConst = NSLayoutConstraint(item: keyboardView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        view.addConstraints([topConst, bottomConst, leftConst, rightConst])
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
    
    func makeButtonSet(suffix: String) {
        
        for file in images {
            if file.hasSuffix(suffix) {
                // Iterate through images
                var index:CGFloat = 0
                let y:CGFloat = 0
                for image in images {
                    var x = index * 48 + 8
                    makeButton(image, x: x, y: y)
                    index++
                }
            }
        }
    }
    
    func makeButton(imageNameWithType:String, x:CGFloat, y:CGFloat) {
        var image:UIImage = UIImage(named: imageNameWithType)!
        var button:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        button.frame = CGRectMake(x, y, 40, 40)
        button.setImage(image, forState: UIControlState.Normal)
        button.addTarget(self, action: "copyImage:", forControlEvents: .TouchUpInside)
        scrollView.addSubview(button)
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
    

    

}
