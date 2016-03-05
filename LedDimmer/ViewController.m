//
//  ViewController.m
//  LedDimmer
//
//  Created by KennyHo on 3/3/16.
//  Copyright © 2016 Kenny. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
    _uuidString = @"800A39F4-73F5-4BC4-A12F-17D1AD07A961";
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.peripheralManager stopAdvertising];
    [super viewWillDisappear:animated];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)adsSwitchDidChange:(id)sender {

    if (self.adsSwitch.on) {
        [self.peripheralManager startAdvertising:@{ CBAdvertisementDataServiceUUIDsKey : @[[CBUUID UUIDWithString:self.uuidString]] }];
        self.levelSlider.userInteractionEnabled = YES;
    } else {
        [self.peripheralManager stopAdvertising];
        
        self.levelSlider.userInteractionEnabled = NO;
    }

}

-(IBAction)levelSliderDidChange:(id)sender{
    [self.peripheralManager stopAdvertising];
    
    NSString* ledLevelString = [NSString stringWithFormat:@"%02X",(unsigned int) (self.levelSlider.value*255)];
    NSLog(@"slider value = %@", ledLevelString);

    self.uuidString = [NSString stringWithFormat:@"%@%@", ledLevelString, @"0A39F4-73F5-4BC4-A12F-17D1AD07A961"];

    [self adsSwitchDidChange:self];
    
}

#pragma mark - Peripheral Methods



/** Required protocol method.  A full app should take care of all the possible states,
 *  but we're just waiting for  to know when the CBPeripheralManager is ready
 */
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    // Opt out from any other state
    if (peripheral.state != CBPeripheralManagerStatePoweredOn) {
        return;
    }
    
    // We're in CBPeripheralManagerStatePoweredOn state...
    NSLog(@"self.peripheralManager powered on.");
    
    // ... so build our service.
    
    // Start with the CBMutableCharacteristic
    self.transferCharacteristic = [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:self.uuidString]
                                                                     properties:CBCharacteristicPropertyNotify
                                                                          value:nil
                                                                    permissions:CBAttributePermissionsReadable];
    // Then the service
    CBMutableService *transferService = [[CBMutableService alloc] initWithType:[CBUUID UUIDWithString:self.uuidString]
                                                                       primary:YES];
    
    // Add the characteristic to the service
    transferService.characteristics = @[self.transferCharacteristic];
    
    // And add it to the peripheral manager
    [self.peripheralManager addService:transferService];
}


@end
