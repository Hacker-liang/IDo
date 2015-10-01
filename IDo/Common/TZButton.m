//
//  TZButton.m
//  PeachTravel
//
//  Created by liangpengshuai on 12/12/14.
//  Copyright (c) 2014 com.aizou.www. All rights reserved.
//

#import "TZButton.h"

@implementation TZButton

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _imagePosition = IMAGE_AT_TOP;
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];

    if (_imagePosition == IMAGE_AT_TOP) {
        [self topImageView];
    } else if (_imagePosition == IMAGE_AT_RIGHT) {
        [self rightImageView];
    }
    
}

- (void) topImageView {
    CGPoint center = self.imageView.center;
    center.x = self.frame.size.width/2;
    center.y = self.imageView.frame.size.height/2+_topSpaceHight;
    self.imageView.center = center;
    
    CGRect newFrame = [self titleLabel].frame;
    newFrame.origin.x = 0;
    newFrame.origin.y = self.imageView.frame.size.height + self.imageView.frame.origin.y + _spaceHight;
    newFrame.size.width = self.frame.size.width;
    
    self.titleLabel.frame = newFrame;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (void) rightImageView {
    
    CGPoint center = self.imageView.center;
    center.x = self.frame.size.width - self.imageView.frame.size.width/2.0;
    self.imageView.center = center;
    
    CGRect newFrame = [self titleLabel].frame;
    newFrame.origin.x = 0;
    newFrame.size.width = self.frame.size.width - CGRectGetWidth(self.imageView.frame)-1;
    self.titleLabel.frame = newFrame;
    
    self.titleLabel.textAlignment = NSTextAlignmentRight;
}

@end
