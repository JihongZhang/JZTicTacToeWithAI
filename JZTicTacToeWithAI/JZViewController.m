//
//  JZViewController.m
//  JZTicTacToeWithAI
//
//  Created by jihong zhang on 9/14/14.
//  Copyright (c) 2014 JZ. All rights reserved.
//

#import "JZViewController.h"
#import "JZCheckBox.h"


#define TicTacToeTotalNum  9
#define TicTacToeRows  3
#define TicTacToeCols  3


@interface JZViewController ()
@property (nonatomic) int youWins;
@property (nonatomic) int computerWins;
@property (nonatomic) int draws;
@end

@implementation JZViewController

char board[TicTacToeTotalNum] = {'-','-','-','-','-','-','-','-','-'};

- (void)viewDidLoad
{
    [super viewDidLoad];
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
}


#pragma mark - JZCheckBox delegate
-(void) onCheckBoxChange:(JZCheckBox *)checkBox isChecked:(BOOL)isChecked
{
    if(isChecked == NO){
        checkBox.isChecked = YES;  //in case multi click
        return;
    }
    
    if(checkBox.key != @"x"){
        checkBox.offImage = [UIImage imageNamed:@"bigO"];
        checkBox.onImage = [UIImage imageNamed:@"bigO"];
        
        Move(board,checkBox.index,'o');
        NSLog(@"Human pick position: %d, board=%s", checkBox.index, board);
        if(isWin(board,'o')  ==  1){
            ++self.youWins;
            NSLog(@"Human win. Total: %d", self.youWins);
            self.labelYouWins.text = [NSString stringWithFormat:@"You wins: %d", self.youWins];
            UIAlertView  *alert = [[UIAlertView alloc] initWithTitle:@"You Win" message:@"Congratulation!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            alert.tag = 11;
            [alert show];
            return;
        }
        
        if(isFull(board) == 1){
            ++self.draws;
            NSLog(@"Draw. Total: %d", self.draws);
            self.labelDraws.text = [NSString stringWithFormat:@"Draws: %d", self.draws];
            UIAlertView  *alert = [[UIAlertView alloc] initWithTitle:@"Draw" message:@"No winer this time." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            alert.tag = 12;
            [alert show];
            return;
        }
        
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
            UIAlertView  *alert = [[UIAlertView alloc] initWithTitle:@"You lose" message:@"Sorry!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            alert.tag = 13;
            [alert show];
            return;
        }
    }
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
}


//============================================================
// main str
#define random(x) (rand()%x)

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

void availablePos(char Bo[],int Pos[]){
    int i,j;
    j = 0;
    for(i = 0; i < TicTacToeTotalNum; i++){
        if(Bo[i] == '-'){
            Pos[j] = i;
            j++;
        }
    }
}

void Move(char Bo[],int pos,char player){
    Bo[pos] = player;
}

void boardCopy(char from[], char to[]){
    memmove( (void*)to, (void*)from, TicTacToeTotalNum * sizeof(char) );
    /*
     int i;
     for(i = 0; i < TicTacToeTotalNum; i++)
     to[i] = from[i];
     */
}
int getConerPosition(int pos[], int num)
{
    for (int i=0; i<num; i++){
        if((pos[i] == 0) || (pos[i] == 2) || (pos[i] == 6) || (pos[i] == 8)){
            return i;
        }
    }
    return -1;
}

int AI(char Bo[]){
    int num;
    char AI_Board[TicTacToeTotalNum];
    //will keep all availabel positon index, -1 is unavailable
    int pos[TicTacToeTotalNum] = {-1,-1,-1,-1,-1,-1,-1,-1,-1};
    int i;
    availablePos(Bo,pos);
    for(i = 0; i < TicTacToeTotalNum; i++){
        if(pos[i] == -1){  //get the total available positons
            num = i;  // the total number of avaiable moving positions
            break;
        }
    }
    
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
    //first to check if there is any corner available, if yes, take it
    int corner;
    if((corner = getConerPosition(pos, num)) != -1){
        return pos[corner];
    }
    //move to any avaibale position
    srand(time(NULL));
    return pos[random(num-1)]; //return any avaibale position
}

@end
