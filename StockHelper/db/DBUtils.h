//
//  DBUtils.h
//  AmwayMCommerce
//
//  Created by 张 黎 on 12-12-27.
//
//
#import <Foundation/Foundation.h>
#import "SQLiteDatabase.h"
#import "ISSARC.h"


@interface DBUtils : NSObject {
    SQLiteDatabase *db;
    SQLiteDatabase *accountDb;
}


@property (nonatomic,strong) SQLiteDatabase *db;

@property (nonatomic,strong) SQLiteDatabase *accountDb;

/*
 初使化对象唯一方法
 */
+(DBUtils*) sharedDBManage;

+ (SQLiteDatabase *)getDB;

+ (SQLiteDatabase *)getAccountDB;

+ (NSString *)getDBPath;

- (void)createTable;


@end

