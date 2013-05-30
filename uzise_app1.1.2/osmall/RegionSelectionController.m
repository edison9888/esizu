//
//  UserRegionSelectViewController.m
//  uzise
//
//  Created by edward on 12-11-1.
//  Copyright (c) 2012年 COSDocument.org. All rights reserved.
//

#import "RegionSelectionController.h"
#import "Constant.h"

#define BLACK_BAR_COMPONENTS				{ 0.23, 0.77, 0.92, 1.0, 0.07, 0.56, 0.70, 1.0 }
@implementation RegionSelectionController
@synthesize shop_dict,currentIndexPath,table,newaddress_dict;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame title:(NSString *)title dict:(NSMutableDictionary *)dict
{
	if ((self = [super initWithFrame:frame])) {
		
		CGFloat colors[8] = BLACK_BAR_COMPONENTS;
		[self.titleBar setColorComponents:colors];
        
		self.headerLabel.text = title;
		[self.headerLabel setFont:[UIFont fontWithName:@"AppleGothic" size:16.0]];
        self.headerLabel.backgroundColor = [UIColor colorWithHex:0x297CB7];
		
        self.margin =UIEdgeInsetsMake(30, 30, 30, 30);
        self.padding = UIEdgeInsetsMake(0, 0, 0, 0);
        
        shop_dict  =[NSMutableDictionary dictionaryWithDictionary:dict];
		////////////////////////////////////
		// RANDOMLY CUSTOMIZE IT
		////////////////////////////////////
		// Show the defaults mostly, but once in awhile show a completely random funky one
        /*	if (arc4random() % 4 == 0) {
         // Funky time.
         UADebugLog(@"Showing a randomized panel for modalPanel: %@", self);
         
         // Margin between edge of container frame and panel. Default = {20.0, 20.0, 20.0, 20.0}
         self.margin = UIEdgeInsetsMake(((arc4random() % 4) + 1) * 20.0f, ((arc4random() % 4) + 1) * 20.0f, ((arc4random() % 4) + 1) * 20.0f, ((arc4random() % 4) + 1) * 20.0f);
         
         // Margin between edge of panel and the content area. Default = {20.0, 20.0, 20.0, 20.0}
         self.padding = UIEdgeInsetsMake(((arc4random() % 4) + 1) * 20.0f, ((arc4random() % 4) + 1) * 20.0f, ((arc4random() % 4) + 1) * 20.0f, ((arc4random() % 4) + 1) * 20.0f);
         
         // Border color of the panel. Default = [UIColor whiteColor]
         self.borderColor = [UIColor colorWithRed:(arc4random() % 2) green:(arc4random() % 2) blue:(arc4random() % 2) alpha:1.0];
         
         // Border width of the panel. Default = 1.5f;
         self.borderWidth = ((arc4random() % 21)) * 0.5f;
         
         // Corner radius of the panel. Default = 4.0f
         self.cornerRadius = (arc4random() % 21);
         
         // Color of the panel itself. Default = [UIColor colorWithWhite:0.0 alpha:0.8]
         self.contentColor = [UIColor colorWithRed:(arc4random() % 2) green:(arc4random() % 2) blue:(arc4random() % 2) alpha:1.0];
         
         // Shows the bounce animation. Default = YES
         self.shouldBounce = (arc4random() % 2);
         
         // Shows the actionButton. Default title is nil, thus the button is hidden by default
         [self.actionButton setTitle:@"Foobar" forState:UIControlStateNormal];
         
         // Height of the title view. Default = 40.0f
         [self setTitleBarHeight:((arc4random() % 5) + 2) * 20.0f];
         
         // The background color gradient of the title
         CGFloat colors[8] = {
         (arc4random() % 2), (arc4random() % 2), (arc4random() % 2), 1,
         (arc4random() % 2), (arc4random() % 2), (arc4random() % 2), 1
         };
         [[self titleBar] setColorComponents:colors];
         
         // The gradient style (Linear, linear reversed, radial, radial reversed, center highlight). Default = UAGradientBackgroundStyleLinear
         [[self titleBar] setGradientStyle:(arc4random() % 5)];
         
         // The line mode of the gradient view (top, bottom, both, none). Top is a white line, bottom is a black line.
         [[self titleBar] setLineMode: pow(2, (arc4random() % 3))];
         
         // The noise layer opacity. Default = 0.4
         [[self titleBar] setNoiseOpacity:(((arc4random() % 10) + 1) * 0.1)];
         
         // The header label, a UILabel with the same frame as the titleBar
         [self headerLabel].font = [UIFont boldSystemFontOfSize:floor(self.titleBarHeight / 2.0)];
         }
         
         */
		//////////////////////////////////////
		// SETUP RANDOM CONTENT
		//////////////////////////////////////
		      
        NSString *province_path =  [IOSFactory getMainPath:@"province" oftype:@"plist"];
        
        NSString *city_path =  [IOSFactory getMainPath:@"city" oftype:@"plist"];
        
        NSString *district_path =  [IOSFactory getMainPath:@"district" oftype:@"plist"];
        
        
        province_dict  = [[NSDictionary alloc] initWithContentsOfFile:province_path];
        
        province_list  =[NSArray arrayWithArray:[province_dict objectForKey:@"province"]];
        
        
        province_rowindex  = [province_list indexOfObject:[shop_dict objectForKey:@"province"]];
        
        currentIndexPath =beforeIndexPath =[NSIndexPath indexPathForRow:province_rowindex inSection:0];
        

        city_dict  = [[NSDictionary alloc] initWithContentsOfFile:city_path];
        
        area_dict  = [[NSDictionary alloc] initWithContentsOfFile:district_path];
        
        newaddress_dict =[[NSMutableDictionary alloc] initWithDictionary:shop_dict];
        
		view  = [[UIView alloc] initWithFrame:CGRectZero];
        table =[[UITableView alloc] initWithFrame:CGRectZero ];
        
        nextButton  =[UIButton buttonWithType:UIButtonTypeCustom];
        [nextButton setBackgroundImage:[UIImage imageNamed:@"cartbutton" ] forState:UIControlStateNormal];
        [nextButton setTitle:NSLocalizedString(@"Next_Button", @"Next_Button") forState:UIControlStateNormal];
        [nextButton addTarget:self action:@selector(nextTableViewData:) forControlEvents:UIControlEventTouchUpInside];
        [nextButton.titleLabel setFont:[UIFont fontWithName:@"STHeitiJ-Light" size:13]];
        [nextButton.titleLabel setTextAlignment:UITextAlignmentCenter];
        [nextButton setFrame:CGRectMake(95, 10, 80, 30)];

        toolbar =[[PrettyToolbar alloc] initWithFrame:CGRectZero];
        [toolbar addSubview:nextButton];
        [table setDelegate:self];
        [table setDataSource:self];
        [view addSubview:table];
       // [view addSubview:toolbar];
		[self.contentView addSubview:view];
		[self.contentView addSubview:toolbar];
	}	
	return self;
}

-(void)nextTableViewData:(UIButton *)sender{
    
    NSInteger tag =sender.tag;
    
  
    if (tag==0) {
        
        [newaddress_dict setValue:[province_list objectAtIndex:currentIndexPath.row] forKey:@"province"];
        
        NSString *str  = [[[province_list objectAtIndex:currentIndexPath.row] allKeys] objectAtIndex:0];
        
        city_list = [[city_dict objectForKey:@"city"] objectForKey:str];
        
        city_rowindex =[city_list indexOfObject:[shop_dict objectForKey:@"city"]];
        
        if (city_rowindex==NSNotFound) {
            currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
             city_rowindex =0;
        }else{
            currentIndexPath = [NSIndexPath indexPathForRow:city_rowindex inSection:0];
        }
           
        sender.tag +=1;
        
        [table reloadData];
        [table scrollToRowAtIndexPath:currentIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
   //     [[table cellForRowAtIndexPath:currentIndexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];

        
        
    }
    if (tag==1) {
        [newaddress_dict setValue:[city_list objectAtIndex:currentIndexPath.row] forKey:@"city"];
        
        NSString *str  = [[[city_list objectAtIndex:currentIndexPath.row] allKeys] objectAtIndex:0];
        
        area_list = [[area_dict objectForKey:@"district"] objectForKey:str];
        
        area_rowindex =[city_list indexOfObject:[shop_dict objectForKey:@"area"]];
        
        if (area_rowindex==NSNotFound) {
            currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            area_rowindex =0;
        }else{
            currentIndexPath = [NSIndexPath indexPathForRow:area_rowindex inSection:0];
        }
        
        sender.tag +=1;
        
        [table reloadData];
        [table scrollToRowAtIndexPath:currentIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];

    }
    if (tag==2) {
        [newaddress_dict setValue:[area_list objectAtIndex:currentIndexPath.row] forKey:@"area"];
        [self hide];
    }
/* */   
    
   // 
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    
    if (nextButton.tag==0) {
       
        return [province_list count];
    }
    if (nextButton.tag==1) {
        
        return [city_list count];
    }
    if (nextButton.tag==2) {
        
        return [area_list count];
    }
    
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    
    if (cell==nil) {
        cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    
    for (UIView *v in cell.contentView.subviews) {
        [v removeFromSuperview];
    }
    if (nextButton.tag==0) {
        cell.textLabel.text = [[[province_list objectAtIndex:indexPath.row] allValues] objectAtIndex:0];
        if (province_rowindex ==indexPath.row) {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            currentIndexPath =beforeIndexPath= indexPath;
        
        }
      
    }
    if (nextButton.tag==1) {
        cell.textLabel.text = [[[city_list objectAtIndex:indexPath.row] allValues] objectAtIndex:0];
        if (city_rowindex ==indexPath.row) {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            currentIndexPath =beforeIndexPath= indexPath;
            
        }
        
    }
    if (nextButton.tag==2) {
        cell.textLabel.text = [[[area_list objectAtIndex:indexPath.row] allValues] objectAtIndex:0];
        if (area_rowindex ==indexPath.row) {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            currentIndexPath =beforeIndexPath= indexPath;
            
        }
        
    }
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
   
    currentIndexPath =indexPath;
    
//     [newaddress_dict setValue:[province_list objectAtIndex:currentIndexPath.row] forKey:@"province"];
    
    if (currentIndexPath.row!=beforeIndexPath.row) {
        
        UITableViewCell *currentCell = [tableView cellForRowAtIndexPath:currentIndexPath];
        currentCell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        UITableViewCell *beforeCell = [tableView cellForRowAtIndexPath:beforeIndexPath];
        beforeCell.accessoryType = UITableViewCellAccessoryNone;
        beforeIndexPath = currentIndexPath;
        
    }
}
/**/


- (void)layoutSubviews {
	[super layoutSubviews];
	
    [view setFrame:self.contentView.bounds];
    [table setFrame:CGRectMake(0, 0, view.bounds.size.width, self.contentView.bounds.size.height-50)];
    [toolbar setFrame:CGRectMake(0, self.contentView.bounds.size.height-50, view.bounds.size.width, 50)];
    //[nextButton setFrame:CGRectMake(toolbar.center.x, toolbar.center.y, 80, 30)];
     [table scrollToRowAtIndexPath:currentIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    UITableViewCell *cell = [table cellForRowAtIndexPath:currentIndexPath];
    
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
}
@end
