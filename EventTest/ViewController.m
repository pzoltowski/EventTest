#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    static EKEventStore* eventStore;
    if (!eventStore) {
        eventStore = [[EKEventStore alloc] init];
    }
    
    NSArray* cals = [eventStore calendarsForEntityType:EKEntityTypeEvent];
    NSLog(@"1st time calendars @%", cals);
    
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    
    switch (status)
    {
            // Update our UI if the user has granted access to their Calendar
        case EKAuthorizationStatusAuthorized:
        {
            NSLog(@"permission was already granted before");
            NSArray* cals = [eventStore calendarsForEntityType:EKEntityTypeEvent];
            break;
        }
        case EKAuthorizationStatusNotDetermined:
        {
            [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error)
             {
                 if (granted)
                 {
                     NSLog(@"granted after user confirmation");
                     dispatch_sync(dispatch_get_main_queue(), ^{
                         [eventStore reset];
                         // refetch calendars
                         NSArray* cals = [eventStore calendarsForEntityType:EKEntityTypeEvent];
                         NSLog(@"calendars @%", cals);
                     });
                 } else {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Privacy Warning" message:@"Permission was not granted for Calendar"
                                                                    delegate:nil
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles:nil];
                     [alert show];
                 }
             }];
        }
            break;
        case EKAuthorizationStatusDenied:
        case EKAuthorizationStatusRestricted:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Privacy Warning" message:@"Permission was not granted for Calendar"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
            break;
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
