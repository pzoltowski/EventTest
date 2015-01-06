#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController {
    EKEventStore* eventStore;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if (!eventStore) {
        eventStore = [EKEventStore new];
    }
    
    // Tu wywaliłem
    //    NSArray* cals = [eventStore calendarsForEntityType:EKEntityTypeEvent];
    //    NSLog(@"1st time calendars %@", cals);
    
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    
    switch (status)
    {
            // Update our UI if the user has granted access to their Calendar
        case EKAuthorizationStatusAuthorized:
        {
            NSLog(@"permission was already granted before");
//            NSArray *cals = [eventStore calendarsForEntityType:EKEntityTypeEvent];
            [self pullEvents];
            break;
        }
        case EKAuthorizationStatusNotDetermined:
        {
            __weak typeof(self) weakSelf = self;
            [eventStore requestAccessToEntityType:EKEntityTypeEvent
                                       completion:^(BOOL granted, NSError *error) {
                                           [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                               [weakSelf calendarAccessGranted:granted];
                                           }];
             }];
        }
            break;
        case EKAuthorizationStatusDenied:
        case EKAuthorizationStatusRestricted:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Privacy Warning"
                                                            message:@"Permission was not granted for Calendar"
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

- (void)calendarAccessGranted:(BOOL)granted {
    if (granted) {
        [self pullEvents];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Privacy Warning"
                                                        message:@"Permission was not granted for Calendar"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }

}

// Na moim symulatorze działa i zwraca kalendarze
// Mam nadzieję że pomoże 
- (void)pullEvents {
//    NSLog(@"granted after user confirmation");

    NSArray* cals = [eventStore calendarsForEntityType:EKEntityTypeEvent];
    
//    dispatch_sync(dispatch_get_main_queue(), ^{
//        [eventStore reset];
//        // refetch calendars
//        
//        NSLog(@"calendars %@", cals);
//    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
