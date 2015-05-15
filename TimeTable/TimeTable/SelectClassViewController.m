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


@interface SelectClassViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *classes;
@property (strong,nonatomic) NSMutableArray *teachers;
@property (strong,nonatomic) NSMutableArray *classrooms;

@end

@implementation SelectClassViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //空リスト生成
    _classes=[NSMutableArray array];
    _teachers=[NSMutableArray array];
    _classrooms=[NSMutableArray array];
    
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
    
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    //空リスト生成
    _classes=[NSMutableArray array];
    _teachers=[NSMutableArray array];
    _classrooms=[NSMutableArray array];
    
    
    if (_classes.count>0 && _teachers.count>0) {
        
        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *dbPathString=paths[0];
        FMDatabase *db=[FMDatabase databaseWithPath:[dbPathString stringByAppendingPathComponent:@"createclass.db"]];
        [db open];
        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS createclasstable (id INTEGER PRIMARY KEY AUTOINCREMENT, className TEXT, teacherName TEXT, classroomName TEXT);"];
        
        FMResultSet *results=[db executeQuery:@"SELECT className, teacherName　FROM createclasstable　WHERE id= (SELECT MAX(id) FROM createclasstable);"];
        while ([results next]) {
            [_classes addObject:[results stringForColumn:@"className"]];
            [_teachers addObject:[results stringForColumn:@"teacherName"]];
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
        
        FMResultSet *results=[db executeQuery:@"SELECT className, teacherName FROM createclasstable;"];
        while ([results next]) {
            [_classes addObject:[results stringForColumn:@"className"]];
            [_teachers addObject:[results stringForColumn:@"teacherName"]];
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
    cell.textLabel.text=_classes[indexPath.section];
    cell.detailTextLabel.text=_teachers[indexPath.section];
    cell.detailTextLabel.textColor=[UIColor grayColor];
    cell.selectionStyle=UITableViewCellSelectionStyleBlue;
    
    //中央寄せに設定できない
    cell.textLabel.textAlignment=NSTextAlignmentCenter;
    return cell;
                         
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _classes.count;
}

#pragma mark - UITableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //selectclasstable内の授業名、教員名に対応した教室名取得
    /*NSArray *paths1=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dbPathString1=paths1[0];
    FMDatabase *db1=[FMDatabase databaseWithPath:[dbPathString1 stringByAppendingPathComponent:@"createclass.db"]];
    [db1 open];
    [db1 executeUpdate:@"CREATE TABLE IF NOT EXISTS createclasstable (id INTEGER PRIMARY KEY AUTOINCREMENT, className TEXT, teacherName TEXT, classroomName TEXT);"];
    
    FMResultSet *results=[db1 executeQuery:@"SELECT classroomName FROM createclasstable WHERE ;"];
    while ([results next]) {
        [_classrooms addObject:[results stringForColumn:@"className"]];
        
    }
    
    [db1 close];*/

    
    
    
    UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:indexPath];
    
    NSArray *paths2=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dbPathString2=paths2[0];
    FMDatabase *db2=[FMDatabase databaseWithPath:[dbPathString2 stringByAppendingPathComponent:@"selectclass.db"]];
    //DBファイル名を定数
    [db2 open];
    [db2 executeUpdate:@"INSERT INTO selectclasstable (className) VALUES  (?, ?);",cell.textLabel.text];
    
    NSLog(@"%@",[dbPathString2 stringByAppendingPathComponent:@"selectclass.db"]);
    
    [db2 close];
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
    
    
}





@end
