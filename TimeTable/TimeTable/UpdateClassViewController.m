//
//  ClassDetailViewController.m
//  TimeTable
//
//  Created by SDT-B004 on 2015/05/18.
//  Copyright (c) 2015年 SDT-B004. All rights reserved.
//

#import "UpdateClassViewController.h"
#import "SelectClassViewController.h"
#import "FMDatabase.h"
#import "DatabaseOfCreateClassTable.h"
#import "TitleLabel.h"
#import "AlertView.h"

@interface UpdateClassViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UITextField *classNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *teacherNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *classroomNameTextField;
- (IBAction)registerButton:(id)sender;

@end

@implementation UpdateClassViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[_registerButton layer] setCornerRadius:10.0];
    [_registerButton setClipsToBounds:YES];
    
    _classNameTextField.delegate=self;
    _teacherNameTextField.delegate=self;
    _classroomNameTextField.delegate=self;
    
    _classNameTextField.text=_classNameString;
    _teacherNameTextField.text=_teacherNameString;
    _classroomNameTextField.text=_classroomNameString;
    
    // 背景をキリックしたら、キーボードを隠す
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeSoftKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];


    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    self.navigationItem.titleView=[TitleLabel createTitlelabel:@"授業変更"];
    
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

- (IBAction)registerButton:(id)sender {
    
    if ((_classNameTextField.text.length != 0) && (_teacherNameTextField.text.length != 0) && (_classroomNameTextField.text.length != 0)){
        
        if ((![_classNameTextField.text canBeConvertedToEncoding:NSASCIIStringEncoding]) && (![_classroomNameTextField.text canBeConvertedToEncoding:NSASCIIStringEncoding]) && (![_teacherNameTextField.text canBeConvertedToEncoding:NSASCIIStringEncoding])) {
            
            [DatabaseOfCreateClassTable updateCreateClassTable:_classNameTextField.text teacherNameTextField:_teacherNameTextField.text classroomNameTextField:_classroomNameTextField.text classNameString:_classNameString teacherNameString:_teacherNameString classroomNameString:_classroomNameString];

            [self.navigationController popViewControllerAnimated:YES];
            
            return;
        }
        [[AlertView createAlertView:@"授業名、教員名、教室名には日本語のみ入力してください。"] show];
        
        return;
    }
    [[AlertView createAlertView:@"授業名、教員名、教室名を3つとも入力しなさい。"] show];

}
@end
