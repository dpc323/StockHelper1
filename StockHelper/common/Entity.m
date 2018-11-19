//
//  Entity.m
//  AmwayMCommerce
//
//  Created by 张 黎 on 12-12-28.
//
//

#import "Entity.h"
#import <objc/runtime.h>
#import "JSONKit.h"

@implementation Entity



- (id)init {
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)dealloc {
//    ISS_RELEASE(_id);
    
#if ! __has_feature(objc_arc)
    [super dealloc];
#endif
}


+ (id)objectFromJson:(NSString *)json {
    NSDictionary *dict = [json objectFromJSONString];
    if (!dict) return nil;
    return ISS_AUTORELEASE([[self alloc] initWithDictionary:dict]);
}

- (id)initWithDictionary:(NSDictionary*) dict {
    self = [self init];
    if (self)
        [self objectFromDictionary:dict];
    return self;
}

- (void)objectFromDictionary:(NSDictionary*) dict {
    unsigned int propCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &propCount);
    
    id objId = [dict objectForKey:@"id"];

    if (objId) {
        [self setValue:objId forKeyPath:@"_id"];
    }
    
    for (i = 0; i < propCount; i++) {
        objc_property_t prop = properties[i];
        const char *propName = property_getName(prop);
        if(propName) {
            NSString *name = [NSString stringWithCString:propName encoding:NSUTF8StringEncoding];
            id obj = [dict objectForKey:name];
            
            if (obj == [NSNull null] || obj == nil) {
                continue;
            }
            
            if ([name isEqualToString:@"_id"]) {
                obj = [dict objectForKey:@"id"];
                NSLog(@"_id obj:%@",obj);
            }

            if ([obj isKindOfClass:[NSDictionary class]]) {//如果是数组类型也直接赋值

                Class klass = [Entity propertyClassForPropertyName:name ofClass:[self class]];
                //NSLog(@"klass:%@",klass);

				obj = ISS_AUTORELEASE([[klass alloc] initWithDictionary:obj]);
            }
            else if ([obj isKindOfClass:[NSArray class]]) {
//                Class arrayItemType = [[self class] performSelector:NSSelectorFromString([NSString stringWithFormat:@"%@_class", name])];
                //NSLog(@"arr prop Name:%@",name);
                //将字段转换成首字母大写，找到对应的类，特殊情况走下面的 if-else
                NSString *first = [[name substringToIndex:1] uppercaseString];
                NSString *rest = [name substringFromIndex:1];
                NSString *newString = [first stringByAppendingString:rest];
                //NSLog(@"newString:%@",newString);
                //NSLog(@"[[name substringToIndex:[name length]-1] capitalizedString]:%@",[[name substringToIndex:[name length]-1] capitalizedString]);
                
                Class arrayItemType = NSClassFromString([[name substringToIndex:[name length]-1] capitalizedString]);
                
                //特殊情况
                if ([name isEqualToString:@"mon"] ||
                    [name isEqualToString:@"tue"] ||
                    [name isEqualToString:@"wed"] ||
                    [name isEqualToString:@"thu"] ||
                    [name isEqualToString:@"fri"] ||
                    [name isEqualToString:@"sat"] ||
                    [name isEqualToString:@"sun"]) {
                    arrayItemType = NSClassFromString(@"Lesson");
                }
                else if ([name isEqualToString:@"replies"]) {
                    arrayItemType = NSClassFromString(@"Reply");
                }
                else if ([name isEqualToString:@"offlineMsgs"]) {
                    arrayItemType = NSClassFromString(@"Message");
                }
                else if ([name isEqualToString:@"classes"]) {
                    arrayItemType = NSClassFromString(@"XXClass");
                }
                //NSLog(@"arrayItemType:%@",arrayItemType);

				NSMutableArray *childObjects = [NSMutableArray arrayWithCapacity:[(NSArray*)obj count]];
				
				for (id child in obj) {
                    //NSLog(@"[child class]:%@",[child class]);
					if ([[child class] isSubclassOfClass:[NSDictionary class]] && arrayItemType!=nil) {
						Entity *childDTO = ISS_AUTORELEASE([[arrayItemType alloc] initWithDictionary:child]);
						[childObjects addObject:childDTO];
					} else {
						[childObjects addObject:child];
					}
				}
				
				obj = childObjects;
            }
            
            // handle all others
			[self setValue:obj forKey:name];
        }
    }
    free(properties);
}

static NSMutableDictionary *propertyClassByClassAndPropertyName;

+ (Class)propertyClassForPropertyName:(NSString *)propertyName ofClass:(Class)klass {
	if (!propertyClassByClassAndPropertyName) {
        propertyClassByClassAndPropertyName = [[NSMutableDictionary alloc] init];
    }
	
	NSString *key = [NSString stringWithFormat:@"%@:%@", NSStringFromClass(klass), propertyName];
//    NSLog(@"key:%@",key);
	NSString *value = [propertyClassByClassAndPropertyName objectForKey:key];
	
	if (value) {
		return NSClassFromString(value);
	}
	
	unsigned int propertyCount = 0;
	objc_property_t *properties = class_copyPropertyList(klass, &propertyCount);
	
	const char * cPropertyName = [propertyName UTF8String];
	
	for (unsigned int i = 0; i < propertyCount; ++i) {
		objc_property_t property = properties[i];
		const char * name = property_getName(property);
		if (strcmp(cPropertyName, name) == 0) {
			free(properties);
			NSString *className = [NSString stringWithUTF8String:property_getTypeName(property)];

			[propertyClassByClassAndPropertyName setObject:className forKey:key];
            //we found the property - we need to free
			return NSClassFromString(className);
		}
	}
    free(properties);
    //this will support traversing the inheritance chain
	return [self propertyClassForPropertyName:propertyName ofClass:class_getSuperclass(klass)];
}

static const char *property_getTypeName(objc_property_t property) {
	const char *attributes = property_getAttributes(property);
	char buffer[1 + strlen(attributes)];
	strcpy(buffer, attributes);
	char *state = buffer, *attribute;
	while ((attribute = strsep(&state, ",")) != NULL) {
		if (attribute[0] == 'T') {
			size_t len = strlen(attribute);
			attribute[len - 1] = '\0';
			return (const char *)[[NSData dataWithBytes:(attribute + 3) length:len - 2] bytes];
		}
	}
	return "@";
}

- (NSDictionary *)toDictionary {
    
    NSMutableDictionary *returnDic = ISS_AUTORELEASE([[NSMutableDictionary alloc] init]);
    
    id idValue = [self valueForKey:@"_id"];
    if (idValue != nil && idValue != [NSNull null]) {
        [returnDic setValue:idValue forKey:@"id"];
    }
    //获取所有的属性名称
    unsigned int propCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &propCount);
    for (i = 0; i < propCount; i++) {
        objc_property_t prop = properties[i];
        const char *propName = property_getName(prop);
        if(propName) {
            NSString *name = [NSString stringWithCString:propName encoding:NSUTF8StringEncoding];
            

            id value = [self valueForKey:name];
//            if ([name isEqualToString:@"roleCode"]) {
//                NSLog(@"class: %@ value: %@", [value class], value);
//            }
//            if (!tempValue || tempValue == [NSNull null]) {//增加为空的判断。附上默认值
//                    tempValue = @"";
//            }
//            [returnDic setValue:[self valueForKey:name] forKey:name];//从类里面取值然后赋给每个值，取得字典
//            
//            [returnDic setValue:value forKey:name];
            
            if (value == nil || value == [NSNull null]) {
                continue;
            }
//            else if ([value isKindOfClass:[NSNumber class]]){  //&& [value intValue] == 0
//                continue;
//            }
            
            if ([[value class] isSubclassOfClass:[Entity class]]) {
                [returnDic setValue:[value toDictionary] forKey:name];
            }
            else if ([value isKindOfClass:[NSArray class]]) {
                NSMutableArray *subValueArray = [[NSMutableArray alloc] initWithCapacity:[(NSArray *)value count]];
                for (id subValue in value) {
                    if ([[subValue class] isSubclassOfClass:[Entity class]]) {
                        [subValueArray addObject:[subValue toDictionary]];
                        continue;
                    }
                    [subValueArray addObject:subValue];
                }
                [returnDic setValue:subValueArray forKey:name];
                ISS_RELEASE(subValueArray);
            }
            else {
                [returnDic setValue:value forKey:name];
            }
            
        }
    }
    free(properties);
    
    return returnDic;

}


- (NSString *)toJsonStr {
    return [[self toDictionary] JSONString];
}

- (NSString *)toString {
    NSMutableString *returnString = [NSMutableString string];
    [returnString appendFormat:@"%@",[self toDictionary]];
    return returnString;
}

@end
