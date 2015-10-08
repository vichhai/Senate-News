//
//  GITSRefreshAndLoadMore.m
//  TableViewRefreshLoadMoreAndWaiting
//
//  Created by vichhai on 9/8/15.
//  Copyright (c) 2015 GITS. All rights reserved.
//

#import "GITSRefreshAndLoadMore.h"
#import "ShareObject.h"
@implementation GITSRefreshAndLoadMore


-(instancetype)init{
    _mainView = [[UIView alloc] init];
    return self;
}

-(void)addRefreshToTableView:(UITableView *)tabelView imageName:(NSString *)imageName{
    _tempHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0,[UIScreen mainScreen].bounds.size.width , 12.0)];
    _tempHeaderView.backgroundColor = [UIColor colorWithRed:211 green:214 blue:219 alpha:1];
    tabelView.tableHeaderView = _tempHeaderView;
    
    // =---> for refresh
    UIImageView *headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 24.0) / 2, -28.0, 24.0, 27.0)];
    headerImage.image = [UIImage imageNamed:imageName];
    headerImage.backgroundColor = [UIColor clearColor];
    headerImage.tag = 3001;
    [tabelView addSubview:headerImage];
}

-(void)addLoadMoreForTableView:(UITableView *)tabelView imageName:(NSString *)imageName{
    _tempFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0,[UIScreen mainScreen].bounds.size.width , 66.0)];
    _tempFooterView.backgroundColor = [UIColor colorWithRed:10 green:214 blue:219 alpha:1];
    tabelView.tableFooterView = _tempFooterView;
    // =---> for load more
    _moreFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, [UIScreen mainScreen].bounds.size.width, 66.0)];
    _moreFooterView.backgroundColor = [UIColor colorWithRed:211 green:214 blue:219 alpha:1];
    
//    UIImageView *footerImage = [[UIImageView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 24.0) / 2,6.0, 24.0, 27.0)];
//    footerImage.image = [UIImage imageNamed:imageName];
//    footerImage.backgroundColor = [UIColor clearColor];
//    footerImage.tag = 3002;
     _activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((_moreFooterView.frame.size.width - 45 ) / 2, (_moreFooterView.frame.size.height - 45 ) / 2, 45, 45)];
    _activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [_activity startAnimating];
    [_moreFooterView addSubview:_activity];
}


-(void)loopRefresh{
    NSArray *imageArray = @[@"load_01.png",@"load_02.png",@"load_03.png",@"load_04.png",@"load_05.png",@"load_06.png"];
    UIImageView *aImage = (UIImageView *)[_mainView viewWithTag:3001];
    aImage.image = [UIImage imageNamed:imageArray[_imageIndex]];
    _imageIndex += 1;
    
    if (_imageIndex == 6) {
        _imageIndex = 0;
    }
}

-(void)loopLoadMore{
//    NSArray *imageArray = [[NSArray alloc] initWithObjects:@"load_01.png",@"load_02.png",@"load_03.png",@"load_04.png",@"load_05.png",@"load_06.png", nil];
//    UIImageView *aImage = (UIImageView *)[_mainView viewWithTag:3002];
//    aImage.image = [UIImage imageNamed:[imageArray objectAtIndex:_imageIndex]];
//    _imageIndex += 1;
//    
//    if (_imageIndex == 6) {
//        _imageIndex = 0;
//    }
    
}

-(void)changeImageWhenScrollDown:(UIView *)anyView scrollView:(UIScrollView *)scrollView{
    UIImageView *image = (UIImageView *)[anyView viewWithTag:3001];
    if (scrollView.contentOffset.y < -70) {
        image.image = [UIImage imageNamed:@"load_01.png"];
    }
    if (scrollView.contentOffset.y < -75) {
        image.image = [UIImage imageNamed:@"load_02.png"];
    }
    if (scrollView.contentOffset.y < -80) {
        image.image = [UIImage imageNamed:@"load_03.png"];
    }
    if (scrollView.contentOffset.y < -85) {
        image.image = [UIImage imageNamed:@"load_04.png"];
    }
    if (scrollView.contentOffset.y < -90) {
        image.image = [UIImage imageNamed:@"load_05.png"];
    }
    if (scrollView.contentOffset.y < -95) {
        image.image = [UIImage imageNamed:@"load_06.png"];
    }
}

-(void)doRefresh:(UITableView *)tableView anyVie:(UIView *)anyView{
    _mainView = anyView;
    _imageIndex = 0;
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(loopRefresh) userInfo:nil repeats:true];
    tableView.contentInset = UIEdgeInsetsMake(85, 0, 0, 0);
}

-(void)doLoadMore:(UIView *)anyView tableView:(UITableView *)tableView scrollView:(UIScrollView *)scrollView{
    _mainView = anyView;
    if (scrollView.contentOffset.y + [UIScreen mainScreen].bounds.size.height >= scrollView.contentSize.height) {
        [ShareObject shareObjectManager].isLoadMore = true;
        
        if ([[ShareObject shareObjectManager].viewObserver isEqualToString:@"MainView"]) {
            [ShareObject shareObjectManager].page += 1;
        } else if([[ShareObject shareObjectManager].viewObserver isEqualToString:@"category"]){
            [ShareObject shareObjectManager].pageCate += 1;
        } else if ([[ShareObject shareObjectManager].viewObserver isEqualToString:@"schedule"]) {
            [ShareObject shareObjectManager].schedulePage += 1;
            [ShareObject shareObjectManager].scheduleFlag = FALSE;
        } else {
            [ShareObject shareObjectManager].pages += 1;
        }
        
        if (tableView.tableFooterView == _moreFooterView) {
            return;
        }
        tableView.tableFooterView = _moreFooterView;
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(loopLoadMore) userInfo:nil repeats:true];
    }
}

-(void)temp:(UITableView *)tableView{
    if (_timer != nil) {
        [_timer invalidate];
        _timer = nil;
    }
    
    if (tableView.tableFooterView == _moreFooterView) {
        tableView.tableFooterView = _tempFooterView;
    }
}

@end

