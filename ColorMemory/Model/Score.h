#import "_Score.h"

@interface Score : _Score {}
// Custom logic goes here.
+ (NSArray *)fetchAllInContext:(NSManagedObjectContext *)moc;
+ (BOOL)removeAllInContext:(NSManagedObjectContext *)moc;
@end
