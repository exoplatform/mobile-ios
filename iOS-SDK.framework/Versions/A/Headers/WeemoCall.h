//
//  WeemoCall.h
//  iOS-SDK
//
//  Created by Charles Thierry on 7/16/13.
//  Copyright (c) 2013 Weemo. All rights reserved.
//

/**
 * \brief Delegate for the Weemo Singleton. Allows the Host Application to be notified upon events. All functions are optionals.
 */
@protocol WeemoCallDelegate <NSObject>
@optional
/**
 * \brief Called when the call starts receiving video.
 * \param sender The id of the WeemoCall which property changed
 * \param isReceiving Answers "Are we receing video?"
 * \sa WeemoCall::receivingVideo
 */
- (void)weemoCall:(id)sender videoReceiving:(BOOL)isReceiving;
/**
 * \brief Called when the call starts sending video.
  * \param sender The id of the WeemoCall which property changed
 * \param isSending Answers "Are we sending video?"
 * \sa WeemoCall::sendingVideo
 */
- (void)weemoCall:(id)sender videoSending:(BOOL)isSending;
/**
 * \brief Called when the incoming video profile changes
 * \param sender The id of the WeemoCall which property changed
 * \param profile The new profile used by the incoming video (impacts the videoIn view size). 0 is low definition, 1 is higher definition
 * \sa WeemoCall::videoProfile
 */
- (void)weemoCall:(id)sender videoProfile:(int)profile;
/**
 * \brief Called when the video source changes
 * \param sender The id of the WeemoCall which property changed
 * \param source The new source. 0 if front (on the screen side of the device) camera, back camera otherwise
 * \sa WeemoCall::videoSource
 */
- (void)weemoCall:(id)sender videoSource:(int)source;

/**
 * \brief Called when the microphone is muted.
 * \param sender The id of the WeemoCall which property changed
 * \param isSending sending captured audio stream if true, sending empty packets otherwise
 * \sa WeemoCall::audioStart
 * \sa WeemoCall::audioStop
 */
- (void)weemoCall:(id)sender audioSending:(BOOL)isSending;
/**
 * \brief Called when the audio route changes
 * \param sender The id of the WeemoCall which property changed
 * \param route The new route used. 0 is the usual route (regular phone equipment), 1 is the phone's speaker
 * \sa WeemoCall::audioRoute
 */
- (void)weemoCall:(id)sender audioRoute:(int)route;

/**
 * \brief Called when the status of the call changes
 * \param sender The id of the WeemoCall which property changed
 * \param status The new status of the call (i.e. CALLSTATUS_RINGING)
 * \sa WeemoCall:callStatus
 */
- (void)weemoCall:(id)sender callStatus:(int)status;



@end


/**
 * \brief Represents a call to a contact or a conference. Such an object is created on Weemo::createCall:.
 *
 * Remarks:
 * 
 * The Video views autorotates with the interface and following the interface rotation rules set by the Host App. However, the outgoing video stream rotates with the device. This allow the outgoing video to be shown with a correct rotation within the receiving device, even if the user sending the video is holding the device using a rotation not supported by the Host App.
 * 
 * When the device is held in a non supported rotation, the monitoring view of the outgoing video is rotated to indicate that the rotation is not supported, though the outgoing video is sent correctly rotated.
 */
@interface WeemoCall : NSObject

/**
 * \brief Hang up the call and stop it
 */
- (void)hangup;

/**
 * \brief Pause the call so it can be later resumed. WARNING: Not Yet Available
 */
- (void)pause;

/**
 * \brief Resume the call if it was paused. Pick it up if it is ringing.
 */
- (void)resume;

/**
 * \brief Start sending video from the camera. The video starts automatically upon call start.
 */
- (void)videoStart;

/**
 * \brief Stop sending video from the camera
 */
- (void)videoStop;

/**
 * \brief Start sending audio from the microphone. 
 *
 * While the outgoing audio stream starts automatically upon call start, it is posisble to mute the microphone, thus sending only empty frames. This function starts the sending of captured audio packet.
 *
 * Upon change, WeemoCallDelegate::weemoCall:audioSending: is called.
 \sa WeemoCallDelegate::weemoCall:audioSending:
 */
- (void)audioStart;

/**
 * \brief Stop sending audio from the microphone.
 *
 * The function stops the sending of captured audio packet. Enpty audio frames are sent instead.
 *
 * Upon change, WeemoCallDelegate::weemoCall:audioSending: is called.
 * \sa WeemoCallDelegate::weemoCall:audioSending:
 */
- (void)audioStop;

/**
 * \brief Switches camera source between front and back.
 *
 * Upon change, WeemoCallDelegate::weemoCall:videoSource: is called.
 * \sa WeemoCallDelegate::weemoCall:videoSource:
 */
- (void)toggleVideoSource;

/**
 * \brief Changes the audio route used by the call.
 *
 * Two audio outputs are possible: Loudspeaker(1) or Earphone/Headset(0). 
 *
 * Upon change, WeemoCallDelegate::weemoCall:audioRoute: is called.
 * \sa WeemoCallDelegate::weemoCall:audioRoute:
 */
- (void)toggleAudioRoute;


/**
 * \brief Request an incoming video profile change.
 *
 * Upon change, WeemoCallDelegate::weemoCall:videoProfile: is called.
 * \sa WeemoCallDelegate::weemoCall:videoProfile:
 */
- (void)toggleVideoProfile;



/**
 * \brief Status of the call (the value is one of the CALLSTATUS_* defines)
 *
 * Upon change, WeemoCallDelegate::weemoCall:callStatus: is called.
 * \sa WeemoCallDelegate::weemoCall:callStatus:
 * \sa CALLSTATUS_* in WeemoData.h
 */
@property(nonatomic, readonly) int callStatus;


/**
 * \brief Value changes after a WeemoCall::toggleVideoProfile.
 *
 * 0 is low quality profile, 1 if higher quality. 
 *
 * Upon change, WeemoCallDelegate::weemoCall:videoProfile: is called.
 * \sa WeemoCallDelegate::weemoCall:videoProfile:
 */
@property (nonatomic, readonly) int videoProfile;

/**
 * \brief Value changes after a WeemoCall::toggleAudioRoute. 
 *
 * 0 is default route (phone standard equipment), 1 is speaker/mic.
 *
 * Upon change, WeemoCallDelegate::weemoCall:audioRoute: is called.
 * \sa WeemoCallDelegate::weemoCall:audioRoute:
 */
@property (nonatomic, readonly) int audioRoute;

/**
 * \brief Value changes after a WeemoCall::toggleVideoSource.
 *
 * 0 is front camera, 1 is back camera.
 *
 * Upon change, WeemoCallDelegate::weemoCall:videoSource: is called.
 * \sa WeemoCallDelegate::weemoCall:videoSource:
 */

@property (nonatomic, readonly) int videoSource;

/**
 * \brief ID of the contact or the conference being called
 */
@property(readonly) NSString *contactID;

/**
 * \brief Whether or not the call is receiving video.
 *
 * This property changes when the video stream is started/ended on the other end.
 *
 * Upon change, WeemoCallDelegate::weemoCall:videoReceiving: is called.
 * \sa WeemoCallDelegate::weemoCall:videoReceiving:
 */
@property(nonatomic, readonly, getter = isReceivingVideo) BOOL receivingVideo;

/**
 * \brief Whether or not the call is sending video.
 *
 * This property changes when the network acknowledge the video status change on this end.
 *
 * Upon change, WeemoCallDelegate::weemoCall:videoSending: is called.
 * \sa WeemoCallDelegate::weemoCall:videoSending:
 */
@property(nonatomic, readonly, getter = isSendingVideo) BOOL sendingVideo;


/**
 * \brief Whether or not the call is sending captured audio packet
 *
 * This property changes when the network acknowledge the microphone status change on this end.
 *
 * Upon change, WeemoCallDelegate::weemoCall:audioSending: is called.
 * \sa WeemoCallDelegate::weemoCall:audioSending:
 */
@property(nonatomic, readonly, getter = isSendingAudio) BOOL sendingAudio;

/**
 * \brief The view in wich the call should display the incoming video.
 */
@property(nonatomic, weak) UIView *viewVideoIn;

/**
 * \brief The view in wich the call should display the outgoing video.
 */
@property(nonatomic, weak) UIView *viewVideoOut;

/**
 * \brief Statistics of the current instant in the call. 
 *
 * As the structure is reused, it's content is only valid until next retrieval of this property. Not available for the moment.
 */
@property(readonly) WeemoStat *stats;

/**
 * \brief YES if this call is a conference
 */
@property(readonly) BOOL isConference;

/**
 * \brief The host app should set this value if it wants to be notified about call changes.
 */
@property(nonatomic, strong) id<WeemoCallDelegate>delegate;

@end
