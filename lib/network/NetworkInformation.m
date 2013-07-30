//
//  NetworkInformation.m
//  iPadPosDemo
//
//  Created by MasashiTateno on 13/06/13.
//
//

#import "NetworkInformation.h"
#import <sys/ioctl.h>
#import <sys/types.h>
#import <sys/socket.h>
#import <sys/sockio.h>
#import <unistd.h>		// for close(), etc etc... perhaps ioctl() is included in this header
#import <net/if.h>		// for struct ifconf, struct ifreq
#import <net/if_dl.h>	// for struct sockaddr_dl, LLADDR
#import <netinet/in.h>	// for some reason... I have no idea. Without this inet_ntoa call causes compile error
#import <net/ethernet.h>// for either_ntoa()
#import <arpa/inet.h>	// for inet_ntoa()


#define NetworkInformation_IFCONF_BUFFER_LENGTH	4000
const int NetworkInformationInterfaceTypeIPv4 = AF_INET;
const int NetworkInformationInterfaceTypeMAC = AF_LINK;
const NSString *NetworkInformationInterfaceAddressKey = @"address";


static NetworkInformation *__sharedNetworkInformationInstance;
@implementation NetworkInformation


#pragma mark Properties


- (NSArray *)allInterfaceNames {
	if (!allInterfaces) {
		[self refresh];
	}
	
	return [allInterfaces allKeys];
}

- (NSString *)primaryIPv4Address {
	if (!allInterfaces) {
		[self refresh];
	}
	if ([self IPv4AddressForInterfaceName:@"en0"]) {
		return [self IPv4AddressForInterfaceName:@"en0"];
	} else if ([self IPv4AddressForInterfaceName:@"en1"]) {
		return [self IPv4AddressForInterfaceName:@"en1"];
	} else if ([self IPv4AddressForInterfaceName:@"en2"]) {
		return [self IPv4AddressForInterfaceName:@"en2"];
	} else if ([self IPv4AddressForInterfaceName:@"pdp_ip0"]) {
		return [self IPv4AddressForInterfaceName:@"pdp_ip0"];
	} else if ([self IPv4AddressForInterfaceName:@"pdp_ip1"]) {
		return [self IPv4AddressForInterfaceName:@"pdp_ip1"];
	} else if ([self IPv4AddressForInterfaceName:@"pdp_ip2"]) {
		return [self IPv4AddressForInterfaceName:@"pdp_ip2"];
	} else if ([self IPv4AddressForInterfaceName:@"pdp_ip3"]) {
		return [self IPv4AddressForInterfaceName:@"pdp_ip3"];
	} else {
		return nil;
	}
}

- (NSString *)primaryMACAddress {
	if (!allInterfaces) {
		[self refresh];
	}
	return [self MACAddressForInterfaceName:@"en0"];
}


#pragma mark Init/dealloc


- (id)init {
	if (self = [super init]) {
		allInterfaces = nil;
	}
	return self;
}

+ (NetworkInformation *)sharedInformation {
	if (!__sharedNetworkInformationInstance) {
		__sharedNetworkInformationInstance = [[NetworkInformation alloc] init];
	}
	return __sharedNetworkInformationInstance;
}


#pragma mark Other methods


- (void)refresh {
	
	if (allInterfaces) {
		allInterfaces = nil;
	}
	
	// Open socket
	int sockfd = socket(AF_INET, SOCK_DGRAM, 0);
	if (sockfd < 0) {
		NSLog(@"NetworkInformation refresh failed: socket could not be opened");
		return;
	}
    
	char buffer[NetworkInformation_IFCONF_BUFFER_LENGTH];
	struct ifconf ifc;
	ifc.ifc_len = NetworkInformation_IFCONF_BUFFER_LENGTH;
	ifc.ifc_buf = buffer;
	if (ioctl(sockfd, SIOCGIFCONF, &ifc) < 0) {
		NSLog(@"NetworkInformation refresh failed: ioctl execution failed");
		close(sockfd);
		return;
	}
	
	allInterfaces = [[NSMutableDictionary alloc] init];
	
	struct ifreq *p_ifr;
    NSString *address = nil;
	for (char *p_index=ifc.ifc_buf; p_index < ifc.ifc_buf+ifc.ifc_len; ) {
		p_ifr = (struct ifreq *)p_index;
		
		NSString *interfaceName = [NSString stringWithCString:p_ifr->ifr_name encoding:NSASCIIStringEncoding];
		NSNumber *family = [NSNumber numberWithInt:p_ifr->ifr_addr.sa_family];
		NSMutableDictionary *interfaceDict = nil;
		NSMutableDictionary *interfaceTypeDetailDict = nil;
		char temp[80];
		
		switch (p_ifr->ifr_addr.sa_family) {
			case AF_LINK:
				
				interfaceDict = [allInterfaces objectForKey:interfaceName];
				if (!interfaceDict) {
					interfaceDict = [NSMutableDictionary dictionary];
					[allInterfaces setObject:interfaceDict forKey:interfaceName];
				}
				
				interfaceTypeDetailDict = [interfaceDict objectForKey:family];
				if (!interfaceTypeDetailDict) {
					interfaceTypeDetailDict = [NSMutableDictionary dictionary];
					[interfaceDict setObject:interfaceTypeDetailDict forKey:family];
				}
				
				struct sockaddr_dl *sdl = (struct sockaddr_dl *) &(p_ifr->ifr_addr);
				int a,b,c,d,e,f;
				
				strcpy(temp, ether_ntoa((const struct ether_addr *)LLADDR(sdl)));
				sscanf(temp, "%x:%x:%x:%x:%x:%x", &a, &b, &c, &d, &e, &f);
				sprintf(temp, "%02X:%02X:%02X:%02X:%02X:%02X",a,b,c,d,e,f);
				
				address = [NSString stringWithCString:temp encoding:NSASCIIStringEncoding];
				[interfaceTypeDetailDict setObject:address forKey:NetworkInformationInterfaceAddressKey];
				
				break;
				
			case AF_INET:
				// IPv4 address
				
				interfaceDict = [allInterfaces objectForKey:interfaceName];
				if (!interfaceDict) {
					interfaceDict = [NSMutableDictionary dictionary];
					[allInterfaces setObject:interfaceDict forKey:interfaceName];
				}
				
				interfaceTypeDetailDict = [interfaceDict objectForKey:family];
				if (!interfaceTypeDetailDict) {
					interfaceTypeDetailDict = [NSMutableDictionary dictionary];
					[interfaceDict setObject:interfaceTypeDetailDict forKey:family];
				}
				
				struct sockaddr_in *sin = (struct sockaddr_in *) &p_ifr->ifr_addr;
				
				strcpy(temp, inet_ntoa(sin->sin_addr));
				
				address = [NSString stringWithCString:temp encoding:NSASCIIStringEncoding];
				[interfaceTypeDetailDict setObject:address forKey:NetworkInformationInterfaceAddressKey];
				
				break;
				
			default:
				break;
				
		}
		
		// Don't forget to calculate loop pointer!
		p_index += sizeof(p_ifr->ifr_name) + MAX(sizeof(p_ifr->ifr_addr), p_ifr->ifr_addr.sa_len);
	}
	
//	NSLog(@"allInterfaces = %@", allInterfaces);
	
	// Don't forget to close socket!
	close(sockfd);
}

- (NSString *)IPv4AddressForInterfaceName:(NSString *)interfaceName {
	NSNumber *interfaceType = [NSNumber numberWithInt:NetworkInformationInterfaceTypeIPv4];
    [self refresh];
	return [[[allInterfaces objectForKey:interfaceName] objectForKey:interfaceType] objectForKey:NetworkInformationInterfaceAddressKey];
}

- (NSString *)MACAddressForInterfaceName:(NSString *)interfaceName {
	NSNumber *interfaceType = [NSNumber numberWithInt:NetworkInformationInterfaceTypeMAC];
    [self refresh];
	return [[[allInterfaces objectForKey:interfaceName] objectForKey:interfaceType] objectForKey:NetworkInformationInterfaceAddressKey];
}

@end
