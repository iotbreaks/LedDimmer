//
//  ViewController.h
//  LedDimmer
//
//  Created by KennyHo on 3/3/16.
//  Copyright © 2016 Kenny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>



@interface ViewController : UIViewController <CBPeripheralManagerDelegate>

@property (strong, nonatomic)  CBPeripheralManager       *peripheralManager;
@property (strong, nonatomic) CBMutableCharacteristic   *transferCharacteristic;
@property (nonatomic, strong) IBOutlet UISwitch* adsSwitch;
@property (nonatomic, strong) IBOutlet UISlider* levelSlider;
@property (nonatomic, strong) NSString* uuidString;


-(IBAction)adsSwitchDidChange:(id)sender;
-(IBAction)levelSliderDidChange:(id)sender;


@end

