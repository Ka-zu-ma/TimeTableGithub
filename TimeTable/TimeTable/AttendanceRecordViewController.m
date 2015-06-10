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
#import "NavigationBar.h"
#import "DatabaseOfDateAndAttendanceRecordTable.h"
#import "CommonMethodsOfDatabase.h"
#import "DatabaseOfCountUpRecordTable.h"

@interface AttendanceRecordViewController ()<UITableViewDelegate,UITableViewDataSource,CountUpDelegate>
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
    
    self.navigationItem.titleView=[TitleLabel createTitlelabel:@"出席状況"];
    
    //バー背景色
    self.navigationController.navigationBar.tintColor=[UIColor blackColor];//バーアイテムカラー
    self.navigationController.navigationBar.barTintColor=[UIColor blueColor];//バー背景色
    
    //[self.navigationController setView:[NavigationBar setColor]];//バー背景色
    
    //[NavigationBar setColor];

    //授業削除ボタンの枠を丸くする
    [[_deleteClassButton layer] setCornerRadius:10.0];
    [_deleteClassButton setClipsToBounds:YES];
    
    //nibファイル登録
    UINib *nib1=[UINib nibWithNibName:@"CountUpCell" bundle:nil];
    [self.tableView registerNib:nib1 forCellReuseIdentifier:@"CountUpCell"];
    
    UINib *nib2=[UINib nibWithNibName:@"DateCell" bundle:nil];
    [self.tableView registerNib:nib2 forCellReuseIdentifier:@"DateCell"];
    
    _tableView.contentInset=UIEdgeInsetsMake(-1.0f,0.0, 0.0, 0.0);
    
    [DatabaseOfCountUpRecordTable createCountUpRecordTable];
    
    NSString *indexPathRowString=[NSString stringWithFormat:@"%ld",(long)_indexPath.row];
    
    if (![[DatabaseOfCountUpRecordTable selectIndexPath] containsObject:indexPathRowString]) {
        [self insertInitialValueOfCounts];
    }
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    
    _dates=[[NSMutableArray alloc]init];
    _attendanceOrAbsenceOrLates=[[NSMutableArray alloc]init];

    [DatabaseOfDateAndAttendanceRecordTable createTable];
    
    NSString *indexPathRowString=[NSString stringWithFormat:@"%ld",(long)_indexPath.row];//クラス内でどこからでもアクセスできるインスタンス変数を引数に渡すのはあまり意味がないので、ローカル変数で渡す
    
    _dates=[DatabaseOfDateAndAttendanceRecordTable selectDateAndAttendanceRecord:indexPathRowString][0];
    _attendanceOrAbsenceOrLates=[DatabaseOfDateAndAttendanceRecordTable selectDateAndAttendanceRecord:indexPathRowString][1];
    
    _attendanceCountString=[DatabaseOfCountUpRecordTable selectCountUpRecordTableToGetCountsWhereMaxIdWhereIndexPath:indexPathRowString][attendanceCountString];
    _absenceCountString=[DatabaseOfCountUpRecordTable selectCountUpRecordTableToGetCountsWhereMaxIdWhereIndexPath:indexPathRowString][absenceCountString];
    _lateCountString=[DatabaseOfCountUpRecordTable selectCountUpRecordTableToGetCountsWhereMaxIdWhereIndexPath:indexPathRowString][lateCountString];
    
    [self.tableView reloadData];
    
    //[super viewWillAppear:animated];
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CountUp Delegate

-(void)attendanceCountUp{
    
    _dates=[[NSMutableArray alloc]init];
    _attendanceOrAbsenceOrLates=[[NSMutableArray alloc]init];
    
    NSString *indexPathString=[NSString stringWithFormat:@"%ld",(long)_indexPath.row];
    
    [DatabaseOfCountUpRecordTable insertCountUpRecordTable:[self selectCountsOfMaxIdAndCreateUpDownNewCounts:1][0] absencecount:[DatabaseOfCountUpRecordTable selectCountUpRecordTableToGetCountsWhereMaxIdWhereIndexPath:indexPathString][absenceCountString] latecount:[DatabaseOfCountUpRecordTable selectCountUpRecordTableToGetCountsWhereMaxIdWhereIndexPath:indexPathString][lateCountString] indexPathRow:indexPathString];
    
    [DatabaseOfDateAndAttendanceRecordTable insertDateAndAttendanceRecord:[super getToday] attendanceRecord:@"出席" indexPathRow:indexPathString];
    
    _dates=[DatabaseOfDateAndAttendanceRecordTable selectDateAndAttendanceRecord:indexPathString][0];
    _attendanceOrAbsenceOrLates=[DatabaseOfDateAndAttendanceRecordTable selectDateAndAttendanceRecord:indexPathString][1];
    
    _attendanceCountString=[DatabaseOfCountUpRecordTable selectCountUpRecordTableToGetCountsWhereMaxIdWhereIndexPath:indexPathString][attendanceCountString];
    _absenceCountString=[DatabaseOfCountUpRecordTable selectCountUpRecordTableToGetCountsWhereMaxIdWhereIndexPath:indexPathString][absenceCountString];
    _lateCountString=[DatabaseOfCountUpRecordTable selectCountUpRecordTableToGetCountsWhereMaxIdWhereIndexPath:indexPathString][lateCountString];

    [self.tableView reloadData];
}

-(void)absenceCountUp{
    
    _dates=[[NSMutableArray alloc]init];
    _attendanceOrAbsenceOrLates=[[NSMutableArray alloc]init];
    
    NSString *indexPathString=[NSString stringWithFormat:@"%ld",(long)_indexPath.row];
    
    [DatabaseOfCountUpRecordTable insertCountUpRecordTable:[DatabaseOfCountUpRecordTable selectCountUpRecordTableToGetCountsWhereMaxIdWhereIndexPath:indexPathString][attendanceCountString] absencecount:[self selectCountsOfMaxIdAndCreateUpDownNewCounts:1][1] latecount:[DatabaseOfCountUpRecordTable selectCountUpRecordTableToGetCountsWhereMaxIdWhereIndexPath:indexPathString][lateCountString] indexPathRow:indexPathString];
    
    [DatabaseOfDateAndAttendanceRecordTable insertDateAndAttendanceRecord:[super getToday] attendanceRecord:@"欠席" indexPathRow:indexPathString];
    
    _dates=[DatabaseOfDateAndAttendanceRecordTable selectDateAndAttendanceRecord:indexPathString][0];
    _attendanceOrAbsenceOrLates=[DatabaseOfDateAndAttendanceRecordTable selectDateAndAttendanceRecord:indexPathString][1];
    
    _attendanceCountString=[DatabaseOfCountUpRecordTable selectCountUpRecordTableToGetCountsWhereMaxIdWhereIndexPath:indexPathString][attendanceCountString];
    _absenceCountString=[DatabaseOfCountUpRecordTable selectCountUpRecordTableToGetCountsWhereMaxIdWhereIndexPath:indexPathString][absenceCountString];
    _lateCountString=[DatabaseOfCountUpRecordTable selectCountUpRecordTableToGetCountsWhereMaxIdWhereIndexPath:indexPathString][lateCountString];
    
    [self.tableView reloadData];
}

-(void)lateCountUp{
    
    _dates=[[NSMutableArray alloc]init];
    _attendanceOrAbsenceOrLates=[[NSMutableArray alloc]init];
    
    NSString *indexPathString=[NSString stringWithFormat:@"%ld",(long)_indexPath.row];
    
    [DatabaseOfCountUpRecordTable insertCountUpRecordTable:[DatabaseOfCountUpRecordTable selectCountUpRecordTableToGetCountsWhereMaxIdWhereIndexPath:indexPathString][attendanceCountString] absencecount:[DatabaseOfCountUpRecordTable selectCountUpRecordTableToGetCountsWhereMaxIdWhereIndexPath:indexPathString][absenceCountString] latecount:[self selectCountsOfMaxIdAndCreateUpDownNewCounts:1][2] indexPathRow:indexPathString];
    
    [DatabaseOfDateAndAttendanceRecordTable insertDateAndAttendanceRecord:[super getToday] attendanceRecord:@"遅刻" indexPathRow:indexPathString];
    
    _dates=[DatabaseOfDateAndAttendanceRecordTable selectDateAndAttendanceRecord:indexPathString][0];
    _attendanceOrAbsenceOrLates=[DatabaseOfDateAndAttendanceRecordTable selectDateAndAttendanceRecord:indexPathString][1];
    
    _attendanceCountString=[DatabaseOfCountUpRecordTable selectCountUpRecordTableToGetCountsWhereMaxIdWhereIndexPath:indexPathString][attendanceCountString];
    _absenceCountString=[DatabaseOfCountUpRecordTable selectCountUpRecordTableToGetCountsWhereMaxIdWhereIndexPath:indexPathString][absenceCountString];
    _lateCountString=[DatabaseOfCountUpRecordTable selectCountUpRecordTableToGetCountsWhereMaxIdWhereIndexPath:indexPathString][lateCountString];

    [self.tableView reloadData];
}

#pragma mark - UITableView DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0){
        return 1;
    }
    return _dates.count;
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
            
        } else if([_attendanceOrAbsenceOrLates[indexPath.row] isEqual:@"欠席"]){
            dateCell.detailTextLabel.textColor=[UIColor blueColor];
            
        }else{
        
            dateCell.detailTextLabel.textColor=[UIColor greenColor];
        }
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
                
         return 130;
    }
    return 40;
}

//編集モードを呼び出す
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //削除ボタン
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:indexPath];
        
        NSString *indexPathString=[NSString stringWithFormat:@"%ld",(long)_indexPath.row];
        
        [DatabaseOfDateAndAttendanceRecordTable delete:cell.textLabel.text attendancerecord:cell.detailTextLabel.text indexPathRow:indexPathString];

        if ([cell.detailTextLabel.text isEqual:@"出席"]) {
            
            //出席カウントを1減らす
            [DatabaseOfCountUpRecordTable insertCountUpRecordTable:[self selectCountsOfMaxIdAndCreateUpDownNewCounts:-1][0] absencecount:[DatabaseOfCountUpRecordTable selectCountUpRecordTableToGetCountsWhereMaxIdWhereIndexPath:indexPathString][absenceCountString] latecount:[DatabaseOfCountUpRecordTable selectCountUpRecordTableToGetCountsWhereMaxIdWhereIndexPath:indexPathString][lateCountString] indexPathRow:indexPathString];
            
            _attendanceCountString=[DatabaseOfCountUpRecordTable selectCountUpRecordTableToGetCountsWhereMaxIdWhereIndexPath:indexPathString][attendanceCountString];
            _absenceCountString=[DatabaseOfCountUpRecordTable selectCountUpRecordTableToGetCountsWhereMaxIdWhereIndexPath:indexPathString][absenceCountString];
            _lateCountString=[DatabaseOfCountUpRecordTable selectCountUpRecordTableToGetCountsWhereMaxIdWhereIndexPath:indexPathString][lateCountString];
            
        }else if ([cell.detailTextLabel.text isEqual:@"欠席"]){
            
            //欠席カウント1減らす
            [DatabaseOfCountUpRecordTable insertCountUpRecordTable:[DatabaseOfCountUpRecordTable selectCountUpRecordTableToGetCountsWhereMaxIdWhereIndexPath:indexPathString][attendanceCountString] absencecount:[self selectCountsOfMaxIdAndCreateUpDownNewCounts:-1][1] latecount:[DatabaseOfCountUpRecordTable selectCountUpRecordTableToGetCountsWhereMaxIdWhereIndexPath:indexPathString][lateCountString] indexPathRow:indexPathString];
    
            _attendanceCountString=[DatabaseOfCountUpRecordTable selectCountUpRecordTableToGetCountsWhereMaxIdWhereIndexPath:indexPathString][attendanceCountString];
            _absenceCountString=[DatabaseOfCountUpRecordTable selectCountUpRecordTableToGetCountsWhereMaxIdWhereIndexPath:indexPathString][absenceCountString];
            _lateCountString=[DatabaseOfCountUpRecordTable selectCountUpRecordTableToGetCountsWhereMaxIdWhereIndexPath:indexPathString][lateCountString];
            
        }else if ([cell.detailTextLabel.text isEqual:@"遅刻"]){
            //遅刻カウント1減らす
            [DatabaseOfCountUpRecordTable insertCountUpRecordTable:[DatabaseOfCountUpRecordTable selectCountUpRecordTableToGetCountsWhereMaxIdWhereIndexPath:indexPathString][attendanceCountString] absencecount:[DatabaseOfCountUpRecordTable selectCountUpRecordTableToGetCountsWhereMaxIdWhereIndexPath:indexPathString][absenceCountString] latecount:[self selectCountsOfMaxIdAndCreateUpDownNewCounts:-1][2] indexPathRow:indexPathString];
            
            _attendanceCountString=[DatabaseOfCountUpRecordTable selectCountUpRecordTableToGetCountsWhereMaxIdWhereIndexPath:indexPathString][attendanceCountString];
            _absenceCountString=[DatabaseOfCountUpRecordTable selectCountUpRecordTableToGetCountsWhereMaxIdWhereIndexPath:indexPathString][absenceCountString];
            _lateCountString=[DatabaseOfCountUpRecordTable selectCountUpRecordTableToGetCountsWhereMaxIdWhereIndexPath:indexPathString][lateCountString];
            
        }
        //セクション指定して更新
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        
        [_dates removeObjectAtIndex:indexPath.row];
        [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
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
    
    NSString *indexPathString=[NSString stringWithFormat:@"%ld",(long)_indexPath.row];

    [CommonMethodsOfDatabase delete:@"count_up_record.db" query:@"DELETE FROM count_up_record_table WHERE indexPath = ?;" indexPathRow:indexPathString];
    
    [CommonMethodsOfDatabase delete:@"date_attendancerecord.db" query:@"DELETE FROM date_attendancerecord_table WHERE indexPath = ?;" indexPathRow:indexPathString];
    
    [CommonMethodsOfDatabase delete:@"selectclass.db" query:@"DELETE FROM selectclasstable WHERE indexPath = ?;" indexPathRow:indexPathString];
    
    //前の画面に戻る前に更新
    NSArray *allControllers = self.navigationController.viewControllers;
    NSInteger target = [allControllers count] - 2;
    TimeTableViewController *parent = allControllers[target];
    [parent.collectionView reloadSections:[NSIndexSet indexSetWithIndex:_indexPath.section]];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Original Methods

-(void)insertInitialValueOfCounts{
    
    NSString *indexPathRowString=[NSString stringWithFormat:@"%ld",(long)_indexPath.row];
    
    [DatabaseOfCountUpRecordTable insertInitialValueCountUpRecordTable:indexPathRowString];
}

//最大idの各カウントを取得し各カウントを1up or 1down
-(NSArray *)selectCountsOfMaxIdAndCreateUpDownNewCounts:(int)plusminus{
    
    NSString *indexPathString=[NSString stringWithFormat:@"%ld",(long)_indexPath.row];

    NSArray *countsOfMaxId=[DatabaseOfCountUpRecordTable selectCountUpRecordTableToGetCountsWhereMaxIdWhereIndexPath:indexPathString];
    
    NSString *attendanceCountOfMaxIdString=countsOfMaxId[0];//NS_ENUM
    NSString *absenceCountOfMaxIdString=countsOfMaxId[1];
    NSString *lateCountOfMaxIdString=countsOfMaxId[2];
    
    NSString *renewAttendanceCountOfMaxIdString=[NSString stringWithFormat:@"%d",attendanceCountOfMaxIdString.intValue+plusminus];
    NSString *renewAbsenceCountOfMaxIdString=[NSString stringWithFormat:@"%d",absenceCountOfMaxIdString.intValue+plusminus];
    NSString *renewLateCountOfMaxIdString=[NSString stringWithFormat:@"%d",lateCountOfMaxIdString.intValue+plusminus];
    
    return @[renewAttendanceCountOfMaxIdString,renewAbsenceCountOfMaxIdString,renewLateCountOfMaxIdString];
}
@end
