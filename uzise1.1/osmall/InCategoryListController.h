

#import <UIKit/UIKit.h>
#import "BaseViewController.h"


typedef enum _E_PRODUCT_SORT_TYPE
{
    E_PRODUCT_SORT_TYPE_PRICE,
    E_PRODUCT_SORT_TYPE_SALE,
    E_PRODUCT_SORT_TYPE_SHELFT_TIME,
    E_PRODUCT_SORT_TYPE_NATURAL,
}E_PRODUCT_SORT_TYPE;


@interface InCategoryListController : BaseViewController<UITableViewDataSource,UITableViewDelegate>{

    NSArray *dataList;
    UITableView *table;
    BOOL price_sort;
    BOOL date_sort;
    NSMutableData *imageData;
    UIImageView *picView;
    NSURLConnection *picUrlConnection;
    UIImage *picImage;
    NSIndexPath *index_path;
    
    E_PRODUCT_SORT_TYPE mCurSortType;
}

@property(nonatomic,strong) UITableView *table;
@property E_PRODUCT_SORT_TYPE mCurSortType;
@property NSInteger typeID; 


@end
