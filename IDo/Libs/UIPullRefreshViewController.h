//
//  UIPullRefreshViewController.h
//  iTings
//
//  Created by Tan Anzhen on 11-8-16.
//  Copyright 2011 autoradio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface UIPullRefreshViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate> 
{
	UIView *refreshHeaderView;							//刷新头View
    UILabel *refreshLabel;								//刷新提示信息
	UILabel *lastUpdatedLabel;                          //最后刷新时间
    UIImageView *refreshArrow;							//刷新箭头
    UIActivityIndicatorView *refreshSpinner;			//刷新指示器
    BOOL isDragging;									//是否正在拖拽？
    BOOL isUIPullRefreshLoading;						//是否正在加载
	
	UITableView *tableView;
}

@property (nonatomic, strong) UIView *refreshHeaderView;
@property (nonatomic, strong) UILabel *refreshLabel;
@property (nonatomic, strong) UILabel *lastUpdatedLabel;
@property (nonatomic, strong) UIImageView *refreshArrow;
@property (nonatomic, strong) UIActivityIndicatorView *refreshSpinner;
@property (nonatomic, strong) UITableView *tableView;
- (void)addPullToRefreshHeader;
- (void)startLoading;
- (void)stopLoading;
- (void)refresh;

- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView;

@end
