# JLScrollView
###swift轮播
原作者：[当当当当](http://www.cnblogs.com/softwaretailor/p/4769267.html)   

暂时只是将其实现，并没有修改什么。  

从网络下载图片，轮播显示，可定时、自动循环  

使用框架: [onevcat/Kingfisher](https://github.com/onevcat/Kingfisher)

##使用方法

	先在class中加入 JLScrollViewDelegate 协议 
	class ActivityViewController: JLScrollViewDelegate｛
	｝
	//获取屏幕宽度 和 高度  
	let width = UIScreen.mainScreen().bounds.width
    let height = width/2
    
    //创建JLScrollView
	var headerView: JLScrollView? = JLScrollView(frame: CGRectMake(0, 0, width, height));
	//设置自动轮播时长
    headerView!.timeInterval = 3.0
    //设置pageControl位置 Left, Right, Center
    headerView?.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center;
    //是否隐藏title(title可不设置)
    headerView?.hiddenTitle = true;
    //是否自动轮播
    headerView?.startTimer = true;
    
    headerView!.loadData(["http://img0.bdstatic.com/img/image/b4ff47b072b4b8934864f4be92ee07c01409737708.jpg",
            "http://7xonbs.com2.z0.glb.qiniucdn.com/pic1@2x.jpg",
            "http://7xonbs.com2.z0.glb.qiniucdn.com/pic2@2x.jpg",
            "http://7xonbs.com2.z0.glb.qiniucdn.com/pic3@2x.jpg",
            "http://7xonbs.com2.z0.glb.qiniucdn.com/pic4@2x.jpg"],["title1","title2","title3","title4","title5"]);
        
    headerView?.deleagte = self;
    //addSubview
    self.view.addSubview(headerView!)  
  
	############别忘了实现点击事件#############
    // MRAK: - 点击事件 
    func imageSelectTap(index: Int) {
        print("imageSelectTap \(index)")
    }

