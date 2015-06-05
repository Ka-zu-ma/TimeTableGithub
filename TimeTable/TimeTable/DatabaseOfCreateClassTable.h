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

+(void)updateCreateClassTable:(NSString *)classNameTextField teacherNameTextField:(NSString *)teacherNameTextField  classroomNameTextField:(NSString *)classroomNameTextField classNameString:(NSString *)classNameString teacherNameString:(NSString *)teacherNameString classroomNameString:(NSString *)classroomNameString;

/*+(void)selectCreateClassTable:(NSString *)query className:(NSString *)className teacherName:(NSString *)teacherName classroomName:(NSString *)classroomName classes:(NSMutableArray *)classes teachers:(NSMutableArray *)teachers classroomNameString:(NSString *)classroomNameString;*/

+(NSArray *)selectCreateClassTable;
+(NSString *)selectCreateClassTableToGetClassroomName:(NSString *)classNameString teacherName:(NSString *)teacherNameString;

+(void)deleteCreateClassTable:(NSString *)classNameString teacherName:(NSString *)teacherNameString classroomName:(NSString *)classroomNameString;

@end
