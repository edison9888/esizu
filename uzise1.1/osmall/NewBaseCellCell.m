
#import "NewBaseCellCell.h"
#define  scrollViewtWidth(x) x>0?x:[[UIScreen mainScreen] bounds].size.width
#define  scrollViewHeight(x) x>0?x:([[UIScreen mainScreen] bounds].size.height-20)

@interface NewBaseCellCell ()

-(void)inittimingScrollView;

-(void)timingScrollView;

-(void)pageChange:(UIPageControl *)sender;
@end

@implementation NewBaseCellCell
@synthesize isShowPageControl,isLoopScrollView,isTiming;
@synthesize scrollViewWidth,scrollViewHeight,pageControlPoint_Y,scrollViewContentX,scrollViewContentY,times,timer;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier isShowPageControl:(BOOL)showPage isLoopScrollView:(BOOL)loopScrollView  scrollCiewDataScoure:(NSArray *)arrayList ScrollViewCellHeight:(CGFloat)cellHeight scrollContentY:(CGFloat)y pageControlPointY:(CGFloat) pageControlPointY Timing:(CGFloat)second
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        isShowPageControl = showPage;
        
        isLoopScrollView=loopScrollView;
        
        list = [NSArray arrayWithArray: arrayList];
        
        scrollViewWidth = scrollViewtWidth(self.frame.size.width);
        
        scrollViewHeight =scrollViewHeight(cellHeight);
        
        scrollViewContentX =[list count]*scrollViewWidth;
        
        scrollViewContentY=y;
        
        mainScrollView = [[UIScrollView alloc]init];
        
        //设置是否允许到处拖放
        mainScrollView.pagingEnabled = YES;
        
        //设置scrollView 滑动长度
        
        if (isLoopScrollView) {
            scrollViewContentX =([list count]+1)*scrollViewWidth;
        }
        times = second;
        if (times>0) {
            isTiming =YES;
        }else {
            isTiming=NO;
        }
        
        mainScrollView.contentSize = CGSizeMake(scrollViewContentX, scrollViewContentY);
        
        mainScrollView.showsHorizontalScrollIndicator = NO;
        
        mainScrollView.showsVerticalScrollIndicator = NO;
        
        mainScrollView.scrollsToTop = NO;
        
        mainScrollView.delegate = self;
        
        mainScrollView.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, scrollViewWidth, scrollViewHeight);
        
        [self.contentView addSubview:mainScrollView];
      
        [self lazyLoadScrollViewWithPage:0];
        [self lazyLoadScrollViewWithPage:1];
        
        pageControlPoint_Y =pageControlPointY;

        if ([self showPageControl]) {
          
            pageControl = [[DDPageControl alloc] init] ;
            [pageControl setCenter: CGPointMake(self.center.x, pageControlPoint_Y)] ;
            [pageControl setNumberOfPages: [list count]] ;
            [pageControl setCurrentPage: 0] ;
            [pageControl setDefersCurrentPageDisplay: YES] ;
            [pageControl setType: DDPageControlTypeOnFullOffFull] ;
            [pageControl setOnColor: [UIColor redColor]] ;//colorWithWhite: 0.9f alpha: 1.0f
            [pageControl setOffColor: [UIColor colorWithWhite: 0.7f alpha: .3f]] ;
            [pageControl setIndicatorDiameter: 6.0f] ;
            [pageControl setIndicatorSpace: 8.0f] ;
    
             [self.contentView addSubview:pageControl];
            [pageControl addTarget:self action:@selector(pageChange:) forControlEvents:UIControlEventValueChanged];
           
        }
        
        if (isTiming) {
            [self performSelector:@selector(inittimingScrollView) withObject:self afterDelay:2.0f];
        }
       
    }
    return self;
}

-(void)timestop{
    [timer invalidate];
}

-(void)inittimingScrollView{
    if (timer!=nil) {
        
        [timer invalidate];
    }else {
        timer =[NSTimer scheduledTimerWithTimeInterval:times target:self selector:@selector(timingScrollView) userInfo:nil repeats:YES];
    }
    
}

-(void)timingScrollView{
    
    int offestX = mainScrollView.contentOffset.x;  
    int page = offestX/scrollViewWidth +1;
   
    int     max_offest =([list count]-1)*scrollViewWidth;
    
    if(offestX >=max_offest){  
        [mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];  
        [pageControl setCurrentPage:0];
         [pageControl updateCurrentPageDisplay];
        
    }else{  
        [mainScrollView setContentOffset:CGPointMake(offestX+scrollViewWidth, 0) animated:YES]; 
        [pageControl setCurrentPage:page];
        [pageControl updateCurrentPageDisplay];
        
    }  
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}



- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
	
    int offest = aScrollView.contentOffset.x;
    
    int page = floor((offest - scrollViewWidth / 2) / scrollViewWidth) + 1;
    
    [self lazyLoadScrollViewWithPage:page-1];
    
    [self lazyLoadScrollViewWithPage:page];
    
    [self lazyLoadScrollViewWithPage:page+1];
    
   
    if (isLoopScrollView) {
        if(offest<0){
            [aScrollView setContentOffset:CGPointMake(scrollViewWidth*[list count], 0)];
            if(isShowPageControl){
                [pageControl updateCurrentPageDisplay];
            }
        }
        if(offest>scrollViewWidth*[list count]){
            [aScrollView setContentOffset:CGPointMake(0, 0)];
        }
    }
    
    if(isShowPageControl){
        [pageControl updateCurrentPageDisplay];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)aScrollView
{
	// if we are animating (triggered by clicking on the page control), we update the page control
	[pageControl updateCurrentPageDisplay] ;
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int page = scrollView.contentOffset.x/scrollViewWidth;
      
    if(isShowPageControl){
        
        [pageControl setCurrentPage:page];
      
        [pageControl updateCurrentPageDisplay];
    }
    
    if (isLoopScrollView) {
        if(page==[list count]){
            [scrollView setContentOffset:CGPointMake(0, 0)];
            if(isShowPageControl){
                [pageControl setCurrentPage:0];
                [pageControl setFrame:CGRectMake(0, pageControlPoint_Y, scrollViewWidth, 40)];
            }
        }   
    }

}


- (void)lazyLoadScrollViewWithPage:(int)page
{
    if (page<0)     
        return;
    if (!list
        || list.count <= 0)
        return;
    if (page>=[list count]&&!isLoopScrollView) 
        return;
    
    CGFloat frameX = page*scrollViewWidth;
    
    if (isLoopScrollView&&page>=[list count]) {
        page =0;
        frameX = [list count]*scrollViewWidth;
    }
    
    UIView *view = [list objectAtIndex:page];
    
    if (view !=nil)
    {
        view.frame=CGRectMake(frameX, scrollViewContentY, scrollViewWidth, scrollViewHeight);
      
        if(view.superview==nil){
            [mainScrollView addSubview:view]; 
        }
    }
    
    
}

-(void)pageChange:(UIPageControl *)sender{
    int current =[sender currentPage];
    [mainScrollView setContentOffset:CGPointMake(scrollViewWidth*current, 0) animated:YES]; 
    
}



@end
