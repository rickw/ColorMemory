//
//  CardView.h
//  ColorMemory
//
//  Created by Rick Windham on 12/30/14.
//  Copyright (c) 2014 Rick Windham. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardView : UIView
@property (assign, readonly) NSInteger cardNumber;
@property (assign, readonly) BOOL showingBack;

- (void)setNumber:(NSInteger)number;
- (void)showFront;
- (void)showBack;
- (void)resetCard;
@end