//
//  Title.h
//  TimeTable
//
//  Created by SDT-B004 on 2015/06/03.
//  Copyright (c) 2015年 SDT-B004. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UILabel;
@class CGRect;
@interface Title : NSObject

@property (weak,nonatomic) UILabel *titleLabel;
@property CGRect *CGRectZero;
//@property UIColor *
-(void)createTitle:(NSString *)titleLabelName;
@end
