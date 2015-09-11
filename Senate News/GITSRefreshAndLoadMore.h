//
//  GITSRefreshAndLoadMore.h
//  TableViewRefreshLoadMoreAndWaiting
//
//  Created by vichhai on 9/8/15.
//  Copyright (c) 2015 GITS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GITSRefreshAndLoadMore : NSObject

@property (strong,nonatomic) UIView *tempFooterView;
@property (strong,nonatomic) UIView *moreFooterView;
@property (nonatomic)   int imageIndex;
@property (strong,nonatomic) UIView *tempHeaderView;
@property (strong,nonatomic) NSTimer *timer;
@property (strong,nonatomic) UIView *mainView;
@property (strong,nonatomic) UIActivityIndicatorView *activity;

-(void)addRefreshToTableView:(UITableView *)tabelView imageName:(NSString *)imageName;
-(void)addLoadMoreForTableView:(UITableView *)tabelView imageName:(NSString *)imageName;
-(void)loopRefresh;
-(void)loopLoadMore;
-(void)changeImageWhenScrollDown:(UIView *)anyView scrollView:(UIScrollView *)scrollView;
-(void)doRefresh:(UITableView *)tableView anyVie:(UIView *)anyView;
-(void)doLoadMore:(UIView *)anyView tableView:(UITableView *)tableView scrollView:(UIScrollView *)scrollView;
-(void)temp:(UITableView *)tableView;
@end
