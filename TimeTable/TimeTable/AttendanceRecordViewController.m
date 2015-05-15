//
//  AttendanceRecordViewController.m
//  TimeTable
//
//  Created by SDT-B004 on 2015/05/01.
//  Copyright (c) 2015年 SDT-B004. All rights reserved.
//

#import "AttendanceRecordViewController.h"
#import "CountUpCell.h"
#import "DateCell.h"
#import "FMDatabase.h"

@interface AttendanceRecordViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *deleteClassButton;
@property (strong,nonatomic) NSMutableArray *dates;
- (IBAction)deleteClassButton:(id)sender;
@end

@implementation AttendanceRecordViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView.delegate=self;
    _tableView.dataSource=self;
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    //タイトル色変更
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectZero];//(0,0)で大きさ、長さが0
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.text=@"出席状況";
    [titleLabel sizeToFit];
    self.navigationItem.titleView=titleLabel;
    
    //バー背景色
    self.navigationController.navigationBar.tintColor=[UIColor blackColor];//バーアイテムカラー
    self.navigationController.navigationBar.barTintColor=[UIColor blueColor];//バー背景色
    
    //授業削除ボタンの枠を丸くする
    [[_deleteClassButton layer] setCornerRadius:10.0];
    [_deleteClassButton setClipsToBounds:YES];
    
    //nibファイル登録
    UINib *nib1=[UINib nibWithNibName:@"CountUpCell" bundle:nil];
    [self.tableView registerNib:nib1 forCellReuseIdentifier:@"CountUpCell"];
    
    UINib *nib2=[UINib nibWithNibName:@"DateCell" bundle:nil];
    [self.tableView registerNib:nib2 forCellReuseIdentifier:@"DateCell"];
    
    
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    
    [self.tableView reloadData];
    [super viewWillAppear:animated];
    
}
#pragma mark - Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0){
        return 1;
    }else{
        //return _dates.count;
        return 15;
    }
    //return _dates.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        CountUpCell *countUpCell=[tableView dequeueReusableCellWithIdentifier:@"CountUpCell"];
        
        return countUpCell;
    }else{
        DateCell *dateCell=[tableView dequeueReusableCellWithIdentifier:@"DateCell"];
        
        dateCell=[[DateCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"DateCell"];
            
        
        
        dateCell.textLabel.text=@"a";
        
        dateCell.detailTextLabel.text=@"a";
        
        /*if ((dateCell.detailTextLabel.text=@"出席")) {
            dateCell.detailTextLabel.textColor=[UIColor redColor];
        }else if((dateCell.detailTextLabel.text=@"欠席")){
            dateCell.detailTextLabel.textColor=[UIColor blueColor];
        }else{
            dateCell.detailTextLabel.textColor=[UIColor greenColor];
        }*/
        
        
        return dateCell;
    }
}

#pragma mark - UITableView Delegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==1) {
        return 10;
    }
    return 0;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 100;
    }
    return 40;
    
}
/*-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    

}*/

/*-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [_dates removeObjectAtIndex:indexPath.row];
    
    NSArray *deleteArray=[NSArray arrayWithObject:indexPath];
    
    [tableView deleteRowsAtIndexPaths:deleteArray withRowAnimation:UITableViewRowAnimationAutomatic];
    
}*/
/*
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}*/

#pragma mark - IBAction

- (IBAction)deleteClassButton:(id)sender {
    
}
@end
