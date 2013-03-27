#import "PaceCalculatorController.h"

@implementation PaceCalculator
- (IBAction)buttonPressed:(id)sender {
//    paceField.stringValue = @"8:01";
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
//	printf("seconds: %d\n", seconds);
	
	formatter.dateFormat = @"hh";
	int hours = [[formatter stringFromDate:timeDate] intValue];
	if(hours == 12) { //is this because 12 is noon?
		hours = 0;
	}
//	printf("hours: %d\n", hours);
	
	formatter.dateFormat = @"mm";
	int minutes = [[formatter stringFromDate:timeDate] intValue];
//	printf("minutes: %d\n", minutes);
	
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
//	printf("seconds: %d\n", seconds);
		
	formatter.dateFormat = @"mm";
	int minutes = [[formatter stringFromDate:timeDate] intValue];
//	printf("minutes: %d\n", minutes);
	
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
//	printf("seconds: %d\n", seconds);
		
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
	
//	printf("in calculate Pace, h:m:s %d:%d:%d\n", h, m, s);
	
	NSString *timerend = [[NSString alloc] initWithFormat:@"%2d:%02.2d:%02.2d", h, m, s];
	
//	NSLog(@"value is %@\n", timerend);
	
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

//-(void) convertValues {
//
////	 printf("hardcoding the time\n");
////	 NSString *timeString = @"2:3";//3661
//	 NSString *timeString = timeField.stringValue;
//	 NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//
//	 formatter.dateFormat = @"hh:mm:ss";
//	 NSDate *timeDate = [formatter dateFromString:timeString];
//
//	 formatter.dateFormat = @"ss";
//	 int seconds = [[formatter stringFromDate:timeDate] intValue];
//	 printf("seconds: %d\n", seconds);
//	 
//	 formatter.dateFormat = @"hh";
//	 int hours = [[formatter stringFromDate:timeDate] intValue];
//	 if(hours == 12) {
//		 hours = 0;
//	 }
//	 printf("hours: %d\n", hours);
//
//	 formatter.dateFormat = @"mm";
//	 int minutes = [[formatter stringFromDate:timeDate] intValue];
//	 printf("minutes: %d\n", minutes);
//	 
//	 totalSeconds = seconds + (minutes * 60) + (hours * 3600);
////	 if(totalSeconds == 0) { 
////		 [self convertValuesNoHours];
////	 } else {
//////	 int t = [timeField.stringValue intValue];
////		 printf("in convertValues - value of time = %d and distance %d\n", totalSeconds, distance);	
////	 }
//	 	 
//}
//
//-(void) calculatePace {
//	//get totalSeconds
//
////	[self convertValuesNoHours];
//	[self convertValues];
//		
//	if(distance != 0) {
//		printf("in calculate Pace, timeInSeconds %d\n", totalSeconds);
//		secondsPace = totalSeconds / distance;
//	}
//	int m = secondsPace / 60;
//	int s = secondsPace - (m * 60); //16*60+30 = 960+30 = 990
//	int hours = m / 60;
//	printf("in calculate Pace, h:m:s %d:%d:%d\n", hours, m, s);
//
//	NSString *timerend = [[NSString alloc] initWithFormat:@"%2d:%02.2d:%02.2d", hours, m, s];
//	
//	NSLog(@"value is %@\n", timerend);
//	
//	paceField.stringValue = timerend;	 
//}
////given we have pace and distance
//-(void) calculateTotalTime {
//	//get totalSeconds
//	NSString *paceString2 = paceField.stringValue;
//	NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
//	
//	formatter2.dateFormat = @"mm:ss";
//	NSDate *timeDatePace = [formatter2 dateFromString:paceString2];
//	
//	NSLog(@"paceString2 is %@\n", paceString2);	
//	
//	formatter2.dateFormat = @"ss";
//	int secondsPace2 = [[formatter2 stringFromDate:timeDatePace] intValue];
//	printf("secondsPace: %d\n", secondsPace2);
//	
////	formatter2.dateFormat = @"hh";
////	int hoursPace = [[formatter2 stringFromDate:timeDatePace] intValue];
////	printf("hoursPace: %d\n", hoursPace);
//	
//	formatter2.dateFormat = @"mm";
//	int minutesPace = [[formatter2 stringFromDate:timeDatePace] intValue];
//	printf("minutesPace: %d\n", minutesPace);
//	
//	totalSecondsPace = secondsPace2 + (minutesPace * 60) ;//+ (hoursPace * 3600);
//	
//	int time = totalSecondsPace * distance;	
//	int m = time / 60;
//	printf("in calculate m %d - time %d\n", m, time);
//	int hours = 0;
//
//	while(m > 60 ) {
//		m = m - 60;
//		hours = hours + 1;
//		printf("2 in calculate m %d - time %d\n", m, time);
//	}
//	printf("3 in calculate m %d - time %d\n", m, time);
//
//	int s = time - (m * 60) - 3600 * hours;
//	printf("in calculate total time, h:m:s %d:%d:%d\n", hours, m, s);
//	
//	NSString *t = [[NSString alloc] initWithFormat:@"%2d:%02.2d:%02.2d", hours, m, s];
//	timeField.stringValue = t;
//	
//	
//}
//-(void) convertValuesForDistance {	
//
//	NSString *paceString2 = paceField.stringValue;
//	NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
//
//	formatter2.dateFormat = @"mm:ss";
//	NSDate *timeDatePace = [formatter2 dateFromString:paceString2];
//
//	NSLog(@"paceString2 is %@\n", paceString2);	
//		
//	formatter2.dateFormat = @"ss";
//	int secondsPace2 = [[formatter2 stringFromDate:timeDatePace] intValue];
//	printf("secondsPace: %d\n", secondsPace2);
//	
////	formatter2.dateFormat = @"hh";
////	int hoursPace = [[formatter2 stringFromDate:timeDatePace] intValue];
////	printf("hoursPace: %d\n", hoursPace);
//	
//	formatter2.dateFormat = @"mm";
//	int minutesPace = [[formatter2 stringFromDate:timeDatePace] intValue];
//	printf("minutesPace: %d\n", minutesPace);
//	
//	totalSecondsPace = secondsPace2 + (minutesPace * 60) ;//+ (hoursPace * 3600);
//
//	if(totalSecondsPace != 0) {
//		distance = (float) totalSeconds / totalSecondsPace;
//	}
//	
//	NSString *d = [[NSString alloc] initWithFormat:@"%02.2f", distance];
//	distanceField.stringValue = d;	 	
//}
//
////given we have pace and time
//-(void) calculateDistance {
//	//get totalSeconds
//	NSString *paceString2 = paceField.stringValue;
//	NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
//	
//	formatter2.dateFormat = @"mm:ss";
//	NSDate *timeDatePace = [formatter2 dateFromString:paceString2];
//	
//	NSLog(@"paceString2 is %@\n", paceString2);	
//	
//	formatter2.dateFormat = @"ss";
//	int secondsPace2 = [[formatter2 stringFromDate:timeDatePace] intValue];
//	printf("secondsPace: %d\n", secondsPace2);
//	
//	//	formatter2.dateFormat = @"hh";
//	//	int hoursPace = [[formatter2 stringFromDate:timeDatePace] intValue];
//	//	printf("hoursPace: %d\n", hoursPace);
//	
//	formatter2.dateFormat = @"mm";
//	int minutesPace = [[formatter2 stringFromDate:timeDatePace] intValue];
//	printf("minutesPace: %d\n", minutesPace);
//	
//	totalSecondsPace = secondsPace2 + (minutesPace * 60) ;//+ (hoursPace * 3600);
//	
//	if(totalSecondsPace != 0) {
//		[self convertValues];
//		distance = (float) totalSeconds / totalSecondsPace;
//	}
//	NSString *d = [[NSString alloc] initWithFormat:@"%02.2f", distance];
//	distanceField.stringValue = d;	 		
//}

//	printf("in calculate Pace, distance hardcoded to 2 time to 16:30\n");
//	distance = 2;
//	distanceField.stringValue = @"2";
//	timeField.stringValue = @"16:30";

//	NSString *nameText = [[NSString alloc] initWithFormat:@"%d:%d",m, s];
//	NSLog(@"value is %@\n", nameText);

//	printf("m:s = %d:%d\n", m, s);
//	paceField.stringValue = @"%d", m;

//	float aFloat = 5.34245;
//	int aInteger = 3;
//	NSString *aString = @"A string";
//	NSLog(@"This is my float: %f \n\n And here is my integer: %i \n\n  And finally my string: %@", aFloat, aInteger, aString);	

//[paceField.stringValue stringwithFormat:@"%d", m];
//	NSString *nameText = [NSString stringWithFormat:@"%@:%@",[timeField stringValue], [timeField stringValue]];

//	paceField.stringValue = m +":"+s;
//need to concatentate a string M:S in paceField
//	paceField.stringValue = "M:s";



@end
