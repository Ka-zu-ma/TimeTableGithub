//
//  CommonMethodsOfDatabase.h
//  TimeTable
//
//  Created by SDT-B004 on 2015/06/08.
//  Copyright (c) 2015年 SDT-B004. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
@interface CommonMethodsOfDatabase : NSObject
+(FMDatabase *)getDatabaseFile:(NSString *)databaseFile;
+(void)delete:(NSString *)databaseFile query:(NSString *)query indexPathRow:(NSString *)indexPathRow;
@end
