/*
 
 NSString+Newliner.m
 
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

#import "NSString+Newliner.h"

@implementation NSString (Newliner)

- (NSString*)stringSplitByNumOfSymbols:(NSUInteger)numbers{
    
    //split the string by spaces
    NSArray *words = [self componentsSeparatedByString:@" "];
    
    //now spaces available or only one component
    if ([words count]<=1) {
        return self;
    }else{
        //there are multiple components
        
        //var for the whole string
        NSString *concatString = @"";
        
        //init with first part
        NSString *rowString = [NSString stringWithFormat:@"%@ ",[words objectAtIndex:0]];
        
        for (int i=1; i<words.count; i++) {
            
            NSString *part = [words objectAtIndex:i];
            
            if ([rowString length]+[part length]>numbers) {
                //the string is already longer than max
                concatString = [NSString stringWithFormat:@"%@%@\n",concatString,rowString];
                
                //put the part into full string
                rowString = @"";
            }
            
            rowString = [NSString stringWithFormat:@"%@%@ ",rowString,part];
        }
        concatString = [NSString stringWithFormat:@"%@%@",concatString,rowString];
        
        return concatString;
    }
}

- (NSUInteger)numberOfLines{
    //count the items
    return [[self componentsSeparatedByString:@"\n"] count];
}


- (NSArray*)componentsSeparatedByString:(NSString *)separator withBundleSize:(NSUInteger)numbers{
    
    //split all items
    NSArray *allItems = [self componentsSeparatedByString:separator];
    
    
    if ([allItems count]<numbers) {
        //too less items, so return own string in array
        return [NSArray arrayWithObject:self];
    }else{
        NSMutableArray *components = [NSMutableArray array];
        
        int numberOfItems = [allItems count]/numbers;
        
        //need one more for an incomplete row
        if ([allItems count]%numbers > 0) {
            numberOfItems++;
        }
        
        for (int i=0; i < numberOfItems; i++) {
            //first item in the array
            NSString *string = [allItems objectAtIndex:i*numbers];
            
            for (int j=1; j<numbers; j++) {
                
                //stop to prevent overflow on the last part (incomplete)
                if (i*numbers+j >= [allItems count]) {
                    break;
                }
                string = [NSString stringWithFormat:@"%@%@%@",string,separator,[allItems objectAtIndex:i*numbers+j]];
            }
            
            [components addObject:string];
        }
        return components;
    }
}

- (NSArray*)componentsSeparatedByString:(NSString *)separator atIndex:(NSUInteger)index{
    
    //split all items
    NSArray *allItems = [self componentsSeparatedByString:separator];
    
    //only possible if the number of items is lower than the index
    if (index > [allItems count]&&[allItems count]>1) {
        //enough items available
        
        //init helping variables
        NSString *firstPart = [allItems objectAtIndex:0];
        NSString *secondPart = [allItems objectAtIndex:index];
        
        for (int i=1; i<[allItems count]; i++) {
            if (index>i) {
                firstPart = [NSString stringWithFormat:@"%@%@%@",firstPart,separator,[allItems objectAtIndex:i]];
            }else{
                
                //index was already inserted
                if (index==i) {
                    continue;
                }else{
                    secondPart = [NSString stringWithFormat:@"%@%@%@",secondPart,separator,[allItems objectAtIndex:i]];
                }
            }
        }
        return [NSArray arrayWithObjects:firstPart,secondPart, nil];
    }else{
        return nil;
    }
}

@end
