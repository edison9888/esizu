

#import "IOSFactory.h"

#import "UserBean.h"

@implementation IOSFactory

#define CHINESE_DATE @"yyyy-MM-dd"
#define CHINESE_DATE_ALL @"yyyy-MM-dd HH:mm:ss"

+(UIUserInterfaceIdiom)getDevice{
    return  [[UIDevice currentDevice]userInterfaceIdiom];
}

//获取iOS app里面的内容 既app Bundle 但是虚拟机可以读取真机只读不能写
+(NSString *)getIOSDocuments{
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    
    if ([paths count]>1) {
        return nil;
    }else {
        return [paths    objectAtIndex:0];
    }
    
}

+(NSString *)getMainPath:(NSString *)name oftype:(NSString *)type{
    return [[NSBundle mainBundle]pathForResource:name ofType:type];
}


+(NSArray *)sortByNumbers:(id)array isAsc:(BOOL)asc{
    
    
    if ([array isKindOfClass:[NSArray class]]) {
        //        sortedArrayUsingDescriptors:
        return  [array sortedArrayUsingComparator:^(id obj1 ,id obj2){
            
            NSNumber *objdata1 ;
            
            NSNumber *objdata2 ;
            
            if ([obj1 isKindOfClass:[NSString class]]) {
                objdata1 =[NSNumber numberWithInt:[obj1 doubleValue]];
            }
            if ([obj2 isKindOfClass:[NSString class]]) {
                objdata2 =[NSNumber numberWithInt:[obj2 doubleValue]];
            }
            
            return asc==YES?[objdata1 compare:objdata2]:[objdata2 compare:objdata1];
        }];
    }
    if ([array isKindOfClass:[NSDictionary class]]) {
        
        return  [array keysSortedByValueUsingComparator:^(id obj1 ,id obj2){
            
            NSNumber *objdata1 ;
            
            NSNumber *objdata2 ;
            
            if ([obj1 isKindOfClass:[NSString class]]) {
                objdata1 =[NSNumber numberWithInt:[obj1 doubleValue]];
            }
            if ([obj2 isKindOfClass:[NSString class]]) {
                objdata2 =[NSNumber numberWithInt:[obj2 doubleValue]];
            }
            
            return asc==YES?[objdata1 compare:objdata2]:[objdata2 compare:objdata1];
        }];
    }
    
    return nil;
}


+(NSArray *)sortObject:(NSArray *)array sortName:(NSString *)sortName isAsc:(BOOL)asc{
    //调用 NSSortDescriptor 进行排序
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:sortName ascending:asc];
    
    NSArray *temparr  = [NSArray arrayWithObjects:descriptor, nil];
    return [array sortedArrayUsingDescriptors:temparr];
}



+(Boolean)checkImageSuffix:(NSString *)imageName{
    NSString *lower_case_str = [imageName lowercaseString];
    NSArray *suffixes = [NSArray arrayWithObjects:@"jpg",@"png",@"gif",@"bmp",@"jpeg",@"ico",@"jpg", nil];
    
    for (NSString *suffix in suffixes) {
        if ([suffix rangeOfString:lower_case_str].location!=NSNotFound) {
            return YES;
            break;
        }
    }
    return NO;
    
}


+(NSArray *)sortNumber:(NSArray *)array isAsc:(BOOL)asc{
    return [array sortedArrayUsingComparator:^(id obj1, id obj2){
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
}


+(NSArray *)sortDictionaryValueByNumber:(NSDictionary *)dict isAsc:(BOOL)asc{
    
    return [dict keysSortedByValueUsingComparator:^(id obj1 ,id obj2){
        return asc==YES?[(NSString *)obj1 compare:(NSString *)obj2]:[(NSString *)obj2 compare:(NSString *)obj1];
    }];
}

+(int)getRandom:(int)from to:(int)to{
    return (int)(from + (arc4random() % (to - from + 1)));
}
//保证每次更换语言设置后再点击回去程序都可以获取最新的语言
+(NSString *)getLoaclLanguage{
    return  [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0];
}

+(NSLocale *)getLoacl:(NSString *)loaclName{
    NSLocale *locale = [NSLocale currentLocale];
    return [locale objectForKey:loaclName];
}

+(NSString *)getLoaclDisplayname:(NSString *)loaction{
    NSLocale *locale = [NSLocale currentLocale];
    
    return  [locale
             displayNameForKey:NSLocaleIdentifier
             value:loaction];
}


#define TIMEZONE(x) (3600*x)
#define CHINESE_TIMEZONE [NSTimeZone timeZoneForSecondsFromGMT:TIMEZONE(8)]



static NSCalendar *cal;


+(NSDate *)addAllDayFromDate:(NSDate *)date second:(NSInteger)second minute:(NSInteger)minute hour:(NSInteger)hour day:(NSInteger)day month:(NSInteger)month year:(NSInteger)year calIdentifier:(NSString *)calIdentifier outputTimeZone:(NSTimeZone *)outputTimeZone{
    
    if (date==nil) {
        return nil;
    }
    
    static NSDateComponents *dateComponents ;
    
    if (dateComponents==nil) {
        dateComponents=[[NSDateComponents alloc]init];
    }
    
    
    if (cal==nil) {
        
        cal = calIdentifier==nil?[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] :[[NSCalendar alloc] initWithCalendarIdentifier:calIdentifier];
        
    }else {
        
        NSString *identifier =[cal calendarIdentifier];
        //更改时区时候使用
        if (![identifier isEqualToString:calIdentifier]) {
            cal  =nil;
            cal=[[NSCalendar alloc] initWithCalendarIdentifier:calIdentifier];
        }
    }
    
    [dateComponents setSecond:second];
    [dateComponents setMinute:minute];
    [dateComponents setHour:hour];
    [dateComponents setDay:day];
    [dateComponents setMonth:month];
    [dateComponents setYear:year];
    [dateComponents setTimeZone:outputTimeZone];
    
    return [cal dateByAddingComponents:dateComponents toDate:date options:0];
}




+(NSDate *)addDayFromChineseDate:(NSDate *)date day:(NSInteger)day {
    
    
    return [self addAllDayFromDate:date second:0 minute:0 hour:0 day:day month:0 year:0 calIdentifier:NSGregorianCalendar outputTimeZone:CHINESE_TIMEZONE];
}

+ (UIColor *)UIColorFromRGB: (NSInteger)rgbValue {
    
    UIColor *rgbColor;
    
    rgbColor = [UIColor colorWithRed: ((float)((rgbValue & 0xFF0000) >> 16)) / 255.0
                               green: ((float)((rgbValue & 0xFF00) >> 8)) / 255.0
                                blue: ((float)(rgbValue & 0xFF)) / 255.0
                               alpha: 1.0];
    
    return rgbColor;
}

+(NSDate *)NSStringToNSDate:(NSString *)stringDate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return  [dateFormatter dateFromString:stringDate];
}

+(NSString *)NSDateToNSString:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return  [dateFormatter stringFromDate:[NSDate date]];
}



+ (UIColor *)UIColorFromRGB: (NSInteger)red green:(NSInteger)green blue:(NSInteger)blue {
    
    UIColor *rgbColor;
    
    rgbColor = [UIColor colorWithRed: red / 255.0
                               green:green / 255.0
                                blue:blue / 255.0
                               alpha: 1.0];
    
    return rgbColor;
}

+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
                                [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
                                UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
                                UIGraphicsEndImageContext();
                                
                                
                                return scaledImage;
}

+ (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    return reSizeImage;
}

+(NSDate *)changeSecondToNSDate:(double) dateSecond{
    
    return  [NSDate dateWithTimeIntervalSince1970:dateSecond/1000.0];
}


// 正则判断手机号码地址格式
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+(NSInteger)totalPageNumber:(NSInteger)totalSize pageSize:(NSInteger)pageSize{
    return totalSize % pageSize == 0 ? totalSize / pageSize : totalSize / pageSize + 1;
}


@end
