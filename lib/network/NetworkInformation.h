//
//  NetworkInformation.h
//  iPadPosDemo
//
//  Created by MasashiTateno on 13/06/13.
//
//

#import <Foundation/Foundation.h>

UIKIT_EXTERN const int NetworkInformationInterfaceTypeIPv4;
UIKIT_EXTERN const int NetworkInformationInterfaceTypeMAC;
UIKIT_EXTERN const NSString *NetworkInformationInterfaceAddressKey;

@interface NetworkInformation : NSObject{
    NSMutableDictionary *allInterfaces;
}

@property (nonatomic, readonly) NSArray *allInterfaceNames;
@property (nonatomic, readonly) NSString *primaryIPv4Address;
@property (nonatomic, readonly) NSString *primaryMACAddress;

+ (NetworkInformation *)sharedInformation;

- (void)refresh;
- (NSString *)IPv4AddressForInterfaceName:(NSString *)interfaceName;
- (NSString *)MACAddressForInterfaceName:(NSString *)interfaceName;

@end
