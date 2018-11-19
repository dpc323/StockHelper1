//
//  BaseDao.m
//  UniversalArchitecture
//
//  Created by issuser on 12-12-6.
//  Copyright (c) 2012年 issuser. All rights reserved.
//

#import "BaseDao.h"
#import "DBUtils.h"

@implementation BaseDao

- (id)init
{
    self = [super init];
    if (self) {
        //NSLog(@"super init BaseDao");
        
        //项目中只用到一个数据库，dao初始化的时候可以将db引用过来, 方便后续直接做增删改查
        [self setCurrentDB:[DBUtils getDB]];
    }
    return self;
}
- (void)setCurrentDB:(SQLiteDatabase *)currentDb {
    db = currentDb;
}

- (id)queryWithEntity:(Entity *)entity  { return nil; }
- (BOOL)insertWithEntity:(Entity *)entity  { return NO; }
- (BOOL)updateWithEntity:(Entity *)entity  { return NO; }
- (BOOL)deleteWithEntity:(Entity *)entity  { return NO; }

@end
