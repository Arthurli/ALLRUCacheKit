//
//  ALLRUCacheKit.h
//  ALLRUCacheKit
//
//  Created by Arthur on 15/1/12.
//  Copyright (c) 2015年 Arthur. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kDefaultCacheNumber 100

@class ALLRUCacheObject;

@interface ALLRUCacheKit : NSObject

@property (nonatomic, assign) NSInteger cacheNumber;

+ (void)setCacheNumber:(NSInteger)cacheNumber;
+ (void)setCacheObject:(id)cacheObject cacheKey:(NSString *)cacheKey;
+ (id)cacheObjectByKey:(NSString *)cacheKey;

@end

@interface ALLRUCacheObject : NSObject

@property (nonatomic, weak) ALLRUCacheObject* prevObject;
@property (nonatomic, weak) ALLRUCacheObject* nextObject;
@property (nonatomic, strong) id cacheObject;
@property (nonatomic, strong) NSString *cacheKey;

- (instancetype)initWithObject:(id)cacheObject andCacheKey:(NSString *)cacheKey;

@end
