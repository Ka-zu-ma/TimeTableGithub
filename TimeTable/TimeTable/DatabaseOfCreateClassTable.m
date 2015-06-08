//
//  DatabaseOfCreateClassTable.m
//  TimeTable
//
//  Created by SDT-B004 on 2015/06/03.
//  Copyright (c) 2015年 SDT-B004. All rights reserved.
//

#import "DatabaseOfCreateClassTable.h"
#import "CommonMethodsOfDatabase.h"
@implementation DatabaseOfCreateClassTable

+(void)createCreateClassTable{
    
    FMDatabase *db=[CommonMethodsOfDatabase getDatabaseFile:@"createclass.db"];
    [db open];
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS createclasstable (id INTEGER PRIMARY KEY AUTOINCREMENT, className TEXT, teacherName TEXT, classroomName TEXT);"];
    [db close];
    
}

+(void)insertCreateClassTable:(NSString *)classNameString teacherName:(NSString *)teacherNameString classroomName:(NSString *)classroomNameString{
    
    FMDatabase *db=[CommonMethodsOfDatabase getDatabaseFile:@"createclass.db"];
    [db open];
    [db executeUpdate:@"INSERT INTO createclasstable (className, teacherName, classroomName) VALUES  (?, ?, ?);",classNameString,teacherNameString,classroomNameString];
    
    [db close];
}

+(void)updateCreateClassTable:(NSString *)classNameTextField teacherNameTextField:(NSString *)teacherNameTextField  classroomNameTextField:(NSString *)classroomNameTextField classNameString:(NSString *)classNameString teacherNameString:(NSString *)teacherNameString classroomNameString:(NSString *)classroomNameString{
    
    FMDatabase *db=[CommonMethodsOfDatabase getDatabaseFile:@"createclass.db"];
    
    [db open];
    [db executeUpdate:@"UPDATE createclasstable SET className = ?, teacherName = ?, classroomName = ? WHERE className = ? AND teacherName = ? AND classroomName = ?;",classNameTextField,teacherNameTextField,classroomNameTextField,classNameString,teacherNameString,classroomNameString];
    
    [db close];
}

+(NSArray *)selectCreateClassTable{
    
    NSMutableArray *classes=[[NSMutableArray alloc]init];
    NSMutableArray *teachers=[[NSMutableArray alloc]init];
    NSMutableArray *classrooms=[[NSMutableArray alloc]init];
    
    FMDatabase *db=[CommonMethodsOfDatabase getDatabaseFile:@"createclass.db"];
    [db open];
    
    FMResultSet *results=[db executeQuery:@"SELECT className, teacherName ,classroomName FROM createclasstable;"];
    while ([results next]) {
        
        [classes addObject:[results stringForColumn:@"className"]];
        [teachers addObject:[results stringForColumn:@"teacherName"]];
        [classrooms addObject:[results stringForColumn:@"classroomName"]];
    }
    
    [db close];
    return  @[classes,teachers,classrooms];
}

+(NSString *)selectCreateClassTableToGetClassroomName:(NSString *)classNameString teacherName:(NSString *)teacherNameString{
    NSString *cellclassroomNameString;
    
    FMDatabase *db=[CommonMethodsOfDatabase getDatabaseFile:@"createclass.db"];
    
    [db open];
    
    FMResultSet *results=[db executeQuery:@"SELECT classroomName FROM createclasstable WHERE className = ? AND teacherName = ?;",classNameString,teacherNameString];
    
    while ([results next]) {
        cellclassroomNameString=[results stringForColumn:@"classroomName"];
    }
    [db close];
    
    return cellclassroomNameString;
}

+(void)deleteCreateClassTable:(NSString *)classNameString teacherName:(NSString *)teacherNameString classroomName:(NSString *)classroomNameString{
    
    FMDatabase *db=[CommonMethodsOfDatabase getDatabaseFile:@"createclass.db"];
    [db open];
    [db executeUpdate:@"DELETE FROM createclasstable WHERE className = ? AND teacherName = ? AND classroomName = ?",classNameString,teacherNameString,classroomNameString];
    [db close];
}
/*+(void)selectCreateClassTable:(NSString *)query className:(NSString *)className teacherName:(NSString *)teacherName classroomName:(NSString *)classroomName classes:(NSMutableArray *)classes teachers:(NSMutableArray *)teachers classroomNameString:(NSString *)classroomNameString{
    
    FMDatabase *db=[self getDatabaseOfcreateclass];
    [db open];
    
    FMResultSet *results=[db executeQuery:query,className,teacherName,classroomName];
    while ([results next]) {
        
        [classes addObject:[results stringForColumn:@"className"]];
        [teachers addObject:[results stringForColumn:@"teacherName"]];
        classroomNameString=[results stringForColumn:@"classroomName"];
    }
    NSLog(@"abc:%@",classroomNameString);
    [db close];

}*/

/*+(NSArray *)selectCreateClassTable:(NSString *)query className:(NSString *)className teacherName:(NSString *)teacherName classroomName:(NSString *)classroomName classes:(NSMutableArray *)classes teachers:(NSMutableArray *)teachers classroomNameString:(NSString *)classroomNameString{
    
    FMDatabase *db=[self getDatabaseOfcreateclass];
    [db open];
    
    FMResultSet *results=[db executeQuery:query,className,teacherName,classroomName];
    while ([results next]) {
        
        [classes addObject:[results stringForColumn:@"className"]];
        [teachers addObject:[results stringForColumn:@"teacherName"]];
        classroomNameString=[results stringForColumn:@"classroomName"];
    }
    NSLog(@"abc:%@",classroomNameString);
    [db close];
    
    return  @[classes,teachers,classroomNameString];
}*/



@end
