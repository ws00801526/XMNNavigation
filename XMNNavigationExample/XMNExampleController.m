//
//  XMNExampleController.m
//  XMNNavigationExample
//
//  Created by XMFraker on 16/11/24.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import "XMNExampleController.h"
#import "XMNNavigationController.h"

#import "XMNBubbleTransition.h"

@interface XMNExampleController () <UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UISwitch *removeSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *hideSwitch;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UITextField *indexTextFiled;

@property (strong, nonatomic) XMNBubbleTransition *bubbleTransition;


@end

@implementation XMNExampleController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [XMNExampleController randomColor];
    self.title = [NSString stringWithFormat:@"Exmaple %d",(int)[self.xmn_navigationController.xmn_viewControllers count]];
    
    NSLog(@"This is %d ExampleC \n  ExampleCs is :%@",(int)self.xmn_navigationController.xmn_viewControllers.count, self.xmn_navigationController.xmn_viewControllers);
    
    self.bubbleTransition = [[XMNBubbleTransition alloc] init];
//    self.xmn_navigationController.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.  
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    NSLog(@"%@ viewDidAppear",NSStringFromClass([self class]));

    self.xmn_navigationController.delegate = self;
}


- (IBAction)pushNextExample {
    
    
    XMNExampleController *exampleC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"XMNExampleController"];
    [self.navigationController pushViewController:exampleC animated:YES];
//    exampleC.xmn_prefersNavigationBarHidden = self.hideSwitch.on;
//    [self xmn_pushViewController:exampleC
//                          params:@{@"testKey":@"testValue",
//                                   @"testKey2":@"testValue2",
//                                   @"testKey3":@"testValue3"}
//            removeViewController:self.removeSwitch.on ? self : nil
//                 completionBlock:nil];
}

- (IBAction)popBack {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)popRoot {

    NSArray *popViewCs = [self.navigationController popToRootViewControllerAnimated:YES];
    NSLog(@"popViewCs :%@",popViewCs);
}

- (IBAction)popToViewCAtIndex {
    
    NSInteger index = [self.indexTextFiled.text integerValue];
    if (index < [self.xmn_navigationController xmn_viewControllers].count) {
        UIViewController *viewController = [self.xmn_navigationController xmn_viewControllers][index];
        NSArray *popViewCs =  [self.navigationController popToViewController:viewController animated:YES];
        NSLog(@"popViewCs :%@",popViewCs);
    }
}

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC {
    
    self.bubbleTransition.mode = operation == UINavigationControllerOperationPush ? XMNBubbleTransitionModePresent : XMNBubbleTransitionModePop;
    self.bubbleTransition.startPoint = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height);
    self.bubbleTransition.bubbleColor = [XMNExampleController randomColor];
    return self.bubbleTransition;
}

+ (UIColor *)randomColor{
    
    static BOOL seed = NO;
    if (!seed) {
        seed = YES;
        srandom((int)time(NULL));
    }
    CGFloat red = (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat green = (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat blue = (CGFloat)random()/(CGFloat)RAND_MAX;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];//alpha为1.0,颜色完全不透明
}
@end
