//
//  HighScoreViewController.m
//  ColorMemory
//
//  Created by Rick Windham on 1/8/15.
//  Copyright (c) 2015 Rick Windham. All rights reserved.
//

#import "HighScoreViewController.h"
#import "HighScoreTableCell.h"
#import "ViewController.h"
#import "Score.h"

@interface HighScoreViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *effectsView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation HighScoreViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.imageView.image = ((ViewController *)self.presentingViewController).screenShot;
}

- (BOOL)shouldAutorotate {
    return NO;
}

#pragma mark - actions

- (IBAction)closeAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}


#pragma mark - table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (HighScoreTableCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    HighScoreTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HighScoreCell" forIndexPath:indexPath];

    Score *score = ((ViewController *)self.presentingViewController).scores[indexPath.row];

    cell.rank.text = [NSString stringWithFormat:@"%lli", score.rankValue];

    if (score.name) {
        cell.score.text = [NSString stringWithFormat:@"%lli", score.scoreValue];
        cell.name.text = [NSString stringWithFormat:@"%@", score.name];
    } else {
        cell.score.text = @"";
        cell.name.text = @"";
    }

    return cell;
}


@end
