//
//  JZCheckBox.h
//  JZShoppingApp
//
//  Created by jihong zhang on 5/12/14.
//  Copyright (c) 2014 JZ. All rights reserved.
//

#import <UIKit/UIKit.h>

#define myCheckboxImageWidth 80
#define myCheckboxImageHeight 80
#define myFontSize 15
#define myMargin 10

@protocol CheckBoxDelegate;

/** This my checkBox widget
 * checkbox can asociate with tile or key
 */
@interface JZCheckBox : UIView

@property (nonatomic) UIImage *offImage;
@property (nonatomic) UIImage *onImage;


/** checkBox with title
 */
-(id)initWithTitle:(NSString*)title andFrame:(CGRect)frame;
/** checkBox with key, index and frame,
 *  the frame size define the checkBox image size
 *  you can change the image for checked and unchecked state 
 *  by replacing the checkbox_yes.png and checkbox_no.png
 */
-(id)initWithKey:(NSString*)key index:(int)index andFrame:(CGRect)frame;
-(id)initWithKey:(NSString*)key index:(int)index andFrame:(CGRect)frame state:(BOOL)state;
-(void)setChecked:(BOOL)checked;

/** check box title
 */
@property (nonatomic,copy) NSString *title;
/** checkbox state
 */
@property (nonatomic, assign) BOOL isChecked;
/** checkbox asociated key
 */
@property (nonatomic,copy) NSString *key;
/** checkbox asociated key(index)
 */
@property (nonatomic)int index;

/** checkbox delegate
 */
@property (nonatomic, retain) id<CheckBoxDelegate> delegate;


@end


/** check box event protocol
 */
@protocol CheckBoxDelegate <NSObject>
@required
-(void) onCheckBoxChange:(JZCheckBox *)checkBox isChecked:(BOOL)isChecked;
@end

