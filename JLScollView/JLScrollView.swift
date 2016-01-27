//
//  JLScrollView.swift
//  JLScollView
//
//  Created by inlead on 16/1/27.
//  Copyright © 2016年 ColdFlame. All rights reserved.
//

import UIKit
import Kingfisher

protocol JLScrollViewDelegate{
    func imageSelectTap(index:Int)
}

class JLScrollView:  UIView, UIScrollViewDelegate{
    private var noteTitle:UILabel?
    private var arrayTitle:Array<String>?
    private var arrayImage:Array<String>?
    private var mainScroll:UIScrollView?
    private var pageControl:UIPageControl?
    private var currentPage:Int = 0;
    private var pageSize:Int = 0;
    private var titleHeight:CGFloat = 20.0;
    
    //MARK: ======================================================== 变量
    private var _startTimer:Bool = false
    private var _timeInterval:Double = 2.0
    private var _hiddenTitle:Bool = false
    private var _colorTitle:UIColor = UIColor.whiteColor()
    private var _hiddenPageControl:Bool = false
    private var _contentHorizontalAlignment:UIControlContentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
    
    var deleagte:JLScrollViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.mainScroll = UIScrollView()
        self.pageControl = UIPageControl()
        self.hiddenTitle = false
        self.hiddenPageControl = false
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: ======================================================== JLScrollViewDelegate 协议实现
    func loadData(image:Array<String>){
        self.loadData(image, title: nil)
    }
    
    func loadData(image:Array<String> , title:Array<String>?){
        self.arrayImage = image
        self.arrayTitle = title
        
        var tempArray:Array<String> = image
        
        tempArray.insert(image.last!, atIndex: 0)
        tempArray.append(image.first!)
        
        self.arrayImage = tempArray
        self.pageSize = self.arrayImage!.count
        
        self.mainScroll!.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        
        let width: CGFloat = self.frame.size.width * CGFloat(self.pageSize)
        
        self.mainScroll?.contentSize = CGSizeMake(width, self.frame.size.height)
        self.mainScroll?.showsHorizontalScrollIndicator = false
        self.mainScroll?.showsVerticalScrollIndicator = false
        self.mainScroll?.scrollsToTop = false
        self.mainScroll?.pagingEnabled = true
        self.mainScroll?.delegate = self
        
        for i in 0 ..< self.pageSize {
            
            let imageUrl:String = self.arrayImage![i]
            
            let imgeView:UIImageView = UIImageView()
            if imageUrl.hasPrefix("http://")  {
                imgeView.kf_setImageWithURL(NSURL(string: imageUrl)!, placeholderImage: UIImage(named:"pic4"))
            } else {
                imgeView.image = UIImage(named:"pic4")
            }
            
            imgeView.frame = CGRectMake(self.frame.size.width*CGFloat(i), CGFloat(0), self.frame.size.width, self.frame.size.height)
            
            imgeView.tag = i
            let Tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("imageGestureTap:"))
            Tap.numberOfTapsRequired = 1
            Tap.numberOfTouchesRequired = 1
            
            imgeView.userInteractionEnabled = true
            imgeView.addGestureRecognizer(Tap)
            self.mainScroll?.addSubview(imgeView)
        }
        
        self.mainScroll?.setContentOffset(CGPointMake(self.frame.size.width, 0), animated: true)
        self.addSubview(self.mainScroll!)
        
        self.contentHorizontalAlignment = _contentHorizontalAlignment
        self.pageControl!.currentPage = 0
        self.pageControl!.pageIndicatorTintColor = UIColor(red: 155/255.0, green:  155/255.0, blue:  155/255.0, alpha: 1.0)
        self.pageControl!.currentPageIndicatorTintColor = UIColor.whiteColor()
        self.pageControl!.userInteractionEnabled = false
        self.pageControl!.numberOfPages = self.pageSize - 2
        self.pageControl?.hidden = self.hiddenPageControl
        self.addSubview(self.pageControl!)
        
        if arrayTitle != nil{
            self.noteTitle = UILabel(frame:CGRectMake(10,self.frame.size.height-self.titleHeight, self.frame.size.width, self.titleHeight))
            self.noteTitle!.text = self.arrayTitle!.first
            noteTitle?.textColor = _colorTitle
            noteTitle?.backgroundColor = UIColor.clearColor()
            noteTitle?.font = UIFont.systemFontOfSize(13.0)
            noteTitle?.hidden = self.hiddenTitle
            self.addSubview(noteTitle!)
        }
    }
    
    //MARK: - ========================================================= UIScrollView 协议实现
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let pageWidth:CGFloat = scrollView.frame.size.width
        let x:CGFloat = scrollView.contentOffset.x
        let page:Int = Int(((x - pageWidth / 2) / pageWidth) + 1)
        self.currentPage = page
        
        pageControl!.currentPage = page - 1
        var titleIndex:Int = page - 1
        
        if self.arrayTitle != nil {
            if (titleIndex == self.arrayTitle!.count) {
                titleIndex = 0
            }
            if (titleIndex < 0) {
                titleIndex = self.arrayTitle!.count-1
            }
            if (titleIndex > self.arrayTitle!.count-1) {
                noteTitle?.text = ""
            }
            else
            {
                noteTitle?.text = self.arrayTitle![titleIndex]
            }
        }
        
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if (currentPage == 0) {
            scrollView.setContentOffset(CGPointMake(CGFloat(arrayImage!.count-2)*self.frame.size.width, CGFloat(0)), animated: false)
        }
        if (currentPage == (self.arrayImage!.count-1)) {
            scrollView.setContentOffset(CGPointMake(self.frame.size.width, CGFloat(0)), animated: false)
        }
    }
    
    func imageGestureTap(getsture: UITapGestureRecognizer){
        if (self.deleagte != nil) {
            self.deleagte?.imageSelectTap(getsture.view!.tag)
        }
    }
    
    
    // pagecontrol 选择器的方法
    func turnPage()
    {
        let page:Int = self.pageControl!.currentPage
        self.mainScroll?.scrollRectToVisible(CGRectMake(CGFloat(self.frame.size.width*CGFloat(page+1)),0,self.frame.size.width,self.frame.size.height), animated: true)
        
    }
    // 定时器 绑定的方法
    func runTimePage()
    {
        var page:Int = self.pageControl!.currentPage // 获取当前的page
        page++;
        page = page >= self.arrayImage!.count-2 ? 0 : page
        self.pageControl!.currentPage = page
        self.turnPage()
    }
    //MARK: ======================================================== 属性封装
    /// 图片标题是否显示
    var hiddenTitle:Bool {
        get{ return _hiddenTitle}
        set{
            _hiddenTitle = newValue
            if noteTitle != nil {
                self.noteTitle?.hidden = _hiddenTitle
            }
        }
    }
    /// 图片标题颜色
    var colorTitle:UIColor{
        get{ return _colorTitle}
        set{
            _colorTitle = newValue
            if noteTitle != nil {
                self.noteTitle?.textColor = _colorTitle
            }
        }
    }
    /// 是否显示 UIPageControl
    var hiddenPageControl:Bool{
        get{return _hiddenPageControl}
        set{
            _hiddenPageControl = newValue
            if pageControl != nil {
                self.pageControl?.hidden = _hiddenPageControl
            }
        }
    }
    /// UIPagerControl 显示位置
    var contentHorizontalAlignment: UIControlContentHorizontalAlignment{
        get{ return _contentHorizontalAlignment }
        set{
            _contentHorizontalAlignment = newValue
            let size:CGSize =   self.pageControl!.sizeForNumberOfPages(pageSize)
            switch _contentHorizontalAlignment {
            case UIControlContentHorizontalAlignment.Center :
                self.pageControl?.center = CGPointMake(self.center.x, self.frame.size.height-self.titleHeight+self.titleHeight/2)
            case UIControlContentHorizontalAlignment.Left :
                self.pageControl?.frame.origin.x = size.width/2;
            case UIControlContentHorizontalAlignment.Right :
                self.pageControl?.frame.origin.x = self.frame.size.width-size.width/2
            default:
                break
            }
        }
    }
    
    var timeInterval: Double {
        get { return _timeInterval}
        set { _timeInterval = newValue }
    }
    
    /// 计时器
    var startTimer:Bool{
        get{ return _startTimer}
        set{
            _startTimer = newValue
            if _startTimer {
                NSTimer.scheduledTimerWithTimeInterval(_timeInterval, target: self, selector: Selector("runTimePage"), userInfo: nil, repeats: true)
            }
        }
    }
    
}
