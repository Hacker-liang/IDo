//
//  GrabTagCollectionViewCell.m
//  IDo
//
//  Created by liangpengshuai on 10/5/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import "GrabTagCollectionViewCell.h"

@implementation GrabTagCollectionViewCell

- (void)awakeFromNib {
}

- (void)setTabBkgImage:(NSString *)tabBkgImage
{
    _tabBkgImage = tabBkgImage;
    [_grabTagBtn setBackgroundImage:[UIImage imageNamed:_tabBkgImage] forState:UIControlStateNormal];
}

@end
