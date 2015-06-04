//
//  TitleLabel.m
//  TimeTable
//
//  Created by SDT-B004 on 2015/06/03.
//  Copyright (c) 2015年 SDT-B004. All rights reserved.
//

#import "TitleLabel.h"

@implementation TitleLabel

+(UILabel *)createTitlelabel:titleLabelName{
    
    //タイトル作成
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectZero];//(0,0)で大きさ、長さが0
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.text=titleLabelName;
    [titleLabel sizeToFit];
    return titleLabel;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
