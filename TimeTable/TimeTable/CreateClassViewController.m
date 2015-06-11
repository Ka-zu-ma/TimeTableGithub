//
//  CreateClassViewController.m
//  TimeTable
//
//  Created by SDT-B004 on 2015/05/01.
//  Copyright (c) 2015年 SDT-B004. All rights reserved.
//

#import "CreateClassViewController.h"
#import "ClassTableCell.h"
#import "FMDatabase.h"
#import "DatabaseOfCreateClassTable.h"
#import "TitleLabel.h"
#import "AlertView.h"


@interface CreateClassViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *registerClassButton;
@property (weak, nonatomic) IBOutlet UITextField *classTextField;
@property (weak, nonatomic) IBOutlet UITextField *classroomTextField;
@property (weak, nonatomic) IBOutlet UITextField *teacherTextField;
- (IBAction)registerClassButton:(id)sender;

@end

@implementation CreateClassViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //授業削除ボタンの枠を丸くする
    [[_registerClassButton layer] setCornerRadius:10.0];
    [_registerClassButton setClipsToBounds:YES];
    
    _classroomTextField.delegate=self;
    _classTextField.delegate=self;
    _teacherTextField.delegate=self;
    
    // 背景をキリックしたら、キーボードを隠す
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeSoftKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    

    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    self.navigationItem.titleView=[TitleLabel createTitlelabel:@"授業作成"];
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// キーボードを隠す処理
- (void)closeSoftKeyboard {
    [self.view endEditing: YES];
}


#pragma mark - IBAction

- (IBAction)registerClassButton:(id)sender {
    
    if ((_classTextField.text.length != 0) && (_teacherTextField.text.length != 0) && (_classroomTextField.text.length != 0)){
        
        if ((![_classTextField.text canBeConvertedToEncoding:NSASCIIStringEncoding]) && (![_classroomTextField.text canBeConvertedToEncoding:NSASCIIStringEncoding]) && (![_teacherTextField.text canBeConvertedToEncoding:NSASCIIStringEncoding])) {
            
            [DatabaseOfCreateClassTable insertCreateClassTable:_classTextField.text teacherName:_teacherTextField.text classroomName:_classroomTextField.text];
            
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        [[AlertView createAlertView:@"授業名、教員名、教室名には日本語のみ入力してください。"] show];
        
        return;
    }
    [[AlertView createAlertView:@"授業名、教員名、教室名を3つとも入力しなさい。"] show];
}

@end
