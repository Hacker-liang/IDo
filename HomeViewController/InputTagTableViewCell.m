//
//  InputTagTableViewCell.m
//  IDo
//
//  Created by liangpengshuai on 10/5/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import "InputTagTableViewCell.h"

@implementation InputTagTableViewCell

- (void)awakeFromNib {
    _addBtn.layer.cornerRadius = 3.0;
    _addBtn.clipsToBounds = YES;
    _textField.layer.borderColor = UIColorFromRGB(0x3DC219).CGColor;
    _textField.layer.borderWidth = 0.5;
    _textField.layer.cornerRadius = 3.0;
    _textField.delegate = self;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];  //textField为你的UITextField实例对象
        return NO;
    }
    return YES;
}

@end
