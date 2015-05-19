//
//  TimeTableViewController.m
//  TimeTable
//
//  Created by SDT-B004 on 2015/05/01.
//  Copyright (c) 2015年 SDT-B004. All rights reserved.
//

#import "TimeTableViewController.h"
#import "DayOfWeekCell.h"
#import "ClassTableCell.h"
#import "SelectClassViewController.h"
#import "AttendanceRecordViewController.h"
#import "CreateClassViewController.h"
#import "FMDatabase.h"

@interface TimeTableViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong,nonatomic) NSMutableArray *weeks;
@property (strong,nonatomic) NSMutableArray *classTimes;
@property (strong,nonatomic) NSMutableArray *classNames;
@property (strong,nonatomic) NSMutableArray *classroomNames;

extern const int userRegisteredWeekCount; //ユーザーが登録した週の日数
extern const int userRegisteredClassCount; //ユーザーが登録した授業コマ数

@end

@implementation TimeTableViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _weeks=[NSMutableArray array];
    _classTimes=[NSMutableArray array];
    
    NSArray *weekContents=@[@"月",@"火",@"水",@"木",@"金",@"土",@"日"];
    NSArray *classTimesContents=@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10"];
    
    int i=0;
    int m=0;
    
    const int userRegisteredWeekCount = 5; //今回は5で作る
    const int userRegisteredClassCount = 7; //今回は7で作る
    
    while (i < userRegisteredWeekCount){
        
        [_weeks addObject:weekContents[i]];
        i++;
    }
    
    while (m < userRegisteredClassCount) {
        [_classTimes addObject:classTimesContents[m]];
        m++;
    }
    
    //ナビゲーションバー表示
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    //タイトル色変更
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.text=@"Time Table";
    [titleLabel sizeToFit];
    self.navigationItem.titleView=titleLabel;
    
    
    self.navigationController.navigationBar.tintColor=[UIColor blueColor];//バーアイテムカラー
    self.navigationController.navigationBar.barTintColor=[UIColor blueColor];//バー背景色
    
    //カスタムセル追加
    [_collectionView registerNib:[UINib nibWithNibName:@"DayOfWeekCell" bundle:nil] forCellWithReuseIdentifier:@"DayOfWeekCell"];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"ClassTableCell" bundle:nil] forCellWithReuseIdentifier:@"ClassTableCell"];
    
    _collectionView.dataSource=self;
    _collectionView.delegate=self;
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    
    /*NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    _row=indexPath.row;
    
    [self.collectionView reloadData];
    [super viewWillAppear:animated];*/
    
    //UICollectionViewCell *cell=[_collectionView cellForItemAtIndexPath:indexPath];
    
    
    
    
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dbPathString=paths[0];
    FMDatabase *db=[FMDatabase databaseWithPath:[dbPathString stringByAppendingPathComponent:@"selectclass.db"]];
    [db open];
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS selectclasstable (id INTEGER PRIMARY KEY AUTOINCREMENT, className TEXT, teacherName TEXT, classroomName TEXT);"];
    
    FMResultSet *results=[db executeQuery:@"SELECT className, classroomName FROM selectclasstable WHERE id= (SELECT MAX(id) FROM selectclasstable);"];
    while ([results next]) {
        [_classNames addObject:[results stringForColumn:@"className"]];
        [_classroomNames addObject:[results stringForColumn:@"classroomName"]];
    }
    [db close];
    
    [self.collectionView reloadData];
    [super viewWillAppear:animated];
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView DataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 2;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        
        return _weeks.count + 1;
    }else{
        
        return (_classTimes.count)*(_weeks.count + 1);
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        DayOfWeekCell *cell=[collectionView
                             dequeueReusableCellWithReuseIdentifier:@"DayOfWeekCell" forIndexPath:indexPath];
        
        cell.backgroundColor=[UIColor blueColor];
        cell.weekLabel.textColor=[UIColor whiteColor];
        
        if (indexPath.row == 0) {
            
            cell.weekLabel.text=@"";
            
        }else{
            
            cell.weekLabel.text=_weeks[indexPath.row -1];
            
        }
        return cell;
        
    }else{
        
        ClassTableCell *cell=[_collectionView dequeueReusableCellWithReuseIdentifier:@"ClassTableCell" forIndexPath:indexPath];
        
        cell.backgroundColor=[UIColor whiteColor];
        cell.classTimeLabel.textColor=[UIColor blackColor];
        
        if (indexPath.row%(_weeks.count + 1) == 0) {
            
            cell.classTimeLabel.text=_classTimes[(indexPath.row) / (_weeks.count + 1) ];
            
        }else{
            
            
            
            if (indexPath.row == 10) {
                
                cell.classLabel.text=@"りか";
                cell.classroomLabel.text=@"実験室";
                cell.classTimeLabel.text=@"";
                
            }else{
                
                cell.classTimeLabel.text=@"";
                cell.classLabel.text=_classNameString;
                cell.classroomLabel.text=@"";
                
            }
            
            /* NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
             NSString *dbPathString=paths[0];
             FMDatabase *db=[FMDatabase databaseWithPath:[dbPathString stringByAppendingPathComponent:@"class.db"]];
             [db open];
             [db executeUpdate:@"CREATE TABLE IF NOT EXISTS classtable (id INTEGER PRIMARY KEY AUTOINCREMENT, className TEXT,teacherName TEXT,classroomName TEXT);"];
             
             FMResultSet *results=[db executeQuery:@"SELECT className, classroomName FROM classtable;"];
             while ([results next]) {
             cell.classTimeLabel.text=[results stringForColumn:@"className"];
             cell.classroomLabel.text=[results stringForColumn:@"classroomName"];
             }
             [db close];*/
            
        }
        return  cell;
    }
    
}

#pragma mark - UICollectionView Layout

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            return CGSizeMake(20, 20);
        }else{
            
            float widthsize=([[UIScreen mainScreen]applicationFrame].size.width -(20 + _weeks.count))/(_weeks.count);
            
            return CGSizeMake(widthsize, 20);
        }
        
    }else{
        if (indexPath.row % (_weeks.count + 1) == 0) {
            
            //[[UIScreen mainScreen]applicationFrame].size.height ステータスバーを除いた画面の高さ
            //[[UIScreen mainScreen]applicationFrame].size.width  ステータスバーを除いた画面の幅
            float heightsize=([[UIScreen mainScreen]applicationFrame].size.height -self.navigationController.navigationBar.bounds.size.height -(20 + _classTimes.count))/(_classTimes.count);
            
            return CGSizeMake(20, heightsize);
            
        }else{
            
            float widthsize=([[UIScreen mainScreen]applicationFrame].size.width -(20 + _weeks.count))/(_weeks.count);
            
            float heightsize=([[UIScreen mainScreen]applicationFrame].size.height -self.navigationController.navigationBar.bounds.size.height  -(20 + _classTimes.count))/(_classTimes.count);
            
            return CGSizeMake(widthsize, heightsize);
        }
    }
    
}

//アイテム同士の間隔を設定
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 1.0f;
}

//セクションとアイテムの間隔を設定
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 1.0f;
}

//特定のセクションのコンテンツの境界を設定
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    return CGSizeMake(0, 0);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(0, 0);
}

#pragma mark - UICollectionView Delegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        //曜日を選択してもアクションを起こさない
    }else{
        if (indexPath.row % (_weeks.count + 1)==0) {
            //時限を選択してもアクション起こさない
        }else{
            if (indexPath.row==10) {
                
                AttendanceRecordViewController *viewController=[[AttendanceRecordViewController alloc]init];
                [self.navigationController pushViewController:viewController animated:YES];
                
            }else{
                
                SelectClassViewController *viewController=[[SelectClassViewController alloc]init];
                
                //セルの番号取得
                NSInteger Selectedrow =indexPath.row;
                viewController.row=Selectedrow;
                
                //viewController.selectedRowString=[NSString stringWithFormat:@"%ld",(long)selectedRow];
                
                
                
                [self.navigationController pushViewController:viewController animated:YES];
            }
        }
    }
}
    
@end