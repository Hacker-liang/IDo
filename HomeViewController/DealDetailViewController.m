//
//  TixianViewController.m
//  xianne
//
//  Created by coca on 15/6/27.
//  Copyright (c) 2015年 coca. All rights reserved.
//

#import "DealDetailViewController.h"

@interface DealDetailViewController ()

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation DealDetailViewController
@synthesize titleStr,dealArr;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.titleStr;
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatMainView];
    [self.tableView.header beginRefreshing];

}

-(void)creatMainView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getDataFromSever];
    }];
}

#pragma mark - GetData 

- (void)getDataFromSever
{
    NSString *url = [NSString stringWithFormat:@"%@%@",baseUrl,[self.titleStr isEqualToString:@"收支明细"]?@"getshouzhi":@"getExtract"];;
    NSMutableDictionary*mDict = [NSMutableDictionary dictionary];
    [mDict setObject:[UserManager shareUserManager].userInfo.userid forKey:@"memberid"];
    [SVHTTPRequest POST:url parameters:mDict completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        [self.tableView.header endRefreshing];
        if (response)
        {
            NSString *jsonString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            NSDictionary *dict = [jsonString objectFromJSONString];
            NSArray *tempList = dict[@"data"];
            if ([tempList isKindOfClass:[NSArray class]]) {
                [dealArr removeAllObjects];
                dealArr = [NSMutableArray arrayWithArray:tempList];
                [self.tableView reloadData];
            }
        }
        else
        {
            UIAlertView *failedAlert = [[UIAlertView alloc]initWithTitle:nil message:messageError delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [failedAlert show];
        }
    }];
}

#pragma mark - TableViewDelegate

#pragma mark -
#pragma mark Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

//设置区域个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//设置每个区域的Item个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return dealArr.count;;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(UITableViewCell *)tableView:(UITableView *)tableViews cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellID = @"dealCell";
    UITableViewCell * cell = [tableViews dequeueReusableCellWithIdentifier:cellID];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    for(UIView * v in cell.contentView.subviews){
        [v removeFromSuperview];
    }
    
    NSDictionary *dic = [dealArr objectAtIndex:indexPath.row];
    
    NSString *typeStr;
    
    if ([self.titleStr isEqualToString:@"收支明细"]) {
        //1支出 2收入 4退款
        switch ([dic[@"type"]intValue]) {
            case 1:
                typeStr = @"支出";
                break;
            case 2:
                typeStr = @"收入";
                break;
            case 4:
                typeStr = @"退款";
                break;
                
            default:
                break;
        }

    }else{
        //0提现 1充值
        switch ([dic[@"isAdd"]intValue]) {
            case 0:
                typeStr = @"提现";
                break;
            case 1:
                typeStr = @"充值";
                break;
           
            default:
                break;
        }

    }
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 200, 20)];
    titleLabel.text = typeStr;
    titleLabel.font = [UIFont systemFontOfSize:17];
    [cell.contentView addSubview:titleLabel];
    
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(titleLabel.frame)+10, 200, 20)];
    titleLabel.text = [NSString stringWithFormat:@"财务流水号：%@",dic[@"id"]];
    titleLabel.font = [UIFont systemFontOfSize:15];
    [cell.contentView addSubview:titleLabel];
    
    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame)+15, 15, self.view.frame.size.width-CGRectGetMaxX(titleLabel.frame)-15*2, 20)];
    contentLabel.text = dic[@"money"];
    contentLabel.font = [UIFont systemFontOfSize:17];
    contentLabel.textAlignment = NSTextAlignmentRight;
    contentLabel.textColor = UIColorFromRGB(0x3ab34c);
    [cell.contentView addSubview:contentLabel];
    
    contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(contentLabel.frame.origin.x, CGRectGetMaxY(contentLabel.frame)+10, contentLabel.frame.size.width, 20)];
    contentLabel.text = dic[@"time"];
    contentLabel.font = [UIFont systemFontOfSize:15];
    contentLabel.textAlignment = NSTextAlignmentRight;
    contentLabel.textColor = UIColorFromRGB(0xbcbcbc);
    [cell.contentView addSubview:contentLabel];
    
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
