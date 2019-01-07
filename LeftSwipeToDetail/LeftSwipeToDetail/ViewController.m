//
//  ViewController.m
//  LeftSwipeToDetail
//
//  Created by 蒋理智 on 2019/1/7.
//  Copyright © 2019年 jingwan. All rights reserved.
//

#import "ViewController.h"
#import "MyCollectionViewCell.h"

static CGFloat leftSwipeLength = 50.0;

@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *moreLabel;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) UIImageView *arrowImageV;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageArray = @[@"test2.jpg", @"test3.jpg", @"test5.jpg", @"test7.png"];
    [self setupSubViews];
}

- (void)setupSubViews {
    
    CGFloat totalWidth = self.view.bounds.size.width;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake(totalWidth, totalWidth);
    UICollectionView *itemView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 100, totalWidth, totalWidth) collectionViewLayout:flowLayout];
    itemView.pagingEnabled = YES;
    itemView.backgroundColor = [UIColor whiteColor];
    [itemView registerClass:[MyCollectionViewCell class] forCellWithReuseIdentifier:@"MyCollectionViewCell"];
    itemView.dataSource = self;
    itemView.delegate = self;
    itemView.alwaysBounceHorizontal = YES;
    [self.view addSubview:itemView];
    self.collectionView = itemView;
    
    UIImageView *arrowImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
    arrowImageV.center = CGPointMake(totalWidth, totalWidth/2.0);
    [itemView addSubview:arrowImageV];
    self.arrowImageV = arrowImageV;
    
    UILabel *moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(totalWidth, (totalWidth-100)/2.0, 20, 100)];
    moreLabel.font = [UIFont systemFontOfSize:12];
    moreLabel.textColor = [UIColor lightGrayColor];
    moreLabel.numberOfLines = 0;
    moreLabel.text = @"滑动查看详情";//释放查看详情
    [itemView addSubview:moreLabel];
    self.moreLabel = moreLabel;
    
    //其实这个功能主要就在于这一步，我们只需要将知道scrollview的contensize就可以随意在后面添加视图，再根据滑动偏移量作出相应变化即可
    [itemView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    // 这个就算看不见也需要处理
    if ([keyPath isEqualToString:@"contentSize"]) {
        CGRect arrowFrame = self.arrowImageV.frame;
        arrowFrame.origin.x = self.collectionView.contentSize.width + 5.0;
        self.arrowImageV.frame = arrowFrame;
        CGRect moreLabelFrame = self.moreLabel.frame;
        moreLabelFrame.origin.x = arrowFrame.origin.x + arrowFrame.size.width+5.0;
        self.moreLabel.frame = moreLabelFrame;
    }
}

#pragma mark -- datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyCollectionViewCell" forIndexPath:indexPath];
    cell.preImgV.image = [UIImage imageNamed:self.imageArray[indexPath.item]];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(scrollView.contentOffset.x + scrollView.bounds.size.width  - scrollView.contentSize.width >= leftSwipeLength) {
        [UIView animateWithDuration:0.2 animations:^{
            self.arrowImageV.transform = CGAffineTransformMakeRotation(M_PI);
            self.moreLabel.text = @"释放查看详情";
            self.moreLabel.textColor = [UIColor redColor];
        }];
        
    }else {
        [UIView animateWithDuration:0.2 animations:^{
            self.moreLabel.text = @"滑动查看详情";
            self.moreLabel.textColor = [UIColor lightGrayColor];
            self.arrowImageV.transform = CGAffineTransformIdentity;
        }];
       
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (scrollView==self.collectionView) {
        if(scrollView.contentOffset.x + scrollView.bounds.size.width - scrollView.contentSize.width >= leftSwipeLength){
            NSLog(@"左滑加载更多触发");
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"进入查看详情界面" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

- (void)dealloc {
    [self.collectionView removeObserver:self forKeyPath:@"contentSize" context:nil];
}


@end
