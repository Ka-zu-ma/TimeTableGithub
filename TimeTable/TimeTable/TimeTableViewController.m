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
#import "TitleLabel.h"
#import "WeekContentsData.h"
#import "ClassTimeContentsData.h"

@interface TimeTableViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (strong,nonatomic) NSMutableArray *weeks;
@property (strong,nonatomic) NSMutableArray *classTimes;

@property (strong,nonatomic) NSMutableDictionary *classNamesAndIndexPathes;
@property (strong,nonatomic) NSMutableDictionary *classroomNamesAndIndexPathes;

@end

@implementation TimeTableViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _weeks=[NSMutableArray array];
    _classTimes=[NSMutableArray array];
    
    NSArray *weekContents=[WeekContentsData createWeekContents];
    NSArray *classTimeContents=[ClassTimeContentsData createClassTimeContents];
    
    int i=0;
    int m=0;
    int userRegisteredWeekCount = 5; //今回は5で作る
    int userRegisteredClassCount = 7; //今回は7で作る
    
    while (i < userRegisteredWeekCount){
        
        [_weeks addObject:weekContents[i]];
        i++;
    }
    
    while (m < userRegisteredClassCount) {
        
        [_classTimes addObject:classTimeContents[m]];
        m++;
    }
    
    //ナビゲーションバー表示
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    self.navigationItem.titleView=[TitleLabel createTitlelabel:@"Time Table"];
    
    self.navigationController.navigationBar.tintColor=[UIColor blueColor];//バーアイテムカラー
    self.navigationController.navigationBar.barTintColor=[UIColor blueColor];//バー背景色
    
    //カスタムセル追加
    [_collectionView registerNib:[UINib nibWithNibName:@"DayOfWeekCell" bundle:nil] forCellWithReuseIdentifier:@"DayOfWeekCell"];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"ClassTableCell" bundle:nil] forCellWithReuseIdentifier:@"ClassTableCell"];
    
    _collectionView.dataSource=self;
    _collectionView.delegate=self;
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView DataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    /*_classNamesAndIndexPathes=[[NSMutableDictionary alloc]init];
    _classroomNamesAndIndexPathes=[[NSMutableDictionary alloc]init];
    
    [super createSelectClassTable];
    FMDatabase *db=[super getDatabaseOfselectclass];
    [db open];
    
    FMResultSet *results=[db executeQuery:@"SELECT className, classroomName, indexPath FROM selectclasstable;"];
    
    while ([results next]) {
        
        [_classNamesAndIndexPathes setObject:[results stringForColumn:@"className"] forKey:[results stringForColumn:@"indexPath"]];
        [_classroomNamesAndIndexPathes setObject:[results stringForColumn:@"classroomName"] forKey:[results stringForColumn:@"indexPath"]];
    }
    
    [db close];//データベースクラスを作り、Modelに入れる*/

    
    return 2;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        
        return _weeks.count + 1;
    }
    return (_classTimes.count)*(_weeks.count + 1);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        //dequeueReusableCellWithReuseIdentifier:再利用できるセルがあればそれを使う、なければ生成
        DayOfWeekCell *cell=[collectionView
                             dequeueReusableCellWithReuseIdentifier:@"DayOfWeekCell" forIndexPath:indexPath];
        
        cell.backgroundColor=[UIColor blueColor];
        cell.weekLabel.textColor=[UIColor whiteColor];
        
        if (indexPath.row == 0) {
            
            cell.weekLabel.text=@"";
            return cell;
        }
        cell.weekLabel.text=_weeks[indexPath.row -1];
            
        return cell;
    }
        
    ClassTableCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"ClassTableCell" forIndexPath:indexPath];
        
    cell.backgroundColor=[UIColor whiteColor];
    cell.classTimeLabel.textColor=[UIColor blackColor];
        
    if (indexPath.row%(_weeks.count + 1) == 0) {
            
        cell.classTimeLabel.text=_classTimes[(indexPath.row) / (_weeks.count + 1) ];
        return cell;
    }
            
    cell.classTimeLabel.text=@"";
    cell.classLabel.text=@"";
    cell.classroomLabel.text=@"";
            /*if ([_classNamesAndIndexPathes.allKeys containsObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]){
                
                cell.classLabel.text=[_classNamesAndIndexPathes objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
                cell.classroomLabel.text=[_classroomNamesAndIndexPathes objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
            
            }//else内にclass,classname空文字、164行目あやしい*/
    
    return  cell;
}

#pragma mark - UICollectionView Layout

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            return CGSizeMake(20, 20);
        
        }
        float widthsize=([[UIScreen mainScreen]applicationFrame].size.width -(20 + _weeks.count))/(_weeks.count);
            
        return CGSizeMake(widthsize, 20);
        
    }
    if (indexPath.row % (_weeks.count + 1) == 0) {
            
        //[[UIScreen mainScreen]applicationFrame].size.height ステータスバーを除いた画面の高さ
        //[[UIScreen mainScreen]applicationFrame].size.width  ステータスバーを除いた画面の幅
        float heightsize=([[UIScreen mainScreen]applicationFrame].size.height -self.navigationController.navigationBar.bounds.size.height -(20 + _classTimes.count))/(_classTimes.count);
            
        return CGSizeMake(20, heightsize);
            
    }
            
    float widthsize=([[UIScreen mainScreen]applicationFrame].size.width -(20 + _weeks.count))/(_weeks.count);
            
    float heightsize=([[UIScreen mainScreen]applicationFrame].size.height -self.navigationController.navigationBar.bounds.size.height  -(20 + _classTimes.count))/(_classTimes.count);
            
    return CGSizeMake(widthsize, heightsize);
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
    
    if (!indexPath.section==0) {
        if (!(indexPath.row % (_weeks.count + 1)==0)) {
            if ([_classNamesAndIndexPathes.allKeys containsObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]) {
                
                AttendanceRecordViewController *viewController=[[AttendanceRecordViewController alloc]init];
                
                viewController.indexPath=indexPath;
                [self.navigationController pushViewController:viewController animated:YES];
                
            }
                
            SelectClassViewController *viewController=[[SelectClassViewController alloc]init];
                
            viewController.indexPath=indexPath;
                
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
}
    
@end