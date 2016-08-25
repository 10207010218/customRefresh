//
//  YZJRefreshHeader.m
//  Refresh
//
//  Created by 汪宁 on 16/8/24.
//  Copyright © 2016年 ZHENAI. All rights reserved.
//

#import "YZJRefreshHeader.h"


@interface YZJRefreshHeader()

@property (weak, nonatomic) UILabel *label;
@property (weak, nonatomic, readonly) UIImageView *gifView;
@property (strong, nonatomic) NSMutableDictionary *stateImages;
/** 所有状态对应的动画时间 */
@property (strong, nonatomic) NSMutableDictionary *stateDurations;
@end
@implementation YZJRefreshHeader

- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = 80;
    
    // 添加label
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor colorWithRed:0.57f green:0.57f blue:0.57f alpha:1.00f];;
    label.font = [UIFont boldSystemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    self.label = label;
    
   
    UIImageView *gifView = [[UIImageView alloc] init];
    gifView.backgroundColor=[UIColor yellowColor];
    gifView.contentMode=UIViewContentModeScaleToFill;
    [self addSubview:_gifView = gifView];
    
    if (!_stateImages) {
        self.stateImages = [NSMutableDictionary dictionary];
    }
    if (!_stateDurations) {
        self.stateDurations = [NSMutableDictionary dictionary];
    }
    
    
}
    
    
- (void)setImages:(NSArray *)images duration:(NSTimeInterval)duration forState:(MJRefreshState)state
    {
        if (images == nil) return;
        
        self.stateImages[@(state)] = images;
        self.stateDurations[@(state)] = @(duration);
        
        /* 根据图片设置控件的高度 */
       // UIImage *image = [images firstObject];
//        if (image.size.height > self.mj_h) {
//            self.mj_h = image.size.height;
//        }
    }
    
    - (void)setImages:(NSArray *)images forState:(MJRefreshState)state
    {
        [self setImages:images duration:images.count * 0.1 forState:state];
    }
   

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    CGFloat width=[UIScreen mainScreen].bounds.size.width;
    self.label.frame = CGRectMake(0, self.mj_h-30, width, 30);
   
    self.gifView.frame=CGRectMake(width*0.4, 0, width*0.2, self.mj_h-30);
   
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
            
            self.label.text = @"下拉刷新";
            break;
        case MJRefreshStatePulling:
            
            self.label.text = @"释放刷新";
            break;
        case MJRefreshStateRefreshing:
            
            self.label.text = @"正在加载";
            
            break;
        default:
            break;
    }
    
    
    if (state == MJRefreshStatePulling || state == MJRefreshStateRefreshing) {
        NSArray *images = self.stateImages[@(state)];
        if (images.count == 0) return;
        
        [self.gifView stopAnimating];
        if (images.count == 1) { // 单张图片
            self.gifView.image = [images lastObject];
        } else { // 多张图片
            self.gifView.animationImages = images;
            self.gifView.animationDuration = [self.stateDurations[@(state)] doubleValue];
            [self.gifView startAnimating];
        }
    } else if (state == MJRefreshStateIdle) {
        [self.gifView stopAnimating];
    }

    
}


#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    
    NSArray *images = self.stateImages[@(MJRefreshStateIdle)];
    if (self.state != MJRefreshStateIdle || images.count == 0) return;
    // 停止动画
    [self.gifView stopAnimating];
    // 设置当前需要显示的图片
    NSUInteger index =  images.count * pullingPercent;
    if (index >= images.count) index = images.count - 1;
    self.gifView.image = images[index];
}

@end
