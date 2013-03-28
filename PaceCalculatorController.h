#import <Cocoa/Cocoa.h>

@interface PaceCalculator : NSObject {
    IBOutlet NSTextField *paceField;
    IBOutlet NSTextField *timeField;
    IBOutlet NSTextField *distanceField;
	
}
- (IBAction)buttonPressed:(id)sender;

-(void) testStringToSeconds;
-(void) testSecondsToString;
- (NSString *)timeFormatted:(int) totalSeconds;

-(NSString *) convertSecondsToString:(int) seconds;
-(NSInteger) convertStringToTime:(NSString *) timeAsTextField;

-(NSInteger) convertStringToTimeNoHours:(NSString *) timeAsTextField;
-(NSInteger) convertStringToTimeNoHoursMinutes:(NSString *) timeAsTextField;

-(void) calculateDistance;
-(void) calculateTotalTime;
-(void) calculatePace;


@end
