//
//  JZViewController.m
//  JZTicTacToeWithAI
//
//  Created by jihong zhang on 9/14/14.
//  Copyright (c) 2014 JZ. All rights reserved.
//

#import "JZViewController.h"
#import "JZCheckBox.h"
#include <stdlib.h>


#define TicTacToeTotalNum  9
#define TicTacToeRows  3
#define TicTacToeCols  3

#define TicTacToeLogFile  "ticTacToe.log"


@interface JZViewController ()
@property (nonatomic) int youWins;
@property (nonatomic) int computerWins;
@property (nonatomic) int draws;
@end

@implementation JZViewController

#pragma mark - game main board status
//'-' means avaibale moving position for both side
//'o' means humane taken position
//'x' means computer taken position
char board[TicTacToeTotalNum] = {'-','-','-','-','-','-','-','-','-'};


#pragma mark - log file
- (BOOL)redirectNSLog {
    // Create log file
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *fileName = [documentsDirectory stringByAppendingPathComponent:@TicTacToeLogFile];

    [@"" writeToFile:fileName atomically:YES encoding:NSUTF8StringEncoding error:nil];
    id fileHandle = [NSFileHandle fileHandleForWritingAtPath:fileName];
    if (!fileHandle)
        return NSLog(@"Opening log failed"), NO;

    // Redirect stderr
    int err = dup2([fileHandle fileDescriptor], STDERR_FILENO);
    if (!err)
        return NSLog(@"Couldn't redirect stderr"), NO;
    return YES;
}


#pragma mark - main UI
- (void)viewDidLoad
{
    [super viewDidLoad];
    
#ifdef DEBUG
    [self redirectNSLog ];  
#endif
    
    [self generateInitData];
    self.youWins = 0;
    self.computerWins = 0;
    self.draws = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)generateInitData
{
    self.checkBoxHolder = [[NSMutableArray alloc] initWithCapacity:TicTacToeTotalNum];
    CGFloat checkWidth = myCheckboxImageWidth;
    CGFloat checkHeight = myCheckboxImageHeight;
    CGFloat checkX;
    CGFloat checkY;
    for(int row = 0; row < TicTacToeRows; row++){
        checkY = myMargin + row * checkHeight;
        for(int col = 0; col < TicTacToeCols; col++){
            checkX = myMargin + col * checkWidth;
            CGRect frame = CGRectMake(checkX, checkY, checkWidth, checkHeight);
            int index = row*TicTacToeCols+col;
            JZCheckBox *checkBox = [[JZCheckBox alloc] initWithKey:@"-" index:index andFrame:frame state:NO];
            checkBox.delegate = self;
            [self.checkBoxHolder insertObject:checkBox atIndex:index];
            [self.scrollView addSubview:checkBox];
        }
    }
    [self takeFirstRandomCornerPosition];
}


#pragma mark - JZCheckBox delegate
-(void) onCheckBoxChange:(JZCheckBox *)checkBox isChecked:(BOOL)isChecked
{
    if(isChecked == NO){
        checkBox.isChecked = YES;  //in case multi click
        return;
    }
    
    if(checkBox.key != @"x"){  //only human click on the check box
        checkBox.offImage = [UIImage imageNamed:@"bigO"];
        checkBox.onImage = [UIImage imageNamed:@"bigO"];
        
        Move(board,checkBox.index,'o');
        NSLog(@"Human pick position: %d, board=%s", checkBox.index, board);
        if(isWin(board,'o')  ==  1){
            ++self.youWins;
            NSLog(@"Human win. Total: %d", self.youWins);
            self.labelYouWins.text = [NSString stringWithFormat:@"You wins: %d", self.youWins];
            [self popUpGameResult:@"You Win" message:@"Congratulation!"];
            return;
        }
        
        //after human moving, computer needs to pick up the best position to move
        int posAI = AI(board);
        Move(board,posAI,'x');
        NSLog(@"Computer pick position: %d, board=%s",posAI,board);
        JZCheckBox *myMoveCheckBox = self.checkBoxHolder[posAI];
        myMoveCheckBox.offImage = [UIImage imageNamed:@"bigX"];
        myMoveCheckBox.onImage = [UIImage imageNamed:@"bigX"];
        myMoveCheckBox.isChecked = YES;
        [myMoveCheckBox setNeedsDisplay];
        
        if(isWin(board,'x') == 1){
            ++self.computerWins;
            NSLog(@"Computer win. Total: %d", self.computerWins);
            self.labelComputerWins.text = [NSString stringWithFormat:@"Computer wins: %d", self.computerWins];
            [self popUpGameResult:@"You lose" message:@"Sorry!"];
            return;
        }
        
        if(isFull(board) == 1){
            ++self.draws;
            NSLog(@"Draw. Total: %d", self.draws);
            self.labelDraws.text = [NSString stringWithFormat:@"Draws: %d", self.draws];
            [self popUpGameResult:@"Draw" message:@"No winer this time."];
            return;
        }
    }
}

-(void)popUpGameResult:(NSString*)title message:(NSString*)message
{
    UIAlertView  *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    return;
}

- (IBAction)buttonReset:(id)sender {
    self.youWins = 0;
    self.computerWins = 0;
    self.draws = 0;
    self.labelComputerWins.text = @"Computer wins: 0";
    self.labelYouWins.text = @"You wins: 0";
    self.labelDraws.text = @"Draws: 0";
    
    for(int i=0; i<self.checkBoxHolder.count; i++){
        JZCheckBox *checkBox = self.checkBoxHolder[i];
        checkBox.onImage = [UIImage imageNamed:@"checkbox_yes"];
        checkBox.offImage = [UIImage imageNamed:@"checkbox_no"];
        checkBox.isChecked = NO;
        checkBox.key = @"-";
        [checkBox setNeedsDisplay];
        board[i] = '-';
    }
    NSLog(@"Reset");
    [self takeFirstRandomCornerPosition];
}

- (IBAction)buttonNewGame:(id)sender {
    for(int i=0; i<self.checkBoxHolder.count; i++){
        JZCheckBox *checkBox = self.checkBoxHolder[i];
        checkBox.onImage = [UIImage imageNamed:@"checkbox_yes"];
        checkBox.offImage = [UIImage imageNamed:@"checkbox_no"];
        checkBox.isChecked = NO;
        checkBox.key = @"-";
        [checkBox setNeedsDisplay];
        board[i] = '-';
    }
    NSLog(@"New Game");
    [self takeFirstRandomCornerPosition];
}

-(void)takeFirstRandomCornerPosition
{
    int cornerPos[4]={0,2,6,8};
    int posAI = cornerPos[arc4random() % 4];
    Move(board,posAI,'x');
    NSLog(@"Computer pick position: %d, board=%s",posAI,board);
    JZCheckBox *myMoveCheckBox = self.checkBoxHolder[posAI];
    myMoveCheckBox.offImage = [UIImage imageNamed:@"bigX"];
    myMoveCheckBox.onImage = [UIImage imageNamed:@"bigX"];
    myMoveCheckBox.isChecked = YES;
    [myMoveCheckBox setNeedsDisplay];
}


//============================================================
#pragma mark - strategy core code for tic tac toe 

int isWin(char Bo[],char player){
    if(((Bo[0] == Bo[1]) && (Bo[1] == Bo[2]) && (Bo[2] == player)) ||
       ((Bo[3] == Bo[4]) && (Bo[4] == Bo[5]) && (Bo[5] == player)) ||
       ((Bo[6] == Bo[7]) && (Bo[7] == Bo[8]) && (Bo[8] == player)) ||
       ((Bo[0] == Bo[3]) && (Bo[3] == Bo[6]) && (Bo[6] == player)) ||
       ((Bo[1] == Bo[4]) && (Bo[4] == Bo[7]) && (Bo[7] == player)) ||
       ((Bo[2] == Bo[5]) && (Bo[5] == Bo[8]) && (Bo[8] == player)) ||
       ((Bo[0] == Bo[4]) && (Bo[4] == Bo[8]) && (Bo[8] == player)) ||
       ((Bo[2] == Bo[4]) && (Bo[4] == Bo[6]) && (Bo[6] == player))){
        return 1;
    } else {
        return 0;
    }
}

int isFull(char Bo[])
{
    int i;
    for(i = 0;i < TicTacToeTotalNum; i++){
        if(Bo[i] == '-'){
            return 0;
        }
    }
    return 1;
}

/** return number of available moving positions and their indexes
    in param: Bo[] - the game main board status
    out param: Pos[] - available moving position indeses
    out param: *num - number of available moving positions
 */
void availablePos(char Bo[],int Pos[], int *num){
    int i,j;
    j = 0;
    for(i = 0; i < TicTacToeTotalNum; i++){
        if(Bo[i] == '-'){
            Pos[j] = i;
            j++;
        }
    }
    *num = j;
}

void Move(char Bo[],int pos,char player){
    Bo[pos] = player;
}

void boardCopy(char from[], char to[]){
    memmove( (void*)to, (void*)from, TicTacToeTotalNum * sizeof(char) );
}

//return avaibale random corner position, if any
//otherwise return -1
int getCornerPos(int pos[], int num)
{
    int cornerPos[4];
    int cornerNum = 0;
    for(int i=0; i<num; i++){
        if((pos[i] == 0) || (pos[i] == 2) || (pos[i] == 6) || (pos[i] == 8)){
            cornerPos[cornerNum] = pos[i];
            NSLog(@"available cornerPos[%d]=%d",cornerNum, cornerPos[cornerNum]);
            (cornerNum)++;
        }
    }

    if(cornerNum > 0){
        int rd = arc4random() % cornerNum;
        int tmp = cornerPos[rd]; //return any avaibale position
        NSLog(@"Computer pick: cornerPos[%d]=%d", rd, cornerPos[rd]);
        return tmp;
    }else{
        return -1;
    }
}


/** return the best moving position for the computer
    in param: Bo[] - the game main board status
 */
int AI(char Bo[]){
    int num;
    char AI_Board[TicTacToeTotalNum];
    //will keep all availabel positon index, -1 is unavailable
    int pos[TicTacToeTotalNum] = {-1,-1,-1,-1,-1,-1,-1,-1,-1};
    int i;
    availablePos(Bo,pos,&num);
    
    
    //check to see if computer can win for all the avaibale moving position
    // if computer can find that position, than computer win
    for(i = 0; i < num; i++){
        boardCopy(Bo, AI_Board);
        Move(AI_Board, pos[i], 'x');
        if(isWin(AI_Board,'x')){
            return pos[i];
        }
    }
    
    //check to see if the human can win for all the avaibale moving position
    //if the human can win in that positon, then the computer will
    //take that positon to avoid the human to win
    for(i = 0; i < num; i++){
        boardCopy(Bo,AI_Board);
        Move(AI_Board, pos[i], 'o');
        if(isWin(AI_Board,'o')){
            return pos[i];
        }
    }
    
    //if computer cannot win, and the human cannot win, then
    //patch: first to check if the center position is available,
    //and than to check if there is any corner available, if yes, take it
    //otherwise take any available position
    if(Bo[4] == '-')
        return 4;
    int cornerPos = -1;
    cornerPos = getCornerPos(pos, num);
    if(cornerPos != -1)
        return cornerPos;
    
    //move to any avaibale position
    return pos[arc4random() % num]; //return any avaibale position
}


@end
