//
//  LWMultitransitionView.h
//  多转场图片轮播器
//
//  Created by 刘伟 on 16/7/19.
//  Copyright © 2016年 刘伟. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol  LWMultitransitionDelegate<NSObject>
//根据所点图片的下标，在代理控制器中做操作
-(void)didClickTheImageWithIndex:(NSInteger)index;
@end
@interface LWMultitransitionView:UIView
@property (nonatomic, assign)int lw_index;//当前图片的下标
@property(nonatomic,strong) NSTimer* lw_timer;//计时器
@property (nonatomic, strong)UIImageView *lw_imageView;//图片
@property (nonatomic, strong)UILabel *lw_label;//标题
@property (nonatomic, strong)NSArray *lw_imageArr;//图片数组
@property (nonatomic, strong)NSArray *lw_titleArr;//标题数组
@property (assign, nonatomic) id<LWMultitransitionDelegate>  delegate;


@property(nonatomic,strong)UIPageControl *lw_pageControl;//页码的属性

@property(nonatomic,strong)NSArray * lw_animationArr;//动画模式
//外界初始化方法
-(instancetype)initWithFrame:(CGRect)frame andImageArr:(NSArray*)imageArr andTitleArr:(NSArray*)titleArr;


@end
