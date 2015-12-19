//
//  AboutViewController.m
//  IDo
//
//  Created by YangJiLei on 15/7/30.
//  Copyright (c) 2015年 IDo. All rights reserved.
//

#import "AboutViewController.h"
#import "FeedbackViewController.h"
#import "ContactUsViewController.h"

@interface AboutViewController ()
{
    NSString *APPTITTLE;
}
@end

@implementation AboutViewController

- (void)backClick
{
    //    [self dismissViewControllerAnimated:YES completion:^(void) {}];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"关于我们";
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSUserDefaults *APPTittleDefaults=[NSUserDefaults standardUserDefaults];
    
    APPTITTLE =[APPTittleDefaults objectForKey:@"APPTittle"];
    
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-30, 84, 60, 60)];
    img.image=[UIImage imageNamed:@"Icon.png"];
    [self.view addSubview:img];
    UILabel *banben=[[UILabel alloc]initWithFrame:CGRectMake(0, 164, self.view.frame.size.width, 20)];
    NSDictionary *infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString *versionNum =[infoDict objectForKey:@"CFBundleShortVersionString"];
    NSString *text =[NSString stringWithFormat:@"v%@",versionNum];
    banben.text = [NSString stringWithFormat:@"%@ %@",APPTITTLE, text];
    banben.textAlignment=1;
    [self.view addSubview:banben];
    
    
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 190, self.view.frame.size.width, self.view.frame.size.height-160) style:UITableViewStyleGrouped];
    self.tableView.delegate= self;
    self.tableView.dataSource =self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str=@"cell";
    NSArray *arr=@[@"  意见建议", @"  联系我们"];
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:str];
    cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    cell.textLabel.text=arr[indexPath.section*2+indexPath.row];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section*2+indexPath.row)
    {
        case 0:
        {
            FeedbackViewController *control=[[FeedbackViewController alloc]init];
            [self.navigationController pushViewController:control animated:YES];
        }
            break;
       
        case 1:
        {
            ContactUsViewController *control=[[ContactUsViewController alloc]init];
            control.title=@"联系我们";
            [self.navigationController pushViewController:control animated:YES];
        }
            break;
        default:
            break;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
