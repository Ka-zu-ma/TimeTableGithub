//
//  SelectClassViewController.m
//  TimeTable
//
//  Created by SDT-B004 on 2015/05/01.
//  Copyright (c) 2015年 SDT-B004. All rights reserved.
//

#import "SelectClassViewController.h"
#import "CreateClassViewController.h"
#import "ClassListCell.h"
#import "FMDatabase.h"
#import "TimeTableViewController.h"
#import "UpdateClassViewController.h"
#import "SuperSelectClassViewController.h"

@interface SelectClassViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *classes;
@property (strong,nonatomic) NSMutableArray *teachers;
@property (strong,nonatomic) NSMutableArray *classrooms;
@property NSString *cellclassroomNameString;

-(void)deleteTableViewCell;
@end

@implementation SelectClassViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView.delegate=self;
    _tableView.dataSource=self;
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationItem.title=@"授業選択";
    
    //タイトル色変更
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.text=@"授業選択";
    [titleLabel sizeToFit];
    self.navigationItem.titleView=titleLabel;  //親クラス作って共通化
    
    self.navigationController.navigationBar.tintColor=[UIColor blackColor];//バーアイテムカラー
    self.navigationController.navigationBar.barTintColor=[UIColor blueColor];//バー背景色
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                              initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                              target:self
                              action:@selector(addButtontouched:)];
    
    self.navigationItem.rightBarButtonItem=addButton;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ClassListCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    //NSLog(@"row=%ld",(long)_row);
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    
    //空リスト生成
    _classes=[NSMutableArray array];
    _teachers=[NSMutableArray array];
    _classrooms=[NSMutableArray array];

    //戻ったときにフェードアウトして非選択状態に戻る
    //[_tableView deselectRowAtIndexPath:_tableView.indexPathForSelectedRow animated:YES];
    
    if (_classes.count>0 && _teachers.count>0 && _classrooms.count>0) {
        
        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *dbPathString=paths[0];
        FMDatabase *db=[FMDatabase databaseWithPath:[dbPathString stringByAppendingPathComponent:@"createclass.db"]];
        [db open];
        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS createclasstable (id INTEGER PRIMARY KEY AUTOINCREMENT, className TEXT, teacherName TEXT, classroomName TEXT);"];
        
        FMResultSet *results=[db executeQuery:@"SELECT className, teacherName, classroomName　FROM createclasstable　WHERE id= (SELECT MAX(id) FROM createclasstable);"];
        
        while ([results next]) {
            [_classes addObject:[results stringForColumn:@"className"]];
            [_teachers addObject:[results stringForColumn:@"teacherName"]];
            [_classrooms addObject:[results stringForColumn:@"classroomName"]];
        }
        
        [db close];
        
        [self.tableView reloadData];
        [super viewWillAppear:animated];
        
    }else{
        
        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *dbPathString=paths[0];
        FMDatabase *db=[FMDatabase databaseWithPath:[dbPathString stringByAppendingPathComponent:@"createclass.db"]];
        [db open];
        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS createclasstable (id INTEGER PRIMARY KEY AUTOINCREMENT, className TEXT, teacherName TEXT, classroomName TEXT);"];
        
        FMResultSet *results=[db executeQuery:@"SELECT className, teacherName, classroomName FROM createclasstable;"];
        while ([results next]) {
            [_classes addObject:[results stringForColumn:@"className"]];
            [_teachers addObject:[results stringForColumn:@"teacherName"]];
            [_classrooms addObject:[results stringForColumn:@"classroomName"]];
        }
        
        [db close];
        
        [self.tableView reloadData];
        [super viewWillAppear:animated];
        
    }
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - BarButtonItem Methods

-(void)addButtontouched:(UIBarButtonItem *)addButton{
    
    CreateClassViewController *viewController=[[CreateClassViewController alloc]init];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - UITableView DataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ClassListCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if(!cell){
    cell=[[ClassListCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text=_classes[indexPath.row];
    cell.detailTextLabel.text=_teachers[indexPath.row];
    
    
    cell.detailTextLabel.textColor=[UIColor grayColor];
    cell.selectionStyle=UITableViewCellSelectionStyleBlue;
    
    //中央寄せに設定できない
    cell.textLabel.textAlignment=NSTextAlignmentCenter;
    return cell;
                         
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return _classes.count; //1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1; //_classes.count;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return  YES;
}

//編集モードを呼び出す
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - UITableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:indexPath];
    
    NSArray *createpaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *createdbPathString=createpaths[0];
    FMDatabase *createdb=[FMDatabase databaseWithPath:[createdbPathString stringByAppendingPathComponent:@"createclass.db"]];
    [createdb open];
    
    FMResultSet *results=[createdb executeQuery:@"SELECT classroomName FROM createclasstable WHERE className = ? AND teacherName = ?;",cell.textLabel.text,cell.detailTextLabel.text];
    while ([results next]) {
        _cellclassroomNameString=[results stringForColumn:@"classroomName"];
    }
    [createdb close];
    
    
    NSArray *Paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dbPathString=Paths[0];
    FMDatabase *db=[FMDatabase databaseWithPath:[dbPathString stringByAppendingPathComponent:@"selectclass.db"]];
    //DBファイル名を定数にする
    
    [db open];
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS selectclasstable (id INTEGER PRIMARY KEY AUTOINCREMENT, className TEXT, teacherName TEXT, classroomName TEXT, indexPath);"];
    
    NSLog(@"%@",[dbPathString stringByAppendingPathComponent:@"selectclass.db"]);
    
    
    
    [db executeUpdate:@"INSERT INTO selectclasstable (className, teacherName, classroomName, indexPath) VALUES  (?, ?, ?, ?);",cell.textLabel.text,cell.detailTextLabel.text,_cellclassroomNameString,_indexPath];//セルが持ってるclassroomNameプロパティをcreateclasstableからとってきてそれを入れないといけない
    
    [db close];

    [self.navigationController popViewControllerAnimated:YES];
    
}

//スワイプで出てくるコマンド設定
-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //削除ボタン
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:indexPath];
        
        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *dbPathString=paths[0];
        FMDatabase *db=[FMDatabase databaseWithPath:[dbPathString stringByAppendingPathComponent:@"createclass.db"]];
        [db open];
        
        FMResultSet *results=[db executeQuery:@"SELECT classroomName FROM createclasstable WHERE className = ? AND teacherName = ?;",cell.textLabel.text,cell.detailTextLabel.text];
        
        while ([results next]) {
            _cellclassroomNameString=[results stringForColumn:@"classroomName"];
        }
        
        [db executeUpdate:@"DELETE FROM createclasstable WHERE className = ? AND teacherName = ? AND classroomName = ?",cell.textLabel.text,cell.detailTextLabel.text,_cellclassroomNameString];
        [db close];
        
        [self deleteTableViewCell];
        
        [self.tableView reloadData];
    }];
    
    //編集ボタン
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"edit" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        UpdateClassViewController *viewController=[[UpdateClassViewController alloc]init];
        
        //indexPathを指定して呼び出しすることでcellを取り出せる
        UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:indexPath];
        
        viewController.classNameString=cell.textLabel.text;
        viewController.teacherNameString=cell.detailTextLabel.text;
        
        //セルの授業名、教室名に対応する教室名を取得
        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *dbPathString=paths[0];
        FMDatabase *db=[FMDatabase databaseWithPath:[dbPathString stringByAppendingPathComponent:@"createclass.db"]];
        [db open];
        
        FMResultSet *results=[db executeQuery:@"SELECT classroomName FROM createclasstable WHERE className = ? AND teacherName = ?;",cell.textLabel.text,cell.detailTextLabel.text];
        
        while ([results next]) {
            _cellclassroomNameString=[results stringForColumn:@"classroomName"];
        }
        
        [db close];
        
        viewController.classroomNameString=_cellclassroomNameString;
        
        [self.navigationController pushViewController:viewController animated:YES];

        
        
        //NSLog(@"Edit:%@", indexPath);
    }];
    
    editAction.backgroundColor=[UIColor greenColor];
    
    return @[deleteAction,editAction];
}

#pragma mark - TableView Methods

-(void)deleteTableViewCell{
    
    //空リスト生成
    _classes=[NSMutableArray array];
    _teachers=[NSMutableArray array];
    _classrooms=[NSMutableArray array];
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dbPathString=paths[0];
    FMDatabase *db=[FMDatabase databaseWithPath:[dbPathString stringByAppendingPathComponent:@"createclass.db"]];
    [db open];
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS createclasstable (id INTEGER PRIMARY KEY AUTOINCREMENT, className TEXT, teacherName TEXT, classroomName TEXT);"];
    
    FMResultSet *results=[db executeQuery:@"SELECT className, teacherName, classroomName FROM createclasstable WHERE id = (SELECT MAX(id) FROM createclasstable);"];
    
    while ([results next]) {
        [_classes addObject:[results stringForColumn:@"className"]];
        [_teachers addObject:[results stringForColumn:@"teacherName"]];
        [_classrooms addObject:[results stringForColumn:@"classroomName"]];
    }
    
    [db close];
}
@end
