//
//  openfortivpn.h
//  openfortivpn
//
//  Created by Henry Kim on 2021/06/05.
//

#import <Foundation/Foundation.h>


//! Project version number for OpenFortiVPN.
FOUNDATION_EXPORT double OpenFortiVPNVersionNumber;

//! Project version string for OpenFortiVPN.
FOUNDATION_EXPORT const unsigned char OpenFortiVPNVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <OpenFortiVPN/PublicHeader.h>

/*!
 *  @brief     OpenFortiVPN(singleton) Notification Key
 */
NS_ASSUME_NONNULL_BEGIN
static NSString * OPENFORTIVPN_NOTIFICATION_RESULT = @"OpenFortiVPNNotificationResult";
NS_ASSUME_NONNULL_END

/*!
 *  @brief      OpenFortiVPN for iOS
 *  @details    OpenFortiVPN body
 *  @author     Henry Kim
 *  @date       2021/06/05
 */
@class OpenFortiVPN;

////////////////////////////////////////////////////////////////////////////////
// OpenFortiVPN Delegate Methods
////////////////////////////////////////////////////////////////////////////////
/*!
 *  @brief     OpenFortiVPN Protocol(Delegate), a.k.a. Listener methods
 */
@protocol OpenFortiVPNListener <NSObject>
@optional
- (void)openFortiVPN:(OpenFortiVPN * _Nonnull)gPlug onError:(NSError * _Nonnull)error;
- (void)openFortiVPN:(OpenFortiVPN * _Nonnull)gPlug onResults:(NSDictionary * _Nonnull)results;
- (void)openFortiVPN:(OpenFortiVPN * _Nonnull)gPlug onEvent:(NSDictionary * _Nonnull)event;
@end
////////////////////////////////////////////////////////////////////////////////


@interface OpenFortiVPN : NSObject

// MARK: - Shared instance of OpenFortiVPN
/*!
 *  @brief      OpenFortiVPN Singleton Instance
 *  @details    If using singleton, could be notified if using addObserver()
 */
+ (OpenFortiVPN * _Nonnull)shared;

// MARK: - Listener(Delegate) of OpenFortiVPN
////////////////////////////////////////////////////////////////////////////////
// OpenFortiVPN Delegate
////////////////////////////////////////////////////////////////////////////////
/*!
 *  @brief      OpenFortiVPN delegater(listener) setup
 *  @details    set delegate
 *  @param      listener - Delegator...
 */
- (void)setOpenFortiVPNListener:(id <OpenFortiVPNListener> _Nonnull)listener;

- (void)runOpenFortiVPN;

@end
