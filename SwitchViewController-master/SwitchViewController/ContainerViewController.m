//
//  ContainerViewController.m
//  SwitchViewController
//
//  Created by JuLiaoyuan on 16/8/30.
//  Copyright © 2016年 Spark. All rights reserved.
//

#import "ContainerViewController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"


@interface ContainerViewController ()

@property (nonatomic, strong) UISegmentedControl *segment;

@property (nonatomic, strong) UIViewController *currentViewController;

@property (nonatomic) NSInteger segmentIndex;

@end

@implementation ContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configura];
    [self createView];
}

- (void)configura {
    self.segmentIndex = 0;
}

- (void)createView {
    self.navigationItem.titleView = self.segment;
    for (UIViewController *vc in [self makeChildViewController]) {
        [self addChildViewController:vc];
    }
    /* 这种方法添加 view 不会触发 first 的 viewwillappear 等一系列方法
    FirstViewController *first = [FirstViewController new];
    first.view.frame = self.view.bounds;
    [self.view addSubview:first.view];
     */
    
    self.currentViewController = self.childViewControllers[self.segmentIndex];
    self.currentViewController.view.frame = self.view.bounds;
    [self.view addSubview:self.currentViewController.view];
    [self.currentViewController didMoveToParentViewController:self];
}

- (UISegmentedControl *)segment {
    if (!_segment) {
        self.segment = [[UISegmentedControl alloc] initWithItems:@[@"第一页",@"第二页"]];
        [self.segment setSelectedSegmentIndex:self.segmentIndex];
        [self.segment addTarget:self action:@selector(switchVC:) forControlEvents:UIControlEventValueChanged];
    }
    return _segment;
}

- (NSArray <UIViewController *> *)makeChildViewController {
    FirstViewController *first = [FirstViewController new];
    SecondViewController *second = [SecondViewController new];
    return @[first,second];
}
- (void)switchVC:(UISegmentedControl *)sender {
    //分两种情况
    
    // case 0 当 container 是一个自定义的 ViewController 容器类或者是 NavigationController时，用下面的方法来触发 view 的 appearance callbacks
    
    [self.currentViewController willMoveToParentViewController:nil];
    [self.currentViewController.view removeFromSuperview];
    UIViewController *vc = self.childViewControllers[sender.selectedSegmentIndex];
    vc.view.frame = self.view.bounds;
    [self.view addSubview:vc.view];
    [vc didMoveToParentViewController:self];
    self.currentViewController = vc;
    
    // case 1 当 container 是一个 Scrollview 的时候，也就是说如果每次滚动到新的页面都需要触发 view 的 appearance callbacks 的话，用下面的方法
    /*
    [self.currentViewController beginAppearanceTransition:NO animated:YES];
    UIViewController *vc = self.childViewControllers[sender.selectedSegmentIndex];
    [vc beginAppearanceTransition:YES animated:YES];
    [self.currentViewController endAppearanceTransition];
    [vc endAppearanceTransition];
    self.currentViewController = vc;
    */
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
