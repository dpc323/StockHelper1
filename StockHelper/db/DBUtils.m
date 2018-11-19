//
//  DBUtils.m
//  AmwayMCommerce
//
//  Created by 张 黎 on 12-12-27.
//
//

#import "DBUtils.h"
//#import "AppConstants.h"
#import "DBConstants.h"
//#import "AccountDBConstants.h"
//#import "NSString+MD5Addition.h"


static DBUtils *_sharedDBManage = nil;

@implementation DBUtils
@synthesize db;
@synthesize accountDb;

#pragma mark - object init
+(DBUtils*) sharedDBManage
{
    @synchronized(self)
    {
        if (nil == _sharedDBManage ) {
            _sharedDBManage = [[self alloc] init];
        }
    }
    return _sharedDBManage;
}

+(id)alloc
{
    @synchronized([DBUtils class]) //线程访问加锁
    {
        NSAssert(_sharedDBManage == nil, @"Shewin: Attempted to allocate a second instance of a singleton.Please call +[sharedExerciseManage] method.");
        _sharedDBManage  = [super alloc];
        return _sharedDBManage;
    }
    return nil;
}

- (id)init
{
    self = [super init];
    if (self) {
        //database init
        [self initDatabase];
    }
    return self;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) {
        if (nil == _sharedDBManage) {
            _sharedDBManage = [super allocWithZone:zone];
            return _sharedDBManage;
        }
    }
    return nil;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (void)dealloc
{
    /*
     other property release
     */
    if (db==nil) { return;}
    else         {[db close]; ISS_RELEASE(db); db =nil;}
    
#if ! __has_feature(objc_arc)
    [super dealloc];
#endif
    _sharedDBManage = nil;
}

#if ! __has_feature(objc_arc)
- (oneway void)release
{
    // do nothing
    if(db==nil || _sharedDBManage == nil)
    {
        NSLog(@"SHDBManage: retainCount is 0.");
        return;
    }
    [super release];
    return;
}

- (id)retain
{
    return self;
}

//- (id)autorelease
//{
//    return self;
//}

- (NSUInteger)retainCount
{
    return NSUIntegerMax; // This is sooo not zero
}
#endif

///////////

- (BOOL)initDatabase
{
    /*
     BOOL success = false;
     
     NSString *userName = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"uname"];
     
     if ([userName length]>0) {
     NSString *dbName = [NSString stringWithFormat:@"%@-%@.db",[[DBConstants dbName] substringToIndex:8],[userName stringFromMD5]];
     NSString *writableDBPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"] stringByAppendingPathComponent:dbName];
     NSLog(@"database path:%@",writableDBPath);
     
     
     success = [fm fileExistsAtPath:writableDBPath];
     //将初始数据库拷贝过去
     if (!success) {
     NSString *dbPath= [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DB_NAME];
     
     NSError *error;
     
     success = [fm copyItemAtPath:dbPath toPath:writableDBPath error:&error];
     
     if(!success)
     {
     NSLog(@"Failed to copy database...error handling here %@.", [error localizedDescription]);
     }
     }
     
     
     db = ISS_RETAIN([SQLiteDatabase databaseWithPath:writableDBPath]);
     if ([db open]) {
     [db setShouldCacheStatements:YES];
     //NSLog(@"Open success db !");
     //建表
     [self createTable];
     }else {
     NSLog(@"Failed to open db!");
     success = NO;
     }
     
     }
     
     return success;
     */
    
//    BOOL success;
    
    //自动创建db
    /*
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:[DBConstants dbName]];
    db = ISS_RETAIN([SQLiteDatabase databaseWithPath:dbPath]);
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        NSLog(@"Open success db：%@!",dbPath);
        
        //建表
        //[self createTable];
    }else {
        NSLog(@"Failed to open db!");
        success = NO;
    }
    */
    
    //引入手动创建db
//    NSString *dbPath= [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[DBConstants dbName]];
//    db = ISS_RETAIN([SQLiteDatabase databaseWithPath:dbPath]);
//    if ([db open]) {
//        [db setShouldCacheStatements:YES];
//        NSLog(@"Open success db：%@!",dbPath);
//        
//        //建表
//        //[self createTable];
//    }else {
//        NSLog(@"Failed to open db!");
//        success = NO;
//    }
//    return success;
    
    
    BOOL success;
    NSFileManager *fm = [NSFileManager defaultManager];
    //	NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //	NSString *documentsDirectory = [paths objectAtIndex:0];
    //	NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:DB_NAME];
    NSString *writableDBPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"] stringByAppendingPathComponent:[DBConstants dbName]];
    NSLog(@"database path:  %@",writableDBPath);
    
    success = [fm fileExistsAtPath:writableDBPath];
    //将初始数据库拷贝过去
    if (!success) {
        NSString *dbPath= [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[DBConstants dbName]];
        
        NSError *error;
        
        success = [fm copyItemAtPath:dbPath toPath:writableDBPath error:&error];
        
        if(!success)
        {
            NSLog(@"Failed to copy database...error handling here %@.", [error localizedDescription]);
        }
    }
    
    
    if(success){
        db = ISS_RETAIN([SQLiteDatabase databaseWithPath:writableDBPath]);
        if ([db open]) {
            [db setShouldCacheStatements:YES];
            //NSLog(@"Open success db !");
        }else {
            NSLog(@"Failed to open db!");
            success = NO;
        }
    }
    
    return success;
}

- (void)createTable
{
    //http://www.tuicool.com/articles/6faUjqu
    
    //监测数据库中我要需要的表是否已经存在
    NSString *existsSql = [NSString stringWithFormat:@"select count(name) as countNum from sqlite_master where type = 'table' and name = '%@'", [DBConstants tableName] ];
    FMResultSet *rs = [db executeQuery:existsSql];
    
    if ([rs next]) {
        NSInteger count = [rs intForColumn:@"countNum"];
        
        NSLog(@"The table count: %li", count);
        
        if (count == 1) {
            NSLog(@"table is existed.");
            
            [db executeUpdate:[NSString stringWithFormat:@"CREATE TABLE %@ (code text, tradeDate DATE, upCount number(6),downCount number(6), noChangeCount number(6), radio number(4,2), volume double, score int, PRIMARY KEY(code, tradeDate))",[TableMarketPredictInfo tableName]]];
//            radio changeRadio
            if (![db columnExists:@"radio" inTableWithName:@"TableStockInfo"]){
                NSString *alertStr = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ INTEGER",@"TableStockInfo",@"radio"];
                BOOL worked = [db executeUpdate:alertStr];
                if(worked){
                    NSLog(@"插入成功");
                }else{
                    NSLog(@"插入失败");
                }
            }
            
            if (![db columnExists:@"changeRadio" inTableWithName:@"TableStockInfo"]){
                NSString *alertStr = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ INTEGER",@"TableStockInfo",@"changeRadio"];
                BOOL worked = [db executeUpdate:alertStr];
                if(worked){
                    NSLog(@"插入成功");
                }else{
                    NSLog(@"插入失败");
                }
            }
            
//            if (![db columnExists:@"新增字段" inTableWithName:@"表名"]){
//                NSString *alertStr = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ INTEGER",@"TableStockInfo",@"radio"];
//                BOOL worked = [db executeUpdate:alertStr];
//                if(worked){
//                    NSLog(@"插入成功");
//                }else{
//                    NSLog(@"插入失败");
//                }
//
//            }
            return;
        }
        
        NSLog(@"table is not existed.");
        
        //创建表

        [db executeUpdate:[NSString stringWithFormat:@"CREATE TABLE %@ (code text, tradeDate DATE, highPrice number(5,2),lowPrice number(5,2), openPrice number(5,2), closePrice number(5,2),volume double, PRIMARY KEY(code, tradeDate))",[TableStockInfo tableName]]];

        [db executeUpdate:[NSString stringWithFormat:@"CREATE TABLE %@ (code text, tradeDate DATE, highPrice number(5,2),lowPrice number(5,2), averagePrice number(5,2), currentPrice number(5,2), predictRidio number(4,2), realRido number(4,2) , predictVolume double, realVolume double, PRIMARY KEY(code, tradeDate))",[TablePredictInfo tableName]]];
        
        [db executeUpdate:[NSString stringWithFormat:@"CREATE TABLE %@ (code text, tradeDate DATE, highPrice number(5,2),lowPrice number(5,2), openPrice number(5,2), closePrice number(5,2),volume double, PRIMARY KEY(code, tradeDate))",[TableMarketInfo tableName]]];
        
    }
    
    [rs close];
}


/*
 - (void)createTable
 {
 
 if (![db tableExists:[TableUpload tableName]]) {
 NSLog(@"need to create %@-----", [TableUpload tableName]);
 [db executeUpdate:[TableUpload getCreateSQL]] ? CFShow(@"create success") : CFShow(@"create Fail----");
 }
 
 if (![db tableExists:[TableReceiver tableName]]) {
 NSLog(@"need to create %@-----", [TableReceiver tableName]);
 [db executeUpdate:[TableReceiver getCreateSQL]] ? CFShow(@"create success") : CFShow(@"create Fail----");
 }
 
 
 if (![db tableExists:[TableDynamic tableName]]) {
 NSLog(@"need to create %@-----", [TableDynamic tableName]);
 [db executeUpdate:[TableDynamic getCreateSQL]] ? CFShow(@"create succes") : CFShow(@"create Fail----");
 }
 
 if (![db tableExists:[TableReply tableName]]) {
 NSLog(@"need to create %@-----", [TableReply tableName]);
 [db executeUpdate:[TableReply getCreateSQL]] ? CFShow(@"create succes") : CFShow(@"create Fail----");
 }
 
 if (![db tableExists:[TableNews tableName]]) {
 NSLog(@"need to create %@-----", [TableNews tableName]);
 [db executeUpdate:[TableNews getCreateSQL]] ? CFShow(@"create succes") : CFShow(@"create Fail----");
 }
 
 if (![db tableExists:[TableQuestion tableName]]) {
 NSLog(@"need to create %@-----", [TableQuestion tableName]);
 [db executeUpdate:[TableQuestion getCreateSQL]] ? CFShow(@"create succes") : CFShow(@"create Fail----");
 }
 
 if (![db tableExists:[TableOption tableName]]) {
 NSLog(@"need to create %@-----", [TableOption tableName]);
 [db executeUpdate:[TableOption getCreateSQL]] ? CFShow(@"create succes") : CFShow(@"create Fail----");
 }
 
 if (![db tableExists:[TableMessage tableName]]) {
 NSLog(@"need to create %@-----", [TableMessage tableName]);
 [db executeUpdate:[TableMessage getCreateSQL]] ? CFShow(@"create succes") : CFShow(@"create Fail----");
 }
 if (![db tableExists:[TableContact tableName]]) {
 NSLog(@"need to create %@-----", [TableContact tableName]);
 [db executeUpdate:[TableContact getCreateSQL]] ? CFShow(@"create succes") : CFShow(@"create Fail----");
 }
 if (![db tableExists:[TableContactCategory tableName]]) {
 NSLog(@"need to create %@-----", [TableContactCategory tableName]);
 [db executeUpdate:[TableContactCategory getCreateSQL]] ? CFShow(@"create succes") : CFShow(@"create Fail----");
 }
 
 if (![db tableExists:[TablePubHistory tableName]]) {
 NSLog(@"need to create %@-----", [TablePubHistory tableName]);
 [db executeUpdate:[TablePubHistory getCreateSQL]] ? CFShow(@"create succes") : CFShow(@"create Fail----");
 }
 }
 */

+ (SQLiteDatabase *)getDB {
    SQLiteDatabase *database = [DBUtils sharedDBManage].db;
    if (database == nil) {
//        NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *documentsDirectory = [paths objectAtIndex:0];
//        NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:[DBConstants dbName]];
//        
//        database = ISS_RETAIN([SQLiteDatabase databaseWithPath:dbPath]);
//        if ([database open]) {
//            [database setShouldCacheStatements:YES];
//            NSLog(@"Open success db !");
//            //建表
//            [[DBUtils sharedDBManage] createTable];
//        }else {
//            NSLog(@"Failed to open db!");
//        }
        
        //引入手动创建db
//        NSString *dbPath= [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[DBConstants dbName]];
//        database = ISS_RETAIN([SQLiteDatabase databaseWithPath:dbPath]);
//        if ([database open]) {
//            [database setShouldCacheStatements:YES];
//            NSLog(@"Open success db：%@!",dbPath);
//            
//            //建表
//            //[self createTable];
//        }else {
//            NSLog(@"Failed to open db!");
//        }
        NSString *dbName = [DBConstants dbName];
        NSString *writableDBPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"] stringByAppendingPathComponent:dbName];
        NSLog(@"database path:  %@",writableDBPath);
        
        NSFileManager *fm = [NSFileManager defaultManager];
        BOOL success = [fm fileExistsAtPath:writableDBPath];
        //将初始数据库拷贝过去
        if (!success) {
            NSString *dbPath= [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dbName];
            
            NSError *error;
            
            success = [fm copyItemAtPath:dbPath toPath:writableDBPath error:&error];
            
            if(!success)
            {
                NSLog(@"Failed to copy database...error handling here %@.", [error localizedDescription]);
            }
        }
        
        database = ISS_RETAIN([SQLiteDatabase databaseWithPath:writableDBPath]);
        DBUtils *dbManager = [DBUtils sharedDBManage];
        dbManager.db = database;
        if ([database open]) {
            [database setShouldCacheStatements:YES];
            //NSLog(@"Open success db !");
            //建表
            //            [dbManager createTable];
            
        }else {
            NSLog(@"Failed to open db!");
        }

    }
    return database;
}

+ (SQLiteDatabase *)getAccountDB {
    return [DBUtils sharedDBManage].accountDb;
}

+ (NSString *)getDBPath {
    return [[NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"] stringByAppendingPathComponent:[DBConstants dbName]];
}

@end
