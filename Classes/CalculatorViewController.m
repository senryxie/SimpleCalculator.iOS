//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Dominic Chang on 11/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"

//prviate properties
@interface CalculatorViewController()
@property(nonatomic, retain) CalculatorBrain *brain;
@end

@implementation CalculatorViewController
@synthesize brain;
@synthesize tempDisplayNumberString;

- (void) dealloc
{
    [tempDisplayNumberString release];
	[brain release];
	[super dealloc];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.tempDisplayNumberString = @"";
        currentDisplayHistoryLength = 0;
        canTypingNumber = NO;
        canTypingOperation = YES;
        isFirstEqual = NO;
    }
    return self;
}

- (CalculatorBrain *)brain 
{
	if (!brain)
    {
		brain = [[CalculatorBrain alloc] init];
	}
	return brain;
}

- (void)updatedisplayHistory
{
    NSString *realHistoryString = @"";
    if ([displayHistoryOperation.text length]>=currentDisplayHistoryLength && currentDisplayHistoryLength>0)
    {
        realHistoryString = [displayHistoryOperation.text substringToIndex:currentDisplayHistoryLength];
    }
    displayHistoryOperation.text = [NSString stringWithFormat:@"%@%@", realHistoryString, tempDisplayNumberString];
    NSLog(@"updatedisplayHistory\ndisplayHistoryOperation：%@ realHistoryString:%@ tempDisplayNumberString:%@", displayHistoryOperation.text,realHistoryString,tempDisplayNumberString);
}

- (void)resetData
{
    [self.brain memClear];
    display.text = @"";
    displayHistoryOperation.text = @"";
    currentDisplayHistoryLength = 0;
    self.tempDisplayNumberString = @"";
    canTypingNumber = YES;
    canTypingOperation = NO;
    isFirstEqual = NO;
}

- (IBAction)digitPressed:(UIButton *)sender
{
    if(!canTypingNumber)
    {
        [self resetData];
    }
	NSString *digit = sender.titleLabel.text;
    
	//prevent unnecessary leading zeros "00000"
	if ([@"0" isEqual:digit] && [@"0" isEqual:display.text])
    {
		userIsInTheMiddleOfTypingANumber = NO;
		return;
	}
	
	if (userIsInTheMiddleOfTypingANumber)
    {
		//if it's not a decimal or decimal is pressed but no decimal exist in the display value
		if (![@"." isEqual:digit] || ([@"." isEqual:digit] && [display.text rangeOfString:@"."].location == NSNotFound))
        {			
			display.text = [display.text stringByAppendingString:digit];
            if (tempDisplayNumberString)
            {
                self.tempDisplayNumberString = [NSString stringWithFormat:@"%@%@", self.tempDisplayNumberString,digit];
            }
            else
            {
                self.tempDisplayNumberString = digit;
            }
            [self updatedisplayHistory];
		}
	}
    else
    {
        if (tempDisplayNumberString)
        {
            self.tempDisplayNumberString = [NSString stringWithFormat:@"%@%@", self.tempDisplayNumberString,digit];
        }
        else
        {
            self.tempDisplayNumberString = digit;
        }
        [self updatedisplayHistory];
		display.text = digit;		 	
		userIsInTheMiddleOfTypingANumber = YES; 
		[self.brain notwaitingForOperand]; //reset not waiting for operand
	}
    canTypingOperation = YES;
}

- (IBAction)operationPressed:(UIButton *)sender
{
    if (!canTypingOperation)
    {
        return;
    }
	//getting the NSString of the operation: +, -, *, /, =, sqrt, etc...
	NSString *operation = sender.titleLabel.text;
	
	if ([@"=" isEqual:operation])
    {
		userIsInTheMiddleOfTypingANumber = NO;
	}
	self.brain.operand = display.text.doubleValue;
	double result = [self.brain performOperation:operation];
	
	if ( isnan(result) || isinf(result) )
    {
		display.text = @"Overflow";	
	}
    else
    {
        if ([@"=" isEqual:operation])
        {
            if(isFirstEqual)
            {
                display.text = [NSString stringWithFormat:@"%2.10g", result];
                self.tempDisplayNumberString = display.text;
                displayHistoryOperation.text = [NSString stringWithFormat:@"%@%@%@", displayHistoryOperation.text,operation,tempDisplayNumberString];
                currentDisplayHistoryLength=[displayHistoryOperation.text length]-[tempDisplayNumberString length];
                canTypingNumber = NO;
                canTypingOperation = YES;
                isFirstEqual = NO;
            }
        }
        else if([@"+/-" isEqual:operation])
        {
            display.text = [NSString stringWithFormat:@"%2.10g", result];
            self.tempDisplayNumberString = display.text;
            canTypingNumber = YES;
            isFirstEqual = YES;
            [self updatedisplayHistory];
        }
        else if([displayHistoryOperation.text length]>0)
        {
            NSString *lastString = [displayHistoryOperation.text substringFromIndex:[displayHistoryOperation.text length]-1];
            if (![@"+" isEqual:lastString] && ![@"-" isEqual:lastString] && ![@"x" isEqual:lastString] && ![@"÷" isEqual:lastString])
            {
                userIsInTheMiddleOfTypingANumber = NO;
                display.text = [NSString stringWithFormat:@"%2.10g", result];
                displayHistoryOperation.text = [NSString stringWithFormat:@"%@%@", displayHistoryOperation.text,operation];
                currentDisplayHistoryLength = [displayHistoryOperation.text length];
                self.tempDisplayNumberString = @"";
                canTypingNumber = YES;
                canTypingOperation = NO;
                isFirstEqual = YES;
            }
        }
	}
}

- (IBAction)memPressed:(UIButton *)sender
{
	NSString *operation = sender.titleLabel.text; //Operation: MC, M+, M-, MR
	
	if ([@"C" isEqual:operation])
    {
		[self resetData];
	}
    if ([@"<-" isEqual:operation])
    {
		if ([tempDisplayNumberString length]>1)
        {
            self.tempDisplayNumberString = [tempDisplayNumberString substringToIndex:[tempDisplayNumberString length]-1];
            display.text = tempDisplayNumberString;
            [self updatedisplayHistory];
        }
        else
        {
            [self resetData];
        }
	}
}

@end
