//
//  HighScoreTableCell.h
//  ColorMemory
//
//  Created by Rick Windham on 1/8/15.
//  Copyright (c) 2015 Rick Windham. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HighScoreTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *rank;
@property (weak, nonatomic) IBOutlet UILabel *score;
@property (weak, nonatomic) IBOutlet UILabel *name;
@end
