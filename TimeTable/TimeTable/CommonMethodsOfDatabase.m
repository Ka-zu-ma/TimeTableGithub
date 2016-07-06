//
//  CommonMethodsOfDatabase.m
//  TimeTable
//
//  Created by SDT-B004 on 2015/06/08.
//  Copyright (c) 2015年 SDT-B004. All rights reserved.
//

#import "CommonMethodsOfDatabase.h"

@implementation CommonMethodsOfDatabase
+(FMDatabase *)getDatabaseFile:(NSString *)databaseFile{
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dbPathString=paths[0];
    FMDatabase *db=[FMDatabase databaseWithPath:[dbPathString stringByAppendingPathComponent:databaseFile]];
        
//    NSLog(@"createclass.dbの場所:%@",[dbPathString stringByAppendingPathComponent:@"createclass.db"]);
    return db;
}

+(void)delete:(NSString *)databaseFile query:(NSString *)query indexPathRow:(NSString *)indexPathRow{
    
    FMDatabase *db=[CommonMethodsOfDatabase getDatabaseFile:databaseFile];
    [db open];
    [db executeUpdate:query,indexPathRow];
    [db close];
    
}

@end
