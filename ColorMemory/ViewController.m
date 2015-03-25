//
//  ViewController.m
//  ColorMemory
//
//  Created by Rick Windham on 12/30/14.
//  Copyright (c) 2014 Rick Windham. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "CardView.h"
#import "Score.h"

static int const PrivateKVOContext;

@interface ViewController ()
@property (strong, nonatomic) IBOutletCollection(CardView) NSArray *cards;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) CardView *firstCard;
@property (strong, nonatomic) NSArray *scores;
@property (weak, nonatomic) NSManagedObjectContext *moc;
@property (assign) NSInteger score;
@property (assign) NSInteger visibleCards;
@end

@implementation ViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setupKVO];
    _visibleCards = _cards.count;
    _moc = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    _scores = [Score fetchAllInContext:_moc];

    if (_scores.count == 0) {
        [self createHighScoreList];
    }

    [self randomizeCards];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate {
    return NO;
}

#pragma mark - core data stack stuff

- (BOOL)saveContext {
    NSError *error;
    [_moc save:&error];

    if (error != nil) {
        NSLog(@"ERROR saving: %@", error);
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - utils

@dynamic screenShot;
- (UIImage *)screenShot {
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, YES, 1);
    [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:YES];
    UIImage *screenShot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenShot;
}

#pragma mark - score methods

- (BOOL)createHighScoreList {
    if ([Score removeAllInContext:_moc]) {
        NSMutableArray *newScores = [NSMutableArray array];
        for (int i = 0; i < 10; i++) {
            Score *newScore = [Score insertInManagedObjectContext:_moc];
            newScore.rankValue = i + 1;
            [newScores addObject:newScore];
        }

        if ([self saveContext]) {
            _scores = [NSArray arrayWithArray:newScores];
            return YES;
        } else {
            NSLog(@"ERROR: creatingHighScoreList");
            return NO;
        }

    } else {
        return NO;
    }
}

- (IBAction)highScoreAction:(id)sender {
}

- (void)updateScore:(NSInteger)updateValue {
    _score += updateValue;
    
    _scoreLabel.text = [NSString stringWithFormat:@"%li", (long)_score];
}

- (void)addHightScore:(NSInteger)score andName:(NSString *)name {
    // this has to change the score and name for the rank but push
    // down the one that's there and drop off the last score
    NSInteger newRank = [self scoreRank];

    for (int i = 10; i > newRank; i--) {
        if (i < 2) {
            break;
        }

        Score *from = (Score *)_scores[i - 2];
        Score *to   = (Score *)_scores[i - 1];

        to.name = from.name;
        to.scoreValue = from.scoreValue;
    }

    Score *newHighScore = (Score *)_scores[newRank -1];
    newHighScore.name = name;
    newHighScore.scoreValue = score;

    if (![self saveContext]) {
        NSLog(@"Error adding high score.");
    }

    [self setupCards];
}

- (NSInteger)scoreRank {
    NSInteger rank = 0;

    for (int i = 0; i < 10; i++) {
        Score *score = (Score *)_scores[i];

        if (score.name == nil || _score >  score.scoreValue) {
            rank = score.rankValue;
            break;
        }
    }

    return rank;
}

#pragma mark - name entry

- (void)alertTextFieldDidChange:(NSNotification *)notification {
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    if (alertController)
    {
        UITextField *login = alertController.textFields.firstObject;
        UIAlertAction *okAction = alertController.actions.lastObject;
        okAction.enabled = login.text.length > 2;
    }
}

- (void)requestName {
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"NEW HIGH SCORE!"
                                          message:@"You made the high score list:"
                                          preferredStyle:UIAlertControllerStyleAlert];

    __weak ViewController *wself = self;

    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = @"Enter Your Name";
         __strong ViewController *sself = wself;
         [[NSNotificationCenter defaultCenter] addObserver:sself
                                                  selector:@selector(alertTextFieldDidChange:)
                                                      name:UITextFieldTextDidChangeNotification
                                                    object:textField];
     }];

    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"Add Me!"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   UITextField *name = alertController.textFields.firstObject;
                                   __strong ViewController *sself = wself;
                                   [self addHightScore:_score andName:name.text];
                                   [[NSNotificationCenter defaultCenter] removeObserver:sself
                                                                                   name:UITextFieldTextDidChangeNotification
                                                                                 object:nil];
                               }];

    okAction.enabled = NO;

    UIAlertAction *noAction = [UIAlertAction
                               actionWithTitle:@"No Thanks"
                               style:UIAlertActionStyleCancel
                               handler:^(UIAlertAction *action)
                               {
                                   __strong ViewController *sself = wself;
                                   [[NSNotificationCenter defaultCenter] removeObserver:sself
                                                                                   name:UITextFieldTextDidChangeNotification
                                                                                 object:nil];
                                   [sself setupCards];
                               }];

    [alertController addAction:noAction];
    [alertController addAction:okAction];

    // Finally present the action
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - card methods

- (void)setupCards {
    _score = 0;
    [self updateScore:0];
    _visibleCards = _cards.count;
    [_cards makeObjectsPerformSelector:@selector(resetCard)];

    [self randomizeCards];
}

- (void)randomizeCards {
    // assign cards randomly
    NSMutableArray *numbers = [NSMutableArray array];

    for (int i = 0; i < 16; i++) {
        [numbers addObject:@(i)];
    }

    [_cards enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSInteger slot = arc4random_uniform((u_int32_t)numbers.count);
        NSInteger num = ([[numbers objectAtIndex:slot] integerValue] + 1) % 8;

        CardView *card = (CardView *)obj;
        [card setNumber:(num == 0 ? 8 : num)];

        numbers[slot] = [numbers objectAtIndex:numbers.count - 1];
        [numbers removeLastObject];
    }];
}

- (void)hideCards:(CardView *)secondCard {
    CardView *firstCard = _firstCard;
    _firstCard = nil;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1.0
                         animations:^{
                             firstCard.alpha = 0.0;
                             secondCard.alpha = 0.0;
                         }
                         completion:^(BOOL done) {
                             _visibleCards -= 2;
                             firstCard.hidden = YES;
                             secondCard.hidden = YES;
                             
                             if (_visibleCards <= 0) {
                                 if ([self scoreRank] < 10) {
                                     [self requestName];
                                 } else {
                                     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                         [self setupCards];
                                 });
                                 }
                             }
                         }];
    });
}

- (void)turnAllToBack {
    _firstCard = nil;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [_cards makeObjectsPerformSelector:@selector(showBack)];
    });
}

#pragma mark - KVO

- (void)setupKVO {
    for (CardView *card in _cards) {
        [card addObserver:self
               forKeyPath:@"showingBack"
                  options:NSKeyValueObservingOptionNew
                  context:(void*)&PrivateKVOContext];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (context == &PrivateKVOContext) {
        CardView *card = (CardView *)object;

        // should never happen
        if (card.showingBack) {
            _firstCard = nil;
            return;
        }

        if (_firstCard == nil) {
            _firstCard = card;
        } else {
            if (_firstCard.cardNumber == card.cardNumber) {
                [self updateScore:2];
                [self hideCards:card];
            } else {
                [self updateScore:-1];
                [self turnAllToBack];
            }
            
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


@end
