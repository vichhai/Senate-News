//
//  ViewController.m
//  SenateProject
//
//  Created by vichhai on 8/28/15.
//  Copyright (c) 2015 GITS. All rights reserved.
//

#import "HomeViewController.h"
#import "SWRevealViewController.h"
#import "CustomTableViewCell.h"
#import "Reachability.h"
#import "ConnectionManager.h"
#import "UIImageView+WebCache.h"
#import "DetailViewController.h"
#import "DXPopover.h"

@interface HomeViewController () <UITableViewDataSource,UITableViewDelegate,ConnectionManagerDelegate>
{
    NSMutableArray *arrayResult;
    GITSRefreshAndLoadMore *refresh_loadmore;
    DXPopover *popover;
}
@property (nonatomic) Reachability *hostReachability;

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@end

@implementation HomeViewController


-(BOOL)prefersStatusBarHidden{
    return true;
}

#pragma mark - check connection with Reachability

- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
    NetworkStatus internetStatus = [reachability  currentReachabilityStatus];
    
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN)){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No internet or Wifi connection!" message:@"Please turn on the cellular or connection to Wifi" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [AppUtils hideLoading:self.view];
        [alert show];
    } else {
        [AppUtils showLoading:self.view];
        [ShareObject shareObjectManager].page = 1;
        [self requestToserver];
    }
}

- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
    return;
}

#pragma mark - UIViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    popover = [DXPopover popover];
    NSString *remoteHostName = @"www.apple.com";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
    [self.hostReachability startNotifier];
    //[self updateInterfaceWithReachability:self.hostReachability];
    
    _mainTableView.hidden = true;
    arrayResult = [[NSMutableArray alloc] init];
    refresh_loadmore = [[GITSRefreshAndLoadMore alloc] init];
    [ShareObject shareObjectManager].page = 1;
    
    // =---> add refresh and load mor to view

    [self setupView];
    
    // =---> show loading
    _mainTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [AppUtils showLoading:self.view];
    
    // =---> set tap gesture for uinavigation bar
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(doDoubleTap)] ;
    doubleTap.numberOfTapsRequired = 2;
    [self.navigationController.navigationBar addGestureRecognizer:doubleTap];
    
    // =---> set navigationbar color
    self.navigationController.navigationBar.barTintColor = [UIColor lightGrayColor];
    
    // =---> Creating a custom right navi bar button1
    UIButton *subButton  = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 18.0f, 18.0f)];
    [subButton setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
    //[searchButton setImage:[UIImage imageNamed:@"Search Filled-50.png"] forState:UIControlStateHighlighted];
    [subButton addTarget:self action:@selector(subButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    // =---> Creating a custom right navi bar button2
    UIButton *moreButton  = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 18.0f, 18.0f)];
    [moreButton setImage:[UIImage imageNamed:@"Menu-50.png"] forState:UIControlStateNormal];
    [moreButton setImage:[UIImage imageNamed:@"Menu Filled-25.png"] forState:UIControlStateHighlighted];
    
    
    // =---> Make space between bar button 20 point
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 20;
    
    // =---> side menu
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [moreButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    }
    
    UIBarButtonItem *barButtonItem1 = [[UIBarButtonItem alloc] initWithCustomView:subButton];
    UIBarButtonItem *barButtonItem2 = [[UIBarButtonItem alloc] initWithCustomView:moreButton];

    NSArray *barButtonItemArray = [[NSArray alloc] initWithObjects:barButtonItem1,negativeSpacer,barButtonItem2, nil];
    self.navigationItem.rightBarButtonItems = barButtonItemArray;

    // =---> request to server
    [self requestToserver];
    
    
    for (UIView *v in [self.view subviews]) {
        NSLog(@"all king of view %@",[v class]);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action BarButton

-(void)subButtonAction:(id)sender{
    //create view popup view with DXPopView
    UIView *TestView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 181, 221)];
    //add label to popup
    UILabel *sortLabel = [[UILabel alloc]initWithFrame:CGRectMake(58, 15, 70, 25)];
    sortLabel.text = @"Sort by:";
    [sortLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
    [TestView addSubview:sortLabel];
    //add button to popup
    UIButton *sortByDate = [[UIButton alloc]initWithFrame:CGRectMake(10, 50, 75, 75)];
    sortByDate.backgroundColor = [UIColor blueColor];
    [TestView addSubview:sortByDate];
    UIButton *sortByName = [[UIButton alloc]initWithFrame:CGRectMake(95, 50, 75, 75)];
    sortByName.backgroundColor = [UIColor greenColor];
    [TestView addSubview:sortByName];
    UIButton *sortByAuthor = [[UIButton alloc]initWithFrame:CGRectMake(10, 135, 75, 75)];
    sortByAuthor.backgroundColor = [UIColor redColor];
    [TestView addSubview:sortByAuthor];
    UIButton *sortById = [[UIButton alloc]initWithFrame:CGRectMake(95, 135, 75, 75)];
    sortById.backgroundColor = [UIColor blackColor];
    [TestView addSubview:sortById];
    //add event to button
    [sortByDate addTarget:self action:@selector(sortByDate) forControlEvents:UIControlEventTouchUpInside];
    [sortByName addTarget:self action:@selector(sortByName) forControlEvents:UIControlEventTouchUpInside];
    [sortByAuthor addTarget:self action:@selector(sortByAuthor) forControlEvents:UIControlEventTouchUpInside];
    [sortById addTarget:self action:@selector(sortById) forControlEvents:UIControlEventTouchUpInside];
    //show the popup
    [popover showAtView:sender withContentView:TestView];
}
//function event of button
-(void) sortByDate{
    NSLog(@"Sort by date");
    [popover dismiss];
}

-(void) sortByName{
    NSLog(@"Sort by name");
    [popover dismiss];
}

-(void) sortByAuthor{
    NSLog(@"sort by author");
    [popover dismiss];
}

-(void) sortById{
    NSLog(@"sort by Id");
    [popover dismiss];
}


#pragma mark - Tableview datasoruce

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrayResult count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    [[cell.shareLabel objectAtIndex:0] setText:[[arrayResult objectAtIndex:indexPath.row] objectForKey:@"ART_TITLE"]]; // set title
    
    [[cell.shareLabel objectAtIndex:1] setText:[[arrayResult objectAtIndex:indexPath.row] objectForKey:@"ART_PUBLISHED_DATE"]]; // set publish date
    
    [[cell.shareLabel objectAtIndex:2] setText:[NSString stringWithFormat:@"By: %@",[[arrayResult objectAtIndex:indexPath.row] objectForKey:@"ART_AUTHOR"]]]; // set author
    
//    [cell.myImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.senate.gov.kh/home/%@",[[arrayResult objectAtIndex:indexPath.row] objectForKey:@"ART_IMAGE"]]] placeholderImage:[UIImage imageNamed:@"none_photo.png"]]; // set image
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"detail" sender:[arrayResult objectAtIndex:indexPath.row]];
}


#pragma mark - prepare for segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"detail"]) {
        DetailViewController *vc = [segue destinationViewController];
        vc.receiveData = sender;
    }
}

#pragma mark - request to server

-(void)requestToserver{
    NSMutableDictionary *reqDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
    
    [dataDic setObject:@"10" forKey:@"PER_PAGE_CNT"];
    [dataDic setObject:[NSString stringWithFormat:@"%d",[ShareObject shareObjectManager].page] forKey:@"PAGE_NO"];
    [reqDic setObject:@"ARTICLES_L001" forKey:@"KEY"];
    [reqDic setObject:dataDic forKey:@"REQ_DATA"];
    
    ConnectionManager *cont = [[ConnectionManager alloc] init];
    cont.delegate = self;
    [cont sendTranData:reqDic];
}

#pragma mark - return result
-(void)returnResult:(NSDictionary *)result{
    
    
    if ([ShareObject shareObjectManager].isLoadMore) {
        [arrayResult addObjectsFromArray:[[result objectForKey:@"RESP_DATA"] objectForKey:@"ART_REC"]];
        [refresh_loadmore temp:_mainTableView];
    } else {
        [self.view setUserInteractionEnabled:true];
        [arrayResult removeAllObjects];
        [arrayResult addObjectsFromArray:[[result objectForKey:@"RESP_DATA"] objectForKey:@"ART_REC"]];
        [refresh_loadmore temp:_mainTableView];
        _mainTableView.contentInset = UIEdgeInsetsMake(30, 0, 0, 0);
    }
        [_mainTableView reloadData];
    // =---> Hide loading
    [AppUtils hideLoading:self.view];
    _mainTableView.hidden = false;
}

#pragma mark - other method
-(void)doDoubleTap{
    // =---> scroll tableView to the top
    [_mainTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

#pragma mark - Refresh And Load More

-(void)setupView {
    // adding refresh to mainTableView
    [refresh_loadmore addRefreshToTableView:_mainTableView imageName:@"load_01.png"];
    
    // adding load more
    [refresh_loadmore addLoadMoreForTableView:_mainTableView imageName:@"load_01.png"];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [refresh_loadmore changeImageWhenScrollDown:self.view scrollView:scrollView];
    //    _mainTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
}

// scroll up
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.contentOffset.y <= -105) {
        [refresh_loadmore doRefresh:_mainTableView anyVie:self.view];
        [ShareObject shareObjectManager].isLoadMore = false;
        [self.view setUserInteractionEnabled:false];
        [ShareObject shareObjectManager].page = 1;
        [self requestToserver];
        
    }
}

//scroll down
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [refresh_loadmore doLoadMore:self.view tableView:_mainTableView scrollView:scrollView];
    [self requestToserver];
}

@end
