//
//  DBConstants.h
//  UniversalArchitecture
//
//  Created by 张 黎 on 13-6-9.
//  Copyright (c) 2013年 zhangli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SQLiteDatabase.h"


/**
 *
 * 书库公共常量类 (需要写清楚注释，以"斜杠+两个星号"开头)
 * 数据库表名请修改数据库对应常量类中initialize方法中的static变量
 * 表的字段名请定义在.h本文件中，方便dao类使用
 * @author  zhangli
 * @version  [V1.0.1, 2013-12-13]
 */

@interface DBConstants : NSObject


+ (NSString *)dbName;

+ (NSString *)tableName;


+ (NSString *)getCreateSQL;


+ (NSString *)getInsertSQL;

+ (NSString *)getDeleteSQL;

+ (NSString *)getDeleteAllSQL;

+ (NSString *)getAlterSQL;
+ (NSString *)getAlterSQLV2;


+ (NSString *)getQuerySQL;

/**
 *获取特殊条件的查询语句,
 *@param nil
 *@return sql
 */

+ (NSString *)getQuerySQLV1;

+ (NSString *)getQuerySQLV2;

+ (NSString *)getQuerySQLV3;

+ (NSString *)getQuerySQLV4;

+ (NSString *)getQuerySQLV5;

+ (NSString *)getQuerySQLV6;

+ (NSString *)getRowIdSQL;


@end

/*******************************股票数据表****************************/

@interface TableStockInfo : DBConstants

@end


/*******************************预测数据表****************************/

@interface TablePredictInfo : DBConstants

@end


/*******************************大盘数据表****************************/

@interface TableMarketInfo : DBConstants

@end


/*******************************大盘预测数据表****************************/

@interface TableMarketPredictInfo : DBConstants

@end


/*******************************时间统计表****************************/

@interface TableHighLowInfo : DBConstants

+ (NSString *)getHighCountSQL;
+ (NSString *)getLowCountSQL;

@end

/*******************************时间预测结果表****************************/

@interface TableDatePredictInfo : DBConstants

@end

/*******************************时间预测数据表2****************************/

@interface TableMarketScoreInfo : DBConstants

@end
