#import "PaceCalculatorController.h"

@implementation PaceCalculator
- (IBAction)buttonPressed:(id)sender {
// Uncomment these to hardcode data when development testing
//    	paceField.stringValue = @"8:01";
//	distanceField.stringValue = @"8";
//	timeField.stringValue = @"";
	
	//distance = [distanceField.stringValue floatValue];
	//if distance field is empty but time and pace is entered,

//      [self testSecondsToString]; //to test the converter method
//      [self testStringToSeconds]; //to test the converter method
	
	NSString *empty = @"";
	
	if ([distanceField.stringValue isEqualToString:empty] && ![timeField.stringValue isEqualToString:empty]  && ![paceField.stringValue isEqualToString:empty]) {
		[self calculateDistance];
	} else if ([timeField.stringValue isEqualToString:empty] && ![distanceField.stringValue isEqualToString:empty]  && ![paceField.stringValue isEqualToString:empty]) {
		//if time field is empty but distance and pace is entered,
		[self calculateTotalTime];
	} else {
		//by default, calculate pace (given you have values for distance and time - text in pace field is ignored
		[self calculatePace];
	}

}

//this might be best as a +
//this method has a bunch of object c centric formatting which might cause problems.
-(NSInteger) convertStringToTime:(NSString *) timeAsTextField
{
	float tSeconds = 0.0;
	
   	NSString *timeString = timeAsTextField;
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	
	//what does it do if it can't find hh or mm?
	formatter.dateFormat = @"hh:mm:ss";
	NSDate *timeDate = [formatter dateFromString:timeString];
	
	formatter.dateFormat = @"ss";
	int seconds = [[formatter stringFromDate:timeDate] intValue];
	
	formatter.dateFormat = @"hh";
	int hours = [[formatter stringFromDate:timeDate] intValue];
	if(hours == 12) { //is this because 12 is noon?
		hours = 0;
	}
	
	formatter.dateFormat = @"mm";
	int minutes = [[formatter stringFromDate:timeDate] intValue];
	
	tSeconds = seconds + (minutes * 60) + (hours * 3600);

	if(tSeconds == 0) {
		tSeconds = [self convertStringToTimeNoHours: timeAsTextField];
		if(tSeconds == 0) {
			tSeconds = [self convertStringToTimeNoHoursMinutes: timeAsTextField];
		}
	}
	
	return tSeconds;
	
}

-(NSInteger) convertStringToTimeNoHours:(NSString *) timeAsTextField
{
	float tSeconds = 0.0;
	
    	NSString *timeString = timeAsTextField;
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	
	formatter.dateFormat = @"mm:ss";
	NSDate *timeDate = [formatter dateFromString:timeString];
	
	formatter.dateFormat = @"ss";
	int seconds = [[formatter stringFromDate:timeDate] intValue];
		
	formatter.dateFormat = @"mm";
	int minutes = [[formatter stringFromDate:timeDate] intValue];
	
	tSeconds = seconds + (minutes * 60);
		
	return tSeconds;	
}
-(NSInteger) convertStringToTimeNoHoursMinutes:(NSString *) timeAsTextField
{
	float tSeconds = 0.0;
	
    	NSString *timeString = timeAsTextField;
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	
	formatter.dateFormat = @"ss";
	NSDate *timeDate = [formatter dateFromString:timeString];
	
	int seconds = [[formatter stringFromDate:timeDate] intValue];
		
	tSeconds = seconds;
	
	return tSeconds;
	
}


//this might be best as a +
-(NSString *) convertSecondsToString:(int) seconds
{
	int m = seconds / 60;
	int s = seconds - (m * 60);
	int h = 0;
	while(m > 59) {
		h = h + 1;
		m = m - 60;
	}
	
	NSString *timerend = [[NSString alloc] initWithFormat:@"%2d:%02.2d:%02.2d", h, m, s];
	
	return timerend;	
}
-(void) calculatePace
{
	int seconds = [self convertStringToTime:timeField.stringValue];
	printf("in calculate Pace, timeInSeconds %d\n", seconds);
	float distance = [distanceField.stringValue floatValue];
	
	if(distance != 0) {
		int sPace = seconds / distance;
		
		NSString *time = [self convertSecondsToString: sPace];
		paceField.stringValue = time;
	}
}
//given we have pace and distance
-(void) calculateTotalTime
{
	int sPace = [self convertStringToTime: paceField.stringValue];
	float distance = [distanceField.stringValue floatValue];
	int tTime = sPace * distance;
	
	NSString *time = [self convertSecondsToString: tTime];
	timeField.stringValue = time;
}
//given we have the pace and total time
-(void) calculateDistance
{
	int sPace  = [self convertStringToTime: paceField.stringValue];
	int sTime  = [self convertStringToTime: timeField.stringValue];
	
	if(sPace != 0) {
		float distance = (float)sTime / sPace;
		NSString *d = [[NSString alloc] initWithFormat:@"%02.2f", distance];
		distanceField.stringValue = d;
	}
}
-(void) testSecondsToString
{
	NSLog(@"0:00:59 - %@\n", [self convertSecondsToString:59]);
	NSLog(@"0:01:01 - %@\n", [self convertSecondsToString:61]);
	NSLog(@"0:02:00 - %@\n", [self convertSecondsToString:120]);
	NSLog(@"0:59:59 - %@\n", [self convertSecondsToString:3599]);
	NSLog(@"1:00:00 - %@\n", [self convertSecondsToString:3600]);
	NSLog(@"1:00:01 - %@\n", [self convertSecondsToString:3601]);
	NSLog(@"1:01:01 - %@\n", [self convertSecondsToString:3661]);
	NSLog(@"1:01:00 - %@\n", [self convertSecondsToString:3660]);
	NSLog(@"2:01:00 - %@\n", [self convertSecondsToString:7260]);
	NSLog(@"2:01:10 - %@\n", [self convertSecondsToString:7270]);

	NSLog(@"***********\n");

	NSLog(@"0:00:59 - %@\n", [self timeFormatted:59]);
	NSLog(@"0:01:01 - %@\n", [self timeFormatted:61]);
	NSLog(@"0:02:00 - %@\n", [self timeFormatted:120]);
	NSLog(@"0:59:59 - %@\n", [self timeFormatted:3599]);
	NSLog(@"1:00:00 - %@\n", [self timeFormatted:3600]);
	NSLog(@"1:00:01 - %@\n", [self timeFormatted:3601]);
	NSLog(@"1:01:01 - %@\n", [self timeFormatted:3661]);
	NSLog(@"1:01:00 - %@\n", [self timeFormatted:3660]);
	NSLog(@"2:01:00 - %@\n", [self timeFormatted:7260]);
	NSLog(@"2:01:10 - %@\n", [self timeFormatted:7270]);
	
}
-(void) testStringToSeconds
{

	NSString *time = [[NSString alloc] initWithFormat:@"%2d:%02.2d:%02.2d", 0, 0, 59];
	NSLog(@"59 - %d\n", [self convertStringToTime:time]);

	NSString *time2 = [[NSString alloc] initWithFormat:@"%2d:%02.2d:%02.2d", 0, 1, 1];
	NSLog(@"61 - %d\n", [self convertStringToTime:time2]);

	NSString *time3 = [[NSString alloc] initWithFormat:@"%2d:%02.2d:%02.2d", 0, 2, 0];
	NSLog(@"120 - %d\n", [self convertStringToTime:time3]);

	NSString *time4 = [[NSString alloc] initWithFormat:@"%2d:%02.2d:%02.2d", 0, 59, 59];
	NSLog(@"3599 - %d\n", [self convertStringToTime:time4]);

	NSString *time5 = [[NSString alloc] initWithFormat:@"%2d:%02.2d:%02.2d", 1, 0, 0];
	NSLog(@"3600 - %d\n", [self  convertStringToTime:time5]);

	NSString *time6 = [[NSString alloc] initWithFormat:@"%2d:%02.2d:%02.2d", 1, 0, 1];
	NSLog(@"3601 - %d\n", [self convertStringToTime:time6]);

	NSString *time7 = [[NSString alloc] initWithFormat:@"%2d:%02.2d:%02.2d", 1,1,1];
	NSLog(@"3661 - %d\n", [self convertStringToTime:time7]);

	NSString *time8 = [[NSString alloc] initWithFormat:@"%2d:%02.2d:%02.2d", 1,1,0];
	NSLog(@"3660 - %d\n", [self convertStringToTime:time8]);

	NSString *time9 = [[NSString alloc] initWithFormat:@"%2d:%02.2d:%02.2d", 2, 1, 0];
	NSLog(@"7260 - %d\n", [self convertStringToTime:time9]);

	NSString *time10 = [[NSString alloc] initWithFormat:@"%2d:%02.2d:%02.2d", 2, 1, 10];
	NSLog(@"7270 - %d\n", [self convertStringToTime:time10]);
	
	NSString *time11 = [[NSString alloc] initWithFormat:@"%2d:%02.2d:%02.2d", 0, 0, 59];
	NSLog(@"59 - %d\n", [self convertStringToTime:time11]);

	NSString *time12 = [[NSString alloc] initWithFormat:@"%2d:%02.2d:%02.2d", 0, 1, 1];
	NSLog(@"61 - %d\n", [self convertStringToTime:time12]);

	NSString *time13 = [[NSString alloc] initWithFormat:@"%2d:%02.2d:%02.2d", 0, 2, 0];
	NSLog(@"120 - %d\n", [self convertStringToTime:time13]);

	NSString *time14 = [[NSString alloc] initWithFormat:@"%2d:%02.2d:%02.2d", 0, 59, 59];
	NSLog(@"3599 - %d\n", [self convertStringToTime:time14]);
	
	NSString *time15 = [[NSString alloc] initWithFormat:@"%02.2d", 59];
	NSLog(@"59 - %d\n", [self convertStringToTime:time15]);
	
	NSString *time16 = [[NSString alloc] initWithFormat:@"%02.2d:%02.2d", 1, 1];
	NSLog(@"61 - %d\n", [self convertStringToTime:time16]);
	
	NSString *time17 = [[NSString alloc] initWithFormat:@"%02.2d:%02.2d", 2, 0];
	NSLog(@"120 - %d\n", [self convertStringToTime:time17]);
	
	NSString *time18 = [[NSString alloc] initWithFormat:@"%02.2d:%02.2d", 59, 59];
	NSLog(@"3599 - %d\n", [self convertStringToTime:time18]);
					
	NSString *time19 = [[NSString alloc] initWithFormat:@"%02.2d", 59];
	NSLog(@"59 - %d\n", [self convertStringToTime:time19]);
	
	NSString *time20 = [[NSString alloc] initWithFormat:@"%02.2d:%02.2d", 1, 1];
	NSLog(@"61 - %d\n", [self convertStringToTime:time20]);

}

- (NSString *)timeFormatted:(int)totalSeconds
{
	
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
	
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}


@end
