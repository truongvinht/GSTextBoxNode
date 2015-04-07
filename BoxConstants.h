/*
 
 BoxConstants.h
 
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

#ifndef GSBoxConstants_h
#define GSBoxConstants_h

///layer level of the box
#define kBoxLayerTagValue 30
#define kBoxLayerGridTagValue 31
#define kBoxBGLayerTagValue 32
#define kTextBoxLayerTagValue 33
#define kTextBoxButtonLayerTagValue 34

//textbox max characters per row
#define GSBOX_TEXT_LENGTH 22
#define GSBOX_TEXTBOX_LENGTH 32
#define GSBOX_TEXTBOX_BATTLE_LENGTH 12

//flag wether it is iphone 5 screen
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

//check wether is retina
#define IS_RETINA [[UIScreen mainScreen] scale] > 1.0f


//constants for configure the text box

/// speed of fading out the text
#define GSTEXT_FADEOUT_SPEED 2.0f

/// number of rows displaying in the box
#define GSTEXT_MAX_ROWS_PER_PAGE 5

/// arrow displayed for continue to next page
#define GSTEXT_ARROW_OFFSET 30.0f

/// position of the arrow
/// | 1  2 |
/// |      |
/// | 3  4 |
#define GSTEXT_ARROW_POSITION 4

/// default font size
#define GSTEXTBOX_DEFAULT_FONTSIZE 18

/// delay time for displaying the next page
#define GSTEXTBOX_DELAY_TO_NEXT_PAGE 2.0f

///symbol of the next page indicator
#define GSTEXTBOX_NEXT_SYMBOL @"»"

//image name of the text box frame
#define GSTEXTBOX_BACKGROUND_FRAME @"textbox.png"

//image name of the text box grid for battle mode
#define GSTEXTBOX_BACKGROUND_GRID @"BoxbuttonGrid.png"

#endif
