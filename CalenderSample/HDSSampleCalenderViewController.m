//
//  AXLSignNoteViewController.m
//  Yumiyou
//
//  Created by hedashuang on 14-10-23.
//  Copyright (c) 2015年 anslink. All rights reserved.
//

#import "HDSSampleCalenderViewController.h"
static int testmonth = 0;
static int testyear = 0;

@interface HDSSampleCalenderViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *signnoteBGScrollview;

//年份月份显示标签

@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UIView *dateListBGView;

@property (nonatomic, strong) NSDate *testdate;
@property (nonatomic, strong) NSMutableArray *dateLabelArray;

@property (nonatomic, strong) NSDate *currentDate;

@property (nonatomic, assign) NSInteger year;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) NSInteger day;


@end

@implementation HDSSampleCalenderViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.signnoteBGScrollview.contentSize = CGSizeMake(320, 450);
    self.signnoteBGScrollview.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    
    //导航栏滑动返回
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    //圆形头像
    [self.headImageView setImage:[UIImage imageNamed:@"headtest"]];
    self.headImageView.layer.cornerRadius = 43;
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.borderWidth = 1;
    self.headImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.dateLabelArray = [NSMutableArray array];
    
    //获取当前日期 年月
    self.currentDate = [NSDate date];

    NSString *string = [NSString stringWithFormat:@"%@", self.currentDate];
    NSString *yearStr = [string substringToIndex:4];
    NSString *monthStr = [string substringWithRange:NSMakeRange(5, 2)];
    NSString *dayStr = [string substringWithRange:NSMakeRange(8, 2)];

    self.year = [yearStr intValue];
    self.month = [monthStr intValue];
    self.day = [dayStr intValue];
    
    testmonth = self.month;
    testyear = self.year;
    
    self.monthLabel.text = [NSString stringWithFormat:@"%d", testmonth];
    self.yearLabel.text = [NSString stringWithFormat:@"%d", testyear];
    
    //本月日期数据加载到日历
    [self reloadDataWith: [self currentMonthofDays:testyear And:testmonth] And:[self currentMothFirstDayWeek:testyear And:testmonth]];
    
}

- (IBAction)backbuttonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 日历月份加减按钮

- (IBAction)calenderLeftButtonAction:(id)sender
{
    
    //移除上个月显示的日历
    if (self.dateLabelArray.count != 0)
    {
        for (int i = 0; i < self.dateLabelArray.count; i++)
        {
            [[self.dateLabelArray objectAtIndex:i] removeFromSuperview];
        }
    }
    int currentmonth = testmonth;
    if (currentmonth > 1)
    {
        testmonth --;
    }
    else
    {
        testmonth = 12;
        testyear --;
    }
    
    if (testmonth < 10)
    {
        self.monthLabel.text = [NSString stringWithFormat:@"0%d", testmonth];

    }
    else
    {
        self.monthLabel.text = [NSString stringWithFormat:@"%d", testmonth];

    }
    self.yearLabel.text = [NSString stringWithFormat:@"%d", testyear];
    
    int monthdays = [self currentMonthofDays:testyear And:testmonth];
    NSLog(@"当前月的天数：%d", monthdays);
    int weekday = [self currentMothFirstDayWeek:testyear And:testmonth];
    NSLog(@"当前月的第一天是星期：%d", weekday);
    
    [self reloadDataWith:monthdays And:weekday];
}

- (IBAction)calenderRightButtonAction:(id)sender
{
    if (self.dateLabelArray.count != 0)
    {
        for (int i = 0; i < self.dateLabelArray.count; i++)
        {
            [[self.dateLabelArray objectAtIndex:i] removeFromSuperview];
        }
    }
   
    int currentmonth = testmonth;
    if (currentmonth < 12)
    {
        testmonth ++;
    }
    else
    {
        testmonth = 1;
        testyear ++;
        
    }
    
    if (testmonth < 10)
    {
        self.monthLabel.text = [NSString stringWithFormat:@"0%d", testmonth];
        
    }
    else
    {
        self.monthLabel.text = [NSString stringWithFormat:@"%d", testmonth];
        
    }
    self.yearLabel.text = [NSString stringWithFormat:@"%d", testyear];
    self.yearLabel.text = [NSString stringWithFormat:@"%d", testyear];
    
    //int testI1 = [self currentMothFirstDayWeek:2015 And:1];
   // NSLog(@"testI1 = %d", testI1);
    
    int monthdays = [self currentMonthofDays:testyear And:testmonth];
    NSLog(@"当前月的天数：%d", monthdays);
    int weekday = [self currentMothFirstDayWeek:testyear And:testmonth];
    NSLog(@"当前月的第一天是星期：%d", weekday);
    
    [self reloadDataWith:monthdays And:weekday];

}

#pragma mark 判断本月的第一天是星期几  1900年1月1日 星期 1
-(NSInteger)currentMothFirstDayWeek:(NSInteger) year And:(NSInteger)month
{
    int sumdays = 0; //今天距离1900.01.01共多少天

    
    for (int i = 1900; i < year; i++)
    {
        if ((i%400 == 0 )||((i%4 == 0)&&(i%100 != 0)))
        {
            sumdays += 366;  //闰年
        }
        else
        {
            sumdays += 365;  //平年
        }
        //NSLog(@"sumdays %d", sumdays);

    }
    //当前年的第n-1月是当前年的第多少天
    
    for (int i = 1; i < month; i++ )
    {
        if ((i == 1 )||( i == 3 )||(i == 5) || (i == 7) ||(i == 8 )|| (i == 10 )||(i == 12))
        {
            sumdays += 31;
        }
        else 
        {
            sumdays += 30;
        }
    }
    
    //当前月份大于二月 平年减一天 闰年减两天
    
    if (month > 2)
    {
        if (year%400 == 0 ||((year%4 == 0)&&(year%100 != 0)))
        {
            sumdays -= 1; //闰年 2月29天
        }
        else
        {
            sumdays -= 2; //平年 2月28天
        }

    }
    NSLog(@"sumdays %d", sumdays);

    return [self firstWeekday:sumdays];
}

#pragma mark 求出当前月的第一天是星期几 
//余数 0 1 2 3 4 5 6  当前月的第一天是到前月之前所有天数取余数加1
-(NSInteger)firstWeekday:(NSInteger) sumdays
{
    int weekday = sumdays%7+1;
    
    return weekday;
}


#pragma mark 判断平年与闰年，并且返回当前月有多少天
-(NSInteger)currentMonthofDays:(NSInteger) year And:(NSInteger) month
{
    if ((month == 1) || (month == 3 )||(month == 5) || (month == 7) ||(month == 8) || (month == 10) ||(month == 12))
    {
        return 31;
    }
    else
    {
        if (month == 2)
        {
            if (year%400 == 0 ||((year%4 == 0)&&(year%100 != 0)))
            {
                return 29;//闰年 2月29天
            }
            else
            {
                return 28;//平年 2月28天
            }
            
        }
        else
            return 30;//4、6、9、11月有30天
    }
}

#pragma mark 添加日期数据到日历表 当前月的天数和第一天是星期几
-(void)reloadDataWith:(NSInteger) month And:(NSInteger) weekday
{

    for (int i = weekday; i < weekday + month; i ++)
    {
        UILabel *testLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 31, 30)];
        testLabel.backgroundColor = [UIColor yellowColor];
        testLabel.textAlignment = NSTextAlignmentCenter;
        testLabel.text = [NSString stringWithFormat:@"%d", i - weekday+1];
    
        [self.dateLabelArray addObject:testLabel];
        [[[self.dateListBGView subviews] objectAtIndex:i] addSubview:testLabel];
        int buttontag = [[[self.dateListBGView subviews] objectAtIndex:i] tag];
        
        //给周六和周日对应日期添加颜色效果
        if ((buttontag == 1) || (buttontag == 8) ||(buttontag == 15) || (buttontag == 22) ||(buttontag == 29) || (buttontag == 36))
        {
            testLabel.textColor = [UIColor colorWithRed:212/255.0 green:22/255.0 blue:30/255.0 alpha:1];
            
        }
        else if ((buttontag == 7) || (buttontag == 14) ||(buttontag == 21) || (buttontag == 28) ||(buttontag == 35) || (buttontag == 42))
        {
            testLabel.textColor = [UIColor colorWithRed:246/255.0 green:129/255.0 blue:31/255.0 alpha:1];
        }
        else
        {
            testLabel.textColor = [UIColor blackColor];
        }
        NSLog(@"buttontag:%d", buttontag);
    }
    
    
    [self.signnoteBGScrollview addSubview:self.dateListBGView];
}

@end
