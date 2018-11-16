//
//  PageView.m
//  Unite
//
//  Created by Li Peixin on 2018/11/9.
//  Copyright © 2018 Li Peixin. All rights reserved.
//

#import "PageView.h"
#import "PageCollectionViewCell.h"

@interface PageView()<UICollectionViewDataSource, UICollectionViewDelegate>{
    double startOffsetX;//记录初始偏移量
    bool isForbidden;
}

@property (nonatomic, strong) UICollectionView *collView;
@property (nonatomic, copy) NSArray *arrImgs;

@end

@implementation PageView

-(instancetype)initWithFrame:(CGRect)frame imgUrls:(NSArray *)imgs{
    if (self = [super initWithFrame:frame]) {
        self.arrImgs = imgs;
        startOffsetX = 0;
        isForbidden = YES;
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    [self setupCollView];
}

// MARK: - 设置collView
-(void)setupCollView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = self.frame.size;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    
    self.collView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    self.collView.pagingEnabled = YES;
    self.collView.backgroundColor = [UIColor whiteColor];
    self.collView.dataSource = self;
    self.collView.delegate = self;
    self.collView.showsHorizontalScrollIndicator = NO;
    self.collView.bounces = NO;
    
    //注册cell
    [self.collView registerNib:[UINib nibWithNibName:@"PageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    [self addSubview:self.collView];
}

// MARK: - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.arrImgs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = (indexPath.item % 2 == 0) ? [UIColor orangeColor] : [UIColor whiteColor];
    cell.lbl.text = [NSString stringWithFormat:@"%ld", indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"--%ld--", indexPath.item);
    if (self.block) {
        self.block();
    }
}

// MARK: - UICollectionViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    isForbidden = NO;
    startOffsetX = scrollView.contentOffset.x;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (isForbidden) {
        return;
    }
    int sourceIndex = 0;
    int targetIndex = 0;
    float progress = 0;
    
    double currentOffsetX = scrollView.contentOffset.x;
    double scrollViewW = scrollView.frame.size.width;
    //左滑
    if (currentOffsetX > startOffsetX) {
        progress = (currentOffsetX - startOffsetX) / scrollViewW;
        sourceIndex = (int)(startOffsetX / scrollViewW);
        targetIndex = (sourceIndex == self.arrImgs.count - 1) ? sourceIndex : (sourceIndex + 1);
    }else{
        progress = (startOffsetX - currentOffsetX) / scrollViewW;
        sourceIndex = (int)(startOffsetX / scrollViewW);
        targetIndex = (sourceIndex == 0) ? sourceIndex : (sourceIndex - 1);
    }
    NSLog(@"progress == %f", progress);
    if ([self.delegate respondsToSelector:@selector(pageViewDelegate:progress:sourceIndex:targetIndex:)]) {
        [self.delegate pageViewDelegate:self progress:progress sourceIndex:sourceIndex targetIndex:targetIndex];
    }
}

-(void)currentIndex:(NSInteger)index{

    isForbidden = YES;
    [self.collView setContentOffset:CGPointMake(self.collView.frame.size.width * index, 0) animated:YES];
}

@end
