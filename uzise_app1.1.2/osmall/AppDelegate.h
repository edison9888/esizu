

#import <UIKit/UIKit.h>

#import "UserBean.h"
#import "PPRevealSideViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabBarController;

@property(strong,nonatomic)UINavigationController *homeNavigationController;

@property(strong,nonatomic)UINavigationController *categoryNavigationController;

@property(strong,nonatomic)UINavigationController *cartNavigationController;

@property(strong,nonatomic)UINavigationController *myNavigationController;

@property(strong,nonatomic)UINavigationController *moreNavigationController;

@property(strong,nonatomic)UINavigationController *loginNaVigationController;

//core data methods
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
