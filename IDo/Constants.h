//
//  Constants.h
//  IDo
//
//  Created by liangpengshuai on 9/23/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#ifdef __OBJC__


#define baseUrl @"http://58.30.16.58/?action="
//#define baseUrl @"http://112.124.51.74/?action="

#define kYzmURL @"http://58.30.16.58/SMS.php"
#define severURL @"http://58.30.16.58/"
#define uploadheadImgURL @"http://58.30.16.59/upload/upload.php"
#define headURL @"http://58.30.16.59/image"

/***** 设备信息 *****/

#define kWindowWidth   [UIApplication sharedApplication].keyWindow.frame.size.width
#define kWindowHeight  [UIApplication sharedApplication].keyWindow.frame.size.height

#define SCREEN_MAX_LENGTH (MAX(kWindowWidth, kWindowHeight))

#define Top_ButtonRect CGRectMake(10.0f, 0.0f,44.0f , 44.0f)
#define Top_RightButtonRect CGRectMake(0.0f, 0.0f,54.0f , 30.0f)

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_4  (fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )480 ) < DBL_EPSILON)
#define IS_IPHONE_5  (fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON)
#define IS_IPHONE_6  (fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )667 ) < DBL_EPSILON)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define Proportion (isPad ? 1 : self.view.frame.size.width/320)

#define Frame(x,y,w,h) CGRectMake(x*Proportion,y*Proportion,w*Proportion,h*Proportion)
#define Height(h) h*Proportion
#define Width(w) w*Proportion

#define IS_IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define COLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

#define APP_THEME_COLOR                 UIColorFromRGB(0xFB6016)
#define APP_PAGE_COLOR                 UIColorFromRGB(0xECECEC)
#define LineColor [UIColor colorWithRed:190/255.0 green:190/255.0 blue:190/255.0 alpha:1]

#define LoginInfoMark @"LoginInfoMark"  //登录信息相关

#define OrderStatusChange @"OrderStatusChangeMark"  //订单状态改变
#define OrderPieStatusChange @"OrderPieStatusChange"  ///派单状态改变
#define OrderGrabStatusChange @"OrderGrabStatusChange"  ///抢单状态改变
#define OrderidMark @"OrderidMark"  ///订单id
#define UserStatusMark @"setUserStatus"  ///设置当前用户身份

#define messageError @"网络貌似出问题了，等一会儿再试试吧…"

#endif

#endif /* Constants_h */
