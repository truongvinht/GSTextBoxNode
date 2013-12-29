/*
 
 GSTextBoxNode.m
 
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

#import "GSTextBoxNode.h"

//import for splitting string into new rows
#import "NSString+Newliner.h"

//import constants
#import "BoxConstants.h"

@interface GSTextBoxNode ()

///label for displaying text
@property(nonatomic,strong) GSTextAutoTypeNode *textLabel;

///flag to register the right display mode
@property(nonatomic,readwrite) GSTextBoxLayout boxLayout;

///flag for hiding text after completion
@property(nonatomic,readwrite) BOOL willHide;

///array to store tempory the text pages
@property(nonatomic,strong) NSMutableArray *textPages;

///store delayTime for multiple pages
@property(nonatomic,readwrite) float delayForTypeAnimation;

///button indicator for the next page
@property(nonatomic,strong) SKLabelNode *nextPage;

///grid box for splitting the view into 4 section
@property(nonatomic,strong) SKSpriteNode *gridBox;

/// battle mode button top left
@property(nonatomic,strong) GSTextViewNode *topLeft;
/// battle mode button top right
@property(nonatomic,strong) GSTextViewNode *topRight;
/// battle mode button bottom left
@property(nonatomic,strong) GSTextViewNode *bottomLeft;
/// battle mode button bottom right
@property(nonatomic,strong) GSTextViewNode *bottomRight;

@end

@implementation GSTextBoxNode

#pragma mark - Setter

- (void)setFontColor:(UIColor *)fontColor{
    _fontColor = fontColor;
    
    //update labels font color
    [self.textLabel setFontColor:_fontColor];
    [self.nextPage setFontColor:_fontColor];
    
    //update battle mode font color
    [self.topLeft setFontColor:_fontColor];
    [self.topRight setFontColor:_fontColor];
    [self.bottomLeft setFontColor:_fontColor];
    [self.bottomRight setFontColor:_fontColor];
}

#pragma mark - init methods

- (GSTextBoxNode*)initWithFont:(UIFont*)font{
    GSTextBoxNode *box = [self initWithFontName:font.fontName withFontSize:font.pointSize];
    return box;
}


- (GSTextBoxNode*)initWithFontName:(NSString*)fontName withFontSize:(CGFloat)fontSize{
    
    if (self = [super init]) {
        //init the background box
        self.boxBackground = [SKSpriteNode spriteNodeWithImageNamed:@"textbox.png"];
        [self.boxBackground setAnchorPoint:CGPointZero];
        [self.boxBackground setZPosition:kBoxLayerTagValue];
        [self addChild:self.boxBackground];
        
        //init grid for the battle mode
        self.gridBox = [SKSpriteNode spriteNodeWithImageNamed:@"BoxbuttonGrid.png"];
        [self.gridBox setAnchorPoint:CGPointZero];
        
        //font name
        self.fontName = fontName;
        
        //default color is black
        self.fontColor = [SKColor blackColor];
        
        //font size
        self.battleFontSize = fontSize+3;
        self.fontSize = fontSize;
        
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        self.textLabel = [GSTextAutoTypeNode labelWithFontName:fontName];
        self.textLabel.fontSize = _fontSize;
        
        [self.textLabel setPosition:CGPointMake(screenSize.width/2, self.boxBackground.size.height/2)];
        
        [self.textLabel setZPosition:kTextBoxLayerTagValue];
        
        //add to current layer
        [self addChild:self.textLabel];
        
        //layer responds to the finished text typing
        self.textLabel.delegate = self;
        
        //default text box layout
        _boxLayout = GSTextBoxLayoutText;
        _willHide = NO;
        
        //set default delay
        self.delayToNextPage = GSTEXTBOX_DELAY_TO_NEXT_PAGE;
        
        //auto continue text
        self.isAutoContinue = YES;
        
        //allow touch
        self.allowTouches = YES;
        
        //create the forward button
        NSString *arrowLabel = GSTEXTBOX_NEXT_SYMBOL;
        self.nextPage = [SKLabelNode labelNodeWithFontNamed:fontName];
        self.nextPage.fontSize = _battleFontSize;
        [self.nextPage setText:arrowLabel];
        
        //init arrow indicator
        [self.nextPage setPosition:CGPointMake(screenSize.width-GSTEXT_BOTTOM_OFFSET, GSTEXT_BOTTOM_OFFSET)];
        self.nextPage.fontColor = _fontColor;
    }
    
    return self;
}


- (GSTextBoxNode*)initWithFontName:(NSString*)fontName{
    return [self initWithFontName:fontName withFontSize:GSTEXTBOX_DEFAULT_FONTSIZE];
}

#pragma mark - Touch events

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    //skip touch events as long as text is running
    if (![self.nextPage parent]&&self.boxLayout == GSTextBoxLayoutText) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    
    //single tap
    if (touch.tapCount == 1) {
        CGPoint tapLocation = [touch locationInNode:self];
        
        switch (self.boxLayout) {
            case GSTextBoxLayoutText:{ //text box
                //check wether tap is within the box
                if (CGRectContainsPoint(self.boxBackground.frame, tapLocation)) {
                    [self.nextPage removeFromParent];
                    [self continueTypeNextPage];
                }else{
                    //ignore touch events outside of the box / maybe use it as cancel event
                }
            }break;
            case GSTextBoxLayoutBattle:{ //battle box with 4 buttons
                if (CGRectContainsPoint(self.boxBackground.frame, tapLocation)) {
                    //touch within the box
                    
                    //check which area
                    if (tapLocation.y >= self.boxBackground.frame.size.height/2) {
                        //top item
                        if (tapLocation.x <= self.boxBackground.frame.size.width/2) {
                            //left top
                            if (_delegate) {
                                if ([self.delegate respondsToSelector:@selector(buttonWithLabel:)]&&self.topLeft) {
                                    [self.delegate buttonWithLabel:GSTextBoxButtonTopLeft];
                                }
                            }
                        }else{
                            //right top
                            if (_delegate) {
                                if ([self.delegate respondsToSelector:@selector(buttonWithLabel:)]&&self.topRight) {
                                    [self.delegate buttonWithLabel:GSTextBoxButtonTopRight];
                                }
                            }
                        }
                    }else{
                        //bottom item
                        if (tapLocation.x <= self.boxBackground.frame.size.width/2) {
                            //left bottom
                            if (_delegate) {
                                if ([self.delegate respondsToSelector:@selector(buttonWithLabel:)]&&self.bottomLeft) {
                                    [self.delegate buttonWithLabel:GSTextBoxButtonBottomLeft];
                                }
                            }
                        }else{
                            //right bottom
                            if (_delegate) {
                                if ([self.delegate respondsToSelector:@selector(buttonWithLabel:)]&&self.bottomRight) {
                                    [self.delegate buttonWithLabel:GSTextBoxButtonBottomRight];
                                }
                            }
                        }
                    }
                    
                }else{
                    //cancel touch
                    if (_delegate) {
                        if ([self.delegate respondsToSelector:@selector(buttonWithLabel:)]) {
                            [self.delegate buttonWithLabel:GSTextBoxButtonCancel];
                        }
                    }
                }
            }break;
            default:
                NSLog(@"GSTextBoxNode#Bad Touch, unknown event");
                break;
        }
        
    }else{
        //unknown handling for multiple touches
    }
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    //skip touch events as long as text is running
    if (![self.nextPage parent]) {
        return;
    }
}

- (void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    
    //skip touch events as long as text is running
    if (![self.nextPage parent]) {
        return;
    }
}

#pragma mark - GSTextAutoType Delegate

/** Method to run the next page after fading in
 */
- (void)runNextItem{
    
    //check wether there are more pages
    if ([self.textPages count]>0) {
        NSString *text = [[self.textPages objectAtIndex: 0] copy];
        [self.textPages removeObjectAtIndex:0];
        
        [self.textLabel typeText:text withDelay:self.delayForTypeAnimation];
    }else{
        
        //perform finished into the call object
        if (self.delegate) {
            if ([self.delegate respondsToSelector:@selector(finishedTyping)]) {
                [self.delegate performSelector:@selector(finishedTyping) withObject:nil];
            }
        }
    }
}

/** Method to fade in the text back in and start showing next page
 */
-(void)fadeInAndReplace{
    
    //write empty string
    [self.textLabel setText:@""];
    
    //fade in the text
    [self.textLabel runAction:[SKAction fadeInWithDuration:0.0]];
    
    if (self.textPages) {
        [self performSelector:@selector(runNextItem) withObject:nil afterDelay:self.delayToNextPage];
    }
}

/** Method to continue to the next page
 */
- (void)continueTypeNextPage{
    
    //check wether it needs to fade out the text
    if (_willHide) {
        
        SKAction *action = [SKAction sequence:@[[SKAction waitForDuration:0.5f],
                             [SKAction fadeOutWithDuration:GSTEXT_FADEOUT_SPEED],
                             [SKAction runBlock:^{
                                [self performSelector:@selector(fadeInAndReplace)];
                             }]]];
        [self.textLabel runAction:action];
    }else{
        if (self.textPages) {
            [self performSelector:@selector(runNextItem) withObject:nil afterDelay:self.delayToNextPage];
        }else{
            
            //ignore this block if battle mode
            if (self.boxLayout == GSTextBoxLayoutText) {
                //no more pages available
                
                //perform finished into the call object
                if (self.delegate) {
                    if ([self.delegate respondsToSelector:@selector(finishedTyping)]) {
                        [self.delegate performSelector:@selector(finishedTyping) withObject:nil];
                    }
                }
            }
        }
    }
}

- (void)typingFinished:(GSTextAutoTypeNode *)sender{
    
    //user needs to tap for continue
    if (!self.isAutoContinue) {
        //show next button
        [self.nextPage setZPosition:kTextBoxButtonLayerTagValue];
        [self addChild:self.nextPage];
        return;
    }
    
    //continue type next page
    [self continueTypeNextPage];
}

#pragma mark - Public Method implementations

- (void)setBoxMode:(GSTextBoxLayout)layout{
    
    //checck which layout was selected
    switch (layout) {
        case GSTextBoxLayoutText:
            if (layout!=self.boxLayout) {
                
                //any item is available, so remove them
                if (self.topLeft) {
                    [self.topLeft removeFromParent];
                }
                
                if (self.topRight) {
                    [self.topRight removeFromParent];
                }
                
                if (self.bottomLeft) {
                    [self.bottomLeft removeFromParent];
                }
                
                if (self.bottomRight) {
                    [self.bottomRight removeFromParent];
                }
                [self.gridBox removeFromParent];
            }
            break;
        case GSTextBoxLayoutBattle:
            
            if (layout!=self.boxLayout) {
                //hide any string
                [self.textLabel setText:@""];
                [self.gridBox setZPosition:kBoxLayerGridTagValue];
                [self addChild:self.gridBox];
                
                //add all buttons
                [self.topLeft setZPosition:kTextBoxButtonLayerTagValue];
                [self addChild:self.topLeft];
                [self.topRight setZPosition:kTextBoxButtonLayerTagValue];
                [self addChild:self.topRight];
                [self.bottomLeft setZPosition:kTextBoxButtonLayerTagValue];
                [self addChild:self.bottomLeft];
                [self.bottomRight setZPosition:kTextBoxButtonLayerTagValue];
                [self addChild:self.bottomRight];
            }
            break;
        default:
            break;
    }
    self.boxLayout = layout;
}

- (void) typeText:(NSString*)text withDelay:(float) delay withHide:(BOOL)willHide{
    
    //update hide flag
    self.willHide = willHide;
    
    //convert string to string with line breaks to show only in visible part of the display
    NSString *textWithLineBreaks =[text stringSplitByNumOfSymbols:GSBOX_TEXTBOX_LENGTH];
    
    //check rows
    NSInteger numberOfRows = [textWithLineBreaks numberOfLines];
    
    if (numberOfRows > GSTEXT_MAX_ROWS_PER_PAGE) {
        //too many rows, try to split into next page
        self.textPages = [NSMutableArray arrayWithArray:[textWithLineBreaks componentsSeparatedByString:@"\n" withBundleSize:GSTEXT_MAX_ROWS_PER_PAGE]];
        
        self.delayForTypeAnimation = delay;
        [self runNextItem];
    }else{
        //text is short enough
        self.textPages = nil;
        
        //start typing text
        [self.textLabel typeText:textWithLineBreaks withDelay:delay];
    }
}

- (void)initButtonLabelsForTopLeft:(NSString*)tLeft andTopRight:(NSString*)tRight andBottomLeft:(NSString*)bLeft andBottomRight:(NSString*)bRight{
    
    const int fixedInsets = 9;
    
    //get box size to fix the position
    CGSize boxSize = self.boxBackground.size;
    
    //top left button
    if (tLeft) {
        self.topLeft = [[GSTextViewNode alloc] initNodeWithFontNamed:_fontName];
        self.topLeft.fontColor = _fontColor;
        self.topLeft.fontSize = _battleFontSize;
        [self.topLeft setText:[tLeft stringSplitByNumOfSymbols:GSBOX_TEXTBOX_BATTLE_LENGTH]];
        [self.topLeft setPosition:CGPointMake(boxSize.width*1/4, boxSize.height*3/4-fixedInsets)];
    }
    
    //top right button
    if (tRight) {
        self.topRight = [[GSTextViewNode alloc] initNodeWithFontNamed:_fontName];
        self.topRight.fontColor = _fontColor;
        self.topRight.fontSize = _battleFontSize;
        [self.topRight setText:[tRight stringSplitByNumOfSymbols:GSBOX_TEXTBOX_BATTLE_LENGTH]];
        [self.topRight setPosition:CGPointMake(boxSize.width*3/4, boxSize.height*3/4-fixedInsets)];
    }
    
    //bottom left button
    if (bLeft) {
        self.bottomLeft = [[GSTextViewNode alloc] initNodeWithFontNamed:_fontName];
        self.bottomLeft.fontColor = _fontColor;
        self.bottomLeft.fontSize = _battleFontSize;
        [self.bottomLeft setText:[bLeft stringSplitByNumOfSymbols:GSBOX_TEXTBOX_BATTLE_LENGTH]];
        [self.bottomLeft setPosition:CGPointMake(boxSize.width*1/4, boxSize.height*1/4+fixedInsets)];
    }
    
    //bottom right button
    if (bRight) {
        self.bottomRight = [[GSTextViewNode alloc] initNodeWithFontNamed:_fontName];
        self.bottomRight.fontColor = _fontColor;
        self.bottomRight.fontSize = _battleFontSize;
        [self.bottomRight setText:[bRight stringSplitByNumOfSymbols:GSBOX_TEXTBOX_BATTLE_LENGTH]];
        [self.bottomRight setPosition:CGPointMake(boxSize.width*3/4, boxSize.height*1/4+fixedInsets)];
    }
}


@end
