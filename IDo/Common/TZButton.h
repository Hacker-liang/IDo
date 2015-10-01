//
//  TZButton.h
//  PeachTravel
//
//  Created by liangpengshuai on 12/12/14.
//  Copyright (c) 2014 com.aizou.www. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    IMAGE_AT_TOP,
    IMAGE_AT_RIGHT
} IMAGE_ORIENTATION;

@interface TZButton : UIButton

@property (nonatomic, assign) IMAGE_ORIENTATION imagePosition;

/**
 *  图片距离上方的间距
 */
@property (nonatomic) CGFloat topSpaceHight;

/**
 *  图片和文字的间距
 */
@property (nonatomic) CGFloat spaceHight;

@end
