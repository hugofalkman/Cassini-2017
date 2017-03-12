//
//  ImageViewController.swift
//  Cassini
//
//  Created by H Hugo Falkman on 2017-03-05.
//  Copyright © 2017 H Hugo Falkman. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    
    // MARK: Model
    
    var imageURL: URL? {
        didSet {
            image = nil
            if view.window != nil { // if we're on screen
                fetchImage()
            }
        }
    }
    
    // MARK: Private Implementation
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    private func fetchImage() {
        if let url = imageURL {
            
            spinner.startAnimating()
            
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                let urlContents = try? Data(contentsOf: url)
                if let imageData = urlContents, url == self?.imageURL {
                    DispatchQueue.main.async {
                        self?.image = UIImage(data: imageData)
                    }
                }
            }
        }
    }
    
    // MARK: View Controller Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if image == nil {
            fetchImage()
        }
    }
    
    // MARK: User Interface
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
            scrollView.minimumZoomScale = 0.03
            scrollView.maximumZoomScale = 1.0
            scrollView.contentSize = imageView.frame.size
            scrollView.addSubview(imageView)
        }
    }
    
    fileprivate var imageView = UIImageView()
    
    private var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            // scrollView might be nil
            // so use optional chaining
            scrollView?.contentSize = imageView.frame.size
            
            spinner?.stopAnimating()
        }
    }
}

// MARK: UIScrollViewDelegate
// Makes ImageViewController conform to UIScrollViewDelegate and
// sets up viewForZooming optional ScrollView Delegate method

extension ImageViewController : UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}



