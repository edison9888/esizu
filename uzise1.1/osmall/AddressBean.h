

#import <Foundation/Foundation.h>

@interface AddressBean : NSObject<NSCopying,NSCoding>

@property NSInteger userid;

@property NSInteger addressid;

@property(nonatomic,copy) NSString *province;

@property(nonatomic,copy) NSString *city;

@property(nonatomic,copy) NSString *district;

@property(nonatomic,copy) NSString *road;

@property(nonatomic,copy) NSString *code;


@end
