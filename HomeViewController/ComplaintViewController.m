//
//  ComplaintViewController.m
//  IDo
//
//  Created by YangJiLei on 15/8/31.
//  Copyright (c) 2015年 IDo. All rights reserved.
//投诉

#import "ComplaintViewController.h"

@interface ComplaintViewController ()

@end

@implementation ComplaintViewController
@synthesize tableView,textView,titleArr,selIndex;
@synthesize tousuId,beitousuId;

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"投诉";
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    
    self.titleArr = [NSArray arrayWithObjects:@"抢错单",@"不实订单",@"违约(须填写原因)",nil];
    
    self.textView = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(15, 15, self.view.frame.size.width-30, 100)];
    self.textView.delegate = self;
    self.textView.backgroundColor = [UIColor whiteColor];
    [self.textView setPlaceholder:@"请输入投诉原因"];
    self.textView.keyboardType = UIKeyboardTypeDefault;
    self.textView.returnKeyType = UIReturnKeyDone;
    self.textView.editable = YES;
    self.textView.textColor = COLOR(98, 98, 98);
    self.textView.font = [UIFont systemFontOfSize:16];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0.0f,0,kWindowWidth,kWindowHeight-50) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor clearColor];
    [AppTools clearTabViewLine:self.tableView];
    self.tableView.rowHeight = 50;
    self.tableView.separatorColor = COLOR(164, 164, 164);
    [self.view addSubview:self.tableView];
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame=CGRectMake(20, kWindowHeight-50, kWindowWidth-40, 40);
    [btn setBackgroundImage:[UIImage imageNamed:@"callbtn.png"] forState:UIControlStateNormal];
    [btn setTintColor:[UIColor whiteColor]];
    btn.titleLabel.font = [UIFont systemFontOfSize:17];
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(Submit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)Submit
{
    NSString *testStr = self.textView.text;
    testStr = [testStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (self.selIndex == 2) {
        if (testStr.length < 1) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"系统提示" message:@"请输入投诉内容" delegate:nil cancelButtonTitle:@"确定"otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
    }
    
    [SVProgressHUD showWithStatus:@"正在提交"];
    NSString *url = [NSString stringWithFormat:@"%@complaint",baseUrl];
    NSMutableDictionary*mDict = [NSMutableDictionary dictionary];
    [mDict setObject:[NSString stringWithFormat:@"%ld",selIndex+2] forKey:@"type"];
    [mDict setObject:self.tousuId forKey:@"tousurenid"];
    [mDict setObject:self.beitousuId forKey:@"beitousurenid"];
    [mDict setObject:self.textView.text forKey:@"content"];

    [SVHTTPRequest POST:url parameters:mDict completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        [SVProgressHUD dismiss];
        if (response)
        {
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
            NSString *tempStatus = [NSString stringWithFormat:@"%@",dict[@"status"]];
            NSString *content = dict[@"info"];
            if ([tempStatus integerValue] == 1) {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"系统提示" message:@"您的投诉已成功提交" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                if (content.length) {
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"系统提示" message:content delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];

                } else {
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"系统提示" message:@"您的投诉提交失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];

                }
            }
        }else{
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"系统提示" message:@"您的投诉提交失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return self.titleArr.count;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

-(void)tableView:(UITableView*)tableView  willDisplayCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}

- (UITableViewCell *)tableView:(UITableView *)tableViews cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableViews dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20.0f, 5.f, 40.0f, 40.0f)];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.tag = 990;
        [cell.contentView addSubview:imageView];
        
        UILabel *titlelab = [[UILabel alloc] initWithFrame:CGRectMake(60.0f, 0.0, 200.0f, 50.0f)];
        titlelab.backgroundColor = [UIColor clearColor];
        titlelab.font = [UIFont systemFontOfSize:15];
        titlelab.textColor = COLOR(49, 49, 49);
        titlelab.tag = 991;
        [cell.contentView addSubview:titlelab];
    }
    
    UIImageView *imageView = (UIImageView*)[cell.contentView viewWithTag:990];
    if (indexPath.section == selIndex) {
        imageView.image = [UIImage imageNamed: @"login_selected"];
    }else{
        imageView.image = [UIImage imageNamed: @"login"];
    }
    
    
    UILabel *titlelab = (UILabel*)[cell.contentView viewWithTag:991];
    titlelab.text = titleArr[indexPath.section];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        return 130;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kWindowWidth, 130.0f)];
        view.backgroundColor = COLOR(200, 200, 200);
        [view addSubview:self.textView];
        return view;
    }
    return nil;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableViews didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.textView resignFirstResponder];
    [tableViews deselectRowAtIndexPath:indexPath animated:YES];//消除选中状态
    self.selIndex = indexPath.section;
    [self.tableView reloadData];
 }

#pragma mark --
#pragma mark UITextDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        
        [self.textView resignFirstResponder];
        return NO;
    }
    return YES;
}

@end
