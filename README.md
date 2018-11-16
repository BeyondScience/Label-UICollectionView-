# Label-UICollectionView-
### 上面使用的是一个UIScrollView上面添加UILabel的TitleView，下面是使用的UICollectionView的PageView，两者使用协议通信，并且在两个类中对外暴露了接口;
### 使用时候在控制器中添加这两个View，遵循协议，实现代理方法，在代理方法中调用接口暴露的方法；
```
// MARK: - PageViewDelegate
- (void)pageViewDelegate:(PageView *)pageView progress:(float)progress sourceIndex:(int)sourceIndex targetIndex:(int)targetIndex{
    //TitleViewu对外暴露的方法
    [titleView setIndexWithSourceIndex:sourceIndex targetIndex:targetIndex progress:progress];
}
// MARK: - TitleViewDelegate
- (void)titleViewDelegate:(TitleView *)titleView index:(NSInteger)index{
    //PageView对外暴露的方法
    [pageView currentIndex:index];
}
```
