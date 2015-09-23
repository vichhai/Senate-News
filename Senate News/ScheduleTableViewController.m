//
//  ScheduleTableViewController.m
//  Senate News
//
//  Created by Jung Taesung on 2015. 9. 21..
//  Copyright (c) 2015년 GITS. All rights reserved.
//

#import "ScheduleTableViewController.h"
#import "SWRevealViewController.h"
#import "ScheduleTableViewCell.h"
#import "AppUtils.h"
#import "Reachability.h"
#import "ConnectionManager.h"
#import "ShareObject.h"
#import "GITSRefreshAndLoadMore.h"

@interface ScheduleTableViewController () <ConnectionManagerDelegate>
{
    NSString *sortBy;
    int remainPage;
    NSMutableArray *arrayResult;
    GITSRefreshAndLoadMore *refresh_loadmore;
}
@property (nonatomic) Reachability *hostReachability;
@end

@implementation ScheduleTableViewController

#pragma mark - Connection method

- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
    NetworkStatus internetStatus = [reachability  currentReachabilityStatus];

    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN)){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No internet or Wifi connection!" message:@"Please turn on the cellular or connection to Wifi" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        //[AppUtils hideLoading:self.view];
        [alert show];
    } else {
        //[AppUtils showLoading:self.view];
        //[ShareObject shareObjectManager].page = 1;
        //[self requestToserver:@"ARTICLES_L001"];
    }
}

- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
    return;
}

#pragma mark - Super class method

-(BOOL)prefersStatusBarHidden{
    return true;
}

#pragma mark - UIViewController method]

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [ShareObject shareObjectManager].viewObserver = @"schedule";
    [ShareObject shareObjectManager].scheduleFlag = FALSE;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // check connection
    NSString *remoteHostName = @"www.apple.com";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
    [self.hostReachability startNotifier];
    // show loading view
    [AppUtils showLoading:self.view];
    // Initialize array
    arrayResult = [[NSMutableArray alloc]init];
    refresh_loadmore = [[GITSRefreshAndLoadMore alloc] init];
    [ShareObject shareObjectManager].schedulePage = 1;
    [refresh_loadmore addLoadMoreForTableView:_scheduleTableView imageName:@"load_01.png"];
    [self addRefreshToView];
    [self addbarButtonAndSideBar];

    
    self.tableView.contentInset = UIEdgeInsetsMake(80, 0, 0, 0);
    
    self.tableView.hidden = true;
    
    // Send request to server
    [self requestToserver:@"SCHEDULE_L001"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"Run out of memory");
}

#pragma mark - Helper method

-(void)addbarButtonAndSideBar{
    // =---> set tap gesture for uinavigation bar
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(doDoubleTap)] ;
    doubleTap.numberOfTapsRequired = 2;
    [self.navigationController.navigationBar addGestureRecognizer:doubleTap];
    
    // =---> set navigationbar color
    // self.navigationController.navigationBar.barTintColor = [UIColor lightGrayColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1];
    
    // =---> Creating a custom right navi bar button2
    UIButton *moreButton  = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 25.0f, 30.0f)];
    [moreButton setImage:[UIImage imageNamed:@"munu_b.png"] forState:UIControlStateNormal];
    [moreButton setImage:[UIImage imageNamed:@"menu_b_p.png"] forState:UIControlStateHighlighted];
    
    // =---> Creating a custom right navi bar button2
    UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 25.0f, 25.0f)];
    [searchButton setImage:[UIImage imageNamed:@"Search-50.png"] forState:UIControlStateNormal];
    [searchButton setImage:[UIImage imageNamed:@"Search Filled-50.png"] forState:UIControlStateHighlighted];
    [searchButton addTarget:self action:@selector(searchClicked) forControlEvents:UIControlEventTouchUpInside];
    
    // =---> Make space between bar button 20 point
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 15;
    
    // =---> side menu
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [moreButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    }
    
    UIBarButtonItem *barButtonItem2 = [[UIBarButtonItem alloc] initWithCustomView:moreButton];
    UIBarButtonItem *barButtonItem3 = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    
    NSArray *barButtonItemArray = [[NSArray alloc] initWithObjects:barButtonItem3,negativeSpacer,barButtonItem2, nil];
    self.navigationItem.rightBarButtonItems = barButtonItemArray;

}

#pragma mark - request to server method

-(void)requestToserver:(NSString *)withAPIKey{
    
    NSMutableDictionary *reqDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
    if ([withAPIKey isEqualToString:@"SCHEDULE_L001"]) {
        [dataDic setObject:@"5" forKey:@"PER_PAGE_CNT"];
        [dataDic setObject:[NSString stringWithFormat:@"%d",[ShareObject shareObjectManager].schedulePage] forKey:@"PAGE_NO"];
        [dataDic setObject:@"" forKey:@"TYPE"];
        [dataDic setObject:@"id" forKey:@"SORT_BY"];
    }
    [reqDic setObject:withAPIKey forKey:@"KEY"];
    [reqDic setObject:dataDic forKey:@"REQ_DATA"];
    ConnectionManager *cont = [[ConnectionManager alloc] init];
    cont.delegate = self;
    [cont sendTranData:reqDic];
}

-(void)returnResult:(NSDictionary *)result withApiKey:(NSString *)apiKey{
    // set data to array for looping to TableViewCell
    remainPage = [[result objectForKey:@"TOTAL_PAGE_COUNT"] intValue];
    if ([apiKey isEqualToString:@"SCHEDULE_L001"]) {
        if ([ShareObject shareObjectManager].scheduleFlag) {
            [arrayResult removeAllObjects];
            NSLog(@"Scroll top true %lu",(unsigned long)arrayResult.count);
        }
        [arrayResult addObjectsFromArray:[[result objectForKey:@"RESP_DATA"] objectForKey:@"SCH_REC"]];
        [ShareObject shareObjectManager].scheduleFlag = FALSE;
    }
    [_scheduleTableView reloadData];
    NSLog(@"count array after request %lu",(unsigned long)arrayResult.count);
    [refresh_loadmore temp:_scheduleTableView];
    [AppUtils hideLoading:self.view];
    //[self.view setUserInteractionEnabled:true];
}

#pragma mark - Refresh And Load More

-(void)addRefreshToView{
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    self.refreshControl.backgroundColor = [UIColor whiteColor];
    self.refreshControl.tintColor = [UIColor blackColor];
    [self.refreshControl addTarget:self action:@selector(refreshing) forControlEvents:UIControlEventValueChanged];
    [_scheduleTableView addSubview:self.refreshControl];
}

-(void)refreshing{
    //[self.view setUserInteractionEnabled:false];
    [ShareObject shareObjectManager].schedulePage = 1;
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Loading..."];
    //[ShareObject shareObjectManager].isLoadMore = false;
    [ShareObject shareObjectManager].scheduleFlag = TRUE;
    [self requestToserver:@"SCHEDULE_L001"];
    [self.refreshControl endRefreshing];
    
}

#pragma mark - Custom Button Click

-(void)doDoubleTap{
    // =---> scroll tableView to the top
    [_scheduleTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

-(void)searchClicked{
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return arrayResult.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ScheduleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"scheduleCell"];
    cell.titleLabel.text = [[arrayResult objectAtIndex:indexPath.row] objectForKey:@"SCH_TITLE"];
    cell.descriptionLabel.text = [[arrayResult objectAtIndex:indexPath.row] objectForKey:@"SCH_DESCRIPTION"];
    cell.dateLabel.text = [[arrayResult objectAtIndex:indexPath.row] objectForKey:@"SCH_PUBLISHED_DATE"];
    cell.posterLabel.text = [NSString stringWithFormat:@"Post by: %@",[[arrayResult objectAtIndex:indexPath.row] objectForKey:@"SCH_AUTHOR"]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - ScrollViewDelegate Method

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([ShareObject shareObjectManager].schedulePage < remainPage && ![ShareObject shareObjectManager].scheduleFlag) {
        [refresh_loadmore doLoadMore:self.view tableView:_scheduleTableView scrollView:scrollView];
        [self requestToserver:@"SCHEDULE_L001"];
        NSLog(@"%d",[ShareObject shareObjectManager].schedulePage);
        NSLog(@"%d",remainPage);
    }
    
}


@end
