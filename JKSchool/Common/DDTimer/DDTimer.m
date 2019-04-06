//
//  DDTimer.m
//  DDDevLib
//
//  Created by Radar on 12-11-26.
//  Copyright (c) 2012年 www.dangdang.com. All rights reserved.
//

#import "DDTimer.h"


@implementation DDTimer
@synthesize delegate=_delegate;
@synthesize _timer;
@synthesize timeInterval;
@synthesize bRepeat;


#pragma mark -
#pragma mark system functions
- (void)dealloc
{
	[self stopTimer];
	
	[_timer release];
	[super dealloc];
}

#pragma mark -
#pragma mark in use functions
-(void)timerFireMethod
{
	//return to delegate 
	if(self.delegate &&[(NSObject*)self.delegate respondsToSelector:@selector(ddTimerDidFired:)])
	{
		[self.delegate ddTimerDidFired:self];
	}
}

#pragma mark -
#pragma mark out use functions
-(void)startTimer
{
    [self stopTimer];
	self._timer =  [NSTimer scheduledTimerWithTimeInterval:self.timeInterval
													target:self 
												  selector:@selector(timerFireMethod) 
												  userInfo:nil 
												   repeats:self.bRepeat];
    
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}
-(void)stopTimer
{
	if(self._timer && [self._timer isValid])
	{
		[self._timer invalidate];
	}	
}
-(void)fireTimer
{
	[self._timer fire];
}


-(void)fireTimer:(NSTimeInterval) delayTime
{
    NSDate *fireDate=[[NSDate date] dateByAddingTimeInterval:delayTime];
    [self._timer setFireDate:fireDate];
}

@end
