

#import <Foundation/Foundation.h>

@interface NewsBean : NSObject<NSCoding,NSCopying>

@property NSInteger newsid;

@property(nonatomic,copy) NSString *title;

@property(nonatomic,copy) NSString *contentURL;

@property(nonatomic,copy) NSString *author;



@property NSDate *date;

@end
