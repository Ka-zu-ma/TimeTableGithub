//
//  DatabaseOfCreateClassTable.h
//  TimeTable
//
//  Created by SDT-B004 on 2015/06/03.
//  Copyright (c) 2015年 SDT-B004. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface DatabaseOfCreateClassTable : NSObject
+(FMDatabase *)getDatabaseOfcreateclass;
+(void)createCreateClassTable;
+(void)insertCreateClassTable:(NSString *)classNameString teacherName:(NSString *)teacherNameString classroomName:(NSString *)classroomNameString;
@end
