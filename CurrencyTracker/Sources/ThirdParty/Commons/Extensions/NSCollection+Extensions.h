//
//  NSCollection+LOVExtensions.h
//  RemoteTools
//
//  Created by Igor Reshetnikov on 3/7/14.
//  Copyright (c) 2014 RemoteTools. All rights reserved.
//



@protocol Collection <NSObject, NSFastEnumeration>

@required
+ (BOOL)isMutable;
+ (BOOL)isOrdered;

- (NSUInteger)count;
- (id)anyObject;

- (BOOL)containsObject:(id)object;

- (NSArray *)sortedArrayUsingSelector:(SEL)comparator;
- (NSArray *)sortedArrayUsingDescriptorKeys:(NSArray *)sortDescriptorKeys;

- (NSArray *)array;
- (NSMutableArray *)mutableArray;

- (NSSet *)set;
- (NSMutableSet *)mutableSet;

- (NSOrderedSet *)orderedSet;
- (NSMutableOrderedSet *)mutableOrderedSet;

- (id <Collection>)convertToCollectionWithClass:(Class)collecitonClass;

- (id)collectionByAddingObject:(id)object;

- (id)originalObject;
- (id)objectContainer;

- (id)valueForKey:(NSString *)key;
- (id)valueForKeyPath:(NSString *)keyPath;

- (NSEnumerator *)objectEnumerator;

@end


@protocol OrderedCollection <Collection>

@required
- (id)firstObject;
- (id)objectAtIndex:(NSUInteger)index;
- (id)lastObject;

- (NSUInteger)indexOfObject:(id)object;
- (NSUInteger)indexOfObjectPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;

- (NSEnumerator *)reverseObjectEnumerator;

@end


@interface NSObject (Collection)

+ (BOOL)isCollection;

@end


@interface NSArray (OrderedCollection) <OrderedCollection>

@end


@interface NSArray (Extensions)

- (NSArray *)sortDescriptorsFromSortKeys;

- (NSMutableArray *)groupSortedArrayByKeys:(NSArray *)sortingKeys;

- (void)enumerateSubArraysWithPageSize:(NSUInteger)pageSize usingBlock:(void (^)(NSArray *subArray, NSUInteger location, BOOL *stop))block;

@end

@interface NSMutableArray (Extensions)

- (void)addNullableObject:(id)object;

@end

@interface NSSet (Collection) <Collection>


@end


@interface NSOrderedSet (OrderedCollection) <OrderedCollection>


@end