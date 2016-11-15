//
//  KFPersonalitySurveyViewController.m
//  KingFashion
//
//  Created by Anh Vu Mai on 10/18/16.
//  Copyright © 2016 Mai Anh Vu. All rights reserved.
//

#import "KFPersonalitySurveyViewController.h"
#import "NSArray+FunctionalInterface.h"

@interface KFPersonalitySurveyViewController ()

@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSArray<UIViewController *> *viewControllers;

@end

@implementation KFPersonalitySurveyViewController

//-------------------------------------------------------------------------------------------------
#pragma mark - Constants
//-------------------------------------------------------------------------------------------------
static NSString *const SEGUE_ID_SHOW_RESULT = @"Show Personality Survey Result";

//-------------------------------------------------------------------------------------------------
#pragma mark - Initialization
//-------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self setUpPageViewController];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)setUpPageViewController {
    self.pageViewController = [[UIPageViewController alloc]
                               initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                               navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                               options:nil];
    [self.pageViewController setViewControllers:@[[self.viewControllers firstObject]]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:nil];
    self.pageViewController.view.frame = self.view.bounds;
    [self.view addSubview:self.pageViewController.view];

    // Activate the view controller
    [self addChildViewController:self.pageViewController];
    [self.pageViewController didMoveToParentViewController:self];
}

//-------------------------------------------------------------------------------------------------
#pragma mark - Transition
//-------------------------------------------------------------------------------------------------
- (IBAction)didTapView:(UITapGestureRecognizer *)sender {
    UIViewController *currentViewController = [self.pageViewController.viewControllers firstObject];
    if (!currentViewController) return;
    UIViewController *nextViewController = [self pageViewController:self.pageViewController
                                  viewControllerAfterViewController:currentViewController];

    // Transition to next view if there are no more next view controller
    if (!nextViewController) {
        [self goToSurveyResults];
    } else {
        [self.pageViewController setViewControllers:@[nextViewController]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:YES
                                         completion:nil];
    }
}

- (void)goToSurveyResults {
    [self performSegueWithIdentifier:SEGUE_ID_SHOW_RESULT sender:nil];
}

//-------------------------------------------------------------------------------------------------
#pragma mark - UIPageViewControllerDataSource
//-------------------------------------------------------------------------------------------------
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController {

    NSInteger viewControllerId = [self.viewControllers indexOfObject:viewController];
    if (viewControllerId >= [self.viewControllers count] - 1) return nil;
    return self.viewControllers[viewControllerId + 1];
}

//-------------------------------------------------------------------------------------------------
#pragma mark - Lazy Instantiation of Properties
//-------------------------------------------------------------------------------------------------
- (NSArray<UIViewController *> *)viewControllers {
    if (!_viewControllers) {
        _viewControllers = [NSArray mapRangeOfSize:4 usingTransform:^UIViewController *(NSUInteger index) {
            UIViewController *viewController = [[UIViewController alloc] init];
            viewController.view.frame = self.view.bounds;

            // Add onboarding image view
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:viewController.view.bounds];
            NSString *imageName = [NSString stringWithFormat:@"onboarding_screen_%02lu", index + 1];
            imageView.image = [UIImage imageNamed:imageName];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            [viewController.view addSubview:imageView];

            return viewController;
        }];
    }
    return _viewControllers;
}

@end
