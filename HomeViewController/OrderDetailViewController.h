//
//  OrderDetailViewController.h
//  IDo
//
//  Created by liangpengshuai on 9/26/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

typedef enum : NSUInteger {
    /**
     *  抢单列表进入
     */
    GrabOrder,
    /**
     *  派单历史进入
     */
    HistoryPie,
    /**
     *  抢单历史进入
     */
    HistoryGrab,
    /**
     *正在进行的派单进入
     */
    OrderIngPie,
    /**
     *正在进行的抢单进入
     */
    OrderIngGrab,
    /**
     *发单人验收订单
     */
    OrderFinish,
    /**
     *接单人催促发单人验收
     */
    OrderUrge
    
} OrderDetailType;

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

@property (nonatomic) OrderDetailType orderDetailType;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, strong) OrderDetailModel *orderDetail;
@end
