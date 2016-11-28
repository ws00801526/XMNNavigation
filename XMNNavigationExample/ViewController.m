//
//  ViewController.m
//  XMNNavigationExample
//
//  Created by XMFraker on 16/11/23.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import "ViewController.h"

#import "XMNNavigationBar.h"
#import "XMNNavigationController.h"

//#import "UINavigationController+XMNFullScreenPop.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.title = @"Test Root VC";
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    NSLog(@"%@ viewDidAppear",NSStringFromClass([self class]));
}


- (IBAction)viewBack {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (Class)xmn_navigationBarClass {
    
    return [XMNNavigationBar class];
}
@end
