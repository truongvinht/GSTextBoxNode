/*
 
 NSString+Newliner.h
 
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

#ifndef NSSTRING_NEWLINER__H
#define NSSTRING_NEWLINER__H

#import <Foundation/Foundation.h>

/*! Add helping method to add new line into the text.*/
@interface NSString (Newliner)

/** Method to split the string into multiple rows by adding '\n'
 *  @param numbers is the number of max characters per row, if the string is too long and has no spaces, then keep it
 *  @return the string with new line characters
 */
- (NSString*)stringSplitByNumOfSymbols:(NSUInteger)numbers;

/** Method to read the number of line breaks in the string
 *  @return the number of break lines ('\n')
 */
- (NSUInteger)numberOfLines;

/** Method to seperate the string into two components
 *
 *  @param separator is the charachter which is responsible for the split
 *  @param numbers is the number of components concatenate together
 *  @return an array with up to NSStrings which are concatenated together
 */
- (NSArray*)componentsSeparatedByString:(NSString *)separator withBundleSize:(NSUInteger)numbers;

@end

#endif