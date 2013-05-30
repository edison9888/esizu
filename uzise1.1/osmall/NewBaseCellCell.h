

#import <UIKit/UIKit.h>

#import "DDPageControl.h"

@interface NewBaseCellCell : UITableViewCell<UIScrollViewDelegate>{
@private
    
    BOOL isShowPageControl;
    
    BOOL isLoopScrollView;
    
    UIScrollView *mainScrollView;
    
    CGFloat scrollViewWidth;
    
    CGFloat scrollViewHeight;
    
    CGFloat scrollViewContentX;
    
    CGFloat scrollViewContentY;
    
    DDPageControl *pageControl;
  
    CGFloat pageControlPoint_Y;
    
    NSArray *list;

    BOOL isTiming;

    CGFloat times;
    
    NSTimer *timer;
}
@property(nonatomic,getter = showPageControl,setter = setShowPageControl:) BOOL isShowPageControl;

@property(nonatomic,getter = loopScrollView,setter = setLoopScrollView:) BOOL isLoopScrollView;

@property(nonatomic,getter = timing,setter = setTiming:) BOOL isTiming;

@property CGFloat times;

@property CGFloat scrollViewWidth;

@property CGFloat scrollViewHeight;

@property CGFloat scrollViewContentX;

@property CGFloat scrollViewContentY;

@property CGFloat pageControlPoint_Y;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier isShowPageControl:(BOOL)showPage isLoopScrollView:(BOOL)loopScrollView  scrollCiewDataScoure:(NSArray *)arrayList ScrollViewCellHeight:(CGFloat)cellHeight scrollContentY:(CGFloat)y pageControlPointY:(CGFloat) pageControlPointY Timing:(CGFloat)second;

@property(nonatomic,strong) NSTimer *timer;


@end
