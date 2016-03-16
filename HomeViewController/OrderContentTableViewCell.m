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
    _contentTextView.layer.borderWidth = 1;
    _contentTextView.layer.cornerRadius = 3.0;
    _contentTextView.delegate = self;
    _contentTextView.returnKeyType = UIReturnKeyDone;
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

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if (_isSendRed) {
        if ([text isEqualToString:@"\n"]) {
            
            [self.contentTextView resignFirstResponder];
            return NO;
        }
        if (textView.text.length > 100 && text.length) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"红包寄语最多输入100个字" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                
            }];
            return NO;
        }
        return YES;
        
    } else {
        if ([text isEqualToString:@"\n"]) {
            
            [self.contentTextView resignFirstResponder];
            return NO;
        }
        return YES;
    }
    
}


@end
