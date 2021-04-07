//
//  KACircleCropViewController.swift
//  Circle Crop View Controller
//
//  Created by Keke Arif on 29/02/2016.
//  Copyright © 2016 Keke Arif. All rights reserved.
//

import UIKit

public protocol KACircleCropViewControllerDelegate
{
    
    func circleCropDidCancel()
    func circleCropDidCropImage(_ image: UIImage)
    
}

open class KACircleCropViewController: UIViewController, UIScrollViewDelegate {
    
    open var delegate: KACircleCropViewControllerDelegate?
    
    open var image: UIImage
    public let imageView = UIImageView()
    public let scrollView = KACircleCropScrollView(frame: CGRect(x: 0, y: 0, width: 240, height: 240))
    public let cutterView = KACircleCropCutterView()
    
    public let label = UILabel(frame: CGRect(x: 0, y: 0, width: 130, height: 30))
    public let okButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
    public let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
    
    
    public init(withImage image: UIImage) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK: View management
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black
        scrollView.backgroundColor = UIColor.black
        
        imageView.image = image
        imageView.frame = CGRect(origin: CGPoint.zero, size: image.size)
        scrollView.delegate = self
        scrollView.addSubview(imageView)
        scrollView.contentSize = image.size
        
        let scaleWidth = scrollView.frame.size.width / scrollView.contentSize.width
        scrollView.minimumZoomScale = scaleWidth
        if imageView.frame.size.width < scrollView.frame.size.width {
            print("We have the case where the frame is too small")
            scrollView.maximumZoomScale = scaleWidth * 2
        } else {
            scrollView.maximumZoomScale = 1.0
        }
        scrollView.zoomScale = scaleWidth
        
        //Center vertically
        scrollView.contentOffset = CGPoint(x: 0, y: (scrollView.contentSize.height - scrollView.frame.size.height)/2)
        
        //Add in the black view. Note we make a square with some extra space +100 pts to fully cover the photo when rotated
        cutterView.frame = view.frame
        cutterView.frame.size.height += 100
        cutterView.frame.size.width = cutterView.frame.size.height
        
        //Add the label and buttons
        label.text = "Move and Scale"
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.font = label.font.withSize(17)
        
        okButton.setTitle("OK", for: UIControl.State())
        okButton.setTitleColor(UIColor.white, for: UIControl.State())
        okButton.titleLabel?.font = backButton.titleLabel?.font.withSize(17)
        okButton.addTarget(self, action: #selector(didTapOk), for: .touchUpInside)
        
        backButton.setTitle("<", for: UIControl.State())
        backButton.setTitleColor(UIColor.white, for: UIControl.State())
        backButton.titleLabel?.font = backButton.titleLabel?.font.withSize(30)
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        
        setLabelAndButtonFrames()
        
        view.addSubview(scrollView)
        view.addSubview(cutterView)
        cutterView.addSubview(label)
        cutterView.addSubview(okButton)
        cutterView.addSubview(backButton)
        
        
    }
    
    
    open func setLabelAndButtonFrames() {
        
        scrollView.center = view.center
        cutterView.center = view.center
        
        label.frame.origin = CGPoint(x: cutterView.frame.size.width/2 - label.frame.size.width/2, y: cutterView.frame.size.height/2 - view.frame.size.height/2 + 3)
        
        okButton.frame.origin = CGPoint(x: cutterView.frame.size.width/2 + view.frame.size.width/2 - okButton.frame.size.width - 12, y: cutterView.frame.size.height/2 - view.frame.size.height/2 + 3)
        
        backButton.frame.origin = CGPoint(x: cutterView.frame.size.width/2 - view.frame.size.width/2 + 3, y: cutterView.frame.size.height/2 - view.frame.size.height/2 + 1)
        
    }
    
    
    override open func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        
        coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            
            self.setLabelAndButtonFrames()
            
            }) { (UIViewControllerTransitionCoordinatorContext) -> Void in
        }
        
        
    }
    
    
    open func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    
    override open var prefersStatusBarHidden : Bool {
        return true
    }
    
    
    
    // MARK: Button taps
    
    @objc open func didTapOk() {
        

        let newSize = CGSize(width: image.size.width*scrollView.zoomScale, height: image.size.height*scrollView.zoomScale)
        
        let offset = scrollView.contentOffset
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 240, height: 240), false, 0)
        let circlePath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 240, height: 240))
        circlePath.addClip()
        var sharpRect = CGRect(x: -offset.x, y: -offset.y, width: newSize.width, height: newSize.height)
        sharpRect = sharpRect.integral
        
        image.draw(in: sharpRect)
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let imageData = finalImage!.pngData() {
            if let pngImage = UIImage(data: imageData) {
                delegate?.circleCropDidCropImage(pngImage)
            } else {
                delegate?.circleCropDidCancel()
            }
        } else {
            delegate?.circleCropDidCancel()
        }
        
        
        
    }
    
    @objc open func didTapBack() {
        
        delegate?.circleCropDidCancel()
        
    }
    

}
