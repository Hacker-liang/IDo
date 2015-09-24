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

@interface MyProfileTableViewController ()

@property (nonatomic, strong) MyProfileHeaderView *myprofileHeaderView;
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation MyProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource = @[@"我的手机号", @"昵称", @"性别", @"我的支付宝", @"VIP 申请", @"声音控制"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MyProfileTableViewCell" bundle:nil] forCellReuseIdentifier:@"myProfileCell"];
    [self setupTableViewFooterView];
    self.navigationItem.title = @"个人中心";
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
    }
    return _myprofileHeaderView;
}

- (void)logout
{
    
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
    NSString *title = _dataSource[indexPath.row];
    cell.titleLabel.text = title;
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
