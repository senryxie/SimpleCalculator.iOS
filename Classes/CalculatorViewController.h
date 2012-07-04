//
//  CalculatorViewController.h
//  Calculator
//
//  Created by Dominic Chang on 11/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalculatorBrain.h"
#include <math.h>

@interface CalculatorViewController : UIViewController
{
	IBOutlet UILabel *display;
	IBOutlet UILabel *displayHistoryOperation;
	IBOutlet UILabel *displayMemory;
    
	BOOL        userIsInTheMiddleOfTypingANumber;
    BOOL        canTypingNumber;
    BOOL        canTypingOperation;
    BOOL        isFirstEqual;
    NSInteger   currentDisplayHistoryLength;
}

@property (nonatomic, retain)NSString           *tempDisplayNumberString;

//digits or decimal points
- (IBAction)digitPressed:(UIButton *)sender;

//operations
- (IBAction)operationPressed:(UIButton *)sender;

//memory operations
- (IBAction)memPressed:(UIButton *)sender;
@end
