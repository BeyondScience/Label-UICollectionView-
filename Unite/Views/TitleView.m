//
//  TitleView.m
//  Unite
//
//  Created by Li Peixin on 2018/11/9.
//  Copyright © 2018 Li Peixin. All rights reserved.
//

#import "TitleView.h"

//橙色
typedef enum : NSInteger {
    KRedSelect = 255,
    kGreenSelect = 128,
    kBlueSelect = 0,
} KColorSelect;

//黑色
typedef enum : NSInteger {
    KRedNormal = 85,
    KGreenNormal = 85,
    KBlueNormal = 85,
} KColorNormal;

typedef enum : NSInteger {
    KRedSpace = KRedSelect - KRedNormal,
    KGreenSpace = kGreenSelect - KGreenNormal,
    KBlueSpace = kBlueSelect - KBlueNormal,
} KColorSpace;

@interface TitleView()

@property (nonatomic, strong) NSMutableArray <UILabel *>*arrLabels;
@property (nonatomic, strong) UIScrollView *scView;
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) UIView *scrollLine;

@end

static NSInteger scrolLineH = 3;

@implementation TitleView
// MARK: - 初始化方法
-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)arrTitles{
    if (self = [super initWithFrame:frame]) {
        self.arrTitle = arrTitles;
        self.arrLabels = [NSMutableArray array];
        self.currentIndex = 0;
        [self setupUI];
    }
    return self;
}

// MARK: - 设置UI
-(void)setupUI{
    self.scView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.frame.size.height - 1)];
    self.scView.backgroundColor = [UIColor whiteColor];
    self.scView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.scView];
    
    [self setupTitleLabels];
    [self setupScrollBottomLine];
}

// MARK: - 设置label
-(void)setupTitleLabels{
    CGRect oldRect = CGRectZero;
    float gap = 10;
    for (int i = 0; i < self.arrTitle.count; i++) {
        UILabel *lbl = [[UILabel alloc] init];
        lbl.tag = i + 101;
        lbl.userInteractionEnabled = YES;
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.text = self.arrTitle[i];
        [lbl sizeToFit];
        lbl.frame = CGRectMake(oldRect.origin.x + oldRect.size.width + gap, scrolLineH + 1, lbl.frame.size.width, self.bounds.size.height - scrolLineH - 1);
        oldRect = lbl.frame;
        [self.arrLabels addObject:lbl];
        [self.scView addSubview:lbl];
        lbl.textColor = [UIColor blackColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [lbl addGestureRecognizer:tap];
    }
    self.scView.contentSize = CGSizeMake(oldRect.size.width + oldRect.origin.x + gap, 0);
}

// MARK: - 设置底部的滚动的view
-(void)setupScrollBottomLine{

    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 1, self.bounds.size.width, 1)];
    bottomView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:bottomView];
    
    UILabel *lbl = self.arrLabels.firstObject;
    lbl.textColor = [UIColor colorWithRed:KRedSelect/255.0 green:kGreenSelect/255.0 blue:kBlueSelect/255.0 alpha:1];
    self.scrollLine = [[UIView alloc] initWithFrame:CGRectMake(lbl.frame.origin.x, self.frame.size.height - scrolLineH, lbl.frame.size.width, scrolLineH)];
    self.scrollLine.backgroundColor = [UIColor orangeColor];
    [self.scView addSubview:self.scrollLine];
}


// MARK: - TitleViewDelegate
-(void)tapAction:(UITapGestureRecognizer *)tap{
    UILabel *currentLabel = (UILabel *)tap.view;
    UILabel *oldLabel = self.arrLabels[_currentIndex];
    if (oldLabel == currentLabel) {
        return;
    }
    //改变颜色
    currentLabel.textColor = [UIColor colorWithRed:KRedSelect/255.0 green:kGreenSelect/255.0 blue:kBlueSelect/255.0 alpha:1];
    oldLabel.textColor = [UIColor colorWithRed:KRedNormal/255.0 green:KGreenNormal/255.0 blue:KBlueNormal/255.0 alpha:1];
    
    _currentIndex = currentLabel.tag - 101;
    [UIView animateWithDuration:0.15 animations:^{
        self.scrollLine.frame = CGRectMake(currentLabel.frame.origin.x, self.frame.size.height - scrolLineH, currentLabel.frame.size.width, scrolLineH);
    }];
    [self midShowLabel:currentLabel];
    
    if ([self.delegate respondsToSelector:@selector(titleViewDelegate:index:)]) {
        [self.delegate titleViewDelegate:self index:(currentLabel.tag - 101)];
    }
}


// MARK: - 居中显示
-(void)midShowLabel:(UILabel *)currentLabel{
    if (!(self.scView.contentSize.width>CGRectGetWidth(self.frame))) {
        return;
    }
    if (CGRectGetMidX(currentLabel.frame)>CGRectGetMidX(self.frame)) {
        if (self.scView.contentSize.width<CGRectGetMaxX(self.frame)/2+CGRectGetMidX(currentLabel.frame)) {
            [self.scView setContentOffset:CGPointMake(self.scView.contentSize.width-CGRectGetWidth(self.frame), 0) animated:YES];
        }
        else{
            [self.scView setContentOffset:CGPointMake(CGRectGetMidX(currentLabel.frame)-CGRectGetWidth(self.frame)/2, 0) animated:YES];
        }
    }
    else{
        [self.scView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

//MARK: 对外暴露的接口
-(void)setIndexWithSourceIndex:(int)source targetIndex:(int)targetIndex progress:(float)progress{
    
    UILabel *oldLabel = self.arrLabels[source];
    UILabel *currentLabel = self.arrLabels[targetIndex];
    
    //改变颜色
    currentLabel.textColor = [UIColor colorWithRed:(KRedNormal + KRedSpace * progress)/255.0 green:(KGreenNormal + KGreenSpace * progress)/255.0 blue:(KBlueNormal + progress * KBlueSpace)/255.0 alpha:1];
    oldLabel.textColor = [UIColor colorWithRed:(KRedSelect - KRedSpace * progress)/255.0 green:(kGreenSelect - KGreenSpace * progress)/255.0 blue:(kBlueSelect - KBlueSpace * progress)/255.0 alpha:1];
    
    float moveTotleX = currentLabel.frame.origin.x - oldLabel.frame.origin.x;
    float moveX = moveTotleX * progress;
    self.scrollLine.frame = CGRectMake(oldLabel.frame.origin.x + moveX, self.frame.size.height - scrolLineH, currentLabel.frame.size.width, scrolLineH);
    _currentIndex = targetIndex;
    
    [self midShowLabel:currentLabel];
}

@end
