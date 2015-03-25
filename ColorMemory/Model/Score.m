#import "Score.h"

@interface Score ()

// Private interface goes here.

@end

@implementation Score

// Custom logic goes here.
+ (NSArray *)fetchAllInContext:(NSManagedObjectContext *)moc {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:self.entityName];
    request.predicate = [NSPredicate predicateWithValue:YES];
    request.returnsObjectsAsFaults = NO;
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"rank" ascending:YES];
    request.sortDescriptors = @[sort];
    NSError *error;
    NSArray *results = [moc executeFetchRequest:request error:&error];

    if (error != nil) {
        NSLog(@"ERROR Fetching: %@", error);
        return nil;
    } else {
        return results;
    }
}

+ (BOOL)removeAllInContext:(NSManagedObjectContext *)moc {
    NSArray *scores = [Score fetchAllInContext:moc];

    for (Score *score in scores) {
        [moc deleteObject:score];
    }

    NSError *error;

    [moc save:&error];

    if (error != nil) {
        NSLog(@"ERROR deleting: %@", error);
        return NO;
    } else {
        return YES;
    }
}
@end
