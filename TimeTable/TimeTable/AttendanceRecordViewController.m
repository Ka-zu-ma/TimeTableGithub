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

@interface AttendanceRecordViewController ()<UITableViewDelegate,UITableViewDataSource,CountUpDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *deleteClassButton;

@property (strong,nonatomic) NSMutableArray *dates;
@property (strong,nonatomic) NSMutableArray *attendanceOrAbsenceOrLates;

@property (strong,nonatomic) NSString *attendanceCountString;
@property (strong,nonatomic) NSString *absenceCountString;
@property (strong,nonatomic) NSString *lateCountString;

@property  (strong,nonatomic) NSString *attendanceCountOfMaxIdString;
@property  (strong,nonatomic) NSString *absenceCountOfMaxIdString;
@property  (strong,nonatomic) NSString *lateCountOfMaxIdString;

@property (strong,nonatomic) NSString *renewAttendanceCountOfMaxIdString;
@property (strong,nonatomic) NSString *renewAbsenceCountOfMaxIdString;
@property (strong,nonatomic) NSString *renewLateCountOfMaxIdString;

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
    
    [self insertInitialValueOfCounts];
    
    
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
        
        while ([results next]) {
            
            [_dates addObject:[results stringForColumn:@"date"]];
            [_attendanceOrAbsenceOrLates addObject:[results stringForColumn:@"attendancerecord"]];
        }
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

#pragma mark - CountUp Delegate

-(void)attendanceCountUp{
    
    [self selectCountsOfMaxIdAndNewCountsWhenUp];
    
    FMDatabase *db=[super getDatabaseOfCountUpRecordTable];
    [db open];
    
    FMResultSet *oneresults=[db executeQuery:@"SELECT attendancecount, absencecount, latecount  FROM count_up_record_table WHERE id = (SELECT MAX(id) FROM count_up_record_table);"];
    
    while ([oneresults next]) {
        
        _absenceCountOfMaxIdString=[oneresults stringForColumn:@"absencecount"];
        _lateCountOfMaxIdString=[oneresults stringForColumn:@"latecount"];

    }
    
    [db executeUpdate:@"INSERT INTO count_up_record_table (attendancecount, absencecount, latecount) VALUES (?, ?, ?);",_renewAttendanceCountOfMaxIdString,_absenceCountOfMaxIdString,_lateCountOfMaxIdString];
    [db close];
    
    FMDatabase *twodb=[super getDatabaseOfDateAndAttendanceRecordTable];
    [twodb open];
    [twodb executeUpdate:@"INSERT INTO date_attendancerecord_table (date, attendancerecord) VALUES (?, ?);",[super getNowTime],@"出席"];
    FMResultSet *results=[twodb executeQuery:@"SELECT date, attendancerecord FROM  date_attendancerecord_table WHERE id = (SELECT MAX(id) FROM date_attendancerecord_table);"];
    
    while ([results next]) {
        [_dates addObject:[results stringForColumn:@"date"]];
        [_attendanceOrAbsenceOrLates addObject:[results stringForColumn:@"attendancerecord"]];

    }
    NSLog(@"%@",_attendanceOrAbsenceOrLates);
    [twodb close];
    
    [self displayLatestCounts];
    
    [self.tableView reloadData];
}

-(void)absenceCountUp{
    
    [self selectCountsOfMaxIdAndNewCountsWhenUp];
    
    FMDatabase *db=[super getDatabaseOfCountUpRecordTable];
    [db open];
    
    FMResultSet *oneresults=[db executeQuery:@"SELECT attendancecount, absencecount, latecount  FROM count_up_record_table WHERE id = (SELECT MAX(id) FROM count_up_record_table);"];
    
    while ([oneresults next]) {
        
        _attendanceCountOfMaxIdString=[oneresults stringForColumn:@"attendancecount"];
        _lateCountOfMaxIdString=[oneresults stringForColumn:@"latecount"];
        
    }
    
    [db executeUpdate:@"INSERT INTO count_up_record_table (attendancecount, absencecount, latecount) VALUES (?, ?, ?);",_attendanceCountOfMaxIdString,_renewAbsenceCountOfMaxIdString,_lateCountOfMaxIdString];
    [db close];
    
    FMDatabase *twodb=[super getDatabaseOfDateAndAttendanceRecordTable];
    [twodb open];
    [twodb executeUpdate:@"INSERT INTO date_attendancerecord_table (date, attendancerecord) VALUES (?, ?);",[super getNowTime],@"欠席"];
    
    FMResultSet *results=[twodb executeQuery:@"SELECT date, attendancerecord FROM  date_attendancerecord_table WHERE id = (SELECT MAX(id) FROM date_attendancerecord_table);"];
    
    while ([results next]) {
        [_dates addObject:[results stringForColumn:@"date"]];
        [_attendanceOrAbsenceOrLates addObject:[results stringForColumn:@"attendancerecord"]];
        
    }
    
    [twodb close];
    
    [self displayLatestCounts];
    
    [self.tableView reloadData];
    
}

-(void)lateCountUp{
    
    [self selectCountsOfMaxIdAndNewCountsWhenUp];
    
    FMDatabase *db=[super getDatabaseOfCountUpRecordTable];
    [db open];
    
    FMResultSet *oneresults=[db executeQuery:@"SELECT attendancecount, absencecount, latecount  FROM count_up_record_table WHERE id = (SELECT MAX(id) FROM count_up_record_table);"];
    
    while ([oneresults next]) {
        
        _attendanceCountOfMaxIdString=[oneresults stringForColumn:@"attendancecount"];
        _absenceCountOfMaxIdString=[oneresults stringForColumn:@"absencecount"];
        
    }
    
    [db executeUpdate:@"INSERT INTO count_up_record_table (attendancecount, absencecount, latecount) VALUES (?, ?, ?);",_attendanceCountOfMaxIdString,_absenceCountOfMaxIdString,_renewLateCountOfMaxIdString];
    [db close];
    
    FMDatabase *twodb=[super getDatabaseOfDateAndAttendanceRecordTable];
    [twodb open];
    [twodb executeUpdate:@"INSERT INTO date_attendancerecord_table (date, attendancerecord) VALUES (?, ?);",[super getNowTime],@"遅刻"];
    
    FMResultSet *results=[twodb executeQuery:@"SELECT date, attendancerecord FROM  date_attendancerecord_table WHERE id = (SELECT MAX(id) FROM date_attendancerecord_table);"];
    
    while ([results next]) {
        [_dates addObject:[results stringForColumn:@"date"]];
        [_attendanceOrAbsenceOrLates addObject:[results stringForColumn:@"attendancerecord"]];
        
    }
    
    [twodb close];
    
    [self displayLatestCounts];
    
    [self.tableView reloadData];
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
        
        countUpCell.delegate=self; //カスタムセルの場合、ここでデリゲート
        
        [countUpCell.attendanceButton setTitle:_attendanceCountString forState:UIControlStateNormal];
        [countUpCell.absenceButton setTitle:_absenceCountString forState:UIControlStateNormal];
        [countUpCell.lateButton setTitle:_lateCountString forState:UIControlStateNormal];
        
        return countUpCell;
        
    }else{
        
        DateCell *dateCell=[tableView dequeueReusableCellWithIdentifier:@"DateCell"];
        
        if(!dateCell){
            dateCell=[[DateCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"DateCell"];
        }

        dateCell.textLabel.text=_dates[indexPath.row];
        dateCell.detailTextLabel.text=_attendanceOrAbsenceOrLates[indexPath.row];
        //xibのtableviewcellのstyleをRight DetailにしないとdetailTextLabelに文字が反映されない
        
        if([_attendanceOrAbsenceOrLates[indexPath.row] isEqual:@"出席"]){
            dateCell.detailTextLabel.textColor=[UIColor redColor];
        }else if([_attendanceOrAbsenceOrLates[indexPath.row] isEqual:@"欠席"]){
            dateCell.detailTextLabel.textColor=[UIColor blueColor];
        }else{
            dateCell.detailTextLabel.textColor=[UIColor greenColor];
        }
        
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
        return 15;
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

//編集モードを呼び出す
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //削除ボタン
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:indexPath];
        
        if ([cell.detailTextLabel.text isEqual:@"出席"]) {
            
            //ここから
            FMDatabase *db=[super getDatabaseOfDateAndAttendanceRecordTable];
            [db open];
            [db executeUpdate:@"DELETE FROM date_attendancerecord_table WHERE date = ? AND attendancerecord = ?",cell.textLabel.text,cell.detailTextLabel.text];
            
            
            [self createEmptyArrays];
            
            FMResultSet *results=[db executeQuery:@"SELECT date, attendancerecord FROM date_attendancerecord_table;"];
            while ([results next]) {
                [_dates addObject:[results stringForColumn:@"date"]];
                [_attendanceOrAbsenceOrLates addObject:[results stringForColumn:@"attendancerecord"]];
                
            }
            [db close];
            //ここまでは共通なので外にまとめたいが....
            
            //出席カウントを1減らす
            [self selectCountsOfMaxIdAndNewCountsWhenDown];
            
            [self selectCountsOfMaxId];
            
            FMDatabase *twodb=[super getDatabaseOfCountUpRecordTable];
            [twodb open];
            [twodb executeUpdate:@"INSERT INTO count_up_record_table (attendancecount,  absencecount, latecount) VALUES (?, ?, ?);",_renewAttendanceCountOfMaxIdString,_absenceCountOfMaxIdString,_lateCountOfMaxIdString];

            
            [twodb close];
            
            [self selectCountsOfMaxId];
            
            _attendanceCountString=_attendanceCountOfMaxIdString;
            _absenceCountString=_absenceCountOfMaxIdString;
            _lateCountString=_lateCountOfMaxIdString;
            
            [self.tableView reloadData];
            
        }else if ([cell.detailTextLabel.text isEqual:@"欠席"]){
            
            FMDatabase *db=[super getDatabaseOfDateAndAttendanceRecordTable];
            [db open];
            [db executeUpdate:@"DELETE FROM date_attendancerecord_table WHERE date = ? AND attendancerecord = ?",cell.textLabel.text,cell.detailTextLabel.text];
            
            
            [self createEmptyArrays];
            
            FMResultSet *results=[db executeQuery:@"SELECT date, attendancerecord FROM date_attendancerecord_table;"];
            while ([results next]) {
                [_dates addObject:[results stringForColumn:@"date"]];
                [_attendanceOrAbsenceOrLates addObject:[results stringForColumn:@"attendancerecord"]];
                
            }
            [db close];
            
            //欠席カウント1減らす
            [self selectCountsOfMaxIdAndNewCountsWhenDown];
            
            [self selectCountsOfMaxId];
            
            FMDatabase *twodb=[super getDatabaseOfCountUpRecordTable];
            [twodb open];
            [twodb executeUpdate:@"INSERT INTO count_up_record_table (attendancecount,  absencecount, latecount) VALUES (?, ?, ?);",_attendanceCountOfMaxIdString,_renewAbsenceCountOfMaxIdString,_lateCountOfMaxIdString];
            
            [twodb close];
            
            [self selectCountsOfMaxId];
            
            _attendanceCountString=_attendanceCountOfMaxIdString;
            _absenceCountString=_absenceCountOfMaxIdString;
            _lateCountString=_lateCountOfMaxIdString;
            
            [self.tableView reloadData];

        }else{
            
            FMDatabase *db=[super getDatabaseOfDateAndAttendanceRecordTable];
            [db open];
            [db executeUpdate:@"DELETE FROM date_attendancerecord_table WHERE date = ? AND attendancerecord = ?",cell.textLabel.text,cell.detailTextLabel.text];
            
            
            [self createEmptyArrays];
            
            FMResultSet *results=[db executeQuery:@"SELECT date, attendancerecord FROM date_attendancerecord_table;"];
            while ([results next]) {
                [_dates addObject:[results stringForColumn:@"date"]];
                [_attendanceOrAbsenceOrLates addObject:[results stringForColumn:@"attendancerecord"]];
                
            }
            [db close];
            
            //遅刻カウント1減らす
            [self selectCountsOfMaxIdAndNewCountsWhenDown];
            
            [self selectCountsOfMaxId];
            
            FMDatabase *twodb=[super getDatabaseOfCountUpRecordTable];
            [twodb open];
            [twodb executeUpdate:@"INSERT INTO count_up_record_table (attendancecount,  absencecount, latecount) VALUES (?, ?, ?);",_attendanceCountOfMaxIdString,_absenceCountOfMaxIdString,_renewLateCountOfMaxIdString];
            
            [twodb close];
            
            [self selectCountsOfMaxId];
            
            _attendanceCountString=_attendanceCountOfMaxIdString;
            _absenceCountString=_absenceCountOfMaxIdString;
            _lateCountString=_lateCountOfMaxIdString;
            
            [self.tableView reloadData];

        }
        
    }];
    
    //編集ボタン
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"edit" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:indexPath];
        
        if ([cell.detailTextLabel.text isEqual:@"出席"]) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"出席/欠席/遅刻 変更" message:@"どれに変更しますか。" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"欠席",@"遅刻",nil];
            
            [alert show];
            

        }
        
        
        
        
    }];
    editAction.backgroundColor=[UIColor greenColor];

    return  @[deleteAction,editAction];
}

#pragma mark - UIAlertView Delegate

//アラートのボタンが押された時
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0://Button1が押されたとき
            
            
            
            break;
            
        case 1://Button2が押されたとき
            break;
            
        default://キャンセルが押されたとき
            break;
    }
}

/*
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}*/

#pragma mark - IBAction

- (IBAction)deleteClassButton:(id)sender {
    
    FMDatabase *db=[super getDatabaseOfCountUpRecordTable];
    [db open];
    [db executeUpdate:@"DROP TABLE count_up_record_table"];
    [db close];
    
    FMDatabase *twodb=[super getDatabaseOfDateAndAttendanceRecordTable];
    [twodb open];
    [twodb executeUpdate:@"DROP TABLE date_attendancerecord_table"];
    [twodb close];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Original Methods

-(void)createEmptyArrays{
    
    _dates=[NSMutableArray array];
    _attendanceOrAbsenceOrLates=[NSMutableArray array];
}

-(void)displayLatestCounts{
    
    FMDatabase *db=[super getDatabaseOfCountUpRecordTable];
    [db open];
    
    FMResultSet *results=[db executeQuery:@"SELECT attendancecount, absencecount, latecount  FROM count_up_record_table WHERE id= (SELECT MAX(id) FROM count_up_record_table);"];
    
    while ([results next]) {
        _attendanceCountString=[results stringForColumn:@"attendancecount"];
        _absenceCountString=[results stringForColumn:@"absencecount"];
        _lateCountString=[results stringForColumn:@"latecount"];
        
    }
    [db close];
}

-(void)insertInitialValueOfCounts{
    
    [super createCountUpRecordTable];
    
    FMDatabase *db=[super getDatabaseOfCountUpRecordTable];
    [db open];
    
    FMResultSet *results=[db executeQuery:@"SELECT COUNT(*) AS COUNT FROM count_up_record_table"];
    
    NSString *count;
    
    while ([results next]) {
        count=[results stringForColumn:@"COUNT"];
    }
    [db close];
    
    if (count.intValue==0) {
        
        FMDatabase *db=[super getDatabaseOfCountUpRecordTable];
        [db open];
        
        [db executeUpdate:@"INSERT INTO count_up_record_table (attendancecount, absencecount, latecount) VALUES (?, ?, ?);",@"0",@"0",@"0"];
        [db close];
        
    }else{
        
    }
}

-(void)selectCountsOfMaxId{
    
    FMDatabase *db=[super getDatabaseOfCountUpRecordTable];
    [db open];
    FMResultSet *results=[db executeQuery:@"SELECT attendancecount, absencecount, latecount FROM count_up_record_table WHERE id = (SELECT MAX(id) FROM count_up_record_table);"];
    while ([results next]) {
        _attendanceCountOfMaxIdString=[results stringForColumn:@"attendancecount"];
        _absenceCountOfMaxIdString=[results stringForColumn:@"absencecount"];
        _lateCountOfMaxIdString=[results stringForColumn:@"latecount"];
    }
    [db close];
}

-(void)selectCountsOfMaxIdAndNewCountsWhenDown{
    
    [self selectCountsOfMaxId];
    
    int a;
    int b=_attendanceCountOfMaxIdString.intValue;
    int c;
    int d=_absenceCountOfMaxIdString.intValue;
    int e;
    int f=_lateCountOfMaxIdString.intValue;
    
    a=b-1;
    c=d-1;
    e=f-1;
    
    _renewAttendanceCountOfMaxIdString=[NSString stringWithFormat:@"%d",a];
    _renewAbsenceCountOfMaxIdString=[NSString stringWithFormat:@"%d",c];
    _renewLateCountOfMaxIdString=[NSString stringWithFormat:@"%d",e];
}

-(void)selectCountsOfMaxIdAndNewCountsWhenUp{
    
    [self selectCountsOfMaxId];
    
    int a;
    int b=_attendanceCountOfMaxIdString.intValue;
    int c;
    int d=_absenceCountOfMaxIdString.intValue;
    int e;
    int f=_lateCountOfMaxIdString.intValue;
    
    a=b+1;
    c=d+1;
    e=f+1;
    
    _renewAttendanceCountOfMaxIdString=[NSString stringWithFormat:@"%d",a];
    _renewAbsenceCountOfMaxIdString=[NSString stringWithFormat:@"%d",c];
    _renewLateCountOfMaxIdString=[NSString stringWithFormat:@"%d",e];
    
    //この書き方だとなぜエラーが出るのか
    //_renewAttendanceCountOfMaxIdString.intValue=_attendanceCountOfMaxIdString.intValue + 1;
}
@end
