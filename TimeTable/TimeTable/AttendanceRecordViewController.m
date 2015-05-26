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
@property (strong,nonatomic) NSMutableArray *attendanceOrAbsenceOrLates;

@property (strong,nonatomic) NSString *attendanceCountString;
@property (strong,nonatomic) NSString *absenceCountString;
@property (strong,nonatomic) NSString *lateCountString;

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
    
    _tableView.contentInset=UIEdgeInsetsMake(-1.0f,0.0, 0.0, 0.0);
    
    [super createCountUpRecordTable];
    
    FMDatabase *db=[super getDatabaseOfCountUpRecordTable];
    [db open];
    [db executeUpdate:@"INSERT INTO count_up_record_table (attendancecount, absencecount, latecount) VALUES (?, ?, ?);",@"0",@"0",@"0"];
    [db close];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    
    _dates=[NSMutableArray array];
    _attendanceOrAbsenceOrLates=[NSMutableArray array];
    
    if (_dates.count > 0 && _attendanceOrAbsenceOrLates.count > 0) {
        
        [super createDateAndAttendanceRecordTable];
        
        FMDatabase *db=[super getDatabaseOfDateAndAttendanceRecordTable];
        [db open];
        
        FMResultSet *results=[db executeQuery:@"SELECT date, attendancerecord FROM  date_attendancerecord_table WHERE id = (SELECT MAX(id) FROM date_attendancerecord_table);"];
        
        [_dates addObject:[results stringForColumn:@"date"]];
        [_attendanceOrAbsenceOrLates addObject:[results stringForColumn:@"attendancerecord"]];
        
        [db close];
        
        [self displayLatestCounts];
        
        [self.tableView reloadData];
        [super viewWillAppear:animated];

    }else{
        
        [super createDateAndAttendanceRecordTable];
        
        FMDatabase *db=[super getDatabaseOfDateAndAttendanceRecordTable];
        [db open];
        
        FMResultSet *results=[db executeQuery:@"SELECT date, attendancerecord FROM  date_attendancerecord_table;"];
        
        while ([results next]) {
            [_dates addObject:[results stringForColumn:@"date"]];
            [_attendanceOrAbsenceOrLates addObject:[results stringForColumn:@"attendancerecord"]];
        }
        
        [db close];
        
        [self displayLatestCounts];
        
        [self.tableView reloadData];
        [super viewWillAppear:animated];
    }
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
        return _dates.count;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        CountUpCell *countUpCell=[tableView dequeueReusableCellWithIdentifier:@"CountUpCell"];
        
        [countUpCell.attendanceButton setTitle:_attendanceCountString forState:UIControlStateNormal];
        [countUpCell.absenceButton setTitle:_absenceCountString forState:UIControlStateNormal];
        [countUpCell.lateButton setTitle:_lateCountString forState:UIControlStateNormal];
        
        return countUpCell;
    }else{
        DateCell *dateCell=[tableView dequeueReusableCellWithIdentifier:@"DateCell"];
        
        if(!dateCell){
            dateCell=[[DateCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"DateCell"];
        }

        dateCell.textLabel.text=_dates[indexPath.row];
        
        dateCell.detailTextLabel.text=_attendanceOrAbsenceOrLates[indexPath.row];
        
        //[dateCell.textLabel sizeToFit];
        //[dateCell.detailTextLabel sizeToFit];
        
        return dateCell;
    }
}

#pragma mark - UITableView Delegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 1.0f;
    }
        return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
                
        //CGSize maxSize= CGSizeMake(150, CGFLOAT_MAX);
        
        return 130;
        
    }
        
        /*DateCell *dateCell=[[DateCell alloc]init];
        dateCell.textLabel.text=_dates[indexPath.row];
        dateCell.detailTextLabel.text=_attendanceOrAbsenceOrLates[indexPath.row];
        
        CGSize maxSize= CGSizeMake(40, CGFLOAT_MAX);
        
        NSDictionary *attributes=@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17.0]};
        
        CGSize modifiedSize=[]*/
    
    return 40;
}

/*-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [_dates removeObjectAtIndex:indexPath.row];
    
    NSArray *deleteArray=[NSArray arrayWithObject:indexPath];
    
    [tableView deleteRowsAtIndexPaths:deleteArray withRowAnimation:UITableViewRowAnimationAutomatic];
    
}*/

//編集モードを呼び出す
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //削除ボタン
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        //UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:indexPath];
        
        
        
    }];
    
    //編集ボタン
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"edit" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        
    }];
    editAction.backgroundColor=[UIColor greenColor];

    return  @[deleteAction,editAction];
}
/*
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}*/

#pragma  mark - Database

-(void)displayLatestCounts{
    
    //[super createCountUpRecordTable];
    FMDatabase *twodb=[super getDatabaseOfCountUpRecordTable];
    [twodb open];
    
    FMResultSet *tworesults=[twodb executeQuery:@"SELECT attendancecount, absencecount, latecount  FROM count_up_record_table WHERE id= (SELECT MAX(id) FROM count_up_record_table);"];
    
    int attendanceCount,absenceCount,lateCount;
    
    attendanceCount=[tworesults intForColumn:@"attendancecount"];
    absenceCount=[tworesults intForColumn:@"absencecount"];
    lateCount=[tworesults intForColumn:@"latecount"];
    
    _attendanceCountString=[NSString stringWithFormat:@"%d",attendanceCount];
    _absenceCountString=[NSString stringWithFormat:@"%d",absenceCount];
    _lateCountString=[NSString stringWithFormat:@"%d",lateCount];
    
    [twodb close];
    
}

#pragma mark - IBAction

- (IBAction)deleteClassButton:(id)sender {
    
    
}


@end
