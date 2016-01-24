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
        //1支出 2收入 3退款
        switch ([dic[@"type"]intValue]) {
            case 1:
                typeStr = @"支出";
                break;
            case 2:
                typeStr = @"收入";
                break;
            case 3:
                typeStr = @"退款";
                break;
                
            case 4:
                typeStr = @"红包支出";
                break;
                
            case 5:
                typeStr = @"红包退款";
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
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 50, 20)];
    titleLabel.text = typeStr;
    titleLabel.font = [UIFont systemFontOfSize:17];
    [cell.contentView addSubview:titleLabel];

    if (![self.titleStr isEqualToString:@"收支明细"]) {
        NSString *flagStr;
        switch ([dic[@"flag"]intValue]) {
            case 1:
                flagStr = @"待审核";
                break;
            case 2:
                flagStr = @"初审通过";
                break;
            case 3:
                flagStr = @"审核通过";
                break;
            case 4:
                flagStr = @"审核拒绝";
                break;
                
            default:
                flagStr = @"";
                break;
        }
        UILabel *flagLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 15, 100, 20)];
        flagLabel.font = [UIFont systemFontOfSize:13.0];
        flagLabel.textColor = UIColorFromRGB(0x3DC219);
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat: @"状态：%@", flagStr]];
        [attStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14.0] range:NSMakeRange(0, 3)];
        [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, 3)];        flagLabel.attributedText = attStr;
        [cell.contentView addSubview:flagLabel];
    }
    
    
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(titleLabel.frame)+10, 200, 20)];
    titleLabel.text = [NSString stringWithFormat:@"财务流水号：%@",dic[@"id"]];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.adjustsFontSizeToFitWidth = YES;
    [cell.contentView addSubview:titleLabel];
    
    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame)+15, 15, self.view.frame.size.width-CGRectGetMaxX(titleLabel.frame)-15*2, 20)];
    contentLabel.text = dic[@"money"];
    contentLabel.font = [UIFont systemFontOfSize:17];
    contentLabel.textAlignment = NSTextAlignmentRight;
    contentLabel.textColor = UIColorFromRGB(0x3ab34c);
    [cell.contentView addSubview:contentLabel];
    
    contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(200, CGRectGetMaxY(contentLabel.frame)+10, self.view.frame.size.width-210, 20)];
    contentLabel.text = dic[@"time"];
    contentLabel.adjustsFontSizeToFitWidth = YES;
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
