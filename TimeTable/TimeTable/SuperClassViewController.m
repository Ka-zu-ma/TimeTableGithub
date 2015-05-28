//
//  SuperSelectClassViewController.m
//  TimeTable
//
//  Created by SDT-B004 on 2015/05/18.
//  Copyright (c) 2015年 SDT-B004. All rights reserved.
//

#import "SuperClassViewController.h"

@interface SuperClassViewController ()

@end

@implementation SuperClassViewController

//static  NSString *const createclassdbName=@"createclass.db";
//static  NSString *const selectclassdbName=@"selectclass.db";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(FMDatabase *)getDatabaseOfcreateclass{
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dbPathString=paths[0];
    FMDatabase *db=[FMDatabase databaseWithPath:[dbPathString stringByAppendingPathComponent:@"createclass.db"]];
    
    NSLog(@"createclass.dbの場所:%@",[dbPathString stringByAppendingPathComponent:@"createclass.db"]);
    return db;
}

-(FMDatabase *)getDatabaseOfselectclass{
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dbPathString=paths[0];
    FMDatabase *db=[FMDatabase databaseWithPath:[dbPathString stringByAppendingPathComponent:@"selectclass.db"]];
    
    return db;
}

-(void)createCreateClassTable{
    
    FMDatabase *db=[self getDatabaseOfcreateclass];
    [db open];
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS createclasstable (id INTEGER PRIMARY KEY AUTOINCREMENT, className TEXT, teacherName TEXT, classroomName TEXT);"];
    [db close];
    
}

-(void)createSelectClassTable{
    
    FMDatabase *db=[self getDatabaseOfselectclass];
    
    [db open];
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS selectclasstable (id INTEGER PRIMARY KEY AUTOINCREMENT, className TEXT, teacherName TEXT, classroomName TEXT);"];
    [db close];
}



@end
