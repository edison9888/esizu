

#import <Foundation/Foundation.h>

@interface UserBean : NSObject<NSCopying,NSCoding>

@property NSInteger userid;

@property(nonatomic,copy)NSString *address;

@property(nonatomic,copy)NSString *levelName;

@property(nonatomic,copy)NSString *mobile;   

@property(nonatomic,copy)NSString *telphone;   

@property(nonatomic,copy)NSString *userName;  

@property(nonatomic,copy)NSString *realName; 

@property(nonatomic,copy)NSString *email;

@property NSInteger sex;

@property NSInteger points;

@property(nonatomic,copy)NSString *password;

@property(nonatomic,copy)NSString *appkey;

@property BOOL isLogin;

@end
