//
//  CardView.m
//  ColorMemory
//
//  Created by Rick Windham on 12/30/14.
//  Copyright (c) 2014 Rick Windham. All rights reserved.
//

#import "CardView.h"

@interface CardView ()

@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;
@property (nonatomic, nonatomic, strong) UIImageView *front;
@property (nonatomic, strong) UIImageView *back;

@property (assign, readwrite) BOOL showingBack;
@property (assign, readwrite) NSInteger cardNumber;
@end

@implementation CardView

#pragma mark - Lifecycle

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:_tapRecognizer];

        CGRect imageFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        
        _back = [[UIImageView alloc] initWithFrame:imageFrame];
        _front = [[UIImageView alloc] initWithFrame:imageFrame];
        
        _back.image = [UIImage imageNamed:@"CardBG"];

        [self setNumber:(self.tag % 8) + 1];

        _showingBack = YES;
        [self addSubview:_back];
        
    }
    
    return self;
}

#pragma mark - methods for controller

- (void)setNumber:(NSInteger)number {
    _cardNumber = number;
    NSString *cardNumberString = [NSString stringWithFormat:@"colour%li", _cardNumber];
    _front.image = [UIImage imageNamed:cardNumberString];
}

- (void)resetCard {
    _showingBack = YES;
    [_front removeFromSuperview];
    [_back removeFromSuperview];
    [self addSubview:_back];

    self.alpha = 0.0;
    self.hidden = NO;
    [self setNumber:(self.tag % 8) + 1];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1.0
                         animations:^{
                             self.alpha = 1.0;
                         }
                         completion:^(BOOL done) {}];
    });

 }

#pragma mark - user interaction and state change

- (void)tapAction:(UITapGestureRecognizer *)sender {
    if (_showingBack) {
        [self showFront];
    } else {
        [self showBack];
    }
}

- (void)showBack {
    if (_showingBack == NO) {
        [UIView transitionFromView:_front
                            toView:_back
                          duration:0.5
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        completion:^(BOOL done) {
                            self.showingBack = YES;
                        }];
    }
}

- (void)showFront {
    if (_showingBack == YES) {
        [UIView transitionFromView:_back
                            toView:_front
                          duration:0.5
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        completion:^(BOOL done) {
                            self.showingBack = NO;
                        }];
    }
}


@end
