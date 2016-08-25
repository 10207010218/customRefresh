//
//  ViewController.m
//  WNRefreshTest
//
//  Created by 汪宁 on 16/8/19.
//  Copyright © 2016年 ZHENAI. All rights reserved.
//

#import "ViewController.h"
#import "MJRefresh.h"
#import "YZJGifHeader.h"
#import "YZJBackFooter.h"
#import "GiFHUD.h"
@interface ViewController ()
@property(nonatomic, assign)NSInteger num;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _num=5;
    [self createTableView];
}
-(void)createTableView
{
    
    _todayTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 40, 414, 400) style:UITableViewStylePlain];
    _todayTableView.dataSource=self;
    _todayTableView.delegate=self;
    _todayTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_todayTableView];
    
    __weak __typeof(self) weakSelf = self;
    YZJBackFooter *footer = [YZJBackFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    _todayTableView.mj_footer =footer;
    
    // 设置了底部inset

    
    
    //    MJRefreshNormalHeader *header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    //        [weakSelf loadNewData];
    //    }];
    
    
    YZJGifHeader *header  = [YZJGifHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
    _todayTableView.mj_header=header;
    
    // 马上进入刷新状态
    
    
    
}
-(void)loadNewData
{
    [_todayTableView.mj_header beginRefreshing];
    [GiFHUD show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        
        [_todayTableView reloadData];
        [_todayTableView.mj_header endRefreshing];
        [GiFHUD dismiss];
        
    });
    
    
}
-(void)loadMoreData
{
    [_todayTableView.mj_footer beginRefreshing];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        
        // 结束刷新
        if (_num>12) {
            [ _todayTableView.mj_footer endRefreshingWithNoMoreData];
        }else
        {
            
            [ _todayTableView.mj_footer endRefreshing];
            _num+=2;
            
        }
        [_todayTableView reloadData];
    });
    
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _num;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
    cell.textLabel.text=[NSString stringWithFormat:@"%ld",indexPath.row];
    cell.contentView.backgroundColor=[UIColor redColor];
    return cell;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
