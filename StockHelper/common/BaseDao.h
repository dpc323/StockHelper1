//
//  BaseDao.h
//  UniversalArchitecture
//
//  Created by issuser on 12-12-6.
//  Copyright (c) 2012年 issuser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entity.h"
#import "SQLiteDatabase.h"
#import "DBConstants.h"

@interface BaseDao : NSObject
{
    FMDatabase  *db;
}
/**
 *初始化 DAO 类后就调用，用于设置当前要发生操作的数据库
 *@param currentDb 当前操作的数据库
 *@return nil
 */
- (void)setCurrentDB:(SQLiteDatabase *)currentDb;

/**
 * 查询
 * @param entity
 * @return
 */
- (id)queryWithEntity:(Entity *)entity;

/**
 * 新增
 * @param entity
 * @return
 */
- (BOOL)insertWithEntity:(Entity *)entity;

/**
 * 修改
 * @param entity
 * @return
 */
- (BOOL)updateWithEntity:(Entity *)entity;

/**
 *
 * 删除
 * @param entity
 * @return
 */
- (BOOL)deleteWithEntity:(Entity *)entity;

/**
 * 根据rs获取实体对象
 *
 * @param rs
 * @return entity
 */
- (id)entityFromRS:(FMResultSet *)rs;

@end
