#import <Cocoa/Cocoa.h>

@interface PaceCalculator : NSObject {
    IBOutlet NSTextField *paceField;
    IBOutlet NSTextField *timeField;
    IBOutlet NSTextField *distanceField;
	
//	float distance;
//	int secondsPace;
//	int totalSeconds;
//	
//	int totalSecondsPace;
//
//	int secondsDistance;
	
	
}
- (IBAction)buttonPressed:(id)sender;

-(void) testStringToSeconds;
-(void) testSecondsToString;
- (NSString *)timeFormatted:(int) totalSeconds;

-(NSString *) convertSecondsToString:(int) seconds;
-(NSInteger) convertStringToTime:(NSString *) timeAsTextField;

-(NSInteger) convertStringToTimeNoHours:(NSString *) timeAsTextField;
-(NSInteger) convertStringToTimeNoHoursMinutes:(NSString *) timeAsTextField;


//-(NSInteger) convertStringToTime:(NSTextField*) timeAsTextField;

-(void) calculateDistance;
-(void) calculateTotalTime;
-(void) calculatePace;

//- (void)convertValues;
//-(void) convertValuesForDistance;

//- (void)convertValuesNoHours;

//-(void) calculatePace;
//-(void) calculateDistance;
//-(void) calculateTotalTime;


@end
