//
//  DatabaseOfSelectClassTable.h
//  TimeTable
//
//  Created by SDT-B004 on 2015/06/03.
//  Copyright (c) 2015年 SDT-B004. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface DatabaseOfSelectClassTable : NSObject

+(void)createSelectClassTable;
+(void)insertSelectClassTable:(NSString *)classNameString teacherName:(NSString *)teacherNameString classroomName:(NSString *)classroomNameString indexPathRow:(NSString *)indexPathRowString;
+(void)selectSelectClassTable:(NSMutableDictionary *)classNamesAndIndexPathes classroomNamesAndIndexPathes:(NSMutableDictionary *)classroomNamesAndIndexPathes;
@end
