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
    
    //戻ったときにフェードアウトして非選択状態に戻る
    [_tableView deselectRowAtIndexPath:_tableView.indexPathForSelectedRow animated:YES];
    
    if (_classes.count>0 && _teachers.count>0 && _classrooms.count>0) {
        
       
        SelectClassViewController *viewController=[[SelectClassViewController alloc]init];
        
        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *dbPathString=paths[0];
        FMDatabase *db=[FMDatabase databaseWithPath:[dbPathString stringByAppendingPathComponent:@"createclass.db"]];
        [db open];
        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS createclasstable (id INTEGER PRIMARY KEY AUTOINCREMENT, className TEXT, teacherName TEXT, classroomName TEXT);"];
        
        FMResultSet *results=[db executeQuery:@"SELECT className, teacherName　FROM createclasstable　WHERE id= (SELECT MAX(id) FROM createclasstable);"];
        while ([results next]) {
            [viewController.classes addObject:[results stringForColumn:@"className"]];
            [viewController.teachers addObject:[results stringForColumn:@"teacherName"]];
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

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    NSArray *managedViewControllers = self.navigationController.viewControllers;
    NSInteger arrayCount = [managedViewControllers count];
    
    TimeTableViewController *viewController = managedViewControllers[arrayCount - 1];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:indexPath];
    
    viewController.classNameString = cell.textLabel.text;
    viewController.row=_row;
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

#pragma mark - UITableView Methods

/*-(void)reload{
    
    
}*/

#pragma mark - UITableView DataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ClassListCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if(!cell){
    cell=[[ClassListCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text=_classes[indexPath.section];
    cell.detailTextLabel.text=_teachers[indexPath.section];
    cell.cellClassroomNameString=_classrooms[indexPath.section];
    
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

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return  YES;
}

//編集モードを呼び出す
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - UITableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
    NSArray *selectclassPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *selectclassdbPathString=selectclassPaths[0];
    FMDatabase *selectclassdb=[FMDatabase databaseWithPath:[selectclassdbPathString stringByAppendingPathComponent:@"selectclass.db"]];
    //DBファイル名を定数
    [selectclassdb open];
    [selectclassdb executeUpdate:@"CREATE TABLE IF NOT EXISTS selectclasstable (id INTEGER PRIMARY KEY AUTOINCREMENT, className TEXT, teacherName TEXT, classroomName TEXT);"];
    
    NSLog(@"%@",[selectclassdbPathString stringByAppendingPathComponent:@"selectclass.db"]);
    
    [selectclassdb close];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
    
    
    
    
    

    
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

    
    
    
    
    
    
    
    
    
    
    
}

//スワイプで出てくるコマンド設定
-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //削除ボタン
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        //セル表示の元となるデータ削除
        [_classes removeObjectAtIndex:indexPath.section];
        
        //セル表示の元となるデータとセル表示を同期させるため、セル削除
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        NSLog(@"abc");
        
        
    }];
    
    //編集ボタン
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"edit" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        UpdateClassViewController *viewController=[[UpdateClassViewController alloc]init];
        
        //indexPathを指定して呼び出しすることでCellを取り出せる
        /*UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:indexPath];
        
        viewController.classNameString=cell.textLabel.text;
        viewController.teacherNameString=cell.detailTextLabel.text;
        viewController.classroomNameString=@"";//_classrooms[indexPath.section];
        viewController.title=@"授業詳細";*/
        
        [self.navigationController pushViewController:viewController animated:YES];

        
        
        NSLog(@"Edit:%@", indexPath);
    }];
    
    editAction.backgroundColor=[UIColor greenColor];
    
    return @[deleteAction,editAction];
}

@end
