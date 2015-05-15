//
//  SecondSectionCell.h
//  TimeTable
//
//  Created by SDT-B004 on 2015/05/07.
//  Copyright (c) 2015年 SDT-B004. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassTableCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *classLabel;
@property (weak, nonatomic) IBOutlet UILabel *classroomLabel;
@property (weak, nonatomic) IBOutlet UILabel *classTimeLabel;

@end
