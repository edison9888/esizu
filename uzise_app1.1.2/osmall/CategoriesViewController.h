//
//  MoreCategoriesController.h
//  uzise
//
//  Created by Wen Shane on 13-5-20.
//  Copyright (c) 2013年 COSDocument.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CategoriesViewControllerDelegate <NSObject>

- (void) didSelectCategory:(NSString*)aCategory;

@end

@interface CategoriesViewController : UITableViewController
{
}

@property (weak) id<CategoriesViewControllerDelegate> mDelegate;

@end
