//
//  MyCollectionViewCell.m
//  LeftSwipeToDetail
//
//  Created by 蒋理智 on 2019/1/7.
//  Copyright © 2019年 jingwan. All rights reserved.
//

#import "MyCollectionViewCell.h"

@implementation MyCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView = [UIImageView new];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [self.contentView addSubview:imageView];
        self.preImgV = imageView;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.preImgV.frame = self.bounds;
}

@end
