//
//  ShowImageViewController.m
//  Senate News
//
//  Created by vichhai on 9/11/15.
//  Copyright (c) 2015 GITS. All rights reserved.
//

#import "ShowImageViewController.h"
#import "ShareObject.h"
@interface ShowImageViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@end

@implementation ShowImageViewController

#pragma mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    [self setupImageView];
}


-(void)setupImageView{

    float height = 300;
    float width = self.view.bounds.size.width - 20;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, ((_myScrollView.frame.size.height - height) / 2) - 10, width, height)];
    imageView.tag = 99;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.senate.gov.kh/home/%@",[ShareObject shareObjectManager].shareURL]];
    
    [_activityIndicatorView startAnimating];
    
    dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(q, ^{
        /* Fetch the image from the server... */
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *img = [[UIImage alloc] initWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            /* This is the main thread again, where we set the tableView's image to
             be what we just fetched. */
            imageView.image = img;
            [_activityIndicatorView stopAnimating];
        });
    });
    
    _myScrollView.minimumZoomScale = 1.0;
    _myScrollView.maximumZoomScale = 5.0f;
    _myScrollView.delegate = self;
    _myScrollView.contentSize = imageView ? imageView.frame.size : CGSizeZero;
    [_myScrollView addSubview:imageView];
    
}

-(UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return [self.view viewWithTag:99];
}

- (IBAction)closeButtonAction:(id)sender {

    [self dismissViewControllerAnimated:true completion:nil];
    
}
- (IBAction)imageDownload:(id)sender {
    
    UIImage *image = ((UIImageView *)[self.view viewWithTag:99]).image;
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

-(void)image:(UIImage *) image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    UIAlertView *alert;
    if (error) {
        alert = [[UIAlertView alloc]initWithTitle:@"" message:@"បរាជ័យ" delegate:self cancelButtonTitle:@"យល់ព្រម" otherButtonTitles:nil];
    }else{
        alert = [[UIAlertView alloc]initWithTitle:@"" message:@"ជោគជ័យ" delegate:self cancelButtonTitle:@"យល់ព្រម" otherButtonTitles:nil];
    }
    
    [alert show];
    
}

@end
