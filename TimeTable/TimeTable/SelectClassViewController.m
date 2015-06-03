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
#import "DatabaseOfCreateClassTable.h"
#import "DatabaseOfSelectClassTable.h"
#import "TitleLabel.h"

@interface SelectClassViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong,nonatomic) NSMutableArray *classes;
@property (strong,nonatomic) NSMutableArray *teachers;

@property (strong,nonatomic) NSString *cellclassroomNameString;

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
    /*UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.text=@"授業選択";
    [titleLabel sizeToFit];*/
    self.navigationItem.titleView=[TitleLabel createTitlelabel:@"授業選択"];  
    
    self.navigationController.navigationBar.tintColor=[UIColor blackColor];//バーアイテムカラー
    self.navigationController.navigationBar.barTintColor=[UIColor blueColor];//バー背景色
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                              initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                              target:self
                              action:@selector(addButtontouched:)];
    
    self.navigationItem.rightBarButtonItem=addButton;
    
    //xibファイルを紐付けたカスタムセル用クラスを指定。セル再利用のためのIDを第二引数で指定。
    [self.tableView registerNib:[UINib nibWithNibName:@"ClassListCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self createEmptyArrays];
    
    [DatabaseOfCreateClassTable createCreateClassTable];
        
    FMDatabase *db=[DatabaseOfCreateClassTable getDatabaseOfcreateclass];
        
    [db open];
        
    FMResultSet *results=[db executeQuery:@"SELECT className, teacherName, classroomName FROM createclasstable;"];
    while ([results next]) {
            [_classes addObject:[results stringForColumn:@"className"]];
            [_teachers addObject:[results stringForColumn:@"teacherName"]];
            
    }
        
    [db close];
        
    [self.tableView reloadData];
    [super viewWillAppear:animated];
    
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
    
    cell.textLabel.text=_classes[indexPath.row];
    cell.detailTextLabel.text=_teachers[indexPath.row];
    
    cell.detailTextLabel.textColor=[UIColor grayColor];
    cell.selectionStyle=UITableViewCellSelectionStyleBlue;
    
    //中央寄せに設定できない
    cell.detailTextLabel.textAlignment=NSTextAlignmentCenter;
    return cell;
                         
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return _classes.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//編集可能かどうか、表示されきったときに呼び出される
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return  YES;
}

//編集モードを呼び出す
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - UITableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:indexPath];
    
    FMDatabase *onedb=[DatabaseOfCreateClassTable getDatabaseOfcreateclass];
    [onedb open];
    
    FMResultSet *results=[onedb executeQuery:@"SELECT classroomName FROM createclasstable WHERE className = ? AND teacherName = ?;",cell.textLabel.text,cell.detailTextLabel.text];
    while ([results next]) {
        _cellclassroomNameString=[results stringForColumn:@"classroomName"];
    }
    [onedb close];
    
    [DatabaseOfSelectClassTable createSelectClassTable];
    FMDatabase *twodb=[DatabaseOfSelectClassTable getDatabaseOfselectclass];
    [twodb open];
    
    [twodb executeUpdate:@"INSERT INTO selectclasstable (className, teacherName, classroomName, indexPath) VALUES  (?, ?, ?, ?);",cell.textLabel.text,cell.detailTextLabel.text,_cellclassroomNameString,[NSString stringWithFormat:@"%ld",(long)_indexPath.row]];
    
    [twodb close];
    
    //前の画面に戻る前に更新
    //UINavigationControllerで遷移してきた過去のビューはself.navigationController.viewControllersに保存
    NSArray *allControllers = self.navigationController.viewControllers;
    NSInteger target = [allControllers count] - 2;
    TimeTableViewController *parent = [allControllers objectAtIndex:target];
    [parent.collectionView reloadSections:[NSIndexSet indexSetWithIndex:_indexPath.section]];

    [self.navigationController popViewControllerAnimated:YES];
    
}

//スワイプで出てくるコマンド設定
-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //削除ボタン
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:indexPath];
        
        FMDatabase *db=[DatabaseOfCreateClassTable getDatabaseOfcreateclass];
        
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
        
        FMDatabase *db=[DatabaseOfCreateClassTable getDatabaseOfcreateclass];
        
        [db open];
        //セルの授業名、教室名に対応する教室名を取得
        FMResultSet *results=[db executeQuery:@"SELECT classroomName FROM createclasstable WHERE className = ? AND teacherName = ?;",cell.textLabel.text,cell.detailTextLabel.text];
        
        while ([results next]) {
            _cellclassroomNameString=[results stringForColumn:@"classroomName"];
        }
        
        [db close];
        
        viewController.classroomNameString=_cellclassroomNameString;
        
        [self.navigationController pushViewController:viewController animated:YES];

    }];
    
    editAction.backgroundColor=[UIColor greenColor];
    
    return @[deleteAction,editAction];
}

#pragma mark - TableView Methods

-(void)deleteTableViewCell{
    
    [self createEmptyArrays];
    
    [DatabaseOfCreateClassTable createCreateClassTable];
    FMDatabase *db=[DatabaseOfCreateClassTable getDatabaseOfcreateclass];
    
    [db open];
    
    FMResultSet *results=[db executeQuery:@"SELECT className, teacherName, classroomName FROM createclasstable;"];
    
    while ([results next]) {
        [_classes addObject:[results stringForColumn:@"className"]];
        [_teachers addObject:[results stringForColumn:@"teacherName"]];
        
    }
    
    [db close];
}

-(void)createEmptyArrays{
    _classes=[[NSMutableArray alloc]init];
    _teachers=[[NSMutableArray array]init];
    
}
@end
