//
//  DetailViewController.m
//  Senate News
//
//  Created by vichhai on 9/3/15.
//  Copyright (c) 2015 GITS. All rights reserved.
//

#import "DetailViewController.h"
#import "CustomDetailTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "ShareObject.h"
#import "ConnectionManager.h"
#import <Social/Social.h>
#import "ShowImageViewController.h"

@interface DetailViewController () <UITableViewDataSource, UITableViewDelegate,ConnectionManagerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,NSLayoutManagerDelegate>
{
    NSMutableArray *linkArray;
    float rowHeigh;
    NSMutableDictionary *resultDic;
}
@property (weak, nonatomic) IBOutlet UITableView *detailTeableView;

@end

@implementation DetailViewController

-(BOOL)prefersStatusBarHidden{
    return true;
}

#pragma mark - view life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_detailTeableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"tableCell"];
    _detailTeableView.hidden = true;
    _detailTeableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [AppUtils showLoading:self.view];
    // =---> Creating a custom right navi bar button2
    UIButton *facebook  = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 20.0f, 20.0f)];
    [facebook setImage:[UIImage imageNamed:@"facebook.png"] forState:UIControlStateNormal];

    UIBarButtonItem *barButtonItem2 = [[UIBarButtonItem alloc] initWithCustomView:facebook];
    
    NSArray *barButtonItemArray = @[barButtonItem2];
    self.navigationItem.rightBarButtonItems = barButtonItemArray;
    [facebook addTarget:self action:@selector(shareToFacebook) forControlEvents:UIControlEventTouchUpInside];

    // =---> request to server
    [self requestToserver];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - action on facebook button

-(void) shareToFacebook{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *facebookController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [facebookController addURL:[NSURL URLWithString:resultDic[@"ART_URL"]]];
        facebookController.completionHandler = ^(SLComposeViewControllerResult result){
            if (result == SLComposeViewControllerResultCancelled) {
                NSLog(@"Cancil");
            }else if(result == SLComposeViewControllerResultDone){
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"ជោគជ័យ" message:@"ប្រតិបតិការបានជោគជ័យ" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }
        };
        [self presentViewController:facebookController animated:YES completion:nil];
    }
    
}

#pragma mark - outlet actions

- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
    [ShareObject shareObjectManager].jsonNotification = nil;
}

#pragma mark - CollectionView datasource and delegate
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    for (UIView *v in (cell.contentView).subviews) {
        if ([v isKindOfClass:[UIImageView class]]){
            [v removeFromSuperview];
        }
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.contentView.frame];
    imageView.image = [UIImage imageNamed:@"none_photo.png"];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.senate.gov.kh/home/%@",resultDic[@"IMAGES"][indexPath.row]]] placeholderImage:[UIImage imageNamed:@"none_photo.png"]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [cell.contentView addSubview:imageView];
    
    // =---> Image Page BackGround
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(cell.contentView.bounds.size.width - 65,(cell.contentView.frame.size.height - 25) - 20,55,20)];
    view.backgroundColor = [UIColor lightGrayColor];
    view.layer.cornerRadius = 5;
    view.layer.masksToBounds = true;
    view.alpha = 0.7;
    
    
    // =---> Image Page
    
    UIImageView *imagePage = [[UIImageView alloc] initWithFrame:CGRectMake(5.0f , view.frame.size.height / 2 - 7.0f , 12.0f, 12.0f)];
    imageView.contentMode = UIViewContentModeScaleToFill;
    imagePage.image = [UIImage imageNamed:@"photo_page_icon.png"];
    
    // =---> label page of page
    
    UILabel *labelPage = [[UILabel alloc] initWithFrame:CGRectMake(23, view.frame.size.height / 2 - 6.0f, 30, 12)];
    labelPage.text = [NSString stringWithFormat:@"%d/ %lu",indexPath.row + 1,(unsigned long)[resultDic[@"IMAGES"] count]];
    labelPage.textColor = [UIColor whiteColor];
    labelPage.font = [UIFont systemFontOfSize:12];
    CGFloat width = [self measureTextWidth:[NSString stringWithFormat:@"%d / %lu",indexPath.row + 1,(unsigned long)[resultDic[@"IMAGES"] count]] constrainedToSize:CGSizeMake(2000.0f, 12) fontSize:12];
    
    // =---> set new frame to label
    labelPage.frame = CGRectMake(labelPage.frame.origin.x, labelPage.frame.origin.y, width, 12);
    
    // =---> set new frame for view
    view.frame = CGRectMake(cell.contentView.bounds.size.width - (labelPage.frame.origin.x + labelPage.frame.size.width) - 10,(cell.contentView.frame.size.height - 25) - 20,(labelPage.frame.origin.x + labelPage.frame.size.width) + 5,20);
    
    [view addSubview:labelPage];
    [view addSubview:imagePage];
    [cell.contentView addSubview:view];
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [resultDic[@"IMAGES"] count];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"showImage" sender:resultDic[@"IMAGES"][indexPath.row]];
} 
#pragma mark - Tableview datasource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell" forIndexPath:indexPath];

    for (UIView *v in (cell.contentView).subviews) {
        if ([v isKindOfClass:[UILabel class]] || [v isKindOfClass:[UITextView class]])
            [v removeFromSuperview];
    }
    if (![AppUtils isNull:resultDic]) {
        
        CGFloat height = 0.0;
        height = [self measureTextHeight:resultDic[@"ART_TITLE"] constrainedToSize:CGSizeMake(cell.contentView.frame.size.width, 2000.0f) fontSize:15.0f] * 0.5;
        
        UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, cell.contentView.frame.size.width - 20, height)];
        labelTitle.numberOfLines = 0;
        labelTitle.font = [UIFont fontWithName:@"KhmerOSBattambang-Bold" size:17];
        labelTitle.text = resultDic[@"ART_TITLE"];
        
        height = [self measureTextHeight:resultDic[@"ART_TITLE"] constrainedToSize:CGSizeMake(cell.contentView.frame.size.width, 2000.0f) fontSize:27.0f];
        
        labelTitle.frame = CGRectMake(10, 10, cell.contentView.frame.size.width - 20, height);
        
        [cell.contentView addSubview:labelTitle];
        
        UILabel *labelDate = [[UILabel alloc] initWithFrame:CGRectMake(10, (labelTitle.frame.size.height + labelTitle.frame.origin.y) + 2, cell.contentView.frame.size.width - 20, 21)];
        labelDate.font = [UIFont systemFontOfSize:12];
        labelDate.textColor = [UIColor darkGrayColor];
        labelDate.text = [NSString stringWithFormat:@"ចុះផ្សាយ %@",resultDic[@"ART_PUBLISHED_DATE"]];
        
        [cell.contentView addSubview:labelDate];
        
        UILabel *labelAuthor = [[UILabel alloc] initWithFrame:CGRectMake(10, (labelDate.frame.size.height + labelDate.frame.origin.y) + 2, cell.contentView.frame.size.width - 20, 21)];
        labelAuthor.font = [UIFont systemFontOfSize:12];
        labelAuthor.textColor = [UIColor darkGrayColor];
        labelAuthor.text = [NSString stringWithFormat:@"ចុះផ្សាយដោយ: %@",resultDic[@"ART_AUTHOR"]]; // set author
        
        labelAuthor.tag = 101;
        [cell.contentView addSubview:labelAuthor];
        
        [self setupCollectinView:cell.contentView];
        
        UICollectionView *tempCollectionView = (UICollectionView *) [cell.contentView viewWithTag:9999];
        
        // =--> Create Content Label
        
        height = [self measureTextHeight:resultDic[@"ART_DETAIL"] constrainedToSize:CGSizeMake(tempCollectionView.frame.size.width, 2000.0f) fontSize:22.0f];
        
        if ([_receiveData isEqualToString:@"11802"] || [_receiveData isEqualToString:@"11809"] || [_receiveData isEqualToString:@"11805"] || [_receiveData isEqualToString:@"11795"]) {
            height = height * 1.2;
        }
        
        UITextView *contentLabel = [[UITextView alloc] initWithFrame:CGRectMake(16, (tempCollectionView.frame.origin.y + tempCollectionView.frame.size.height) + 5 , self.view.bounds.size.width - 30 , height)];
        
        contentLabel.text = resultDic[@"ART_DETAIL"];
        contentLabel.tag = 100;
        contentLabel.selectable = true;
        contentLabel.scrollEnabled = false;
        contentLabel.editable = false;
        contentLabel.layoutManager.delegate = self;
        contentLabel.dataDetectorTypes = UIDataDetectorTypeLink;
        
        if ([AppUtils isNull:resultDic[@"ART_DETAIL"]] == false && [AppUtils isNull:resultDic[@"ART_TITLE"]] == false) {
            
            [AppUtils setTextViewHeight:resultDic[@"ART_DETAIL"] anyTextView:contentLabel];
            contentLabel.font = [UIFont systemFontOfSize:16];
        }
        [cell.contentView addSubview:contentLabel];
        
        rowHeigh = (contentLabel.frame.origin.y + contentLabel.frame.size.height) + 10 ;
    }
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return rowHeigh;
}
#pragma mark - manager layout delegate 
- (CGFloat)layoutManager:(NSLayoutManager *)layoutManager lineSpacingAfterGlyphAtIndex:(NSUInteger)glyphIndex withProposedLineFragmentRect:(CGRect)rect
{
    return 10;
}

#pragma mark - other methods
-(void)setupCollectinView:(UIView *)anyView{
    
    UILabel *label = (UILabel *)[self.view viewWithTag:101];
    
    // =---> create flow layout for collection view
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.sectionInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    flowLayout.itemSize     = CGSizeMake(self.view.bounds.size.width - 30,[ShareObject shareObjectManager].shareWidth );
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView *imageCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(16, (label.frame.size.height + label.frame.origin.y) + 10, self.view.bounds.size.width - 30, [ShareObject shareObjectManager].shareWidth) collectionViewLayout:flowLayout];
    
    // set Datasource and Delegate
    imageCollectionView.delegate = self;
    imageCollectionView.dataSource = self;
    imageCollectionView.tag = 9999;
    
    [imageCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"collectionCell"];
    imageCollectionView.showsHorizontalScrollIndicator = false;
    imageCollectionView.showsVerticalScrollIndicator = false;
    imageCollectionView.backgroundColor = [UIColor whiteColor];
    imageCollectionView.pagingEnabled = true;
    [anyView addSubview:imageCollectionView];
}

- (CGFloat)measureTextHeight:(NSString*)text constrainedToSize:(CGSize)constrainedToSize fontSize:(CGFloat)fontSize {
    
    CGRect rect = [text boundingRectWithSize:constrainedToSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil];
    
    return rect.size.height;
    
}


- (CGFloat)measureTextWidth:(NSString*)text constrainedToSize:(CGSize)constrainedToSize fontSize:(CGFloat)fontSize {
    
    CGRect rect = [text boundingRectWithSize:constrainedToSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil];
    
    return rect.size.width;
    
}

-(NSArray *)getImagesFromURL:(NSArray *)arrayURL{
    NSMutableArray *arrayImageView = [[NSMutableArray alloc] init];
    
    for (int i = 0; i<arrayURL.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView sd_setImageWithURL:arrayURL[i] placeholderImage:[UIImage imageNamed:@"none_photo.png"]];
        [arrayImageView addObject:imageView];
    }
    return arrayImageView;
}


-(void)setupScrollViewWithImages:(NSArray *)imageViewArray atAnyView:(UIView *)anyView{
    
    UIScrollView *anyScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(16, 158, self.view.bounds.size.width - 30, [ShareObject shareObjectManager].shareWidth)];
    anyScrollView.pagingEnabled = true;
    anyScrollView.showsHorizontalScrollIndicator = false;
    anyScrollView.tag = 9999;
    
    for (int index = 0; index < imageViewArray.count; index++) {
        UIImageView *imageView = (UIImageView *)imageViewArray[index];
        imageView.frame = CGRectMake((anyScrollView.frame.size.width * (CGFloat)index), 0, anyScrollView.frame.size.width, anyScrollView.frame.size.height);
        
        // =---> Image Page BackGround
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake((imageView.frame.origin.x + imageView.frame.size.width) - 65,(anyScrollView.frame.size.height - 25) - 10,55,20)];
        view.backgroundColor = [UIColor lightGrayColor];
        view.layer.cornerRadius = 5;
        view.layer.masksToBounds = true;
        view.alpha = 0.7;
        
        // =---> Image Page
        
        UIImageView *imagePage = [[UIImageView alloc] initWithFrame:CGRectMake(5.0f , view.frame.size.height / 2 - 7.0f , 12.0f, 12.0f)];
        imagePage.image = [UIImage imageNamed:@"photo_page_icon.png"];
        
        // =---> label page of page
        
        UILabel *labelPage = [[UILabel alloc] initWithFrame:CGRectMake(23, view.frame.size.height / 2 - 6.0f, 30, 12)];
        labelPage.text = [NSString stringWithFormat:@"%d / %lu",index + 1,(unsigned long)imageViewArray.count];
        labelPage.textColor = [UIColor whiteColor];
        labelPage.font = [UIFont systemFontOfSize:12];
        CGFloat width = [self measureTextWidth:[NSString stringWithFormat:@"%d / %lu",index + 1,(unsigned long)imageViewArray.count] constrainedToSize:CGSizeMake(2000.0f, 12) fontSize:12];
        
        // =---> set new frame to label
        labelPage.frame = CGRectMake(labelPage.frame.origin.x, labelPage.frame.origin.y, width, 12);
        
        // =---> set new frame for view
        view.frame = CGRectMake((imageView.frame.origin.x + imageView.frame.size.width) - (labelPage.frame.origin.x + labelPage.frame.size.width) - 10,(anyScrollView.frame.size.height - 25) - 10,(labelPage.frame.origin.x + labelPage.frame.size.width) + 5,20);
        
        [view addSubview:labelPage];
        [view addSubview:imagePage];
        [anyScrollView addSubview:imageView];
        [anyScrollView addSubview:view];
    }
    anyScrollView.contentSize = CGSizeMake(anyScrollView.frame.size.width * (CGFloat)imageViewArray.count, anyScrollView.frame.size.height);
    
    [anyView addSubview:anyScrollView];
}

#pragma mark - request to server

-(void)requestToserver{
    NSMutableDictionary *reqDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
 
    dataDic[@"ART_ID"] = _receiveData;
    reqDic[@"KEY"] = @"ARTICLES_R001";
    reqDic[@"REQ_DATA"] = dataDic;
    
    ConnectionManager *cont = [[ConnectionManager alloc] init];
    cont.delegate = self;
    [cont sendTranData:reqDic];
}

-(void)returnResult:(NSDictionary *)result withApiKey:(NSString *)apiKey{
    
    if ([apiKey isEqualToString:@"ARTICLES_R001"]) {
        resultDic = [[NSMutableDictionary alloc] initWithDictionary:result[@"RESP_DATA"][@"ART_REC"]];
        [_detailTeableView reloadData];
        [AppUtils hideLoading:self.view];
        _detailTeableView.hidden = false;
    }
}

#pragma mark - prepare for segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    [ShareObject shareObjectManager].shareURL = sender;
}

@end
