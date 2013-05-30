

#import <Foundation/Foundation.h>

@interface ProductBean : NSObject<NSCoding,NSCopying>

@property NSInteger productId;

@property(nonatomic,copy)NSString *productName;

@property(nonatomic,copy)NSString *productTypeName;

@property double price;

@property double retallPrice;

@property double shopPrice;

@property NSInteger quantity;

@property NSDate *datetime;

@property(nonatomic,copy) NSString *productNO;

@property NSInteger productTypeId;

@property NSInteger shopcount;

@property NSInteger sellCount;

@property(nonatomic,copy) NSString *introduce;

@property NSInteger comments;

@property(nonatomic,copy) NSString *product_url;

//@property(nonatomic,strong) NSMutableArray *product_url_list;

//@property(nonatomic,strong) UIImageView *product_url_imageview;

@end
