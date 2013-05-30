

#import "AppDelegate.h"

#import "IOSFactory.h"

#import "CategoryViewController.h"

#import "MyViewController.h"

#import "CartViewController.h"

#import "MoreViewController.h"

#import "LoginViewController.h"

#import "UserBean.h"

#import "ProductBean.h"

#import "NewsBean.h"

#import "HomeViewController.h"

#import "Constant.h"

#import "UserBean.h"

#import "ASIDownloadCache.h"
#import "ASIHTTPRequest.h"
#import "PrettyNavigationController.h"
#import "CartManager.h"
#import "Global.h"
#import "UserManager.h"
#import "MobClick.h"
#import "PPRevealSideViewController.h"
#import "AlixPay.h"
#import "AlixPayResult.h"
#import "DataVerifier.h"


@interface AppDelegate()<PPRevealSideViewControllerDelegate>

@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;
@synthesize homeNavigationController=_homeNavigationController;
@synthesize categoryNavigationController=_categoryNavigationController;
@synthesize cartNavigationController=_cartNavigationController;
@synthesize myNavigationController=_myNavigationController;
@synthesize moreNavigationController=_moreNavigationController;
@synthesize loginNaVigationController=_loginNaVigationController;

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


-(void)createLoaclPlistData{
    //获取沙箱路径
    NSString *sandBox_path = [IOSFactory getIOSDocuments];
    //检查cache目录是否存在
    NSString *cache_directory = [sandBox_path stringByAppendingFormat:@"/cache" ];
    //文件管理
    NSFileManager *fileManager =  [NSFileManager defaultManager];
    //检测是否存在该目录
    if (![fileManager fileExistsAtPath:cache_directory ]) {
        [fileManager createDirectoryAtPath:cache_directory withIntermediateDirectories:YES attributes:nil error:NULL];
      
    }
    NSString *plist_path =[cache_directory stringByAppendingFormat:Path_Plist];
    if (![fileManager fileExistsAtPath:plist_path ]) {
        
   
        
        NSMutableDictionary *dict =[[NSMutableDictionary alloc]initWithCapacity:5];
         
        
       //创建基础数据
        
        [fileManager createFileAtPath:plist_path contents:[NSDictionary dictionaryWithDictionary:dict] attributes:nil];
        // }
    }else {
        //每次从线上获取最新的数据
    }     

}



-(NSArray*)buildTabbarChildren
{

    HomeViewController* sHomeController = [[HomeViewController alloc] init];
    PrettyNavigationController* sNavControllerOfHome = [[PrettyNavigationController alloc] initWithRootViewController:sHomeController];
    sNavControllerOfHome.delegate = sHomeController;
    self.homeNavigationController = sNavControllerOfHome;
    [self.homeNavigationController.tabBarItem setImage:[UIImage imageNamed:@"53-house"]];
    [self.homeNavigationController.tabBarItem setTitle:NSLocalizedString(@"Home", nil)];
    
    
    CategoryViewController* sCategoryController = [[CategoryViewController alloc] init];
    PrettyNavigationController* sNavControllerOfCatetory = [[PrettyNavigationController alloc] initWithRootViewController: sCategoryController];
    [sCategoryController setTitle:NSLocalizedString(@"Category", nil)];
    self.categoryNavigationController = sNavControllerOfCatetory;
    UITabBarItem* sTabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Category", nil) image:[UIImage imageNamed:@"259-list"] tag:0];
    self.categoryNavigationController.tabBarItem = sTabBarItem;    
    
    CartViewController* sCartController = [[CartViewController alloc] init];
    PrettyNavigationController* sNavCartController = [[PrettyNavigationController alloc] initWithRootViewController: sCartController];
    self.cartNavigationController = sNavCartController;
    [sCartController setTitle:NSLocalizedString(@"Cart", @"cart")];
    [self.cartNavigationController setTitle:NSLocalizedString(@"Cart", @"cartTabBar")];
    [self.cartNavigationController.tabBarItem setImage:[UIImage imageNamed:@"80-shopping-cart"]];

    MyViewController* sMyController = [[MyViewController alloc] init];
    PrettyNavigationController* sNavMyController = [[PrettyNavigationController alloc] initWithRootViewController: sMyController];
    self.myNavigationController = sNavMyController;
    [sMyController setTitle:NSLocalizedString(@"My", @"myTabBar")];
    [self.myNavigationController setTitle:NSLocalizedString(@"My", @"myTabBar")];
    [self.myNavigationController.tabBarItem setImage:[UIImage imageNamed:@"123-id-card"]];
    
    MoreViewController* sMoreController = [[MoreViewController alloc] init];
    PrettyNavigationController* sNavMoreController = [[PrettyNavigationController alloc] initWithRootViewController: sMoreController];
    self.moreNavigationController = sNavMoreController;
    [sMoreController setTitle:NSLocalizedString(@"More", @"More")];
    [self.moreNavigationController setTitle:NSLocalizedString(@"More", @"moreTabar")];
    UITabBarItem *tar = [[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemMore tag:4];
    [self.moreNavigationController setTabBarItem:tar];

    NSArray* sViewControllers = [NSArray arrayWithObjects:self.homeNavigationController,self.categoryNavigationController,self.cartNavigationController,self.myNavigationController,self.moreNavigationController,nil];
    
    return sViewControllers;
//    UINib *more_nib = [UINib nibWithNibName:@"MoreNavigation" bundle:nil];
//    self.moreNavigationController = [[more_nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
//    
//    [self.moreNavigationController setTitle:NSLocalizedString(@"More", @"moreTabar")];
//    
//    
//    UITabBarItem *tar = [[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemMore tag:4];
//    [self.moreNavigationController setTabBarItem:tar];
    //[self.moreNavigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg01"] forBarMetrics:UIBarMetricsDefault];
}

-(void) badgeCartQuantityIfAny
{
    [[CartManager shared] pushNotification];
}

- (void) cartChanged
{
    NSInteger sTotalProductsInCart = [[CartManager shared] getCartProductsCount];
    UITabBarItem* sTabBarItem = [[[self.tabBarController tabBar] items] objectAtIndex:2];
    if (sTotalProductsInCart > 0)
    {
        [sTabBarItem setBadgeValue:[NSString stringWithFormat:@"%d",sTotalProductsInCart]];
    }
    else
    {
        [sTabBarItem setBadgeValue:nil];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //open cache
//    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    [[ASIDownloadCache sharedCache] setShouldRespectCacheControlHeaders:NO];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
        [[UserManager shared] startNewSession];
        [self createLoaclPlistData];
    });
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = [self buildTabbarChildren];
    [self.tabBarController setDelegate:self];
    self.tabBarController.tabBar.tintColor = MAIN_COLOR;
    
    PPRevealSideViewController* sRootViewController = [[PPRevealSideViewController alloc] initWithRootViewController:self.tabBarController];
    sRootViewController.delegate = self;
    
    self.window.rootViewController = sRootViewController;
    [self.window makeKeyAndVisible];

    [NSThread sleepForTimeInterval:1];

    [[UITabBarItem appearance] setTitleTextAttributes:@{ UITextAttributeTextColor : [UIColor whiteColor] } forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cartChanged) name:NOTIFICATION_CART_CHANGE object:nil];
    
    [self badgeCartQuantityIfAny];

    //
    [MobClick startWithAppkey:KEY_UMENG];
    [MobClick startWithAppkey:KEY_UMENG reportPolicy:BATCH channelId:CHANNELID];
    
    
    [self checkUpdateAutomatically];
    
      return YES;
}

- (void) checkUpdateAutomatically
{
    [MobClick checkUpdate:NSLocalizedString(@"New Version Found", nil) cancelButtonTitle:NSLocalizedString(@"Skip", nil) otherButtonTitles:NSLocalizedString(@"Update now", nil)];
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [self parseURL:url application:application];
    return YES;
}

- (void)parseURL:(NSURL *)url application:(UIApplication *)application {
	AlixPay *alixpay = [AlixPay shared];
	AlixPayResult *result = [alixpay handleOpenURL:url];
	if (result) {
		//是否支付成功
		if (9000 == result.statusCode)
        {
			/*
			 *用公钥验证签名
			 */
			id<DataVerifier> verifier = CreateRSADataVerifier([[NSBundle mainBundle] objectForInfoDictionaryKey:@"RSA public key"]);
			if ([verifier verifyString:result.resultString withSign:result.signString])
            {
				UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
																	 message:result.statusMessage
																	delegate:nil
														   cancelButtonTitle:@"确定"
														   otherButtonTitles:nil];
				[alertView show];
				[alertView release];
			}//验签错误
			else {
				UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
																	 message:@"签名错误"
																	delegate:nil
														   cancelButtonTitle:@"确定"
														   otherButtonTitles:nil];
				[alertView show];
				[alertView release];
			}
		}
		//如果支付失败,可以通过result.statusCode查询错误码
		else
        {
			UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
																 message:NSLocalizedString(@"Pay failed, please view your unpaied orders and try again", nil)
																delegate:nil
													   cancelButtonTitle:@"确定"
													   otherButtonTitles:nil];
			[alertView show];
			[alertView release];
		}
		
	}
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"uzise" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CoreDataSample.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


#pragma mark - PPRevealSideViewControllerDelegate
- (void)pprevealSideViewController:(PPRevealSideViewController *)controller didPushController:(UIViewController *)pushedController
{
    self.tabBarController.tabBar.userInteractionEnabled = NO;
}

- (void)pprevealSideViewController:(PPRevealSideViewController *)controller didPopToController:(UIViewController *)centerController
{
    self.tabBarController.tabBar.userInteractionEnabled = YES;
}



@end
