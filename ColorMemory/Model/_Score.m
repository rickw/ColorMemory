// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Score.m instead.

#import "_Score.h"

const struct ScoreAttributes ScoreAttributes = {
	.name = @"name",
	.rank = @"rank",
	.score = @"score",
};

@implementation ScoreID
@end

@implementation _Score

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Score" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Score";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Score" inManagedObjectContext:moc_];
}

- (ScoreID*)objectID {
	return (ScoreID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"rankValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"rank"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"scoreValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"score"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic name;

@dynamic rank;

- (int64_t)rankValue {
	NSNumber *result = [self rank];
	return [result longLongValue];
}

- (void)setRankValue:(int64_t)value_ {
	[self setRank:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitiveRankValue {
	NSNumber *result = [self primitiveRank];
	return [result longLongValue];
}

- (void)setPrimitiveRankValue:(int64_t)value_ {
	[self setPrimitiveRank:[NSNumber numberWithLongLong:value_]];
}

@dynamic score;

- (int64_t)scoreValue {
	NSNumber *result = [self score];
	return [result longLongValue];
}

- (void)setScoreValue:(int64_t)value_ {
	[self setScore:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitiveScoreValue {
	NSNumber *result = [self primitiveScore];
	return [result longLongValue];
}

- (void)setPrimitiveScoreValue:(int64_t)value_ {
	[self setPrimitiveScore:[NSNumber numberWithLongLong:value_]];
}

@end

