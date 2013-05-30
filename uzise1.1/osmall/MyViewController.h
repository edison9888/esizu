
#import <UIKit/UIKit.h>


#import "iCarousel.h"
#import "BaseViewController.h"

@class UserBean;

@interface MyViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,iCarouselDataSource,iCarouselDelegate>{

    UITableView *mTableView;
    
    UITableView *scroll_table;
    
    UIBarButtonItem *loginOut;
    
    iCarousel *carousel;
}


@end
