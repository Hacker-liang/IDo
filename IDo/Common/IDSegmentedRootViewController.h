//
//  IDSegmentedRootViewController.h
//  IDo
//
//  Created by liangpengshuai on 9/23/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IDSegmentedRootViewController : UIViewController

/**
 *  选中后的颜色
 */
@property (nonatomic, strong) UIColor *selectedColor;

/**
 *  未选中的颜色
 */
@property (nonatomic, strong) UIColor *normalColor;

/**
 *  切换键的图像
 */
@property (nonatomic, strong) NSArray *segmentedNormalImages;
@property (nonatomic, strong) NSArray *segmentedSelectedImages;

/**
 *  切换键的标题
 */
@property (nonatomic, strong) NSArray *segmentedTitles;

@property (nonatomic) CGFloat indictorWidth;


@property (nonatomic, strong) UIFont *segmentedTitleFont;

@property (nonatomic, strong) NSArray *viewControllers;

- (void)changePage:(NSInteger)pageIndex;

@end
