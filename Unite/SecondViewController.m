//
//  SecondViewController.m
//  Unite
//
//  Created by 慕慕跃科 on 2018/11/9.
//  Copyright © 2018 Li Peixin. All rights reserved.
//

#import "SecondViewController.h"
#import "PageCollectionViewCell.h"

@interface SecondViewController ()<UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collView;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

-(void)setupUI{
    [self setupCollView];
}

-(void)setupCollView{
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
//    layout.itemSize = self.view.bounds.size;
    layout.itemSize = CGSizeMake(self.view.bounds.size.width, 200);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    self.collView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) collectionViewLayout:layout];
    self.collView.pagingEnabled = YES;
    self.collView.dataSource = self;
    self.collView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:self.collView];
    
    [self.collView registerNib:[UINib nibWithNibName:@"PageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = (indexPath.item % 2 == 0) ? [UIColor orangeColor] : [UIColor redColor];
    return cell;
}

@end
