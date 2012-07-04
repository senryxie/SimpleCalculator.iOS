//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Dominic Chang on 11/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//	

#import "CalculatorBrain.h"

@implementation CalculatorBrain

@synthesize operand;
@synthesize waitingOperation;
@synthesize memOperand;

- (void)performWaitingOperation:(BOOL )equal 
{
	if ([@"+" isEqual:waitingOperation])
    {
		operand = waitingOperand + operand; 
	} 
    else if ([@"x" isEqual:waitingOperation]) 
    {
		operand = waitingOperand * operand; 
	} 
    else if ([@"-" isEqual:waitingOperation])
    {
		if (waitingForOperand)
        {
			operand = operand - waitingOperand; 
		}else {
			operand = waitingOperand - operand; 
		}		
	} 
    else if ([@"÷" isEqual:waitingOperation])
    {
		if (waitingForOperand)
        {
			operand = operand / waitingOperand;		
		}else 
        {
			operand = waitingOperand / operand;
		}
	} 
    else 
    {
		waitingForOperand = YES;
	}
}

- (void)memClear
{
	memOperand = 0;
    operand = 0;
    waitingOperation = @"";
    waitingOperand = 0;
}

- (void)memAdd:(double )memNum
{
	memOperand = memOperand + memNum;
}

- (void)memSub:(double )memNum
{
	memOperand = memOperand - memNum;
}

//reset BOOL waitingForOperand
- (void)notwaitingForOperand
{
	waitingForOperand = NO;
}

- (double)performOperation:(NSString *)operation
{
	if ([@"+/-" isEqual:operation])
    {
		if (operand != 0)
        {
			operand = -operand;
		}
	}
	else if ([@"=" isEqual:operation])
    {
		double originalOperand = operand;		
		[self performWaitingOperation:YES];
		if (!waitingForOperand)
        {
			waitingOperand = originalOperand;			
			waitingForOperand = YES;			
		}
	}
	//two operand operations e.g. +,-,*,/ 
	else 
    {
		//perform operation if it is not waiting for an operand
		if (!waitingForOperand)
        {
			[self performWaitingOperation:NO];			
		}
		waitingOperand = operand;
		waitingOperation = operation;		
	}
	
	return operand;
}
@end
									