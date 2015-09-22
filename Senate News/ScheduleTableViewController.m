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

@interface ScheduleTableViewController () <ConnectionManagerDelegate>{
    NSString *sortBy;
    int remainPage;
    NSMutableArray *arrayResult;
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

#pragma mark - UIViewController method

- (void)viewDidLoad {
    [super viewDidLoad];
    // check connection
    NSString *remoteHostName = @"www.apple.com";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
    [self.hostReachability startNotifier];
    // show loading view
    [AppUtils showLoading:self.view];
    // set up sort
    sortBy = @"id";
    // Initialize array
    arrayResult = [[NSMutableArray alloc]init];
    
    // custom side bar
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [_menuButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    }
    
    // Send request to server
    [self requestToserver:@"SCHEDULE_L001"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"Run out of memory");
}

#pragma mark - request to server method

-(void)requestToserver:(NSString *)withAPIKey{
    
    NSMutableDictionary *reqDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
    if ([withAPIKey isEqualToString:@"SCHEDULE_L001"]) {
        [dataDic setObject:@"10" forKey:@"PER_PAGE_CNT"];
        [dataDic setObject:[NSString stringWithFormat:@"%d",[ShareObject shareObjectManager].page] forKey:@"PAGE_NO"];
        [dataDic setObject:@"1" forKey:@"TYPE"];
        [dataDic setObject:sortBy forKey:@"SORT_BY"];
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
        [arrayResult addObjectsFromArray:[[result objectForKey:@"RESP_DATA"] objectForKey:@"SCH_REC"]];
    }
    [_scheduleTableView reloadData];
    [AppUtils hideLoading:self.view];
}

#pragma mark - Custom Button Click

- (IBAction)searchAction:(id)sender {
    
    
}
- (IBAction)menuAction:(id)sender {
    
    
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
    
}

@end
