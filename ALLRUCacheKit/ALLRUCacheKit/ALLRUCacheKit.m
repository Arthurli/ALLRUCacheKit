//
//  ALLRUCacheKit.m
//  ALLRUCacheKit
//
//  Created by Arthur on 15/1/12.
//  Copyright (c) 2015年 Arthur. All rights reserved.
//

#import "ALLRUCacheKit.h"

@interface ALLRUCacheKit ()

@property (nonatomic, strong) NSMutableDictionary* cachePool;
@property (nonatomic, strong) ALLRUCacheObject* firstCache;
@property (nonatomic, strong) ALLRUCacheObject* lastCache;

@end

@implementation ALLRUCacheKit

+ (ALLRUCacheKit *)defaultCacheKit {
    static ALLRUCacheKit * kit = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kit = [[ALLRUCacheKit alloc] init];
    });
    
    return kit;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        _cachePool = [[NSMutableDictionary alloc] init];
        _cacheNumber = kDefaultCacheNumber;
    }
    
    return self;
}

+ (void)setCacheObject:(id)cacheObject cacheKey:(NSString *)cacheKey
{
    if (cacheObject && cacheKey) {
        ALLRUCacheKit *kit = [ALLRUCacheKit defaultCacheKit];
        ALLRUCacheObject *cache = [[ALLRUCacheObject alloc] initWithObject:cacheObject andCacheKey:cacheKey];
        if ([kit.cachePool objectForKey:cacheKey]) {
            [kit removeCacheByKey:cacheKey];
        }
        [kit addNewCache:cache cacheKey:cacheKey];
    }
}

+ (id)cacheObjectByKey:(NSString *)cacheKey
{
    if (cacheKey) {
        ALLRUCacheKit *kit = [ALLRUCacheKit defaultCacheKit];
        ALLRUCacheObject *cache = [kit.cachePool objectForKey:cacheKey];
        return cache.cacheObject;
    }
    
    return nil;
}

+ (void)setCacheNumber:(NSInteger)cacheNumber
{
    if (cacheNumber < 0) {
        return;
    }
    
    ALLRUCacheKit *kit = [ALLRUCacheKit defaultCacheKit];
    kit.cacheNumber = cacheNumber;
    
    if (kit.lastCache != nil) {
        while (kit.cachePool.count > kit.cacheNumber) {
            [kit removeCacheByKey:kit.lastCache.cacheKey];
        }
    }
}

- (void)addNewCache:(ALLRUCacheObject *)cache cacheKey:(NSString *)key
{
    if (cache == nil || key == nil) {
        return;
    }
    
    ALLRUCacheObject* newCache = cache;
    
    if (self.firstCache != nil) {
        ALLRUCacheObject *originalFirst = self.firstCache;
        newCache.nextObject = originalFirst;
        originalFirst.prevObject = newCache;
    }
    
    self.firstCache = newCache;
    
    if (self.lastCache == nil) {
        self.lastCache = newCache;
    }
    
    self.cachePool[key] = newCache;
    
    if (self.cachePool.count > self.cacheNumber) {
        [self removeCacheByKey:self.lastCache.cacheKey];
    }
}

- (void)removeCacheByKey:(NSString *)key
{
    if (key) {
        ALLRUCacheObject *cache = self.cachePool[key];
        if (cache == nil) {
            return;
        }
        
        ALLRUCacheObject *prevObject = cache.prevObject;
        ALLRUCacheObject *nextObject = cache.nextObject;
        
        if (prevObject != nil && nextObject != nil) {
            prevObject.nextObject = nextObject;
            nextObject.prevObject = prevObject;
        } else if (prevObject != nil) {
            self.lastCache = prevObject.cacheObject;
            prevObject.nextObject = nil;
        } else if (nextObject != nil) {
            self.firstCache = nextObject.cacheObject;
            nextObject.prevObject = nil;
        } else {
            self.lastCache = nil;
            self.firstCache = nil;
        }
        
        [self.cachePool removeObjectForKey:key];
    }
}

@end
