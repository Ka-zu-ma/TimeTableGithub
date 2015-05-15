//
//  AttendanceRecordTableViewCell.m
//  TimeTable
//
//  Created by SDT-B004 on 2015/05/12.
//  Copyright (c) 2015年 SDT-B004. All rights reserved.
//

#import "CountUpCell.h"

@implementation CountUpCell

- (void)awakeFromNib {
    //出席ボタン
    //枠線色
    [[_attendanceButton layer] setBorderColor:[[UIColor redColor]CGColor]];
    //枠線太さ
    [[_attendanceButton layer] setBorderWidth:1.0];
    //枠線角丸
    [[_attendanceButton layer] setCornerRadius:10.0];
    [_attendanceButton setClipsToBounds:YES];
    
    [[_absenceButton layer] setBorderColor:[[UIColor blueColor]CGColor]];
    
    [[_absenceButton layer] setBorderWidth:1.0];
    
    [[_absenceButton layer] setCornerRadius:10.0];
    [_absenceButton setClipsToBounds:YES];
    
    [[_lateButton layer] setBorderColor:[[UIColor greenColor]CGColor]];
    
    [[_lateButton layer] setBorderWidth:1.0];
    
    [[_lateButton layer] setCornerRadius:10.0];
    [_lateButton setClipsToBounds:YES];
    
    
    
    

    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)attendanceButton:(id)sender {
    int tapCount1=_attendanceButton.titleLabel.text.intValue;
    int tapCount2;
    tapCount2=tapCount1+1;
    _attendanceButton.titleLabel.text=[NSString stringWithFormat:@"%d",tapCount2];
    
}

- (IBAction)absenceButton:(id)sender {
    
    int tapCount1=_absenceButton.titleLabel.text.intValue;
    int tapCount2;
    tapCount2=tapCount1+1;
    _absenceButton.titleLabel.text=[NSString stringWithFormat:@"%d",tapCount2];
}

- (IBAction)lateButton:(id)sender {
    
    int tapCount1=_lateButton.titleLabel.text.intValue;
    int tapCount2;
    tapCount2=tapCount1+1;
    _lateButton.titleLabel.text=[NSString stringWithFormat:@"%d",tapCount2];
}
@end
