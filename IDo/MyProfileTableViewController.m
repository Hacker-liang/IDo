//
//  MyProfileTableViewController.m
//  IDo
//
//  Created by liangpengshuai on 9/23/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import "MyProfileTableViewController.h"
#import "MyProfileHeaderView.h"
#import "MyProfileTableViewCell.h"
#import "ASIFormDataRequest.h"
#import "Requtst2BeVIPViewController.h"
#import "ChangeAlipayViewController.h"

@interface MyProfileTableViewController () <UIImagePickerControllerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) MyProfileHeaderView *myprofileHeaderView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) UserInfo *userInfo;
@property (nonatomic, strong) UIImage *headerImage;


@end

@implementation MyProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _userInfo = [UserManager shareUserManager].userInfo;
    _dataSource = @[@"我的手机号", @"昵称", @"性别", @"我的支付宝", @"声音控制"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MyProfileTableViewCell" bundle:nil] forCellReuseIdentifier:@"myProfileCell"];
    [self setupTableViewFooterView];
    self.navigationItem.title = @"个人中心";
    [[UserManager shareUserManager] asyncLoadAccountInfoFromServer:^(BOOL isSuccess) {
        if (isSuccess) {
            _userInfo = [UserManager shareUserManager].userInfo;
            _myprofileHeaderView.userInfo = _userInfo;
            [self.tableView reloadData];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupTableViewFooterView
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 140)];
    
    UIButton *logoutBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, footerView.bounds.size.width-20, 40)];
    logoutBtn.backgroundColor = APP_THEME_COLOR;
    logoutBtn.layer.cornerRadius = 5.0;
    [logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    logoutBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [logoutBtn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:logoutBtn];
    self.tableView.tableFooterView = footerView;
}

- (MyProfileHeaderView *)myprofileHeaderView
{
    if (!_myprofileHeaderView) {
        _myprofileHeaderView = [MyProfileHeaderView myProfileHeaderView];
        _myprofileHeaderView.ratingView.isYellow = NO;
        _myprofileHeaderView.userInfo = _userInfo;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setUserHead)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        _myprofileHeaderView.headerImageView.userInteractionEnabled = YES;
        [_myprofileHeaderView.headerImageView addGestureRecognizer:tap];
    }
    return _myprofileHeaderView;
}

- (void)logout
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确定退出登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [SVProgressHUD showWithStatus:@"正在退出"];
            [[UserManager shareUserManager] asyncLogout:^(BOOL isSuccess) {
                if (isSuccess) {
                    [SVProgressHUD showSuccessWithStatus:@"退出登录成功"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"userDidLogout" object:nil userInfo:nil];
                } else {
                    [SVProgressHUD showErrorWithStatus:@"退出登录失败"];
                }
            }];
        }
    }];
   
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 270;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.myprofileHeaderView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myProfileCell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryNone;

    } else if (indexPath.row == 4) {
        UISwitch *switchView;
        if ([cell.accessoryView isKindOfClass:[UISwitch class]]) {
            switchView = (UISwitch *)cell.accessoryView;
        } else {
            switchView=[[UISwitch alloc]init];
        }
        [switchView addTarget:self action:@selector(switchAction:) forControlEvents:(UIControlEventTouchUpInside)];
        if(!self.userInfo.isMute) {
            [switchView setOn:YES animated:NO];
        } else {
            [switchView setOn:NO animated:NO];
        }
        cell.accessoryView=switchView;
        cell.textLabel.font = [UIFont systemFontOfSize:17.0];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.text = @" 声音控制";

    } else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSString *title = _dataSource[indexPath.row];
    cell.titleLabel.text = title;

    switch (indexPath.row) {
        case 0:
            cell.subtitleLabel.text = [NSString stringWithFormat:@"%@(不可修改)", _userInfo.tel];
            break;
            
        case 1:
            cell.subtitleLabel.text = _userInfo.nickName;

            break;
            
        case 2:
            if ([_userInfo.sex integerValue] == 1 || [_userInfo.sex isEqualToString:@"0"]) {
                cell.subtitleLabel.text = @"男";
            } else {
                cell.subtitleLabel.text = @"女";
            }

            break;
            
        case 3:
            cell.subtitleLabel.text = _userInfo.zhifubao;

            break;
            
        case 4:
            cell.subtitleLabel.text = nil;

            break;
            
        case 5:
            cell.subtitleLabel.text = nil;

            break;
        default:
            break;
    }
    
    return cell;
}


//选中项回调
- (void)tableView:(UITableView *)stableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [stableView deselectRowAtIndexPath:indexPath animated:YES];//消除选中状态
    if (indexPath.section == 0 && indexPath.row == 1) {
        UIAlertView *thAlertView = [[UIAlertView alloc] initWithTitle:@"昵称"
                                                              message:@"请输入昵称"
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                                    otherButtonTitles:@"确定",nil];
        thAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField *tf=[thAlertView textFieldAtIndex:0];
        tf.text = _userInfo.nickName;
        tf.keyboardType = UIKeyboardTypeDefault;
        thAlertView.tag = 500;
        [thAlertView show];
    }
    
    if (indexPath.section == 0 && indexPath.row == 2) {
        UIActionSheet * editActionSheet = [[UIActionSheet alloc] initWithTitle:@"修改性别" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"男",@"女",nil];
        [editActionSheet addButtonWithTitle:@"取消"];
        editActionSheet.delegate = self;
        editActionSheet.tag = 601;
        [editActionSheet showInView:self.view];
    }
    
    if (indexPath.section == 0 && indexPath.row == 3) {
//        UIAlertView *thAlertView = [[UIAlertView alloc] initWithTitle:@"支付宝"
//                                                              message:@"请输入支付宝账户"
//                                                             delegate:self
//                                                    cancelButtonTitle:@"取消"
//                                                    otherButtonTitles:@"确定",nil];
//        thAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
//        UITextField *tf=[thAlertView textFieldAtIndex:0];
//        tf.text = _userInfo.zhifubao;
//        tf.keyboardType = UIKeyboardTypeDefault;
//        thAlertView.tag = 501;
//        [thAlertView show];
        ChangeAlipayViewController *ctl = [[ChangeAlipayViewController alloc] init];
        [self.navigationController pushViewController:ctl animated:YES];
    }
}

-(void)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (!isButtonOn) {
        [[UserManager shareUserManager] setNotiMute:YES];
        [self changeUserSet:@"1" Type:@"6"];

    }else {
        [[UserManager shareUserManager] setNotiMute:NO];
        [self changeUserSet:@"0" Type:@"6"];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        if (alertView.tag == 500) {
            //得到输入框
            UITextField *tf=[alertView textFieldAtIndex:0];
            if (tf.text.length > 0 && [tf.text stringByReplacingOccurrencesOfString:@" " withString:@""].length >0)
            {
                [self changeUserSet:tf.text Type:@"1"];
            }
        }else if (alertView.tag == 501){
            UITextField *tf=[alertView textFieldAtIndex:0];
            if (tf.text.length > 0 && [tf.text stringByReplacingOccurrencesOfString:@" " withString:@""].length >0)
            {
                [self changeUserSet:tf.text Type:@"4"];
                _userInfo.zhifubao = tf.text;
            }
        }
    }
}

- (void)changeUserSet:(NSString *)aContent Type:(NSString*)aType
{
    [SVProgressHUD showWithStatus:@"正在修改"];
    NSString *url = [NSString stringWithFormat:@"%@editmembermes",baseUrl];
    NSMutableDictionary*mDict = [NSMutableDictionary dictionary];
    [mDict setObject:_userInfo.userid forKey:@"memberid"];
    [mDict setObject:aContent forKey:@"content"];
    [mDict setObject:aType forKey:@"type"];
    
    [SVHTTPRequest POST:url parameters:mDict completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (response)
        {
            NSString *jsonString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            NSLog(@"jsonString = %@",jsonString);
            NSDictionary *dict = [jsonString objectFromJSONString];
            if ([[dict objectForKey:@"status"] integerValue] == 30001 || [[dict objectForKey:@"status"] integerValue] == 30002) {
                if ([UserManager shareUserManager].isLogin) {
                                        [UserManager shareUserManager].userInfo = nil;
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"info"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alertView showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"userInfoError" object:nil];
                    }];
                }
                return;
            }
            NSInteger status = [[dict objectForKey:@"status"] integerValue];
            if (status == 1) {
                [SVProgressHUD showSuccessWithStatus:@"修改成功"];
                if ([aType integerValue] == 1) {
                    _userInfo.nickName = aContent;
                    _myprofileHeaderView.nickNameLabel.text = _userInfo.nickName;
                } else if ([aType integerValue] == 4) {
                    _userInfo.zhifubao = aContent;
                }
                [[UserManager shareUserManager] saveUserData2Cache];
                [self.tableView reloadData];
            } else {
                NSString *info = [dict objectForKey:@"info"];
                if (info) {
                    [SVProgressHUD showErrorWithStatus:info];
                } else {
                    [SVProgressHUD showErrorWithStatus:@"修改失败"];
                }
            }
        } else {
            [SVProgressHUD showErrorWithStatus:@"修改失败"];
        }
    }];
}

#pragma mark - 修改用户信息
- (void)setUserHead
{
    UIActionSheet * editActionSheet = [[UIActionSheet alloc] initWithTitle:@"设置头像" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册中选择",nil];
    [editActionSheet addButtonWithTitle:@"取消"];
    editActionSheet.delegate = self;
    [editActionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 601) {
        if (buttonIndex == 0) {
            [self changeUserSet:@"1" Type:@"3"];
            [UserManager shareUserManager].userInfo.sex = @"1";
            [[UserManager shareUserManager] saveUserData2Cache];

        } else if (buttonIndex == 1) {
            [self changeUserSet:@"2" Type:@"3"];
            [UserManager shareUserManager].userInfo.sex = @"2";
            [[UserManager shareUserManager] saveUserData2Cache];
        }
        
    } else {
        if (buttonIndex + 1 >= actionSheet.numberOfButtons ) {
            return;
        }
        if (buttonIndex == 0)
        {
            NSUInteger sourceType = 0;
            // 判断是否支持相机
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                sourceType = UIImagePickerControllerSourceTypeCamera;
            }
            else
            {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
            
            // 跳转到相机或相册页面
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            
            imagePickerController.delegate = self;
            
            imagePickerController.allowsEditing = YES;
            
            imagePickerController.sourceType = sourceType;
            
            [self presentViewController:imagePickerController animated:NO completion:^(void) {}];
        }
        else if (buttonIndex == 1)
        {
            NSUInteger sourceType = 0;
            // 判断是否支持相机
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }
            else
            {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
            
            // 跳转到相机或相册页面
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            
            imagePickerController.delegate = self;
            
            imagePickerController.allowsEditing = YES;
            
            imagePickerController.sourceType = sourceType;
            
            [self presentViewController:imagePickerController animated:NO completion:^(void) {}];
        }
    }
}

# pragma mark 选取头像
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        _headerImage  = [info objectForKey:UIImagePickerControllerOriginalImage];
        NSData *imageData = UIImageJPEGRepresentation(_headerImage,0.5);
        [self uploadHeadImage:imageData];
        
    }];
}

- (void)uploadHeadImage:(NSData*)imageData
{
    [SVProgressHUD showWithStatus:@"正在上传"];
    ASIFormDataRequest *uploadImageRequest= [ASIFormDataRequest requestWithURL:[NSURL URLWithString:uploadheadImgURL]];
    [uploadImageRequest setRequestMethod:@"POST"];
    [uploadImageRequest setPostFormat:ASIMultipartFormDataPostFormat];
    
    //使用日期来保存
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd-hh:mm"];
    NSString *currDate = [dateFormat stringFromDate:[NSDate date]];
    
    NSString *photoName=[NSString stringWithFormat:@"%@.jpg",currDate];
    
    NSString *photoDescribe=@" ";
    
    NSLog(@"photoName=%@",photoName);
    
    NSLog(@"photoDescribe=%@",photoDescribe);
    
    NSLog(@"图片大小+++++%ld",[imageData length]/1024);
    
    //照片content
    [uploadImageRequest addData:imageData withFileName:photoName andContentType:@"image/jpeg" forKey:@"file"];
    
    [uploadImageRequest setDelegate : self ];
    
    [uploadImageRequest setDidFinishSelector : @selector (requestFinished:)];
    
    [uploadImageRequest setDidFailSelector : @selector (responseFailed:)];
    
    [uploadImageRequest startAsynchronous];
}

#pragma mark ASIHTTPRequest Delegate Methods
- (void)requestFinished:(ASIHTTPRequest *)request {
    NSString *jsonString = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
    NSDictionary *dict = [jsonString objectFromJSONString];
    if (dict) {
        NSString *errorCode = dict[@"errorCode"];
        if ([errorCode integerValue] == 0) {
            NSString *dataStr = [NSString stringWithFormat:@"%@",dict[@"data"]];
            if ((NSNull *)dataStr != [NSNull null] && ![dataStr isEqualToString:@""]) {
                NSString *headPath = dict[@"data"][@"origin"];
                [self uploadHeadPath:headPath];
            }
        }else{
            [SVProgressHUD dismiss];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"系统提示"
                                                                message:dict[@"errorMsg"]
                                                               delegate:self
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil,nil];
            [alertView show];
        }
    }
}

- (void)responseFailed:(ASIHTTPRequest *)request {
    [SVProgressHUD dismiss];
    UIAlertView *failedAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络出问题了，请稍候重试!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [failedAlert show];
}

- (void)uploadHeadPath:(NSString*)aPath
{
    NSString *url = [NSString stringWithFormat:@"%@surememberimg",baseUrl];
    NSMutableDictionary*mDict = [NSMutableDictionary dictionary];
    [mDict setObject:[UserManager shareUserManager].userInfo.userid forKey:@"memberid"];
    [mDict setObject:aPath forKey:@"img"];
    [SVHTTPRequest POST:url parameters:mDict completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (response) {
            NSString *jsonString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            NSDictionary *dict = [jsonString objectFromJSONString];
            if ([[dict objectForKey:@"status"] integerValue] == 30001 || [[dict objectForKey:@"status"] integerValue] == 30002) {
                if ([UserManager shareUserManager].isLogin) {
                                        [UserManager shareUserManager].userInfo = nil;
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"info"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alertView showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"userInfoError" object:nil];
                    }];
                }
                return;
            }
            if ([dict[@"status"] integerValue] == 1) {
                [UserManager shareUserManager].userInfo.avatar = [NSString stringWithFormat:@"%@%@",headURL,aPath];
                [[UserManager shareUserManager] saveUserData2Cache];
                [_myprofileHeaderView.headerImageView sd_setImageWithURL:[NSURL URLWithString:aPath] placeholderImage:_headerImage];

                [SVProgressHUD showSuccessWithStatus:@"上传成功"];
                
            }else{

                [SVProgressHUD showErrorWithStatus:@"头像上传失败，请稍后再试！"];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:@"头像上传失败，请稍后再试！"];
        }
    }];
}



@end
