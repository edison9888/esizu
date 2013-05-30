

#import <UIKit/UIKit.h>


@interface MoreViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    NSDictionary *dict;
    NSArray *moreList;
    UITableView *tableview;
}

@end
