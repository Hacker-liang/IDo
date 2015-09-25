//
//  FYTimeViewController.m
//  闲人帮
//
//  Created by apple  on 15/4/21.
//  Copyright (c) 2015年 冯琰琰. All rights reserved.
//

#import "FYTimeViewController.h"

@interface FYTimeViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIPickerView *pickView;
    NSMutableArray *day;
    NSMutableArray *hour;
    NSMutableArray *min;
}



@end

@implementation FYTimeViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title=@"时间设置";

    self.view.backgroundColor=[UIColor whiteColor];
    
    UIButton *leftBt = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBt.frame = Top_ButtonRect;

    [leftBt addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc]initWithCustomView:leftBt]];

    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    btn.frame=CGRectMake(0, 0, 50, 40);
    [btn setTitleColor:COLOR(59, 59, 59) forState:UIControlStateNormal];
    UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem=right;
    [btn addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
    
    [self initArr];
    pickView=[[UIPickerView alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 150)];
    pickView.delegate=self;
    pickView.dataSource=self;
    
    [self.view addSubview:pickView];

    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(0, 250, self.view.frame.size.width, 60)];
    NSArray *arr=@[@" 天",@" 时",@"分"];
    for (int i=0; i<3; i++)
    {
        CGFloat x=self.view.frame.size.width/4;
        UILabel *lab1=[[UILabel alloc]initWithFrame:CGRectMake(x+100*i, 0, 70, 60)];
        lab1.text=arr[i];
        [lab addSubview:lab1];
    }
    [self.view addSubview:lab];
    

    
}
-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)initArr
{
    //    获取系统的当前时间
    NSDate *now = [NSDate date];
    //        NSLog(@"now date is: %@", now);
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];

    int myhour =(int) [dateComponent hour];
    int minute =(int) [dateComponent minute];
  

    
    day=[NSMutableArray arrayWithCapacity:0];
    hour=[NSMutableArray arrayWithCapacity:0];
    min=[NSMutableArray arrayWithCapacity:0];
    
    NSArray *dayArray=[NSArray arrayWithObjects:@"今天",@"明天",@"后天", nil];
    for (int i=0; i<dayArray.count; i++)
    {
        NSString *istr;
        istr=[NSString stringWithFormat:@"%@",dayArray[i]];
        [day addObject:istr];
        
        if ([istr isEqualToString:@"今天"])
        {
            for (int i=minute; i<60; i++)
            {
                NSString *istr;
                if (i<10)
                {
                    istr=[NSString stringWithFormat:@"0%d",i];
                }
                else
                {
                    istr=[NSString stringWithFormat:@"%d",i];
                }
                [min addObject:istr];
            }
            for (int i=myhour; i<24; i++)
            {
                NSString *istr;
                if (i<10)
                {
                    istr=[NSString stringWithFormat:@"0%d",i];
                }
                else
                {
                    istr=[NSString stringWithFormat:@"%d",i];
                }
                [hour addObject:istr];
            }
        }
        else
        {
            for (int i=0; i<60; i++)
            {
                NSString *istr;
                if (i<10)
                {
                    istr=[NSString stringWithFormat:@"0%d",i];
                }
                else
                {
                    istr=[NSString stringWithFormat:@"%d",i];
                }
                [min addObject:istr];
            }
            for (int i=0; i<24; i++)
            {
                NSString *istr;
                if (i<10)
                {
                    istr=[NSString stringWithFormat:@"0%d",i];
                }
                else
                {
                    istr=[NSString stringWithFormat:@"%d",i];
                }
                [hour addObject:istr];
            }

        }
    }
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component==0)
    {
        return day.count;
    }
    else if(component==1)
    
    {
        return hour.count;
    }
    else
    {
        return min.count;
    }
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component==0)
    {
        return day[row];
    }
    else if(component==1)
        
    {
        return hour[row];
    }
    else
    {
        return min[row];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:
(NSInteger)component
{
    return 80;
}

-(void)select:(id)sender
{
    NSInteger rowDay=[pickView selectedRowInComponent:0];
    NSInteger rowHour=[pickView selectedRowInComponent:1];
    NSInteger rowMin=[pickView selectedRowInComponent:2];
    
    //    获取系统的当前时间
    NSDate *now = [NSDate date];    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    int year =(int) [dateComponent year];
    int month =(int) [dateComponent month];
    int myday =(int) [dateComponent day];

    
    if ([day[rowDay] isEqualToString:@"今天"])
    {
        _strTime=[NSString stringWithFormat:@"%d-%d-%d %@:%@:00",year,month,myday,hour[rowHour],min[rowMin]];
    }
    else if ([day[rowDay] isEqualToString:@"明天"])
    {
        NSDate *nextday=[NSDate dateWithTimeInterval:24*60*60 sinceDate:now];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:nextday];
       
        int year1 =(int) [dateComponent year];
        int month1 =(int) [dateComponent month];
        int day1 =(int) [dateComponent day];
        _strTime = [NSString stringWithFormat:@"%d-%d-%d %@:%@:00",year1,month1,day1,hour[rowHour],min[rowMin]];
    }
    else
    {
        NSDate *NextToday=[NSDate dateWithTimeInterval:24*2*60*60 sinceDate:now];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:NextToday];

        int year2 =(int) [dateComponent year];
        int month2 =(int) [dateComponent month];
        int day2 =(int) [dateComponent day];
        _strTime = [NSString stringWithFormat:@"%d-%d-%d %@:%@:00",year2,month2,day2,hour[rowHour],min[rowMin]];
    }
   NSString *showTime = [NSString stringWithFormat:@"%@ %@:%@",day[rowDay],hour[rowHour],min[rowMin]];
    if (self.postValue)
    {
        self.postValue(showTime,_strTime);
    }
    [self backTo];
}

-(void)backTo
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
