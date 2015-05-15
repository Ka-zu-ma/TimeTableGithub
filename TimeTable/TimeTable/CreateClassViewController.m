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
    
    /*UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapped:)];
    
    [self.view addGestureRecognizer:tapGesture];*/
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    //タイトル色変更
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.text=@"授業作成";
    [titleLabel sizeToFit];
    self.navigationItem.titleView=titleLabel;
    
    //バー背景色
    self.navigationController.navigationBar.tintColor=[UIColor blackColor];//バーアイテムカラー
    self.navigationController.navigationBar.barTintColor=[UIColor blueColor];//バー背景色

    // Do any additional setup after loading the view from its nib.
}

/*-(void)viewWillAppear:(BOOL)animated{
    
    if ((_classTextField.text=@"") || (_teacherTextField.text=@"") || (_classroomTextField.text=@"")) {
        _registerClassButton.enabled=NO;
        
    }else{
        _registerClassButton.enabled=YES;
        
    }

    
}*/
#pragma Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - IBAction

- (IBAction)registerClassButton:(id)sender {
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dbPathString=paths[0];
    FMDatabase *db=[FMDatabase databaseWithPath:[dbPathString stringByAppendingPathComponent:@"createclass.db"]];
    [db open];
    [db executeUpdate:@"INSERT INTO createclasstable (className, teacherName, classroomName) VALUES  (?, ?, ?);",_classTextField.text,_teacherTextField.text,_classroomTextField.text];
    
    NSLog(@"%@",[dbPathString stringByAppendingPathComponent:@"createclass.db"]);
    
    [db close];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - UITextField Delegate

/*-(void)textFieldDidEndEditing:(UITextField *)textField{
    if ((_classTextField.text=@"") || (_teacherTextField.text=@"") || (_classroomTextField.text=@"")) {
        _registerClassButton.enabled=NO;
        
    }else{
        _registerClassButton.enabled=YES;
        
    }
    
}*/

/*-(BOOL)textFieldShouldReturn:(UITextField *)textField{
 [self.view endEditing:YES];
 return NO;
 }*/



@end
