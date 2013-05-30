

#import <Foundation/Foundation.h>
#import "UserBean.h"
typedef BOOL (^MyBlockType)(float, float);
@interface IOSFactory : NSObject

/*
 获取当前手机类型
 */
+(UIUserInterfaceIdiom)getDevice;
/*
 获取IOS文档目录
 */
+(NSString *)getIOSDocuments;
/*
 获取IOS安装目录下面的文件
 */
+(NSString *)getMainPath:(NSString *)name oftype:(NSString *)type;
/*
 数组排序
 */
+(NSArray *)sortByNumbers:(id)array isAsc:(BOOL)asc;
/*
 字典排序
 */
+(NSArray *)sortDictionaryValueByNumber:(NSDictionary *)dict isAsc:(BOOL)asc;

+(NSArray *)sortNumber:(NSArray *)array isAsc:(BOOL)asc;

+(NSArray *)sortObject:(NSArray *)array sortName:(NSString *)sortName isAsc:(BOOL)asc;


+(Boolean)checkImageSuffix:(NSString *)imageName;


+(int)getRandom:(int)from to:(int)to;


+(NSString *)getLoaclLanguage;

+(NSLocale *)getLoacl:(NSString *)loaclName;

+(NSString *)getLoaclDisplayname:(NSString *)loaction;

//添加时间
+(NSDate *)addAllDayFromDate:(NSDate *)date second:(NSInteger)second minute:(NSInteger)minute hour:(NSInteger)hour day:(NSInteger)day month:(NSInteger)month year:(NSInteger)year calIdentifier:(NSString *)calIdentifier outputTimeZone:(NSTimeZone *)outputTimeZone;



+(NSDate *)addDayFromChineseDate:(NSDate *)date day:(NSInteger)day ;

+ (UIColor *)UIColorFromRGB: (NSInteger)rgbValue;

+(NSDate *)NSStringToNSDate:(NSString *)stringDate;

+ (UIColor *)UIColorFromRGB: (NSInteger)red green:(NSInteger)green blue:(NSInteger)blue;

+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;

+ (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize;

+(NSString *)NSDateToNSString:(NSDate *)date;

+(NSDate *)changeSecondToNSDate:(double) dateSecond;

+ (BOOL)isMobileNumber:(NSString *)mobileNum;

+(NSInteger)totalPageNumber:(NSInteger)totalSize pageSize:(NSInteger)pageSize;


@end
