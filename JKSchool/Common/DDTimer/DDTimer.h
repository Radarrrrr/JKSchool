//
//  DDTimer.h
//  DDDevLib
//
//  Created by Radar on 12-11-26.
//  Copyright (c) 2012年 www.dangdang.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@class DDTimer;
@protocol DDTimerDelegate <NSObject>
@optional
-(void)ddTimerDidFired:(DDTimer*)ddTimer;
@end


@interface DDTimer : NSObject {

	NSTimer *_timer;
	double timeInterval;
	BOOL bRepeat;
	
@private
	id _delegate;		
}

@property(assign) id<DDTimerDelegate> delegate;

@property (nonatomic, retain) NSTimer *_timer;
@property (nonatomic, assign) double timeInterval;
@property (nonatomic, assign) BOOL bRepeat;
@property (nonatomic, assign) BOOL  isInmediately; //是否立即执行


#pragma mark -
#pragma mark in use functions
-(void)timerFireMethod;



#pragma mark -
#pragma mark out use functions
-(void)startTimer; 
-(void)stopTimer;  
-(void)fireTimer;

-(void)fireTimer:(NSTimeInterval) delayTime;



@end
