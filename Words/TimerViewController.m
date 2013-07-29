//
//  TimerViewController.m
//  words
//
//  Created by ASPCartman on 29.07.13.
//  Copyright (c) 2013 ASPCartman. All rights reserved.
//

#import "TimerViewController.h"
#import "IXPickerOverlayView.h"
#include <mach/mach_time.h>

@interface TimerViewController ()
{	 
    NSInteger interval;
}
@property (strong,nonatomic) IBOutlet UILabel *timerLabel;
@property (strong,nonatomic) IBOutlet UIButton *playButton;
@property (assign) NSInteger currentTime;
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation TimerViewController
@synthesize timer = _timer;
- (void) viewDidLoad
{
	self.currentTime = 30*1000;
	[self updateTimeLabel];
	_timer = nil;
}

- (void) viewWillDisappear:(BOOL)animated
{
	[self stopTimer];
	[super viewWillDisappear:animated];
}

- (IBAction) back
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)startTimer
{

	_timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(minus) userInfo:nil repeats:YES];
	[self.playButton setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];

}

- (void)stopTimer
{
	[_timer invalidate];
	_timer = nil;
	[self.playButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];

}

- (IBAction) toggleTimer
{	
	if (_timer == nil)
		[self startTimer];
	else 
		[self stopTimer];
}

- (void) minus
{
	static NSInteger prevCallSystemTime = 0;
	static NSTimer *prevCallTimer = nil;
	static const int64_t kOneMillion = 1000 * 1000;
    static mach_timebase_info_data_t s_timebase_info;
	
    if (s_timebase_info.denom == 0) {
        (void) mach_timebase_info(&s_timebase_info);
    }
	NSInteger currentSystemTime = (NSInteger)((mach_absolute_time() * s_timebase_info.numer) / (kOneMillion * s_timebase_info.denom));

	if (prevCallTimer != _timer)
		prevCallSystemTime = 0;
	if (prevCallSystemTime == 0)
		prevCallSystemTime = currentSystemTime;
	
	
	NSInteger diff = currentSystemTime - prevCallSystemTime;
	prevCallSystemTime = currentSystemTime;
	prevCallTimer = _timer;
	_currentTime -= diff;
	if (_currentTime < 0)
	{
		_currentTime = 0;
		[self stopTimer];
	}
	[self updateTimeLabel];
}

- (IBAction) reset
{
	[self stopTimer];
	_currentTime = 30*1000;
	[self updateTimeLabel];
}

#pragma mark TimeLabelShit
- (void) updateTimeLabel
{
	[self setMinutes:[self minutes]
			 seconds:[self seconds]
			mseconds:[self mseconds]];
}

- (NSInteger) minutes
{
	return (self.currentTime/1000) / 60;
}

- (NSInteger) seconds
{
	return (self.currentTime/1000) % 60;
}

- (NSInteger) mseconds
{
	return self.currentTime % 1000 / 10;
}

- (void) setMinutes:(NSInteger)minutes seconds:(NSInteger)seconds mseconds:(NSInteger)mseconds
{
	self.timerLabel.text = [NSString stringWithFormat: @"%02d:%02d.%02d", minutes,seconds,mseconds];
}

- (IBAction)up:(id)sender
{
	[self stopTimer];
	
	NSInteger currentTime = self.currentTime;
	currentTime += 10*1000;
	currentTime -= currentTime % 10000;
	self.currentTime = currentTime;
	
	[self updateTimeLabel];
}

- (IBAction)down:(id)sender
{
	[self stopTimer];
	
	NSInteger currentTime = self.currentTime;
	currentTime -= 10*1000;
	currentTime -= currentTime % 10000;
	if (currentTime < 0)
		currentTime = 0;
	self.currentTime = currentTime;
	
	[self updateTimeLabel];
}

@end
