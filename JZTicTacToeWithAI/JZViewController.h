//
//  JZViewController.h
//  JZTicTacToeWithAI
//
//  Created by jihong zhang on 9/14/14.
//  Copyright (c) 2014 JZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JZCheckBox.h"

@interface JZViewController : UIViewController <CheckBoxDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *labelYouWins;
@property (weak, nonatomic) IBOutlet UILabel *labelComputerWins;
@property (weak, nonatomic) IBOutlet UILabel *labelDraws;


- (IBAction)buttonReset:(id)sender;
- (IBAction)buttonNewGame:(id)sender;

@property (nonatomic, retain) NSMutableArray *checkBoxHolder;

@end
