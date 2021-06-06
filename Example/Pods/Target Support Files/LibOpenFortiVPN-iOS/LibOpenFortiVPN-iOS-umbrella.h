#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "route.h"
#import "posix_spawn.h"
#import "openfortivpn.h"

FOUNDATION_EXPORT double LibOpenFortiVPN_iOSVersionNumber;
FOUNDATION_EXPORT const unsigned char LibOpenFortiVPN_iOSVersionString[];

