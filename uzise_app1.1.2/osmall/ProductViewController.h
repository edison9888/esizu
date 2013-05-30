

#import <UIKit/UIKit.h>

#import "ProductBean.h"
#import "BaseTableViewController.h"

@interface ProductViewController : BaseTableViewController
{
    
    NSMutableArray *pic_list;
    UIButton *doneInKeyboardButton;
    UITextField *prodcut_quantity_field;
}

- (id) initWithProductName:(NSString*)aProductName;

@property(nonatomic,copy) ProductBean *product;

@property(nonatomic,strong) NSMutableArray *pic_list;

@property NSInteger product_id;

@property(nonatomic,copy) NSString *backTitle;

@property BOOL isViewPic;

@end
