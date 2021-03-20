//
//  ViewController.m
//  Assignment2
//
//  Created by socas on 2021-03-10.
//


#import "ViewController.h"

@interface ViewController() {
    // Renderer is imported in the header file so don't need to reimport here
    Renderer *glesRenderer;
    GameManager *manager;
    CameraTransformations *cameraTransformations;
    bool fogState, flashlightState, lightingState;
    
}

@property (weak, nonatomic) IBOutlet UIButton *fogBtn;
@property (weak, nonatomic) IBOutlet UIButton *flashlightBtn;
@property (weak, nonatomic) IBOutlet UIButton *lightingBtn;

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *singleFinTap;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *doubleFinTap;


@end


@implementation ViewController

// MARK: Gesture handling

- (IBAction)move:(UIPanGestureRecognizer *)sender {
    if (sender.numberOfTouches == 1) {
        CGPoint velocity = [sender velocityInView:self.view];

        // minimum velocity before we count
        float minimum = 50;
        //NSLog(@"x: %f", velocity.x);
        //NSLog(@"y: %f", velocity.y);
        
        if (velocity.x > minimum) {
            // drag left to right equals clockwise
            // need to make it counter clockwise so use negative
            [cameraTransformations rotate:-0.02];
        } else if (velocity.x < -minimum) {
            // draft right to left equals counter clockwise
            // need to make it clock wise so use negative
            [cameraTransformations rotate:0.02];
        }
        
        // Y-up is negative, Y-down is positive
        // remember this for rotation as well
        float forwardVelocity = 0;
        if (velocity.y > minimum) { // up to down
            forwardVelocity = 0.1;
        } else if (velocity.y < -minimum) { // down to up
            forwardVelocity = -0.1f;
        }
        
        [cameraTransformations translate:forwardVelocity];
        
    }
}
- (IBAction)resetPlayerCube:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized) {
        [cameraTransformations reset];
    }
}

- (IBAction)showConsole:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized) {
        manager.display2DMap = !manager.display2DMap;
    }
}

// MARK: Game options

- (IBAction)switchFog:(UIButton *)sender {
    glesRenderer.useFog = !glesRenderer.useFog;
    NSString *fogBtnTitle = glesRenderer.useFog ? @"Fog: On" : @"Fog: Off";
    [_fogBtn setTitle:fogBtnTitle forState:UIControlStateNormal];
    
    /*if (!glesRenderer.useFog) {
        [_fogBtn setTitle:@"Fog: On" forState:UIControlStateNormal];
        glesRenderer.useFog = true;
    } else {
        [_fogBtn setTitle:@"Fog: Off" forState:UIControlStateNormal];
        glesRenderer.useFog = false;
    }*/
}

- (IBAction)switchFlashlight:(UIButton *)sender {
    if (!flashlightState) {
        [_flashlightBtn setTitle:@"Flashlight: On" forState:UIControlStateNormal];
        flashlightState = true;
    } else {
        [_flashlightBtn setTitle:@"Flashlight: Off" forState:UIControlStateNormal];
        flashlightState = false;
    }
}

- (IBAction)switchLighting:(UIButton *)sender {
    // Daytime should be the default
    if (!lightingState) {
        [_lightingBtn setTitle:@"Mode: Night" forState:UIControlStateNormal];
        lightingState = true;
    } else {
        [_lightingBtn setTitle:@"Mode: Day" forState:UIControlStateNormal];
        lightingState = false;
    }
}

// MARK: View Rendering

- (void)viewDidLoad {
    // in obj-c, this is how you 'call a method'
    // in obj-c, this is called 'send a message'
    // so we are sending a message to super's viewDidLoad method == call it
    // see https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjectiveC/Chapters/ocObjectsClasses.html#//apple_ref/doc/uid/TP30001163-CH11-SW1
    // note [] only applies to OOP and objects
    // normal function can be called normally
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // ### <<<
    // send a message to Renderer's alloc method (aka call it) then pass the return
    // result into another message call. Now, call the return obj's init method.
    glesRenderer = [[Renderer alloc] init];
    GLKView *view = (GLKView *)self.view;
    // Initialize transformations for the player
    
    // use default setting.
    cameraTransformations = [[CameraTransformations alloc] initWithDefaultValues];
    
    // set up the opengl window and draw
    // set up the manager
    manager = [[GameManager alloc] init];
    [manager initManager:view];
    
        
    // Gestures setup
    // Single finger double tap
    _singleFinTap.numberOfTapsRequired = 2;
    _singleFinTap.numberOfTouchesRequired = 1;
    
    // Double finger double tap
    _doubleFinTap.numberOfTapsRequired = 2;
    _doubleFinTap.numberOfTouchesRequired = 2;
}

- (void)update
{
    
    GLKMatrix4 viewMatrix = [cameraTransformations getViewMatrix];
    [manager update:viewMatrix]; // ###
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [manager draw];
}


@end
