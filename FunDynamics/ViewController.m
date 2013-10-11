//
//  ViewController.m
//  FunDynamics
//
//  Created by siddarth chaturvedi on 10/10/13.
//  Copyright (c) 2013 JustUnfollow. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) UIView                   *square1View;
@property (strong, nonatomic) UIView                   *square2View;
@property (strong, nonatomic) UIDynamicAnimator        *animator;
@property (strong, nonatomic) UIGravityBehavior        *gravityBehaviour;
@property (strong, nonatomic) UICollisionBehavior      *collisionBehaviour;
@property (strong, nonatomic) UIAttachmentBehavior     *attachmentBehaviour;
@property (strong, nonatomic) UIPanGestureRecognizer   *panGestureRecoganizer;
@property (strong, nonatomic) UIDynamicItemBehavior    *square1DynamicProperties;

@end

@implementation ViewController

@synthesize square1View = _square1View;
@synthesize square2View = _square2View;
@synthesize animator = _animator;
@synthesize gravityBehaviour = _gravityBehaviour;
@synthesize collisionBehaviour = _collisionBehaviour;
@synthesize attachmentBehaviour = _attachmentBehaviour;
@synthesize panGestureRecoganizer = _panGestureRecoganizer;
@synthesize square1DynamicProperties = _square1DynamicProperties;


//Method foe setting the user inteface and adding animator and behaviours.
- (void)setUI {
    
    //Adding the square boxes to main view.
    //Square1 is in yellow color.
    _square1View = [[UIView alloc] initWithFrame:CGRectMake(170, 100, 100, 100)];
    _square1View.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:_square1View];
    
     //Square2 is in blue color.
    _square2View = [[UIView alloc] initWithFrame:CGRectMake(10, 250, 100, 100)];
    _square2View.backgroundColor = [UIColor blueColor];
    [self.view addSubview:_square2View];
    
    //Creating the animator
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    //Adding the collsion behaviour to animator
    _collisionBehaviour = [[UICollisionBehavior alloc] initWithItems:@[_square1View,_square2View]];
    _collisionBehaviour.translatesReferenceBoundsIntoBoundary = YES;
    _collisionBehaviour.collisionMode = UICollisionBehaviorModeEverything;
    _collisionBehaviour.collisionDelegate = self;
    [_animator addBehavior:_collisionBehaviour];
    
    //Adding pan gesture recoganizer for creating dragging effect.
    _panGestureRecoganizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    _panGestureRecoganizer.minimumNumberOfTouches = 1;
    [self.square1View addGestureRecognizer:_panGestureRecoganizer];
    
    //Adding the dynamicitembehaviour to change the animation configuration of dynamic item.
    //You can comment out thsese lines initially to check it out what happens without changing these properties.
    _square1DynamicProperties = [[UIDynamicItemBehavior alloc] initWithItems:@[_square1View]];
    _square1DynamicProperties.elasticity = 1.0;
    _square1DynamicProperties.friction = 0.0;
    _square1DynamicProperties.resistance = 0.0;
    _square1DynamicProperties.allowsRotation = YES;
    [_animator addBehavior:_square1DynamicProperties];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

//Handling the pan gesture.
- (void)handlePanGesture:(id)sender {
    
    UIPanGestureRecognizer *recognizer = (UIPanGestureRecognizer*)sender;
    CGPoint translatedPoint = [recognizer translationInView:self.view];
    
    if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        
        //When gesture begin.
        if(self.gravityBehaviour) {
            // Removing gravity if it is alredy there.
            [self.animator removeBehavior:self.gravityBehaviour];
            self.gravityBehaviour = nil;
        }
        
        //Adding attachment behaviour.
        UIAttachmentBehavior *attachmentBehaviour = [[UIAttachmentBehavior alloc] initWithItem:_square1View attachedToAnchor:recognizer.view.center];
        [self.animator addBehavior:attachmentBehaviour];
        self.attachmentBehaviour = attachmentBehaviour;
        [self.animator updateItemUsingCurrentState:self.square1View];
        
    }else if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        
        //Removing Attachment behaviour.
        [self.animator removeBehavior:self.attachmentBehaviour];
        self.attachmentBehaviour = nil;
        
        //Adding gravity behaviour
        UIGravityBehavior *gravityBehaviour = [[UIGravityBehavior alloc] initWithItems:@[_square1View,_square2View]];
        [self.animator addBehavior:gravityBehaviour];
        self.gravityBehaviour = gravityBehaviour;
        [self.animator updateItemUsingCurrentState:self.square1View];
    
    }else if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateChanged) {
        
        //Updating the anchor point of attachment behaviour.
        self.attachmentBehaviour.anchorPoint = CGPointMake(self.attachmentBehaviour.anchorPoint.x + translatedPoint.x,
                                          self.attachmentBehaviour.anchorPoint.y + translatedPoint.y);
    }
    
    //Resetting the translation.
     [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
}

@end
