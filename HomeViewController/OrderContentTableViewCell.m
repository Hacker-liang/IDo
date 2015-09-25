//
//  OrderContentTableViewCell.m
//  IDo
//
//  Created by liangpengshuai on 9/25/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import "OrderContentTableViewCell.h"

@implementation OrderContentTableViewCell

- (void)awakeFromNib {
    _contentTextView.layer.borderColor = LineColor.CGColor;
    _contentTextView.layer.borderWidth = 0.5;
    _contentTextView.layer.cornerRadius = 3.0;
    _contentTextView.delegate = self;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    _placeholderTextField.hidden = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length == 0) {
        _placeholderTextField.hidden = NO;
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    _placeholderTextField.hidden = !(textView.text.length == 0);
}

@end
