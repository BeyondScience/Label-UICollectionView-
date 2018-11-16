//
//  PageView.h
//  Unite
//
//  Created by Li Peixin on 2018/11/9.
//  Copyright © 2018 Li Peixin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class PageView;
@protocol PageViewDelegate <NSObject>


/**
 PageViewDelegate

 @param pageView PageView
 @param sourceIndex 原来的页面
 @param targetIndex 将要滑到的页面
 */



-(void)pageViewDelegate:(PageView *)pageView progress:(float)progress sourceIndex:(int)sourceIndex targetIndex:(int)targetIndex;

@end

@interface PageView : UIView

@property (nonatomic, weak) id <PageViewDelegate> delegate;
@property (nonatomic, copy) dispatch_block_t block;

-(instancetype)initWithFrame:(CGRect)frame imgUrls:(NSArray *)img;

-(void)currentIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
