//
//  FlickrPhotoDetailViewController.m
//  TopPlaces
//
//  Created by Timothée Boucher on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FlickrPhotoDetailViewController.h"
#import "FlickrFetcher.h"

@interface FlickrPhotoDetailViewController() <UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *photoView;
@end

@implementation FlickrPhotoDetailViewController
@synthesize scrollView = _scrollView;
@synthesize photoInformation = _photoInformation;
@synthesize photoView = _photoView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    
    self.title = [self.photoInformation objectForKey:@"title"];
    
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.maximumZoomScale = 2.0;
    self.scrollView.delegate = self;
    
    dispatch_queue_t fetchPhoto = dispatch_queue_create("fetchPhoto", NULL);
    dispatch_async(fetchPhoto, ^{
        NSData *photoData = [NSData dataWithContentsOfURL:[FlickrFetcher urlForPhoto:self.photoInformation format:FlickrPhotoFormatLarge]];
        UIImage *photo = [UIImage imageWithData:photoData];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.scrollView.contentSize = photo.size;
            UIImageView *photoView = [[UIImageView alloc] initWithImage:photo];
            
            self.photoView = photoView;
            [self.scrollView addSubview:photoView];
            
            CGSize scrollSize = self.scrollView.bounds.size;
            CGSize photoSize = photo.size;
            
            CGRect visibleRect;
            if (scrollSize.width/scrollSize.height >= photoSize.width/photoSize.height) { // photo is narrower than screen
                self.scrollView.minimumZoomScale = scrollSize.height/photoSize.height;
                visibleRect = CGRectMake(0, (photoSize.height-scrollSize.height*photoSize.width/scrollSize.width)/2, photoSize.width, scrollSize.height*photoSize.width/scrollSize.width);
            } else { // photo is wider than screen
                self.scrollView.minimumZoomScale = scrollSize.width/photoSize.width;
                visibleRect = CGRectMake((photoSize.width-scrollSize.width*photoSize.height/scrollSize.height)/2, 0, scrollSize.width*photoSize.height/scrollSize.height, photoSize.height);
            }
            
            [self.scrollView zoomToRect:visibleRect animated:NO];
            
            self.navigationItem.rightBarButtonItem = nil;
        });
    });
    dispatch_release(fetchPhoto);
}


- (void)viewDidUnload
{
    [self setScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated {

}

-(void)viewWillDisappear:(BOOL)animated {

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

-(BOOL)wantsFullScreenLayout {
    return YES;
}

#pragma mark UIScrollViewDelegate implementation
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.photoView;
}

@end
