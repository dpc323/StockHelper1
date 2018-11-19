//
//  DBConstants.m
//  UniversalArchitecture
//
//  Created by 张 黎 on 13-6-9.
//  Copyright (c) 2013年 zhangli. All rights reserved.
//

#import "DBConstants.h"


static NSString *DATABASE_NAME = @"stock.sqlite";

@implementation DBConstants

+ (NSString *)dbName { return DATABASE_NAME;}

+ (NSString *)tableName { return nil; }


+ (NSString *)getCreateSQL { return nil; }


+ (NSString *)getInsertSQL { return nil; }

+ (NSString *)getDeleteSQL { return nil; }

+ (NSString *)getDeleteAllSQL { return nil; }

+ (NSString *)getAlterSQL { return nil; }
+ (NSString *)getAlterSQLV2 { return nil; }

+ (NSString *)getQuerySQL { return nil; }

+ (NSString *)getQuerySQLV1 { return nil; }
+ (NSString *)getQuerySQLV2 { return nil; }
+ (NSString *)getQuerySQLV3 { return nil; }
+ (NSString *)getQuerySQLV4 { return nil; }
+ (NSString *)getQuerySQLV5 { return nil; }
+ (NSString *)getQuerySQLV6 { return nil; }

+ (NSString *)getRowIdSQL{ return nil; }



@end

@implementation TableStockInfo


NSString *const code = @"code";
NSString *const date = @"tradeDate";

static NSString *TABLE_STOCKINFO = @"StockInfo";

+ (NSString *)tableName { return TABLE_STOCKINFO;}

+ (NSString *)getQuerySQL {
    return [NSString stringWithFormat:
            @"select * from %@ where "
            "%@ = ?",
            TABLE_STOCKINFO,
            code
            ];
}

+ (NSString *)getQuerySQLV1 {
    return [NSString stringWithFormat:
            @"select * from %@ where "
            "%@ = ? "
            "order by %@ desc limit 0,?",
            TABLE_STOCKINFO,
            code,
            date
            ];
}

+ (NSString*)getQuerySQLV2{
//    select count(*) from stockInfo where tradeDate > "2017-05-20" and code = '000001'
    return [NSString stringWithFormat:
            @"select count(*) from %@ where"
            "%@ > ? and"
            "%@ = ? "
            ,TABLE_STOCKINFO
            ,date
            ,code
            ];
}

+ (NSString *)getQuerySQLV4 {
    return [NSString stringWithFormat:
            @"select * from %@ where "
            "%@ = ? and %@ = ?",
            TABLE_STOCKINFO,
            code,
            date];
}

+ (NSString *)getInsertSQL {
    return [NSString stringWithFormat:
            @"INSERT INTO %@(%@, %@, %@, %@, %@, %@, %@,%@,%@)"
            "VALUES (?,?,?,?,?,?,?,?,?)",
            TABLE_STOCKINFO,
            @"code", @"tradeDate", @"highPrice", @"lowPrice", @"openPrice", @"closePrice", @"radio",@"volume",@"changeRadio"];
    
}


+ (NSString *)getAlterSQL {
    return [NSString stringWithFormat:
            @"UPDATE %@ SET "
            "%@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?",
            TABLE_STOCKINFO,
            @"code", @"tradeDate", @"highPrice", @"lowPrice", @"openPrice", @"closePrice",@"radio", @"volume", @"changeRadio"];
}

@end

@implementation TablePredictInfo

static NSString *TABLE_PREDICTINFO = @"PredictInfo";
static NSString *predictRidio = @"predictRidio";
static NSString *realRido = @"realRido";

+ (NSString *)tableName { return TABLE_PREDICTINFO;}

+ (NSString *)getQuerySQL {
    return [NSString stringWithFormat:
            @"select * from %@ where "
            "%@ = ?",
            TABLE_PREDICTINFO,
            code
            ];
}

+ (NSString *)getQuerySQLV1 {
    return [NSString stringWithFormat:
            @"select * from %@ where "
            "%@ = ? and %@ = ?",
            TABLE_PREDICTINFO,
            code,
            date
            ];
}

+ (NSString *)getQuerySQLV2 {
    return [NSString stringWithFormat:
            @"select * from %@ where "
            "%@ = ?"
            "order by %@ desc limit 0,?",
            TABLE_PREDICTINFO,
            date,
            predictRidio
            ];
}

+ (NSString *)getQuerySQLV3 {
    return [NSString stringWithFormat:
            @"select * from %@ where "
            "%@ = ?"
            "order by %@ desc limit 0,?",
            TABLE_PREDICTINFO,
            date,
            realRido
            ];
}

+ (NSString *)getQuerySQLV4 {
    return [NSString stringWithFormat:
            @"select * from %@ where "
            "%@ = ? and %@ = ?",
            TABLE_PREDICTINFO,
            code,
            date];
}

+ (NSString *)getInsertSQL {
    return [NSString stringWithFormat:
            @"INSERT INTO %@(%@, %@, %@, %@, %@, %@, %@, %@, %@, %@)"
            "VALUES (?,?,?,?,?,?,?,?,?,?)",
            TABLE_PREDICTINFO,
            @"code", @"tradeDate", @"highPrice", @"lowPrice", @"averagePrice", @"currentPrice", @"predictRidio", @"realRido", @"predictVolume", @"realVolume"];
    
}

+ (NSString *)getAlterSQL {
    return [NSString stringWithFormat:
            @"UPDATE %@ SET "
            "%@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?"
            "where %@ = ?, %@ = ?",
            TABLE_PREDICTINFO,
            @"highPrice", @"lowPrice", @"averagePrice", @"currentPrice", @"predictRidio", @"realRido",@"predictVolume", @"realVolume", @"code", @"tradeDate"];
}

@end


@implementation TableMarketInfo

static NSString *TABLE_MARKETINFO = @"MarketInfo";

+ (NSString *)tableName { return TABLE_MARKETINFO;}

+ (NSString *)getQuerySQL {
    return [NSString stringWithFormat:
            @"select * from %@ where "
            "%@ = ?",
            TABLE_MARKETINFO,
            code
            ];
}

+ (NSString *)getQuerySQLV1 {
    return [NSString stringWithFormat:
            @"select * from %@ where "
            "%@ = ? "
            "order by %@ desc limit 0,?",
            TABLE_MARKETINFO,
            code,
            date
            ];
}


+ (NSString *)getQuerySQLV4 {
    return [NSString stringWithFormat:
            @"select * from %@ where "
            "%@ = ? and %@ = ?",
            TABLE_MARKETINFO,
            code,
            date];
}

+ (NSString *)getInsertSQL {
    return [NSString stringWithFormat:
            @"INSERT INTO %@(%@, %@, %@, %@, %@, %@, %@)"
            "VALUES (?,?,?,?,?,?,?)",
            TABLE_MARKETINFO,
            @"code", @"tradeDate", @"highPrice", @"lowPrice", @"openPrice", @"closePrice", @"volume"];
    
}


+ (NSString *)getAlterSQL {
    return [NSString stringWithFormat:
            @"UPDATE %@ SET "
            "%@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?",
            TABLE_MARKETINFO,
            @"code", @"tradeDate", @"highPrice", @"lowPrice", @"openPrice", @"closePrice", @"volume"];
}


@end

/*******************************大盘预测数据表****************************/

@implementation TableMarketPredictInfo

static NSString *TABLE_MARKETPREDICTINFO = @"TableMarketPredictInfo";
static NSString *score = @"score";

+ (NSString *)tableName { return TABLE_MARKETPREDICTINFO;}

+ (NSString *)getQuerySQL {
    return [NSString stringWithFormat:
            @"select * from %@ where "
            "%@ = ?",
            TABLE_MARKETPREDICTINFO,
            code
            ];
}

+ (NSString *)getQuerySQLV1 {
    return [NSString stringWithFormat:
            @"select * from %@ where "
            "%@ = ? "
            "order by %@ desc limit 0,?",
            TABLE_MARKETPREDICTINFO,
            code,
            date
            ];
}


//select sum(score) from TableMarketPredictInfo where  tradedate between "2017-08-08" and "2017-08-10"

+ (NSString *)getQuerySQLV2 {
    return [NSString stringWithFormat:
            @"select sum(%@) from %@ where"
            "%@ between ? and ?",
            score,
            TABLE_MARKETPREDICTINFO,
            date
            ];
}

//select sum(score) from (select * from TableMarketPredictInfo  order by tradedate desc limit 1)

+ (NSString *)getQuerySQLV3 {
    return [NSString stringWithFormat:
            @"select sum(%@) from (select %@ from %@ order by %@ desc limit 0,?)",
            score,
            score,
            TABLE_MARKETPREDICTINFO,
            date
            ];
}

+ (NSString *)getQuerySQLV4 {
    return [NSString stringWithFormat:
            @"select * from %@ where "
            "%@ = ? and %@ = ?",
            TABLE_MARKETPREDICTINFO,
            code,
            date];
}

+ (NSString *)getInsertSQL {
    return [NSString stringWithFormat:
            @"INSERT INTO %@(%@, %@, %@, %@, %@, %@, %@, %@)"
            "VALUES (?,?,?,?,?,?,?,?)",
            TABLE_MARKETPREDICTINFO,
            @"code", @"tradeDate", @"upCount", @"downCount",@"noChangeCount", @"radio", @"volume", @"score"];
}

+ (NSString *)getAlterSQL {
    return [NSString stringWithFormat:
            @"UPDATE %@ SET "
            "%@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?",
            TABLE_MARKETPREDICTINFO,
            @"code", @"tradeDate", @"upCount", @"downCount",@"noChangeCount", @"radio", @"volume", @"score"];
}

@end

/*******************************时间统计表****************************/

@implementation TableHighLowInfo

static NSString *TABLE_HIGHLOWINFO = @"HighLowInfo";

+ (NSString *)tableName { return TABLE_HIGHLOWINFO;}

+ (NSString *)getQuerySQL {
    return [NSString stringWithFormat:
            @"select * from %@ where "
            "%@ = ?",
            TABLE_HIGHLOWINFO,
            code
            ];
}

+ (NSString *)getQuerySQLV1 {
    return [NSString stringWithFormat:
            @"select * from %@ where "
            "%@ = ? "
            "order by %@ desc limit 0,?",
            TABLE_HIGHLOWINFO,
            code,
            date
            ];
}

//select highDate,count(*) from HighLowInfo  group by highDate order by count(*) desc limit 0,1
+ (NSString *)getQuerySQLV2 {
    return [NSString stringWithFormat:
            @"select highDate,count(*) from %@ group by highDate order by count(*) desc limit 0,1",
            TABLE_HIGHLOWINFO];
}

+ (NSString *)getQuerySQLV3 {
    return [NSString stringWithFormat:
            @"select lowDate,count(*) from %@ group by lowDate order by count(*) desc limit 0,1",
            TABLE_HIGHLOWINFO];
}

+ (NSString *)getHighCountSQL {
    return [NSString stringWithFormat:
            @"select count(*) from %@ where highDate = ?",
            TABLE_HIGHLOWINFO];
}

+ (NSString *)getLowCountSQL {
    return [NSString stringWithFormat:
            @"select count(*) from %@ where lowDate = ?",
            TABLE_HIGHLOWINFO];
}

+ (NSString *)getQuerySQLV4 {
    return [NSString stringWithFormat:
            @"select * from %@ where "
            "%@ = ? and %@ = ?",
            TABLE_HIGHLOWINFO,
            code,
            date];
}

+ (NSString *)getInsertSQL {
    return [NSString stringWithFormat:
            @"INSERT INTO %@(%@, %@, %@, %@, %@, %@, %@, %@, %@)"
            "VALUES (?,?,?,?,?,?,?,?,?)",
            TABLE_HIGHLOWINFO,
            @"code", @"highDate", @"lowDate", @"highPrice",@"lowPrice", @"upCounts", @"downCounts", @"upRatios",@"downRatios"];
}

+ (NSString *)getAlterSQL {
    return [NSString stringWithFormat:
            @"UPDATE %@ SET "
            "%@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?",
            TABLE_HIGHLOWINFO,
            @"code", @"highDate", @"lowDate", @"highPrice", @"lowPrice", @"upCounts", @"downCounts", @"upRatios", @"downRatios"];
}

+ (NSString *)getAlterSQLV2 {
    return [NSString stringWithFormat:
            @"UPDATE %@ SET "
            " %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ? "
            "where %@ = ?",
            TABLE_HIGHLOWINFO,
            @"highDate", @"lowDate", @"highPrice", @"lowPrice", @"upCounts", @"downCounts", @"upRatios", @"downRatios", @"code"];
}
//    ,upCounts,downCounts,upRatios,downRatios

@end

/*******************************时间预测结果表****************************/

@implementation TableDatePredictInfo

static NSString *TABLE_DATEPREDICTINFO = @"DatePredictInfo";

+ (NSString *)tableName { return TABLE_DATEPREDICTINFO;}

+ (NSString *)getQuerySQL {
    return [NSString stringWithFormat:
            @"select * from %@ where "
            "%@ = ?",
            TABLE_DATEPREDICTINFO,
            code
            ];
}

+ (NSString *)getQuerySQLV1 {
    return [NSString stringWithFormat:
            @"select * from %@ where "
            "%@ = ? "
            "order by %@ desc limit 0,?",
            TABLE_DATEPREDICTINFO,
            code,
            date
            ];
}

+ (NSString *)getQuerySQLV4 {
    return [NSString stringWithFormat:
            @"select * from %@ where "
            "%@ = ? and %@ = ?",
            TABLE_DATEPREDICTINFO,
            code,
            date];
}

+ (NSString *)getInsertSQL {
    return [NSString stringWithFormat:
            @"INSERT INTO %@(%@, %@, %@, %@, %@, %@,%@, %@)"
            "VALUES (?,?,?,?,?,?,?,?)",
            TABLE_DATEPREDICTINFO,
            @"predictDate", @"highMaxDate", @"lowMaxDate", @"highMaxCount",@"lowMaxCount",@"currentHighCount",@"currentLowCount",@"score"];
}

+ (NSString *)getAlterSQL {
    return [NSString stringWithFormat:
            @"UPDATE %@ SET "
            "%@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?",
            TABLE_DATEPREDICTINFO,
            @"predictDate", @"highMaxDate", @"lowMaxDate", @"highMaxCount",@"lowMaxCount",@"currentHighCount",@"currentLowCount",@"score"];
}

@end

/*******************************时间预测结果表2****************************/

@implementation TableMarketScoreInfo

static NSString *TABLE_MARKETSCOREINFO = @"MarketScoreInfo";

+ (NSString *)tableName { return TABLE_MARKETSCOREINFO;}

+ (NSString *)getQuerySQL {
    return [NSString stringWithFormat:
            @"select * from %@ where "
            "%@ = ?",
            TABLE_MARKETSCOREINFO,
            date
            ];
}

//select tradedate,max(score) from (select * from TableMarketPredictInfo  order by tradedate desc)
+ (NSString *)getQuerySQLV2 {
    return [NSString stringWithFormat:
            @"select %@, max(%@) from %@ where %@ > ?",
            date,
            date,
            TABLE_MARKETSCOREINFO,
            date];
}

+ (NSString *)getQuerySQLV3 {
    return [NSString stringWithFormat:
            @"select %@, min(%@) from %@ where %@ > ?",
            date,
            date,
            TABLE_MARKETSCOREINFO,
            date];
}

+ (NSString *)getQuerySQLV4 {
    return [NSString stringWithFormat:
            @"select * from %@ where "
            "%@ = ? and %@ = ?",
            TABLE_MARKETSCOREINFO,
            code,
            date];
}

//@synthesize tradeDate,sumSore,sumSoce10,predictScore,market;

+ (NSString *)getInsertSQL {
    return [NSString stringWithFormat:
            @"INSERT INTO %@(%@, %@, %@, %@, %@)"
            "VALUES (?,?,?,?,?)",
            TABLE_MARKETSCOREINFO,
            @"tradeDate", @"sumSore", @"sumSoce10", @"predictScore",@"market"];
}

+ (NSString *)getAlterSQL {
    return [NSString stringWithFormat:
            @"UPDATE %@ SET "
            "%@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?",
            TABLE_MARKETSCOREINFO,
            @"tradeDate", @"sumSore", @"sumSoce10", @"predictScore",@"market"];
}

@end

