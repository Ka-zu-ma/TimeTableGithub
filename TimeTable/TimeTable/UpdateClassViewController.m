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
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    //タイトル色変更
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.text=@"授業変更";
    [titleLabel sizeToFit];
    self.navigationItem.titleView=titleLabel;
    
    
    self.navigationController.navigationBar.tintColor=[UIColor blackColor];//バーアイテムカラー
    self.navigationController.navigationBar.barTintColor=[UIColor blueColor];//バー背景色
   
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - IBAction

- (IBAction)registerButton:(id)sender {
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dbPathString=paths[0];
    FMDatabase *db=[FMDatabase databaseWithPath:[dbPathString stringByAppendingPathComponent:@"createclass.db"]];
    [db open];
    [db executeUpdate:@"UPDATE createclasstable SET className = ?, teacherName = ?, classroomName = ? WHERE className = ? AND teacherName = ? AND classroomName = ?;",_classNameTextField.text,_teacherNameTextField.text,_classroomNameTextField.text,_classNameString,_teacherNameString,_classroomNameString];
    
    [db close];
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
