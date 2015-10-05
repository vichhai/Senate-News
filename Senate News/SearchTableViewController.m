//
//  SearchTableViewController.m
//  Senate News
//
//  Created by vichhai on 9/16/15.
//  Copyright (c) 2015 GITS. All rights reserved.
//

#import "SearchTableViewController.h"
#import "AppUtils.h"
#import "ConnectionManager.h"
#import "ShareObject.h"
#import "GITSRefreshAndLoadMore.h"
#import "CustomSearchTableViewCell.h"
#import "DetailViewController.h"
#import "UIImageView+WebCache.h"

@interface SearchTableViewController ()<UISearchBarDelegate,ConnectionManagerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *arrayResult;
    GITSRefreshAndLoadMore *refresh_loadmore;
    NSString *keywords;
    int remainPage;
}
@property (strong,nonatomic) UISearchBar *search;
@property (strong,nonatomic) UIRefreshControl *refreshControl;
@end

@implementation SearchTableViewController

#pragma mark - view life cycle

-(BOOL)prefersStatusBarHidden{
    return true;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // =---> refresh
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to refresh"];
    self.refreshControl.backgroundColor = [UIColor whiteColor];
    self.refreshControl.tintColor = [UIColor blackColor];
    [self.refreshControl addTarget:self action:@selector(refreshing) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView addSubview:self.refreshControl];
    self.tableView.hidden = true;
    
    // =---> array result
    arrayResult = [[NSMutableArray alloc] init];
    
    // =---> search
    _search = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.width, 44)];
    _search.delegate = self;
    self.navigationItem.titleView = _search;

    // =---> load more
    refresh_loadmore = [[GITSRefreshAndLoadMore alloc] init];
    [refresh_loadmore addLoadMoreForTableView:self.tableView imageName:@"load_01.png"];
    
    // =---> set left menu
    [AppUtils settingLeftButton:self action:@selector(backClicked) normalImageCode:@"Back-100.png" highlightImageCode:nil];
    
    // =---> page
    [ShareObject shareObjectManager].pages = 1;
}

-(void)viewWillAppear:(BOOL)animated{
    [_search becomeFirstResponder];
    [ShareObject shareObjectManager].viewObserver = @"searchView";
}

#pragma mark - request to server
-(void)requestToserverWithKeyWord:(NSString *)keyword{
    
    NSMutableDictionary *reqDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];

    dataDic[@"PER_PAGE_CNT"] = @"20";
    dataDic[@"PAGE_NO"] = [NSString stringWithFormat:@"%d",[ShareObject shareObjectManager].pages];
    dataDic[@"SEARCH_KEY_WORD"] = keyword;
    
    reqDic[@"KEY"] = @"ARTICLES_L002";
    reqDic[@"REQ_DATA"] = dataDic;
    
    ConnectionManager *cont = [[ConnectionManager alloc] init];
    cont.delegate = self;
    [cont sendTranData:reqDic];
    
}

#pragma mark - return result

-(void)returnResult:(NSDictionary *)result withApiKey:(NSString *)apiKey{
    
    remainPage = [result[@"TOTAL_PAGE_COUNT"] intValue];
    
    if ([apiKey isEqual:@"ARTICLES_L002"]) {
        
        if ([result[@"STATUS"] intValue] == 0) {
            [AppUtils showErrorMessage:@"គ្មានទិន្នន័យ"];
            [AppUtils hideLoading:self.view];
        
            return;
        } else {
            
            if ([ShareObject shareObjectManager].isLoadMore){
                [arrayResult addObjectsFromArray:result[@"RESP_DATA"][@"ART_REC"]];
                [refresh_loadmore temp:self.tableView];
                [ShareObject shareObjectManager].isLoadMore = false;
            } else {
                if (self.refreshControl) {
                    [self.refreshControl endRefreshing];
                }
                
                [self.view setUserInteractionEnabled:true];
                [arrayResult removeAllObjects];
                [arrayResult addObjectsFromArray:result[@"RESP_DATA"][@"ART_REC"]];
                [refresh_loadmore temp:self.tableView];
                self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            }
        }
    }
    [AppUtils hideLoading:self.view];
    [self.tableView reloadData];
    self.tableView.hidden = false;
}

#pragma mark - Refresh And Load More
-(void)refreshing{
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Loading..."];
    [ShareObject shareObjectManager].isLoadMore = false;
    [self.view setUserInteractionEnabled:false];
    [ShareObject shareObjectManager].pages = 1;
    
    if ([AppUtils isNull:keywords]) {
        [AppUtils showErrorMessage:@"Search box is empty. Cannot refresh"];
        [self.refreshControl endRefreshing];
    }else {
        [self requestToserverWithKeyWord:keywords];
    }
}

#pragma mark - search bar delegate method
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
        [self.search resignFirstResponder];
        searchBar.text = nil;
        searchBar.showsCancelButton = false;
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = false;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [AppUtils showLoading:self.view];
    [ShareObject shareObjectManager].pages = 1;
    keywords = searchBar.text;
    [searchBar resignFirstResponder];
    [self requestToserverWithKeyWord:keywords];
    
}

#pragma mark - Table view data source and delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return arrayResult.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CustomSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [(cell.shareLabels)[0] setFont:[UIFont fontWithName:@"KhmerOSBattambang-Bold" size:17]];
    
    [(cell.shareLabels)[0] setText:arrayResult[indexPath.row][@"ART_TITLE"]]; // set title
    
    [(cell.shareLabels)[1] setText:arrayResult[indexPath.row][@"ART_PUBLISHED_DATE"]]; // set publish date
    
    [(cell.shareLabels)[2] setText:[NSString stringWithFormat:@"By: %@",arrayResult[indexPath.row][@"ART_AUTHOR"]]]; // set author
   [cell.myImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.senate.gov.kh/home/%@",[[arrayResult objectAtIndex:indexPath.row] objectForKey:@"ART_IMAGE"]]] placeholderImage:[UIImage imageNamed:@"none_photo.png"]];
    return cell;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([ShareObject shareObjectManager].pages < remainPage) {
        [refresh_loadmore doLoadMore:self.view tableView:self.tableView scrollView:scrollView];
        if ([ShareObject shareObjectManager].isLoadMore == true) {
            [self requestToserverWithKeyWord:keywords];
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.search resignFirstResponder];
    
    [self performSegueWithIdentifier:@"detail" sender:arrayResult[indexPath.row][@"ART_ID"]];
}

#pragma mark - bar button action
-(void)backClicked{
    [self.search resignFirstResponder];
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - prepare for segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"detail"]) {
        DetailViewController *vc = segue.destinationViewController;
        vc.receiveData = sender;
    }
}
@end
