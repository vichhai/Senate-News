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
@interface DetailViewController () <UITableViewDataSource, UITableViewDelegate>
{
    CGFloat rowHeigh;
    NSArray *arrContent;
    NSArray *linkArray;
}

@end

@implementation DetailViewController

-(BOOL)prefersStatusBarHidden{
    return true;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    linkArray = [[NSArray alloc] initWithObjects:@"http://www.keenthemes.com/preview/metronic/theme/assets/global/plugins/jcrop/demos/demo_files/image1.jpg",@"http://www.geant.net/Resources/PartnerResources/Partner%20Resources%20Image%20Library/Image%2010_958642.jpg",@"http://www.menucool.com/slider/jsImgSlider/images/image-slider-2.jpg", nil];
    
    arrContent = [[NSArray alloc] initWithObjects:@"​​សម្រាប់​ការ​ប្រកួត​រវាង​​​ក្រុម​ម្ចាស់​ផ្ទះ​ជប៉ុន​ និង​កម្ពុជា​​​​ល្ងាច​​ថ្ងៃ​ទី៣ ខែ​កញ្ញា ឆ្នាំ២០១៥​នេះ​​ អ្នក​ស្នេហា​វិស័យ​បាល់ទាត់​​នៅ​កម្ពុជា​អាច​​ចូល​រួម​ទស្សនា​បាន​​ដោយ​សេរី​ នៅ​​​​​កោះ​ពេជ្រ​ ​ចាប់​ពី​​វេលា​ម៉ោង៤:០០​តទៅ​ ដែល​មាន​​​​បំពាក់​ដោយ​ LED ខ្នាត​ធំ​ និង​ការ​ប្រគំតន្ត្រី​ដ៏​​អស្ចារ្យ​​ដែល​មាន​លោក ខេមរៈ សិរីមន្ត ចួល​រួម​សម្ដែង​ ​ដើម្បី​ចូលរួម​គាំទ្រ​​ក្រុម​បាល់ទាត់​ជម្រើស​ជាតិ​​កម្ពុជា សម្រាប់​​ការ​ប្រកួត​​បាល់ទាត់​​ពិភព​លោក​​​​​វគ្គ​ជម្រុះ​ប្រចាំ​តំបន់​អាស៊ី​ជុំ​ទី២​ ជើង​ទី១ ក្នុង​ពូល E ។ ការ​រៀប​ចំ​បញ្ចាំង ​​LED ​ខ្នាត​ធំ​ និង​ការ​​ប្រគំតន្ត្រី​​នេះ​រៀប​ចំ​ឡើង​ដោយ​ស្ថានីយ​ទូរទស្សន៍​បាយ័ន​ និង​ក្រុម​ហ៊ុន​ស្រាបៀរ​កម្ពុជា​ដែល​នាំ​​​តារា​ល្បីៗ ​មួយ​ចំនួន​ចូល​រួម​​សម្ដែង​ដូច​ជា​តារា​ចម្រៀង​​លោក​ ខេមរៈ សិរីមន្ត​​ និង​​តារា​ល្បី​ៗ ​ជា​ច្រើន​ដួង​ទៀត។ លើស​ពី​នេះ​ក៏​មាន​ការ​ចូល​រួម​​ពី​​កីឡាករ​បាល់ទាត់​លេចធ្លោ​ក្នុង​ក្រុម​​​​ជម្រើស​​ជាតិ​កម្ពុជា​អាយុ​ក្រោម​១៩​ឆ្នាំ​ចំនួន​៤​​រូប​​គឺ​​អ្នក​ចាំ​ទី អ៊ុំ​ សេរីរ័ត្ន​ ច្រឹង​ ពលរដ្ឋ​​ អ៊ុំ វិចិត្រ និង​ ទូច រ៉ូម៉ា។ ​កីឡាករ​ទាំង​៣​នាក់​មក​ពី​ក្លិប​ក្រសួង​ការពារ​ជាតិ ហើយ​​អ្នក​គាំទ្រ​​អាច​ចូល​រួម​ថត​រូប​ជា​អនុស្សាវរីយ៍​​ជា​មួយ​ពួក​គេ​បាន។",nil];
    
    // =---> Creating a custom right navi bar button1
    UIButton *menu  = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 25.0f, 28.0f)];
    [menu setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
    
    // =---> Creating a custom right navi bar button2
    UIButton *facebook  = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 25.0f, 25.0f)];
    [facebook setImage:[UIImage imageNamed:@"facebook.png"] forState:UIControlStateNormal];
    
    UIBarButtonItem *barButtonItem1 = [[UIBarButtonItem alloc] initWithCustomView:menu];
    UIBarButtonItem *barButtonItem2 = [[UIBarButtonItem alloc] initWithCustomView:facebook];
    
    NSArray *barButtonItemArray = [[NSArray alloc] initWithObjects:barButtonItem1,barButtonItem2, nil];
    self.navigationItem.rightBarButtonItems = barButtonItemArray;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
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
    
    cell.labelTitle.text = @"​​សម្រាប់​ការ​ប្រកួត​រវាង​​​ក្រុម​ម្ចាស់​ផ្ទះ​ជប៉ុន​ និង​កម្ពុជា​​​​ល្ងាច​​ថ្ងៃ​ទី៣ ខែ​កញ្ញា ឆ្នាំ២០១៥​នេះ​​ អ្នក​ស្នេហា​វិស័យ​បាល់ទាត់​​នៅ​កម្ពុជា​អាច​​ចូល​រួម​ទស្សនា​បាន​​ដោយ​សេរី​ នៅ​​​​​កោះ​ពេជ្រ​ ​ចាប់​ពី​​វេលា​ម៉ោង៤:០០​តទៅ​ ដែល​មាន​​​​បំពាក់​ដោយ​ LED ខ្នាត​ធំ​ និង​ការ​ប្រគំតន្ត្រី​ដ៏​​អស្ចារ្យ​​ដែល​មាន​លោក ខេមរៈ សិរីមន្ត ចួល​រួម​សម្ដែង​ ​ដើម្បី​ចូលរួម​គាំទ្រ​​ក្រុម​បាល់ទាត់​ជម្រើស​ជាតិ​​កម្ពុជា សម្រាប់​​ការ​ប្រកួត​​បាល់ទាត់​​ពិភព​លោក​​​​​វគ្គ​ជម្រុះ​ប្រចាំ​តំបន់​អាស៊ី​ជុំ​ទី២​ ជើង​ទី១ ក្នុង​ពូល E ។";
    CGFloat height = [self measureTextHeight:[arrContent objectAtIndex:indexPath.row] constrainedToSize:CGSizeMake(cell.myScrollView.frame.size.width, 2000.0f) fontSize:14.0f];
    
    [self setupScrollViewWithImages:[self getImagesFromURL:linkArray] atAnyView:cell.contentView];
    
   
    
    
    // =---> Getting Scroll View from cell
    
    UIScrollView *anyScrollView = (UIScrollView *)[cell.contentView viewWithTag:9999];
    
    NSLog(@"anyScrollView is here %@",anyScrollView);
    
    // =--> Create Content Label
    
    //    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(cell.myScrollView.frame.origin.x, (cell.myScrollView.frame.origin.y + cell.myScrollView.frame.size.height) + 5 , self.view.bounds.size.width - 30 , height)];
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 300 , self.view.bounds.size.width - 30 , height)];
    
    [contentLabel setFont:[UIFont systemFontOfSize:14]];
    contentLabel.text = [arrContent objectAtIndex:indexPath.row];
    contentLabel.numberOfLines = 0;
    contentLabel.tag = 100;
    [cell.contentView addSubview:contentLabel];
    
//    [self addImageToScrollView:[self getImagesFromURL:linkArray] toScrollView:cell.myScrollView];
    
    
    rowHeigh = (contentLabel.frame.origin.y + contentLabel.frame.size.height) + 10 ;
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrContent.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return rowHeigh;
}

#pragma mark - other methods

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
