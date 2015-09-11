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

@interface DetailViewController () <UITableViewDataSource, UITableViewDelegate,ConnectionManagerDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
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
    _detailTeableView.hidden = true;
    [AppUtils showLoading:self.view];
    // =---> Creating a custom right navi bar button1
    //UIButton *menu  = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 25.0f, 28.0f)];
    //[menu setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
    
    // =---> Creating a custom right navi bar button2
    UIButton *facebook  = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 30.0f, 30.0f)];
    [facebook setImage:[UIImage imageNamed:@"facebook.png"] forState:UIControlStateNormal];
    
   // UIBarButtonItem *barButtonItem1 = [[UIBarButtonItem alloc] initWithCustomView:menu];
    UIBarButtonItem *barButtonItem2 = [[UIBarButtonItem alloc] initWithCustomView:facebook];
    
    NSArray *barButtonItemArray = [[NSArray alloc] initWithObjects:barButtonItem2, nil];
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
        [facebookController addURL:[NSURL URLWithString:[resultDic objectForKey:@"ART_URL"]]];
        [facebookController setCompletionHandler:^(SLComposeViewControllerResult result){
            if (result == SLComposeViewControllerResultCancelled) {
                NSLog(@"Cancil");
            }else if(result == SLComposeViewControllerResultDone){
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Done" message:@"Your sharing is succesfull!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }
        }];
        [self presentViewController:facebookController animated:YES completion:nil];
    }
    
}

#pragma mark - outlet actions

- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - CollectionView datasource and delegate
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    for (UIView *v in [cell.contentView subviews]) {
        if ([v isKindOfClass:[UIImageView class]]){
            [v removeFromSuperview];
        }
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.contentView.frame];
    imageView.image = [UIImage imageNamed:@"none_photo.png"];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.senate.gov.kh/home/%@",[[resultDic objectForKey:@"IMAGES"] objectAtIndex:indexPath.row]]] placeholderImage:[UIImage imageNamed:@"none_photo.png"]];
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
    imagePage.image = [UIImage imageNamed:@"photo_page_icon.png"];
    
    // =---> label page of page
    
    UILabel *labelPage = [[UILabel alloc] initWithFrame:CGRectMake(23, view.frame.size.height / 2 - 6.0f, 30, 12)];
    labelPage.text = [NSString stringWithFormat:@"%ld / %lu",indexPath.row + 1,(unsigned long)[[resultDic objectForKey:@"IMAGES"] count]];
    labelPage.textColor = [UIColor whiteColor];
    labelPage.font = [UIFont systemFontOfSize:12];
    CGFloat width = [self measureTextWidth:[NSString stringWithFormat:@"%ld / %lu",indexPath.row + 1,(unsigned long)[[resultDic objectForKey:@"IMAGES"] count]] constrainedToSize:CGSizeMake(2000.0f, 12) fontSize:12];
    
    // =---> set new frame to label
    [labelPage setFrame:CGRectMake(labelPage.frame.origin.x, labelPage.frame.origin.y, width, 12)];
    
    // =---> set new frame for view
    [view setFrame:CGRectMake(cell.contentView.bounds.size.width - (labelPage.frame.origin.x + labelPage.frame.size.width) - 10,(cell.contentView.frame.size.height - 25) - 20,(labelPage.frame.origin.x + labelPage.frame.size.width) + 5,20)];
    
    [view addSubview:labelPage];
    [view addSubview:imagePage];
    [cell.contentView addSubview:view];
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[resultDic objectForKey:@"IMAGES"] count];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"index path %@",indexPath);
}
#pragma mark - Tableview datasource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    // remove duplicate label when scrolling
    for (UIView *v in [cell.contentView subviews]) {
        if ([v isKindOfClass:[UILabel class]])
            if (v.tag == 100) {
                [v removeFromSuperview];
            }
    }
    
    cell.labelTitle.text = [resultDic objectForKey:@"ART_TITLE"]; // set title
    cell.labelAuthor.text = [NSString stringWithFormat:@"By: %@",[resultDic objectForKey:@"ART_AUTHOR"]]; // set author
    
    // =---> getting array image from resultDic
    //    NSArray *arr = [[NSArray alloc] initWithArray:ret];
    //    linkArray = [[NSMutableArray alloc] init];
    //
    //    for (int i = 0; i < arr.count; i++) {
    //        [linkArray addObject:[NSString stringWithFormat:@"http://www.senate.gov.kh/home/%@",[arr objectAtIndex:i]]];
    //    }
    //
    //    [self setupScrollViewWithImages:[self getImagesFromURL:linkArray] atAnyView:cell.contentView]; // set image to scroll view
    
    
    [self setupCollectinView:cell.contentView];
    
    
    // =--> Create Content Label
    CGFloat height = [self measureTextHeight:[resultDic objectForKey:@"ART_DETAIL"] constrainedToSize:CGSizeMake(cell.myScrollView.frame.size.width, 2000.0f) fontSize:15.0f];
    UICollectionView *tempScrollView = (UICollectionView *) [cell.contentView viewWithTag:9999];
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, (tempScrollView.frame.origin.y + tempScrollView.frame.size.height) + 5 , self.view.bounds.size.width - 30 , height)];
    
    [contentLabel setFont:[UIFont systemFontOfSize:15]];
    contentLabel.text = [resultDic objectForKey:@"ART_DETAIL"];
    contentLabel.numberOfLines = 0;
    contentLabel.tag = 100;
    
    if ([AppUtils isNull:[resultDic objectForKey:@"ART_DETAIL"]] == false && [AppUtils isNull:[resultDic objectForKey:@"ART_TITLE"]] == false) {
        
        [AppUtils setLineHeight:[resultDic objectForKey:@"ART_DETAIL"] anyLabel:contentLabel];
        [AppUtils setLineHeight:[resultDic objectForKey:@"ART_TITLE"] anyLabel:cell.labelTitle];
        
    }
    
    [cell.contentView addSubview:contentLabel];
    
    rowHeigh = (contentLabel.frame.origin.y + contentLabel.frame.size.height) + 10 ;
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return rowHeigh;
}

#pragma mark - other methods
-(void)setupCollectinView:(UIView *)anyView{
    // =---> create flow layout for collection view
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.sectionInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    flowLayout.itemSize     = CGSizeMake(self.view.bounds.size.width - 30,[ShareObject shareObjectManager].shareWidth );
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView *imageCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(16, 138, self.view.bounds.size.width - 30, [ShareObject shareObjectManager].shareWidth) collectionViewLayout:flowLayout];
    
    // set Datasource and Delegate
    imageCollectionView.delegate = self;
    imageCollectionView.dataSource = self;
    imageCollectionView.tag = 9999;
    
    [imageCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
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
        [imageView sd_setImageWithURL:[arrayURL objectAtIndex:i] placeholderImage:[UIImage imageNamed:@"none_photo.png"]];
        [arrayImageView addObject:imageView];
    }
    return arrayImageView;
}


-(void)setupScrollViewWithImages:(NSArray *)imageViewArray atAnyView:(UIView *)anyView{
    
    UIScrollView *anyScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(16, 138, self.view.bounds.size.width - 30, [ShareObject shareObjectManager].shareWidth)];
    anyScrollView.pagingEnabled = true;
    anyScrollView.showsHorizontalScrollIndicator = false;
    anyScrollView.tag = 9999;
    
    for (int index = 0; index < imageViewArray.count; index++) {
        UIImageView *imageView = (UIImageView *)[imageViewArray objectAtIndex:index];
        [imageView  setFrame:CGRectMake((anyScrollView.frame.size.width * (CGFloat)index), 0, anyScrollView.frame.size.width, anyScrollView.frame.size.height)];
        
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
        [labelPage setFrame:CGRectMake(labelPage.frame.origin.x, labelPage.frame.origin.y, width, 12)];
        
        // =---> set new frame for view
        [view setFrame:CGRectMake((imageView.frame.origin.x + imageView.frame.size.width) - (labelPage.frame.origin.x + labelPage.frame.size.width) - 10,(anyScrollView.frame.size.height - 25) - 10,(labelPage.frame.origin.x + labelPage.frame.size.width) + 5,20)];
        
        [view addSubview:labelPage];
        [view addSubview:imagePage];
        [anyScrollView addSubview:imageView];
        [anyScrollView addSubview:view];
    }
    [anyScrollView setContentSize:CGSizeMake(anyScrollView.frame.size.width * (CGFloat)imageViewArray.count, anyScrollView.frame.size.height)];
    
    [anyView addSubview:anyScrollView];
}

#pragma mark - request to server

-(void)requestToserver{
    NSMutableDictionary *reqDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
    
    [dataDic setObject:[_receiveData objectForKey:@"ART_ID"] forKey:@"ART_ID"];
    [reqDic setObject:@"ARTICLES_R001" forKey:@"KEY"];
    [reqDic setObject:dataDic forKey:@"REQ_DATA"];
    
    ConnectionManager *cont = [[ConnectionManager alloc] init];
    cont.delegate = self;
    [cont sendTranData:reqDic];
    
}

#pragma mark - return result
-(void)returnResult:(NSDictionary *)result{
    
    resultDic = [[NSMutableDictionary alloc] initWithDictionary:[[result objectForKey:@"RESP_DATA"] objectForKey:@"ART_REC"]];
    [_detailTeableView reloadData];
    [AppUtils hideLoading:self.view];
    _detailTeableView.hidden = false;
}


//-(void)addImageToScrollView:(NSArray *)imageViewArray toScrollView:(UIScrollView *)anyScrollView{

//    for (int index = 0; index < imageViewArray.count; index++) {
//        UIImageView *imageView = (UIImageView *)[imageViewArray objectAtIndex:index];
//        [imageView  setFrame:CGRectMake((anyScrollView.frame.size.width * (CGFloat)index), 0, anyScrollView.frame.size.width, anyScrollView.frame.size.height)];
//        
//        NSLog(@"images %@",imageView);
//        NSLog(@"Scroll View %f",anyScrollView.frame.size.width);
//        
//        // =---> Image Page BackGround
//        
//        UIView *view = [[UIView alloc]initWithFrame:CGRectMake((imageView.frame.origin.x + imageView.frame.size.width) - 65,(anyScrollView.frame.size.height - 25) - 10,55,20)];
//        view.backgroundColor = [UIColor lightGrayColor];
//        view.layer.cornerRadius = 5;
//        view.layer.masksToBounds = true;
//        view.alpha = 0.7;
//        
//        // =---> Image Page
//        
//        UIImageView *imagePage = [[UIImageView alloc] initWithFrame:CGRectMake(5.0f , view.frame.size.height / 2 - 7.0f , 12.0f, 12.0f)];
//        imagePage.image = [UIImage imageNamed:@"photo_page_icon.png"];
//        
//        // =---> label page of page
//        
//        UILabel *labelPage = [[UILabel alloc] initWithFrame:CGRectMake(23, view.frame.size.height / 2 - 6.0f, 30, 12)];
//        labelPage.text = [NSString stringWithFormat:@"%d / %lu",index + 1,(unsigned long)imageViewArray.count];
//        labelPage.textColor = [UIColor whiteColor];
//        labelPage.font = [UIFont systemFontOfSize:12];
//        CGFloat width = [self measureTextWidth:[NSString stringWithFormat:@"%d / %lu",index + 1,(unsigned long)imageViewArray.count] constrainedToSize:CGSizeMake(2000.0f, 12) fontSize:12];
//        
//        // =---> set new frame to label
//        [labelPage setFrame:CGRectMake(labelPage.frame.origin.x, labelPage.frame.origin.y, width, 12)];
//        
//        // =---> set new frame for view
//        [view setFrame:CGRectMake((imageView.frame.origin.x + imageView.frame.size.width) - (labelPage.frame.origin.x + labelPage.frame.size.width) - 10,(anyScrollView.frame.size.height - 25) - 10,(labelPage.frame.origin.x + labelPage.frame.size.width) + 5,20)];
//        
//        [view addSubview:labelPage];
//        [view addSubview:imagePage];
//        [anyScrollView addSubview:imageView];
//        [anyScrollView addSubview:view];
//    }
//     [anyScrollView setContentSize:CGSizeMake(anyScrollView.frame.size.width * (CGFloat)imageViewArray.count, anyScrollView.frame.size.height)];
//}


@end
