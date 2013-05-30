//
//  TaggedImageView.h
//  uzise
//
//  Created by Wen Shane on 13-5-9.
//  Copyright (c) 2013年 COSDocument.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaggedImageView : UIImageView
{
    id mTag;
}

@property (nonatomic, strong) id mTag;

@end
