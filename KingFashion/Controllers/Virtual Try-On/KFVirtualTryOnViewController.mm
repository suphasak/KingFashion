//
//  KFVirtualTryOnViewController.m
//  KingFashion
//
//  Created by Anh Vu Mai on 10/18/16.
//  Copyright © 2016 Mai Anh Vu. All rights reserved.
//

#import "KFVirtualTryOnViewController.h"
#import "NSArray+FunctionalInterface.h"
#import "KFSmartCartManager.h"

#ifdef __cplusplus
#import <opencv2/videoio/cap_ios.h>
#import <opencv2/imgproc.hpp>
#import <opencv2/objdetect.hpp>
using namespace cv;
#endif


@interface KFVirtualTryOnViewController () <CvVideoCameraDelegate>

@property (nonatomic, strong) CvVideoCamera *camera;
@property (weak, nonatomic) IBOutlet UIView *cameraView;
@property (nonatomic, assign) NSInteger skippedFrameCount;

@property (nonatomic, assign) CascadeClassifier classifier;
@property (nonatomic, assign) std::vector<cv::Rect> detectedObjectRects;
@property (atomic, assign, getter=isRefreshing) BOOL refreshing;

@property (nonatomic, weak) IBOutlet UIView *overlayContainerView;
@property (nonatomic, weak) IBOutlet UIButton *smartCartButton;
@property (nonatomic, weak) UIPageViewController *overlayPageViewController;
@property (nonatomic, strong) NSArray<UIViewController *> *overlayViewControllers;
@property (nonatomic, assign, getter=isFacePresent) BOOL facePresent;

@property (nonatomic, strong) NSArray<KFSmartCartItem *> *items;

@end

@implementation KFVirtualTryOnViewController

//-------------------------------------------------------------------------------------------------
#pragma mark - Constants
//-------------------------------------------------------------------------------------------------
static NSInteger const REFRESH_THRESHOLD = 30;
static NSString *const RESOURCE_NAME_HAAR_CLASSIFIER_FACE = @"haarcascade_frontalface_alt2";

//-------------------------------------------------------------------------------------------------
#pragma mark - Initialization
//-------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];

    _skippedFrameCount = 0;
    _refreshing = NO;
    _items = [KFSmartCartItem allItems];

    [self setUpCamera];
    [self setUpClassifier];

    self.facePresent = YES;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)setUpCamera {
    self.camera = [[CvVideoCamera alloc] initWithParentView:self.cameraView];
    self.camera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionFront;
    self.camera.defaultAVCaptureSessionPreset = AVCaptureSessionPresetiFrame960x540;
    self.camera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    self.camera.rotateVideo = YES;
    self.camera.defaultFPS = 30;
    self.camera.grayscaleMode = NO;
    self.camera.delegate = self;
}

- (void)setUpClassifier {
    NSString *pathToClassifier = [[NSBundle mainBundle]
                                  pathForResource:RESOURCE_NAME_HAAR_CLASSIFIER_FACE
                                  ofType:@"xml"
                                  inDirectory:@"Cascades"];
    const CFIndex cascadeNameLength = 2048;
    char *cascadeName = (char *) malloc(cascadeNameLength);
    CFStringGetFileSystemRepresentation((CFStringRef) pathToClassifier, cascadeName, cascadeNameLength);
    CascadeClassifier classifier;
    classifier.load(cascadeName);
    free(cascadeName);
    self.classifier = classifier;
}

- (void)startCapture {
    [self.camera start];
}

- (void)stopCapture {
    [self.camera stop];
}

//-------------------------------------------------------------------------------------------------
#pragma mark - Recognition
//-------------------------------------------------------------------------------------------------

- (void)processImage:(Mat &)image {
//    if (++self.skippedFrameCount >= REFRESH_THRESHOLD) {
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
//            [self refreshDetectedObjectRectsInImage:image];
//        });
//        self.skippedFrameCount = 0;
//    }
}

- (void)refreshDetectedObjectRectsInImage:(Mat &)image {
    Mat grayImage;
    cvtColor(image, grayImage, COLOR_BGR2GRAY);
    std::vector<cv::Rect> detectedObjects;
    cv::Size minSize(30, 30);
    self.classifier.detectMultiScale(grayImage, detectedObjects, 1.1, 5, 0, minSize);

    self.facePresent = detectedObjects.size() > 0;
    NSLog(@"%d", self.facePresent);
}

//-------------------------------------------------------------------------------------------------
#pragma mark - Lazy Instantiation of Properties
//-------------------------------------------------------------------------------------------------
- (UIPageViewController *)overlayPageViewController {
    if (!_overlayPageViewController) {
        UIPageViewController *pageVC = [[UIPageViewController alloc]
                                        initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                        navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                        options:nil];
        [pageVC setViewControllers:@[[self.overlayViewControllers firstObject]]
                         direction:UIPageViewControllerNavigationDirectionForward
                          animated:NO
                        completion:nil];
        pageVC.view.frame = self.overlayContainerView.bounds;
        [self.overlayContainerView addSubview:pageVC.view];
        [self addChildViewController:pageVC];
        _overlayPageViewController = pageVC;
    }
    return _overlayPageViewController;
}

- (NSArray<UIViewController *> *)overlayViewControllers {
    if (!_overlayViewControllers) {
        _overlayViewControllers = [[[self.items mapObjectsUsingKey:@"textureImage"] mapObjectsUsingTransform:^UIImageView *(UIImage *image, NSUInteger index) {

            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            return imageView;
        }] mapObjectsUsingTransform:^UIViewController *(UIImageView *imageView, NSUInteger index) {

            UIViewController *viewController = [[UIViewController alloc] init];
            viewController.view.frame = self.overlayContainerView.bounds;
            CGFloat imageHeight = (self.overlayContainerView.bounds.size.width *
                                   imageView.image.size.height /
                                   imageView.image.size.width);
            CGFloat imageY = self.overlayContainerView.bounds.size.height - imageHeight;
            imageView.frame = CGRectMake(0, imageY, self.overlayContainerView.bounds.size.width, imageHeight);
            [viewController.view addSubview:imageView];

            return viewController;
        }];
    }
    return _overlayViewControllers;
}

//-------------------------------------------------------------------------------------------------
#pragma mark - Try-On Content Handling
//-------------------------------------------------------------------------------------------------
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController {

    NSInteger controllerIndex = [self.overlayViewControllers indexOfObject:viewController];
    if (controllerIndex == NSNotFound) {
        return nil;
    }

    NSInteger nextControllerIndex = controllerIndex + 1;
    if (nextControllerIndex >= [self.overlayViewControllers count]) {
        nextControllerIndex = 0;
    }
    return self.overlayViewControllers[nextControllerIndex];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSInteger controllerIndex = [self.overlayViewControllers indexOfObject:viewController];
    if (controllerIndex == NSNotFound) {
        return nil;
    }

    NSInteger nextControllerIndex = controllerIndex - 1;
    if (nextControllerIndex < 0) {
        nextControllerIndex = [self.overlayViewControllers count] - 1;
    }
    return self.overlayViewControllers[nextControllerIndex];
}

- (void)didAddToCartItem:(KFSmartCartItem *)item {
    [[KFSmartCartManager sharedManager] addItem:item];

    UIImageView *animationView = [[UIImageView alloc] initWithImage:item.textureImage];
    animationView.frame = self.overlayContainerView.frame;
    animationView.clipsToBounds = YES;
    animationView.contentMode = UIViewContentModeScaleAspectFill;

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view addSubview:animationView];
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
            animationView.transform = CGAffineTransformMakeScale(0.01, 0.01);
            animationView.center = self.smartCartButton.center;
        } completion:^(BOOL finished) {
            if (finished) {
                [animationView removeFromSuperview];
            }
        }];
    });

}
//-------------------------------------------------------------------------------------------------
#pragma mark - Swiping Handler
//-------------------------------------------------------------------------------------------------
- (IBAction)didSwipeLeftOnView:(UISwipeGestureRecognizer *)sender {
    if (!self.isFacePresent) return;
    
    UIViewController *nextViewController = [self pageViewController:self.overlayPageViewController
                                  viewControllerAfterViewController:[self.overlayPageViewController.viewControllers firstObject]];
    [self.overlayPageViewController setViewControllers:@[nextViewController]
                                             direction:UIPageViewControllerNavigationDirectionForward
                                              animated:YES
                                            completion:nil];
}

- (IBAction)didSwipeRightOnView:(UISwipeGestureRecognizer *)sender {
    if (!self.isFacePresent) return;
    
    UIViewController *nextViewController = [self pageViewController:self.overlayPageViewController
                                 viewControllerBeforeViewController:[self.overlayPageViewController.viewControllers firstObject]];
    [self.overlayPageViewController setViewControllers:@[nextViewController]
                                             direction:UIPageViewControllerNavigationDirectionReverse
                                              animated:YES
                                            completion:nil];
}

- (IBAction)didSwipeUpInView:(UISwipeGestureRecognizer *)sender {
    if (!self.isFacePresent) return;

    NSInteger currentItemIndex = [self.overlayViewControllers indexOfObject:
                                  [self.overlayPageViewController.viewControllers firstObject]];
    if (currentItemIndex == NSNotFound ||
        currentItemIndex < 0 ||
        currentItemIndex >= [self.items count]) {
        return;
    }

    [self didAddToCartItem:self.items[currentItemIndex]];
}

//-------------------------------------------------------------------------------------------------
#pragma mark - Setter Override
//-------------------------------------------------------------------------------------------------
- (void)setFacePresent:(BOOL)facePresent {
    if (_facePresent == facePresent) {
        return;
    }

    _facePresent = facePresent;

    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.overlayContainerView.alpha = facePresent ? 1 : 0;
        } completion:nil];
    });
}

//-------------------------------------------------------------------------------------------------
#pragma mark - App State Change
//-------------------------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startCapture];
    [self.overlayPageViewController didMoveToParentViewController:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopCapture];
}

@end
