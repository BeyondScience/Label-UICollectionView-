//
//  TitleView.h
//  Unite
//
//  Created by Li Peixin on 2018/11/9.
//  Copyright © 2018 Li Peixin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TitleView;

@protocol TitleViewDelegate <NSObject>

-(void)titleViewDelegate:(TitleView *)titleView index:(NSInteger)index;

@end

@interface TitleView : UIView


@property (nonatomic, copy) NSArray *arrTitle;
@property (nonatomic, weak) id <TitleViewDelegate>delegate;


-(void)setIndexWithSourceIndex:(int)source targetIndex:(int)targetIndex progress:(float)progress;
-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)arrTitles;

@end

NS_ASSUME_NONNULL_END
