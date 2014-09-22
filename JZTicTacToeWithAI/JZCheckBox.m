//
//  JZCheckBox.m
//  JZShoppingApp
//
//  Created by jihong zhang on 5/12/14.
//  Copyright (c) 2014 JZ. All rights reserved.
//

#import "JZCheckBox.h"


@interface JZCheckBox()

@property (nonatomic) CGFloat checkBoxWidth;
@property (nonatomic) CGFloat checkBoxHeight;

@end



@implementation JZCheckBox

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.isChecked = false;
        self.checkBoxHeight = frame.size.height;
        self.checkBoxWidth = frame.size.width;
    }
    return self;
}

-(id)initWithTitle:(NSString*)title andFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        self.isChecked = false;
        self.checkBoxHeight = frame.size.height;
        self.checkBoxWidth = frame.size.width;
        self.title = title;
        self.backgroundColor = [UIColor clearColor];
    
        self.onImage = [UIImage imageNamed:@"checkbox_yes"];
        self.offImage = [UIImage imageNamed:@"checkbox_no"];
    }
    return self;
}


-(id)initWithKey:(NSString*)key index:(int)index andFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        self.isChecked = false;
        self.checkBoxHeight = frame.size.height;
        self.checkBoxWidth = frame.size.width;
        self.key = key;
        self.index = index;
        
        self.backgroundColor = [UIColor clearColor];
        
        self.onImage = [UIImage imageNamed:@"checkbox_yes"];
        self.offImage = [UIImage imageNamed:@"checkbox_no"];
    }
    return self;
}

-(id)initWithKey:(NSString*)key index:(int)index andFrame:(CGRect)frame state:(BOOL)state
{
    if(self = [super initWithFrame:frame]){
        self.isChecked = state;
        self.checkBoxHeight = frame.size.height;
        self.checkBoxWidth = frame.size.width;
        self.key = key;
        self.index = index;
        
        self.backgroundColor = [UIColor clearColor];
        
        self.onImage = [UIImage imageNamed:@"checkbox_yes"];
        self.offImage = [UIImage imageNamed:@"checkbox_no"];
    }
    return self;
 
}

// Only override drawRect: if you perform custom drawing.
- (void)drawRect:(CGRect)rect
{
    UIImage *image = self.isChecked ? self.onImage : self.offImage;
    [image drawInRect:CGRectMake(0, 0, self.checkBoxWidth, self.checkBoxHeight)];
    
    UIFont *font = [UIFont systemFontOfSize:myFontSize];
    [self.title drawAtPoint:CGPointMake(self.checkBoxWidth + myMargin, 0) withFont:font];
    
}

//overwite touchesEnded
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.isChecked = !self.isChecked;
    [self setChecked:self.isChecked];
}

-(void)setChecked:(BOOL)checked{
    self.isChecked = checked;
    
    //notify delegate: check state changed
    if([self.delegate respondsToSelector:@selector(onCheckBoxChange:isChecked:)]){
        [self.delegate onCheckBoxChange:self isChecked:self.isChecked ];
    }
    [self setNeedsDisplay];
    
}

-(void)setTitle:(NSString *)title
{
    if(_title != title){
        _title = [title copy];
        [self setNeedsDisplay];
    }
}


@end
