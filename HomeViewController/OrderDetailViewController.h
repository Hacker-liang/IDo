//
//  OrderDetailViewController.h
//  IDo
//
//  Created by liangpengshuai on 9/26/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *addressBtn;
@property (weak, nonatomic) IBOutlet UIButton *orderNumberBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLeftLabel;
@property (weak, nonatomic) IBOutlet MKMapView *mapview;

@property (nonatomic) BOOL isSendOrder;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, strong) OrderDetailModel *orderDetail;

- (void)updateDetailViewWithStatus:(OrderStatus)status andShouldReloadOrderDetail:(BOOL)isReload;

@end
