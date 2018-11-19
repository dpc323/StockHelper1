//
//  Entity.h
//  AmwayMCommerce
//
//  Created by 张 黎 on 12-12-28.
//
//

#import <Foundation/Foundation.h>
#import "ISSARC.h"


@interface Entity : NSObject

//所有实体类共有的id。
@property (nonatomic, retain) NSString *_id;

+ (id)objectFromJson:(NSString *)json;

- (id)initWithDictionary:(NSDictionary *)dict;

- (NSString *)toJsonStr;

- (NSDictionary *)toDictionary;

- (NSString *)toString;

+ (Class)propertyClassForPropertyName:(NSString *)propertyName ofClass:(Class)klass;

@end
