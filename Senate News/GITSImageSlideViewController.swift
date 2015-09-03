//
//  GITSImageSlideViewController.swift
//  CustomDelegate
//
//  Created by vichhai on 7/30/15.
//  Copyright (c) 2015 kan vichhai. All rights reserved.
//

import UIKit

var pageContol : UIPageControl!
var scrollView : UIScrollView!
var tempArray = []

class GITSImageSlideViewController: UIViewController {
    
    //      [UIApplication sharedApplication].statusBarFrame.size.height // get status bar height
    
    
    /* ---> create sliding image without page control */
    class func showSlidingImages(anyImages: [AnyObject],anyView: UIView) {
        tempArray = anyImages
        
        // ---> setting up scroll view
        
        scrollView = UIScrollView(frame: anyView.frame)
        scrollView.pagingEnabled = true
        //        scrollView.bounces = false
        scrollView.backgroundColor = UIColor.clearColor()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        for index in 0...anyImages.count - 1 {
            
            var imageView = UIImageView(frame: CGRectMake(scrollView.frame.size.width * CGFloat(index), 0, scrollView.frame.size.width, scrollView.frame.size.height))
            imageView.image = UIImage(named: anyImages[index] as! String)
            imageView.contentMode = UIViewContentMode.ScaleToFill
            scrollView.addSubview(imageView)
        }
        
        scrollView.contentSize = CGSizeMake((anyView.frame.size.width * CGFloat(anyImages.count)), scrollView.frame.size.height)
        
        // ---> add scroll view as subview of any view
        anyView.addSubview(scrollView)
    }
    
    /* ---> create sliding image with page control */
    class func showSlidingImages(anyImages:[AnyObject],anyView : UIView,withPageControl:Bool) {
    
        self.showSlidingImages(anyImages, anyView: anyView)
        
        if withPageControl {
            
            // ---> setting up page control
            pageContol = UIPageControl(frame: CGRectMake(141, 448, anyView.frame.size.width, 37))
            pageContol.numberOfPages = anyImages.count
            pageContol.pageIndicatorTintColor = UIColor.redColor()
            pageContol.currentPageIndicatorTintColor = UIColor.whiteColor()
            pageContol.frame = CGRectMake((anyView.frame.size.width - pageContol.frame.size.width)/2,UIScreen.mainScreen().bounds.size.height - 82 , anyView.frame.size.width, 37)
            
            // ---> add pageControl as subview as any view
            anyView.addSubview(pageContol)
            
            // ---> add event for page control
            
        }

    }
    
    /* ---> create sliding image with page control */
    class func showSlidingImages(anyImages:[AnyObject],anyView : UIView, anyDirectionWithAnyWidthAndHeight : CGRect) {
        
        
        scrollView = UIScrollView(frame: anyDirectionWithAnyWidthAndHeight)
        scrollView.pagingEnabled = true
        //        scrollView.bounces = false
        scrollView.backgroundColor = UIColor.clearColor()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        for index in 0...anyImages.count - 1 {
            
            var imageView = UIImageView(frame: CGRectMake(scrollView.frame.size.width * CGFloat(index), 0, scrollView.frame.size.width, scrollView.frame.size.height))
            imageView.image = UIImage(named: anyImages[index] as! String)
            imageView.contentMode = UIViewContentMode.ScaleToFill
            scrollView.addSubview(imageView)
        }
        
        scrollView.contentSize = CGSizeMake((scrollView.frame.size.width * CGFloat(anyImages.count)), scrollView.frame.size.height)
        
        // ---> add scroll view as subview of any view
        anyView.addSubview(scrollView)
    }
    
    
    // ---> Loop Images sliding
//    class func showSlidingImages(anyImages:[AnyObject],anyView : UIView,withPagging:Bool,loop:Bool) {
//        self.showSlidingImages(anyImages, anyView: anyView, withPagging: withPagging)
//        
//    }
//
    // -----> Add this method to any class that you have your scroll view delegate
    class func changingSelectedPaging (anyScrollView:UIScrollView,withLooping : Bool) {
        
        // ---> Updating page
        var pageWidth = anyScrollView.frame.size.width
        var page :Int = Int(floor((anyScrollView.contentOffset.x - (pageWidth / CGFloat(tempArray.count))) / pageWidth)) + 1
        
        if pageContol != nil {
            pageContol.currentPage = page
        }
        
        if withLooping {
//            if(scrollView.contentOffset.x == 0) {
//                var newOffset : CGPoint = CGPointMake(scrollView.bounds.size.width + scrollView.contentOffset.x, scrollView.contentOffset.y)
//                scrollView.setContentOffset(newOffset, animated: false)
//            }
//            else if(scrollView.contentOffset.x > scrollView.bounds.size.width * 5) {
//                var newOffset : CGPoint = CGPointMake(scrollView.contentOffset.x-scrollView.bounds.size.width, scrollView.contentOffset.y)
//                scrollView.setContentOffset(newOffset, animated: false)
//            }
////            
//            if (scrollView.contentOffset.x < (scrollView.contentOffset.x * 5)) {
//                println("True")
//            }
            
//            println("scroll view size \(scrollView.frame.size.width) and content ofset \(scrollView.contentOffset.x)")
            }
    }
}
