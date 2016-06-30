//
//  EngineWidget.m
//  emotivExample
//
//  Created by EmotivLifeSciences.
//  Copyright (c) 2014 EmotivLifeSciences. All rights reserved.
//

#import "EngineWidget.h"
#import <edk_ios/Iedk.h>
#import "FindingTreasure-Swift.h"

@implementation EngineWidget

EmoEngineEventHandle eEvent			= IEE_EmoEngineEventCreate();
EmoStateHandle eState				= IEE_EmoStateCreate();
int state                           = 0;
unsigned int userID                 = 0;
unsigned long trainedAction         = 0;
unsigned long activeAction          = 0;
bool isConnected = false;
bool userAdded = false;
int numberInsight= 1;
int numberEpoc= 1;
int headsetType = 0;



NSString *profilePath;
NSString *profileName;

static EngineWidget *instance;
+(EngineWidget *)shareInstance{
    if (!instance) instance = [[EngineWidget alloc] init];
    return instance;
}

-(id) init {
    self = [super init];
    if(self)
    {
        [self connectEngine];
          NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(getNextEvent) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
    return self;
}

-(void) connectEngine
{
    IEE_EmoInitDevice();
    IEE_EngineConnect();
}

-(void) connectEmoComposer
{
    IEE_EngineRemoteConnect("192.168.1.200", 1726);
}

-(void) getNextEvent {
    [self.listDeviceDelegate reloadListDevice:[self getListDevice]];
    
    state = IEE_EngineGetNextEvent(eEvent);
    if(state == EDK_OK)
    {
        IEE_Event_t eventType = IEE_EmoEngineEventGetType(eEvent);
        int result = IEE_EmoEngineEventGetUserId(eEvent, &userID);
        
        if (result != EDK_OK) {
            NSLog(@"WARNING : Failed to return a valid user ID for the current event");
        }
        
        if(eventType == IEE_EmoStateUpdated ) {
            
            IEE_EmoEngineEventGetEmoState(eEvent, eState);
            IEE_MentalCommandAction_t action = IS_MentalCommandGetCurrentAction(eState);
            float power = IS_MentalCommandGetCurrentActionPower(eState);
            
            int valueAF3 = IS_GetContactQuality(eState, IEE_CHAN_AF3);
            int valueAF4 = IS_GetContactQuality(eState, IEE_CHAN_AF4);
            int valueT7 = IS_GetContactQuality(eState, IEE_CHAN_T7);
            int valueT8 = IS_GetContactQuality(eState, IEE_CHAN_T8);
            int valuePz = IS_GetContactQuality(eState, IEE_CHAN_Pz);
            
            int chargeLevel = 0;
            int maxChargeLevel = 0;
            IS_GetBatteryChargeLevel(eState, &chargeLevel, &maxChargeLevel);
            
            if(self.delegate){
                [self.delegate emoStateUpdate:(MentalAction_t)action power:power];
                [self.delegate getSignalChanels:valueAF3 af4Channel:valueAF4 t7Channel:valueT7 t8Channel:valueT8 pzChannel:valuePz];
                [self.delegate updateBatteryLevel:chargeLevel maxValue:maxChargeLevel];
            }
            
        }
        if(eventType == IEE_UserAdded)
        {
            NSLog(@"User Added");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"userAddedNotification" object:nil userInfo:nil];
            userAdded = true;
            isConnected = true;
            if(self.delegate)
                [self.delegate headsetConnect];
        }
        if(eventType == IEE_UserRemoved){
            NSLog(@"user remove");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"userRemovedNotification" object:nil userInfo:nil];
            isConnected = false;
            userAdded = false;
            if(self.delegate)
                [self.delegate headsetDisconnect];
        }
        if(eventType == IEE_MentalCommandEvent) {
            IEE_MentalCommandEvent_t mcevent = IEE_MentalCommandEventGetType(eEvent);
            switch (mcevent) {
                case IEE_MentalCommandTrainingCompleted:
                    if(self.delegate)
                        [self.delegate onMentalCommandTrainingCompleted];
                    NSLog(@"complete");
                    break;
                case IEE_MentalCommandTrainingStarted:
                    if(self.delegate)
                        [self.delegate onMentalCommandTrainingStarted];
                    NSLog(@"start");
                    break;
                case IEE_MentalCommandTrainingFailed:
                    if(self.delegate)
                        [self.delegate onMentalCommandTrainingFailed];
                    NSLog(@"fail");
                    break;
                case IEE_MentalCommandTrainingSucceeded:
                    if(self.delegate)
                        [self.delegate onMentalCommandTrainingSuccessed];
                    NSLog(@"success");
                    break;
                case IEE_MentalCommandTrainingRejected:
                    if(self.delegate)
                        [self.delegate onMentalCommandTrainingRejected];
                    NSLog(@"reject");
                    break;
                case IEE_MentalCommandTrainingDataErased:
                    if(self.delegate)
                        [self.delegate onMentalCommandTrainingDataErased];
                    NSLog(@"erased");
                    break;
                case IEE_MentalCommandSignatureUpdated:
                    if(self.delegate)
                        [self.delegate onMentalCommandTrainingSignatureUpdated];
                    NSLog(@"update signature");
                default:
                    break;
            }
        }
    }
}


-(void) setActiveAction : (MentalAction_t) action
{
    if(!(activeAction & action) && action != Mental_Neutral) {
        activeAction = activeAction | action;
        IEE_MentalCommandSetActiveActions(userID, activeAction);
    }
}

-(void) setTrainingAction : (MentalAction_t) action
{
    IEE_MentalCommandSetTrainingAction(userID, (IEE_MentalCommandAction_t)action);
}

-(void) setTrainingControl : (MentalControl_t) control
{
    IEE_MentalCommandSetTrainingControl(userID, (IEE_MentalCommandTrainingControl_t)control);
}

-(void) clearTrainingData : (MentalAction_t) action
{
    IEE_MentalCommandSetTrainingAction(userID, (IEE_MentalCommandAction_t) action);
    IEE_MentalCommandSetTrainingControl(userID, (IEE_MentalCommandTrainingControl_t)MC_ERASE);
}

-(int) getSkillRating : (MentalAction_t) action
{
    float skillRating = 0.0f;
    IEE_MentalCommandGetActionSkillRating(userID, (IEE_MentalCommandAction_t)action, &skillRating);
    return (int)(skillRating * 100);
}

-(BOOL) isActionTrained : (MentalAction_t) action
{
    return trainedAction & action;
}

-(BOOL) isHeadsetConnected {
    return userAdded;
}

-(int) getHeadsetNumber {
    return headsetType;
}

-(NSArray*) getListDevice {
    NSMutableArray *listDevice = [[NSMutableArray alloc] init];
    HeadsetDevice *device;
    if (IEE_GetInsightDeviceCount() != 0 || IEE_GetEpocPlusDeviceCount() != 0) {
        for (int i = 0; i < IEE_GetInsightDeviceCount(); i++) {
            NSString *nameDeviceInsight = [NSString stringWithFormat:@"%s",IEE_GetInsightDeviceName(i)];
            device = [[HeadsetDevice alloc] init];
            device.name = nameDeviceInsight;
            device.type = 0;
            [listDevice addObject:device];
        }
        for (int j = 0; j < IEE_GetEpocPlusDeviceCount(); j++) {
            NSString *nameDeviceEpoc = [NSString stringWithFormat:@"%s",IEE_GetEpocPlusDeviceName(j)];
            device = [[HeadsetDevice alloc] init];
            device.name = nameDeviceEpoc;
            device.type = 1;
            [listDevice addObject:device];
        }
    }
    return  listDevice;
}

-(BOOL) connnectDevice:(int)headsetNumber type:(int)type {
    headsetType = type;
    if (type == 0)
        isConnected = IEE_ConnectInsightDevice(headsetNumber);
#ifndef DEVAPP
    else
        isConnected = IEE_ConnectEpocPlusDevice(headsetNumber);
#endif
    return isConnected;
}

-(int) getSelectedHeadsetID {
    return userID;
}

-(bool) CognitivGetTrainingTime:(int)headsetID TrainingTimeOut:(unsigned int *)pTrainingTimeOut {
    assert(pTrainingTimeOut);
    int status = 0;
    status = IEE_MentalCommandGetTrainingTime(headsetID, pTrainingTimeOut);
    return status == EDK_OK;
}

@end
