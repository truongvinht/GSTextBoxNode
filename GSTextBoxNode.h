/*
 
 GSTextBoxNode.h
 
 Copyright (c) 2013 Truong Vinh Tran
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

#ifndef GSTEXTBOXNODE_H
#define GSTEXTBOXNODE_H

#import <SpriteKit/SpriteKit.h>
#import "GSTextAutoTypeNode.h"

///enum for the box mode
typedef enum{
    GSTextBoxLayoutText,  //show only text
    GSTextBoxLayoutBattle //show 4 buttons with text label
}GSTextBoxLayout;

///enum for the buttons within the box
typedef enum{
    GSTextBoxButtonTopLeft,
    GSTextBoxButtonTopRight,
    GSTextBoxButtonBottomLeft,
    GSTextBoxButtonBottomRight,
    GSTextBoxButtonCancel
}GSTextBoxButton;


/** Protocol for calling parent after finish typing*/
@protocol GSTextBoxDelegate <NSObject>

@optional
/** Method will be called after finished typing chosen text in TextBoxLayoutText
 */
- (void)finishedTyping;

/** Method will be called after finished showing text and user touched within box*/
- (void)didTouchEndOfText;

/** Method to notify after button touched*/
- (void)buttonWithLabel:(GSTextBoxButton)button;

@end

/** TextBox Node to display box with text. It is used during a game for displaying any text and during battle.*/
@interface GSTextBoxNode : SKNode<GSTextAutoTypeDelegate>


///sprite background for showing the box
@property(nonatomic,strong) SKSpriteNode *boxBackground;

///delay between the next text page (default = 2 sec)
@property(nonatomic,readwrite) float delayToNextPage;

///target responds to the finished typing
@property(nonatomic,weak) id<GSTextBoxDelegate> delegate;

///text auto continue to next page (default is true)
@property(nonatomic,readwrite) BOOL isAutoContinue;

///allow touch (default = true)
@property(nonatomic,readwrite) BOOL allowTouches;

///font name for displaying any text
@property(nonatomic,strong) NSString *fontName;

///font size for the text in battle mode
@property(nonatomic) CGFloat battleFontSize;

///font size for the text in display mode
@property(nonatomic) CGFloat fontSize;

///font color of the displaying text
@property(SK_NONATOMIC_IOSONLY, strong) SKColor *fontColor;

/** Method to init a new text box node
 * 
 *  @param font is the font for any text displayed within the box
 *  @return new instance of GSTextBoxNode
 */
- (GSTextBoxNode*)initWithFont:(UIFont*)font;

/** Method to init a new text box node
 *
 *  @param fontName is the name of the font
 *  @param fontSize font size of the displaying text
 *  @return new instance of GSTextBoxNode
 */
- (GSTextBoxNode*)initWithFontName:(NSString*)fontName withFontSize:(CGFloat)fontSize;

/** Method to init a new text box node and default font size of 18
 *
 *  @param fontName is the name of the font
 *  @return new instance of GSTextBoxNode
 */
- (GSTextBoxNode*)initWithFontName:(NSString*)fontName;

/** Method to set the box layout
 *
 *  @param layout set the target layout
 */
- (void)setBoxMode:(GSTextBoxLayout)layout;

/** Method to type target text in text mode
 *
 *  @param text is the text which will be displayed
 *  @param delay is the duration how long the text needs for typing
 *  @param willHide if it is true then the text will hide after finish typing
 */
- (void) typeText:(NSString*)text withDelay:(float) delay withHide:(BOOL)willHide;

/** Method to init and set the button labels
 *
 *  @param tLeft is the label for the top left button
 *  @param tRight is the label for the top right button
 *  @param bLeft is the label for the bottom left button
 *  @param bRight is the label for the bottom right button
 */
- (void)initButtonLabelsForTopLeft:(NSString*)tLeft andTopRight:(NSString*)tRight andBottomLeft:(NSString*)bLeft andBottomRight:(NSString*)bRight;

/** Method to receive Touch events from UIView
 *
 *  @param touches are the touch events from UIView
 *  @param event is the corresponding event
 */
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

@end

#endif