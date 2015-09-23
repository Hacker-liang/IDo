//
//  HomeMenuTableViewHeaderView.m
//  IDo
//
//  Created by liangpengshuai on 9/23/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import "HomeMenuTableViewHeaderView.h"

@implementation HomeMenuTableViewHeaderView


+ (id)homeMenuTableViewHeaderView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"HomeMenuTableViewHeaderView" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib
{
    self.backgroundColor = [UIColor orangeColor];
}

@end
