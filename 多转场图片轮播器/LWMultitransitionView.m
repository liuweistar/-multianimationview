//
//  LWMultitransitionView.m
//  多转场图片轮播器
//
//  Created by 刘伟 on 16/7/19.
//  Copyright © 2016年 刘伟. All rights reserved.
//
#import "UIImageView+WebCache.h"
#import "LWMultitransitionView.h"
#import "Masonry.h"
@implementation LWMultitransitionView
//重写初始化方法
-(instancetype)initWithFrame:(CGRect)frame andImageArr:(NSArray*)imageArr andTitleArr:(NSArray*)titleArr{
    
    if (self= [super initWithFrame:frame]) {
        //给数据数组赋值
        self.lw_imageArr = imageArr;
        self.lw_titleArr = titleArr;
        //创建 UI
        
        [self setupUI];
       //    //创建定时器
        self.lw_timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(scrollChange:) userInfo:nil repeats:YES];
  }
    return self;
}
//创建 UI
-(void)setupUI{
    //防崩溃处理
    if (_lw_imageArr.count ==0||_lw_titleArr.count == 0) {
        return;
    }
   //设置大小位置
    self.lw_imageView=[[UIImageView alloc]initWithFrame:self.bounds];
    
    //设置起始图片
   [_lw_imageView  sd_setImageWithURL:[NSURL URLWithString:self.lw_imageArr[0]] placeholderImage:[UIImage imageNamed:@"政策库0"]];//默认图片
    
    _lw_imageView.userInteractionEnabled = YES;

    
    //添加图片
    [self addSubview:_lw_imageView];
    UIImageView* backImage = [[UIImageView alloc]init];
    backImage.image = [UIImage imageNamed:@"透明背景"];
    [_lw_imageView addSubview:backImage];
    [backImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        ;
        make.height.mas_equalTo(30);
        
    }];
    UILabel * lb = [[UILabel alloc]init];
    self.lw_label = lb;
    lb.font = [UIFont systemFontOfSize:13];
    lb.textColor = [UIColor whiteColor];
    [backImage addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(backImage);
        make.left.equalTo(backImage).offset(5);
        make.right.equalTo(backImage).offset(-80);
    }];
    lb.text = self.lw_titleArr[0];
    
    
    //设置图片视图的tag
    
    
    //创建点击手势
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Tapimage)];//默认点击第一张
    //添加点击手势
    [_lw_imageView addGestureRecognizer:doubleTap];
    
    //添加手势
    
    //左滑动手势
    UISwipeGestureRecognizer *leftSwipeGesture=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeLeft:)];
    
    //设置滑动的方向
    leftSwipeGesture.direction=UISwipeGestureRecognizerDirectionLeft;
    
    //添加
    [self addGestureRecognizer:leftSwipeGesture];
    
    //右滑动的手势
    UISwipeGestureRecognizer *rightSwipeGesture=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeRight:)];
    
    //设置滑动的方向
    rightSwipeGesture.direction=UISwipeGestureRecognizerDirectionRight;
    
    //添加
    [self addGestureRecognizer:rightSwipeGesture];
   //创建pageControl
    [self creatpageControl:_lw_imageArr.count];
}
//代理方法
-(void)Tapimage{
    if ([self.delegate respondsToSelector:@selector(didClickTheImageWithIndex:)]) {
        [self.delegate didClickTheImageWithIndex:_lw_index];
    }


}
//右滑
-(void)swipeRight:(UISwipeGestureRecognizer *)gesture{
    [self transition:NO andAnimationMode:5];
}
//左滑
-(void)swipeLeft:(UISwipeGestureRecognizer *)gesture{
    [self transition:YES andAnimationMode:4];
}
//定时器的方法
-(void)scrollChange:(NSTimer *)sender
{
    int i = arc4random() % 8;
    [self transition:YES andAnimationMode:i];
}
#pragma mark 转场动画
-(void)transition:(BOOL)isNext andAnimationMode:(int)animationMode
{
// 图片为网络请求，会有延迟 因此给数组做判断，防止数组越界崩溃。
    if (self.lw_imageArr.count == 0) {
        return;
    }
    //防止手动滑动view时，图片转换过快，用户体验不好，因此停止定时器，在转滑动view完成时再开启定时器。
    [self.lw_timer invalidate];
    //动画模式
    _lw_animationArr=@[@"cube", @"moveIn", @"reveal", @"fade",@"pageCurl", @"pageUnCurl", @"suckEffect", @"rippleEffect", @"oglFlip"];
    //创建转场动画对象
    CATransition *transition=[[CATransition alloc]init];
    transition.type=_lw_animationArr[animationMode];
    
    //判断是左滑还是右滑
    if (isNext) {
        transition.subtype=kCATransitionFromRight;  //右滑
    }else{
        transition.subtype=kCATransitionFromRight;   //左滑
    }
   //动画时间
    transition.duration=0.8f;
    //3.设置转场后的新视图添加转场动画
    [_lw_imageView sd_setImageWithURL:[NSURL URLWithString:[self getImageString:isNext]] placeholderImage:[UIImage imageNamed:@"政策库0"]];
    _lw_label.text = _lw_titleArr[_lw_index];
    //添加动画
    [_lw_imageView.layer addAnimation:transition forKey:@"KCTransitionAnimation"];
    //重新开启定时器
    self.lw_timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(scrollChange:) userInfo:nil repeats:YES];
}
//向左滑动浏览下一张图片
-(void)leftSwipe:(UISwipeGestureRecognizer *)gesture
{
    [self transition:YES andAnimationMode:4];
}

//向右滑动浏览上一张图片
-(void)rightSwipe:(UISwipeGestureRecognizer *)gesture
{
    [self transition:NO andAnimationMode:5];
}
#pragma mark 取得当前图片的urlString
-(NSString *)getImageString:(BOOL)isNext
{
    if (isNext) {
        _lw_index=(_lw_index+1)%_lw_imageArr.count;
        
        self.lw_pageControl.currentPage=_lw_index;
    }else{
        _lw_index=(_lw_index-1+_lw_imageArr.count)%(int)_lw_imageArr.count;//
        
        self.lw_pageControl.currentPage=_lw_index;
    }
    
    //获取的图片名字
    return  _lw_imageArr[_lw_index];
}
//懒加载
-(NSArray *)lw_titleArr{
    if (_lw_titleArr == nil) {
        _lw_titleArr = [NSArray array];
    }
    return _lw_titleArr;
}
-(NSArray *)lw_imageArr{
    if (_lw_imageArr == nil) {
        _lw_imageArr = [NSArray array];
    }
    
    return _lw_imageArr;
}
//创建页码器
-(void)creatpageControl:(long)page
{
    //初始化pageControl，位置依需求修改
    self.lw_pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(self.frame.size.width-80, self.frame.size.height-28, 80, 25)];
     //设置初始页码
    self.lw_pageControl.numberOfPages=page;
    //设置当前页点的颜色
    self.lw_pageControl.currentPageIndicatorTintColor=[UIColor redColor];
    //设置其他页点的颜色
    self.lw_pageControl.pageIndicatorTintColor=[UIColor grayColor];
    //添加到view上
    [self addSubview:self.lw_pageControl];
}


@end
