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
#import "UpdateAttendanceRecordAndCountViewController.h"
#import "TimeTableViewController.h"
#import "TitleLabel.h"

@interface AttendanceRecordViewController ()<UITableViewDelegate,UITableViewDataSource,CountUpDelegate>
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
    /*UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectZero];//(0,0)で大きさ、長さが0
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.text=@"出席状況";
    [titleLabel sizeToFit];*/
    self.navigationItem.titleView=[TitleLabel createTitlelabel:@"出席状況"];
    
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
    
    [self createEmptyArrays];
    
    [super createDateAndAttendanceRecordTable];
    
    FMDatabase *db=[super getDatabaseOfDateAndAttendanceRecordTable];
    [db open];
    
    FMResultSet *results=[db executeQuery:@"SELECT date, attendancerecord FROM  date_attendancerecord_table WHERE indexPath=?;",[NSString stringWithFormat:@"%ld",(long)_indexPath.row]];
    
    while ([results next]) {
        [_dates addObject:[results stringForColumn:@"date"]];
        [_attendanceOrAbsenceOrLates addObject:[results stringForColumn:@"attendancerecord"]];
        
    }
    
    [db close];
    [self.tableView reloadData];
    
    [self displayLatestCounts];
    //[super viewWillAppear:animated];
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CountUp Delegate

-(void)attendanceCountUp{
    
        NSArray *renewCountsOfMaxId=[self selectCountsOfMaxIdAndCreateUpDownNewCounts:1];
    
        FMDatabase *onedb=[super getDatabaseOfCountUpRecordTable];
        [onedb open];
    
        FMResultSet *oneresults=[onedb executeQuery:@"SELECT absencecount, latecount FROM count_up_record_table WHERE id = (SELECT MAX(id) FROM count_up_record_table WHERE  indexPath = ?);",[NSString stringWithFormat:@"%ld",(long)_indexPath.row]];
    
        while ([oneresults next]) {
            
        _absenceCountOfMaxIdString=[oneresults stringForColumn:@"absencecount"];
        _lateCountOfMaxIdString=[oneresults stringForColumn:@"latecount"];
        }
    
    
        [onedb executeUpdate:@"INSERT INTO count_up_record_table (attendancecount, absencecount, latecount,indexPath) VALUES (?, ?, ?, ?);",renewCountsOfMaxId[0],_absenceCountOfMaxIdString,_lateCountOfMaxIdString,[NSString stringWithFormat:@"%ld",(long)_indexPath.row]];
        [onedb close];
    
        FMDatabase *twodb=[super getDatabaseOfDateAndAttendanceRecordTable];
        [twodb open];
        [twodb executeUpdate:@"INSERT INTO date_attendancerecord_table (date, attendancerecord, indexPath) VALUES (?, ?, ?);",[super getToday],@"出席",[NSString stringWithFormat:@"%ld",(long)_indexPath.row]];
        
    
      
        FMResultSet *tworesults=[twodb executeQuery:@"SELECT date, attendancerecord FROM  date_attendancerecord_table WHERE id = (SELECT MAX(id) FROM date_attendancerecord_table  WHERE indexPath = ?);",[NSString stringWithFormat:@"%ld",(long)_indexPath.row]];
    
        while ([tworesults next]) {
        [_dates addObject:[tworesults stringForColumn:@"date"]];
        [_attendanceOrAbsenceOrLates addObject:[tworesults stringForColumn:@"attendancerecord"]];

        }
    
        [twodb close];
        
    [self displayLatestCounts];
    
    [self.tableView reloadData];
        
   
}

-(void)absenceCountUp{
    
    NSArray *renewCountsOfMaxId=[self selectCountsOfMaxIdAndCreateUpDownNewCounts:1];
    
    FMDatabase *db=[super getDatabaseOfCountUpRecordTable];
    [db open];
    
    FMResultSet *oneresults=[db executeQuery:@"SELECT attendancecount, latecount FROM count_up_record_table WHERE id = (SELECT MAX(id) FROM count_up_record_table WHERE  indexPath = ?);",[NSString stringWithFormat:@"%ld",(long)_indexPath.row]];
    
    while ([oneresults next]) {
        
        _attendanceCountOfMaxIdString=[oneresults stringForColumn:@"attendancecount"];
        _lateCountOfMaxIdString=[oneresults stringForColumn:@"latecount"];
        
    }
    
    [db executeUpdate:@"INSERT INTO count_up_record_table (attendancecount, absencecount, latecount, indexPath) VALUES (?, ?, ?, ?);",_attendanceCountOfMaxIdString,renewCountsOfMaxId[1],_lateCountOfMaxIdString,[NSString stringWithFormat:@"%ld",(long)_indexPath.row]];
    [db close];
    
    FMDatabase *twodb=[super getDatabaseOfDateAndAttendanceRecordTable];
    [twodb open];
    [twodb executeUpdate:@"INSERT INTO date_attendancerecord_table (date, attendancerecord, indexPath) VALUES (?, ?, ?);",[super getToday],@"欠席",[NSString stringWithFormat:@"%ld",(long)_indexPath.row]];
    
    FMResultSet *results=[twodb executeQuery:@"SELECT date, attendancerecord FROM  date_attendancerecord_table WHERE id = (SELECT MAX(id) FROM date_attendancerecord_table WHERE indexPath = ?);",[NSString stringWithFormat:@"%ld",(long)_indexPath.row]];
    
    while ([results next]) {
        [_dates addObject:[results stringForColumn:@"date"]];
        [_attendanceOrAbsenceOrLates addObject:[results stringForColumn:@"attendancerecord"]];
        
    }
    
    [twodb close];
    
    [self displayLatestCounts];
    
    [self.tableView reloadData];
    
 
}

-(void)lateCountUp{
    
    NSArray *renewCountsOfMaxId=[self selectCountsOfMaxIdAndCreateUpDownNewCounts:1];
    
    FMDatabase *db=[super getDatabaseOfCountUpRecordTable];
    [db open];
    
    FMResultSet *oneresults=[db executeQuery:@"SELECT attendancecount, absencecount FROM count_up_record_table WHERE id = (SELECT MAX(id) FROM count_up_record_table WHERE indexPath = ?);",[NSString stringWithFormat:@"%ld",(long)_indexPath.row]];
    
    while ([oneresults next]) {
        
        _attendanceCountOfMaxIdString=[oneresults stringForColumn:@"attendancecount"];
        _absenceCountOfMaxIdString=[oneresults stringForColumn:@"absencecount"];
        
    }
    
    [db executeUpdate:@"INSERT INTO count_up_record_table (attendancecount, absencecount, latecount, indexPath) VALUES (?, ?, ?, ?);",_attendanceCountOfMaxIdString,_absenceCountOfMaxIdString,renewCountsOfMaxId[2],[NSString stringWithFormat:@"%ld",(long)_indexPath.row]];
    [db close];
    
    FMDatabase *twodb=[super getDatabaseOfDateAndAttendanceRecordTable];
    [twodb open];
    [twodb executeUpdate:@"INSERT INTO date_attendancerecord_table (date, attendancerecord, indexPath) VALUES (?, ?, ?);",[super getToday],@"遅刻",[NSString stringWithFormat:@"%ld",(long)_indexPath.row]];
    
    FMResultSet *results=[twodb executeQuery:@"SELECT date, attendancerecord FROM  date_attendancerecord_table WHERE id = (SELECT MAX(id) FROM date_attendancerecord_table WHERE indexPath = ?);",[NSString stringWithFormat:@"%ld",(long)_indexPath.row]];
    
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
        
        [self deleteDateAndSelect:cell];

        if ([cell.detailTextLabel.text isEqual:@"出席"]) {
            
            //出席カウントを1減らす
            NSArray *renewCountsOfMaxId=[self selectCountsOfMaxIdAndCreateUpDownNewCounts:-1];
            
            NSArray *oneCountsOfMaxId=[self selectCountsOfMaxId];
            
            FMDatabase *twodb=[super getDatabaseOfCountUpRecordTable];
            [twodb open];
            [twodb executeUpdate:@"INSERT INTO count_up_record_table (attendancecount,  absencecount, latecount, indexPath) VALUES (?, ?, ?, ?);",renewCountsOfMaxId[0],oneCountsOfMaxId[1],oneCountsOfMaxId[2],[NSString stringWithFormat:@"%ld",(long)_indexPath.row]];
            
            [twodb close];
            
            NSArray *twoCountsOfMaxId=[self selectCountsOfMaxId];
            
            _attendanceCountString=twoCountsOfMaxId[0];
            _absenceCountString=twoCountsOfMaxId[1];
            _lateCountString=twoCountsOfMaxId[2];
            
            [self.tableView reloadData];
            
        }else if ([cell.detailTextLabel.text isEqual:@"欠席"]){
            
            //欠席カウント1減らす
            NSArray *renewCountsOfMaxId=[self selectCountsOfMaxIdAndCreateUpDownNewCounts:-1];
            
            NSArray *oneCountsOfMaxid=[self selectCountsOfMaxId];
            
            FMDatabase *twodb=[super getDatabaseOfCountUpRecordTable];
            [twodb open];
            [twodb executeUpdate:@"INSERT INTO count_up_record_table (attendancecount,  absencecount, latecount, indexPath) VALUES (?, ?, ?, ?);",oneCountsOfMaxid[0],renewCountsOfMaxId[1],oneCountsOfMaxid[2],[NSString stringWithFormat:@"%ld",(long)_indexPath.row]];
            
            [twodb close];
            
            NSArray *twoCountsOfMaxId=[self selectCountsOfMaxId];
            
            _attendanceCountString=twoCountsOfMaxId[0];
            _absenceCountString=twoCountsOfMaxId[1];
            _lateCountString=twoCountsOfMaxId[2];
            
            [self.tableView reloadData];

        }else{
            //遅刻カウント1減らす
            NSArray *renewCountsOfMaxId=[self selectCountsOfMaxIdAndCreateUpDownNewCounts:-1];
            
            NSArray *oneCountsOfMaxid=[self selectCountsOfMaxId];
            
            FMDatabase *twodb=[super getDatabaseOfCountUpRecordTable];
            [twodb open];
            [twodb executeUpdate:@"INSERT INTO count_up_record_table (attendancecount,  absencecount, latecount, indexPath) VALUES (?, ?, ?, ?);",oneCountsOfMaxid[0],oneCountsOfMaxid[1],renewCountsOfMaxId[2],[NSString stringWithFormat:@"%ld",(long)_indexPath.row]];
            
            [twodb close];
            
            NSArray *twoCountsOfMaxId=[self selectCountsOfMaxId];
            
            _attendanceCountString=twoCountsOfMaxId[0];
            _absenceCountString=twoCountsOfMaxId[1];
            _lateCountString=twoCountsOfMaxId[2];
            
            [self.tableView reloadData];
        }
        
    }];
    
    //編集ボタン
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"edit" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:indexPath];
        
        UpdateAttendanceRecordAndCountViewController *viewController=[[UpdateAttendanceRecordAndCountViewController alloc]init];
        
        viewController.dateString=cell.textLabel.text;
        viewController.attendanceRecordString=cell.detailTextLabel.text;
        viewController.indexPath=_indexPath;
        
        [self.navigationController pushViewController:viewController animated:YES];
        
    }];
    
    editAction.backgroundColor=[UIColor greenColor];

    return  @[deleteAction,editAction];
}

#pragma mark - IBAction

- (IBAction)deleteClassButton:(id)sender {
    
    FMDatabase *db=[super getDatabaseOfCountUpRecordTable];
    [db open];//トランザクション
    [db executeUpdate:@"DELETE FROM count_up_record_table WHERE indexPath = ?;",[NSString stringWithFormat:@"%ld",(long)_indexPath.row]];
    [db close];
    
    FMDatabase *twodb=[super getDatabaseOfDateAndAttendanceRecordTable];
    [twodb open];
    [twodb executeUpdate:@"DELETE FROM date_attendancerecord_table WHERE indexPath = ?;",[NSString stringWithFormat:@"%ld",(long)_indexPath.row]];
    [twodb close];
    
    FMDatabase *threedb=[super getDatabaseOfselectclass];
    [threedb open];
    
    [threedb executeUpdate:@"DELETE FROM selectclasstable WHERE indexPath = ?;",[NSString stringWithFormat:@"%ld",(long)_indexPath.row]];
    
    [threedb close];
    
    //前の画面に戻る前に更新
    NSArray *allControllers = self.navigationController.viewControllers;
    NSInteger target = [allControllers count] - 2;
    TimeTableViewController *parent = allControllers[target];
    [parent.collectionView reloadSections:[NSIndexSet indexSetWithIndex:_indexPath.section]];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Original Methods

-(void)deleteDateAndSelect:(UITableViewCell *)cell{
    FMDatabase *db=[super getDatabaseOfDateAndAttendanceRecordTable];
    [db open];
    [db executeUpdate:@"DELETE FROM date_attendancerecord_table WHERE date = ? AND attendancerecord = ? AND indexPath = ?",cell.textLabel.text,cell.detailTextLabel.text,[NSString stringWithFormat:@"%ld",(long)_indexPath.row]];
    
    [self createEmptyArrays];
    
    FMResultSet *results=[db executeQuery:@"SELECT date, attendancerecord FROM date_attendancerecord_table WHERE indexPath = ?;",[NSString stringWithFormat:@"%ld",(long)_indexPath.row]];
    while ([results next]) {
        [_dates addObject:[results stringForColumn:@"date"]];
        [_attendanceOrAbsenceOrLates addObject:[results stringForColumn:@"attendancerecord"]];
        
    }
    [db close];
    
}

-(void)createEmptyArrays{
    
    _dates=[[NSMutableArray alloc]init];
    _attendanceOrAbsenceOrLates=[[NSMutableArray alloc]init];
}

-(void)displayLatestCounts{
    
    FMDatabase *db=[super getDatabaseOfCountUpRecordTable];
    [db open];
    
    FMResultSet *results=[db executeQuery:@"SELECT attendancecount, absencecount, latecount FROM  count_up_record_table WHERE id=(SELECT MAX(id) FROM count_up_record_table WHERE indexPath = ?);",[NSString stringWithFormat:@"%ld",(long)_indexPath.row]];
    
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
    
    FMResultSet *results=[db executeQuery:@"SELECT attendancecount, absencecount ,latecount FROM count_up_record_table WHERE indexPath = ?;",[NSString stringWithFormat:@"%ld",(long)_indexPath.row]];
    
    while ([results next]) {
        _attendanceCountString=[results stringForColumn:@"attendancecount"];
        _absenceCountString=[results stringForColumn:@"absencecount"];
        _lateCountString=[results stringForColumn:@"latecount"];
    }
    
    [db close];
    
    if (_attendanceCountString.length == 0 && _absenceCountString.length == 0 && _lateCountString.length == 0) {
        
        FMDatabase *db=[super getDatabaseOfCountUpRecordTable];
        [db open];
        
        [db executeUpdate:@"INSERT INTO count_up_record_table (attendancecount, absencecount,  latecount, indexPath) VALUES (?, ?, ?, ?);",@"0",@"0",@"0",[NSString stringWithFormat:@"%ld",(long)_indexPath.row]];
        [db close];
    }
}

-(NSArray *)selectCountsOfMaxId{
    
    NSString *attendanceCountOfMaxIdString;
    NSString *absenceCountOfMaxIdString;
    NSString *lateCountOfMaxIdString;
    
    FMDatabase *db=[super getDatabaseOfCountUpRecordTable];
    [db open];
    
    FMResultSet *results=[db executeQuery:@"SELECT attendancecount, absencecount, latecount FROM count_up_record_table WHERE id = (SELECT MAX(id) FROM count_up_record_table WHERE indexPath = ?);",[NSString stringWithFormat:@"%ld",(long)_indexPath.row]];
    
    while ([results next]) {
        attendanceCountOfMaxIdString=[results stringForColumn:@"attendancecount"];
        absenceCountOfMaxIdString=[results stringForColumn:@"absencecount"];
        lateCountOfMaxIdString=[results stringForColumn:@"latecount"];
    }
    [db close];
    
    return @[attendanceCountOfMaxIdString,absenceCountOfMaxIdString,lateCountOfMaxIdString];
}

//最大idの各カウントを取得し各カウントを1up or 1down
-(NSArray *)selectCountsOfMaxIdAndCreateUpDownNewCounts:(int)plusminus{
    
    NSArray *countsOfMaxId=[self selectCountsOfMaxId];
    NSString *attendanceCountOfMaxIdString=countsOfMaxId[0];//NS_ENUM
    NSString *absenceCountOfMaxIdString=countsOfMaxId[1];
    NSString *lateCountOfMaxIdString=countsOfMaxId[2];
    
    NSString *renewAttendanceCountOfMaxIdString=[NSString stringWithFormat:@"%d",attendanceCountOfMaxIdString.intValue+plusminus];
    NSString *renewAbsenceCountOfMaxIdString=[NSString stringWithFormat:@"%d",absenceCountOfMaxIdString.intValue+plusminus];
    NSString *renewLateCountOfMaxIdString=[NSString stringWithFormat:@"%d",lateCountOfMaxIdString.intValue+plusminus];
    
    return @[renewAttendanceCountOfMaxIdString,renewAbsenceCountOfMaxIdString,renewLateCountOfMaxIdString];
}
@end
