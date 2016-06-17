//
//  EngineWidget.h
//  emotivExample
//
//  Created by EmotivLifeSciences.
//  Copyright (c) 2014 EmotivLifeSciences. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
typedef enum MentalControl_enum
{
    Mental_None,
    Mental_Start,
    Mental_Accept,
    Mental_Reject,
    Mental_Erase,
    Mental_Reset
} MentalControl_t;

typedef enum MentalAction_enum
{
    Mental_Neutral = 0x0001,
    Mental_Push = 0x0002,
    Mental_Pull = 0x0004,
    Mental_Lift = 0x0008,
    Mental_Drop = 0x0010,
    Mental_Left = 0x0020,
    Mental_Right = 0x0040
} MentalAction_t;

@protocol EngineWidgetDelegate <NSObject>

@optional-(void) emoStateUpdate : (MentalAction_t) currentAction power : (float) currentPower;
@optional-(void) onMentalCommandTrainingStarted;
@optional-(void) onMentalCommandTrainingSuccessed;
@optional-(void) onMentalCommandTrainingFailed;
@optional-(void) onMentalCommandTrainingCompleted;
@optional-(void) onMentalCommandTrainingRejected;
@optional-(void) onMentalCommandTrainingDataErased;
@optional-(void) onMentalCommandTrainingDataReset;
@optional-(void) onMentalCommandTrainingSignatureUpdated;

/*signal quality*/
@optional-(void) updateSignalQuality : (int) af3 AF4 : (int) af4 T7 : (int) t7 T8 : (int) t8 Pz : (int) pz;
@optional-(void) updateSignalQuality : (NSArray *) array;

/*battery level*/
@optional-(void) updateBatteryLevel:(int) lv  maxValue:(int)maxLv;

/*engine delegate*/
@optional-(void) headsetConnect;

@optional-(void) headsetDisconnect;

@optional-(void) showChooseView : (int) numberDevice;
/*list device delegate*/
@optional-(void) reloadListDevice: (NSArray *) array;
@end


@interface EngineWidget : NSObject

@property(nonatomic, strong) id<EngineWidgetDelegate> delegate;
@property(nonatomic, strong) id<EngineWidgetDelegate> listDeviceDelegate;
@property(nonatomic, strong) id<EngineWidgetDelegate> gameDelegate;

@property BOOL isConneted;
+(EngineWidget *) shareInstance;

+(void) setNilInstance;

-(void) setActiveAction : (MentalAction_t) action;
-(void) setTrainingAction : (MentalAction_t) action;
-(void) setTrainingControl : (MentalControl_t) control;
-(void) clearTrainingData : (MentalAction_t) action;
-(int) getSkillRating : (MentalAction_t) action;
-(BOOL) isActionTrained : (MentalAction_t) action;
-(BOOL) isHeadsetConnected;

-(int) getHeadsetNumber;
-(BOOL) connnectDevice:(int)headsetNumber type:(int)type;
-(NSMutableArray*) getListDevice;
-(BOOL) getStatus;
-(int) getDefaultEngineUserID;

-(bool) CognitivGetTrainingTime : (int) headsetID TrainingTimeOut : (unsigned int*) pTrainingTimeOut;

@end
