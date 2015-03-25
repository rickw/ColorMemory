// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Score.h instead.

#import <CoreData/CoreData.h>

extern const struct ScoreAttributes {
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *rank;
	__unsafe_unretained NSString *score;
} ScoreAttributes;

@interface ScoreID : NSManagedObjectID {}
@end

@interface _Score : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) ScoreID* objectID;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* rank;

@property (atomic) int64_t rankValue;
- (int64_t)rankValue;
- (void)setRankValue:(int64_t)value_;

//- (BOOL)validateRank:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* score;

@property (atomic) int64_t scoreValue;
- (int64_t)scoreValue;
- (void)setScoreValue:(int64_t)value_;

//- (BOOL)validateScore:(id*)value_ error:(NSError**)error_;

@end

@interface _Score (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSNumber*)primitiveRank;
- (void)setPrimitiveRank:(NSNumber*)value;

- (int64_t)primitiveRankValue;
- (void)setPrimitiveRankValue:(int64_t)value_;

- (NSNumber*)primitiveScore;
- (void)setPrimitiveScore:(NSNumber*)value;

- (int64_t)primitiveScoreValue;
- (void)setPrimitiveScoreValue:(int64_t)value_;

@end
