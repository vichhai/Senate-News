//
//  CategoryViewController.m
//  Senate News
//
//  Created by vichhai on 9/21/15.
//  Copyright (c) 2015 GITS. All rights reserved.
//

#import "CategoryViewController.h"
#import "CustomSearchTableViewCell.h"
#import "AppUtils.h"
#import "SWRevealViewController.h"
#import "ShareObject.h"
#import "ConnectionManager.h"
#import "GITSRefreshAndLoadMore.h"
#import "DetailViewController.h"

@interface CategoryViewController () <UITableViewDataSource,UITableViewDelegate,ConnectionManagerDelegate>
{
    NSMutableArray *arrayResult;
    GITSRefreshAndLoadMore *refresh_loadmore;
    int remainPage;
    
}

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (strong,nonatomic) UIRefreshControl *refreshControl;
@end

@implementation CategoryViewController

#pragma mark - view life cycle

-(BOOL)prefersStatusBarHidden{
    return true;
}

-(void)viewWillAppear:(BOOL)animated{
    [ShareObject shareObjectManager].viewObserver = @"category";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    UIButton *moreButton  = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 25.0f, 30.0f)];
    [moreButton setImage:[UIImage imageNamed:@"munu_b.png"] forState:UIControlStateNormal];
    [moreButton setImage:[UIImage imageNamed:@"menu_b_p.png"] forState:UIControlStateHighlighted];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [moreButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    }
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:moreButton];
    
    self.navigationItem.rightBarButtonItem = barButtonItem;
    
    arrayResult = [[NSMutableArray alloc] init];
    [self addRefreshToView];
    
    refresh_loadmore = [[GITSRefreshAndLoadMore alloc] init];
    [refresh_loadmore addLoadMoreForTableView:_mainTableView imageName:@"load_01.png"];
    
    _mainTableView.hidden = true;
    [AppUtils showLoading:self.view];
    [self requestToserver:@"ARTICLES_L001"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - request to server 
-(void)requestToserver:(NSString *)withAPIKey{
    
    NSMutableDictionary *reqDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
    
    if ([withAPIKey isEqualToString:@"ARTICLES_L001"]) { // list article
        
        [dataDic setObject:@"20" forKey:@"PER_PAGE_CNT"];
        [dataDic setObject:[NSString stringWithFormat:@"%d",[ShareObject shareObjectManager].pageCate] forKey:@"PAGE_NO"];
        if (![AppUtils isNull:[ShareObject shareObjectManager].shareCateId]) {
            [dataDic setObject:[ShareObject shareObjectManager].shareCateId forKey:@"CAT_ID"];
        }
    }
    
    [reqDic setObject:withAPIKey forKey:@"KEY"];
    [reqDic setObject:dataDic forKey:@"REQ_DATA"];
    
    ConnectionManager *cont = [[ConnectionManager alloc] init];
    cont.delegate = self;
    [cont sendTranData:reqDic];
}

#pragma mark - return result
-(void)returnResult:(NSDictionary *)result withApiKey:(NSString *)apiKey{
    
    remainPage = [[result objectForKey:@"TOTAL_PAGE_COUNT"] intValue];
    
    if ([ShareObject shareObjectManager].isLoadMore){
        [arrayResult addObjectsFromArray:[[result objectForKey:@"RESP_DATA"] objectForKey:@"ART_REC"]];
        [refresh_loadmore temp:_mainTableView];
    } else {
        if (_refreshControl) {
            [_refreshControl endRefreshing];
        }
        
        [self.view setUserInteractionEnabled:true];
        [arrayResult removeAllObjects];
        [arrayResult addObjectsFromArray:[[result objectForKey:@"RESP_DATA"] objectForKey:@"ART_REC"]];
        [refresh_loadmore temp:_mainTableView];
        _mainTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    [_mainTableView reloadData];
    
    // =---> Hide loading
    [AppUtils hideLoading:self.view];
    _mainTableView.hidden = false;
    
}

#pragma mark - tableview datasource and delegate method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [arrayResult count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CustomSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    [[cell.shareLabels objectAtIndex:0] setText:[[arrayResult objectAtIndex:indexPath.row] objectForKey:@"ART_TITLE"]]; // set title
    
    [[cell.shareLabels objectAtIndex:1] setText:[[arrayResult objectAtIndex:indexPath.row] objectForKey:@"ART_PUBLISHED_DATE"]]; // set publish date
    
    [[cell.shareLabels objectAtIndex:2] setText:[NSString stringWithFormat:@"By: %@",[[arrayResult objectAtIndex:indexPath.row] objectForKey:@"ART_AUTHOR"]]]; // set author
    
    //    [cell.myImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.senate.gov.kh/home/%@",[[arrayResult objectAtIndex:indexPath.row] objectForKey:@"ART_IMAGE"]]] placeholderImage:[UIImage imageNamed:@"none_photo.png"]]; // set image
    
    return cell;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([ShareObject shareObjectManager].pageCate <= remainPage) {
        [refresh_loadmore doLoadMore:self.view tableView:self.mainTableView scrollView:scrollView];
        [self requestToserver:@"ARTICLES_L001"];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"detail" sender:[arrayResult objectAtIndex:indexPath.row]];
}

#pragma mark - other methods
-(void)addRefreshToView{
    _refreshControl = [[UIRefreshControl alloc] init];
    _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    self.refreshControl.backgroundColor = [UIColor whiteColor];
    self.refreshControl.tintColor = [UIColor blackColor];
    [self.refreshControl addTarget:self action:@selector(refreshing) forControlEvents:UIControlEventValueChanged];
    [_mainTableView addSubview:_refreshControl];
}

-(void)refreshing{
    _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Loading..."];
    [ShareObject shareObjectManager].isLoadMore = false;
    [self.view setUserInteractionEnabled:false];
    [ShareObject shareObjectManager].pageCate = 1;
    [self requestToserver:@"ARTICLES_L001"];
}

#pragma mark - prepare for segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"detail"]) {
        NSLog(@"sender is %@",sender);
        DetailViewController *vc = [segue destinationViewController];
        vc.receiveData = sender;
    }
}

@end