


#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"

#import "PrettyKit.h"

@interface HomeViewController : BaseTableViewController<UINavigationControllerDelegate>
{
    NSArray *dataList;
    
    NSMutableArray *muDataList;
    NSArray *newsList;
    
    NSMutableArray *mPosterAds;
    
    NSMutableArray *mMonthAds;
    
    NSMutableArray *mSeasonAds;
    
    NSMutableArray *news_list;
    
    PrettyNavigationBar *navigationBar;
    
}


@property(copy)NSString *textlabel;
@end