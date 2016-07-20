//
//  ViewController.m
//  多转场图片轮播器
//
//  Created by 刘伟 on 16/7/19.
//  Copyright © 2016年 刘伟. All rights reserved.
//
#warning 如果运行报错，请先command＋shift＋k ，clean一下！
#import "ViewController.h"
#import "LWMultitransitionView.h"
@interface ViewController ()<LWMultitransitionDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray * imageArr = @[
                           @"http://casclu.htdtv.cn/upload/201606281623582523_QQ%E6%88%AA%E5%9B%BE20160628162022.png",
                           @"http://casclu.htdtv.cn/upload/201607041436171785_3.png",
                           @"http://casclu.htdtv.cn/upload/201607041441022410_3.png"
                          ];
    NSArray * titleArr = @[@"医疗专家赴航天科技集团天津基地开展“心贴心”义诊",
                           @"航天科技集团直属工会新一任副主席选举产生",
                           @"我们赢了！2016“军工杯”乒乓球邀请赛冠军花落航天科技集团"
];
    //初始化 并设置代理
    LWMultitransitionView * animation = [[LWMultitransitionView alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 200) andImageArr:imageArr andTitleArr:titleArr];
    animation.delegate = self;
    [self.view addSubview:animation];
    
}
//代理方法
-(void)didClickTheImageWithIndex:(NSInteger)index{
    NSLog(@"%zd",index);
}

@end
