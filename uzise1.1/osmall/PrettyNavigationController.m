//
//  PrettyNavigationController.m
//  uzise
//
//  Created by Wen Shane on 13-4-24.
//  Copyright (c) 2013年 COSDocument.org. All rights reserved.
//

#import "PrettyNavigationController.h"

@interface PrettyNavigationController ()

@end

@implementation PrettyNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self)
    {
        //replace navigation bar with pretty navigation bar
        [self setValue:[[PrettyNavigationBar alloc] init] forKeyPath:@"navigationBar"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
