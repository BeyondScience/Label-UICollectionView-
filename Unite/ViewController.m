//
//  ViewController.m
//  Unite
//
//  Created by Li Peixin on 2018/11/9.
//  Copyright © 2018 Li Peixin. All rights reserved.
//

#import "ViewController.h"
#import "TitleView.h"
#import "PageView.h"
#import "SecondViewController.h"

@interface ViewController ()<PageViewDelegate, TitleViewDelegate>{
    TitleView *titleView;
    PageView *pageView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

-(void)setupUI{
    titleView = [[TitleView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 40) titles:@[@"diyici",@"dierci",@"disanci",@"diwuci",@"diliuci",@"diliucidiliucidiliuci",@"diwuci",@"diliuci",@"diliucidiliucidiliuci",@"diwuci",@"diliuci",@"diliucidiliucidiliuci"]];
    [self.view addSubview:titleView];
    titleView.delegate = self;
    
    pageView = [[PageView alloc] initWithFrame:CGRectMake(0, 140, self.view.bounds.size.width, 200) imgUrls:@[@"diyici",@"dierci",@"disanci",@"diwuci",@"diliuci",@"diliucidiliucidiliuci",@"diwuci",@"diliuci",@"diliucidiliucidiliuci",@"diwuci",@"diliuci",@"diliucidiliucidiliuci"]];
    [self.view addSubview:pageView];
    pageView.delegate = self;
    __weak typeof(self) weakself = self;
    [pageView setBlock:^{
        [weakself.navigationController pushViewController:[SecondViewController new] animated:YES];
    }];
}


- (void)pageViewDelegate:(PageView *)pageView progress:(float)progress sourceIndex:(int)sourceIndex targetIndex:(int)targetIndex{
    [titleView setIndexWithSourceIndex:sourceIndex targetIndex:targetIndex progress:progress];
}

- (void)titleViewDelegate:(TitleView *)titleView index:(NSInteger)index{
    [pageView currentIndex:index];
}

@end
