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
    Transformations *transformations;
    Transformations *cubeTransformations;
    Transformations *playerTransformations;
    bool fogState, flashlightState, lightingState;
    
}

@property (weak, nonatomic) IBOutlet UIButton *fogBtn;
@property (weak, nonatomic) IBOutlet UIButton *flashlightBtn;
@property (weak, nonatomic) IBOutlet UIButton *lightingBtn;

//@property (weak, nonatomic) IBOutlet UILabel *console;

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *singleFinTap;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *doubleFinTap;


@end


@implementation ViewController

// MARK: Gesture handling

- (IBAction)move:(UIPanGestureRecognizer *)sender {
    if (sender.numberOfTouches == 1) {
        CGPoint velocity = [sender velocityInView:self.view];
        NSLog(@"Velocity %.1f, %.1f", velocity.x, velocity.y);

        // Y-up is negative, Y-down is positive
        GLKVector3 mov = GLKVector3Make(0.0f, 0.0f, 0.0f);
        
        if (velocity.x > 0) { // right
            mov.x += 0.05f;
        } else if (velocity.x < 0) { // left
            mov.x += -0.05f;
        }
        if (velocity.y > 0) { // up
            mov.z += 0.05f;
        } else if (velocity.y < 0) { // down
            mov.z += -0.05f;
        }
        
        [playerTransformations translateBy:mov];
        
    }
}
- (IBAction)resetPlayerCube:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized) {
        [playerTransformations reset];
    }
}

- (IBAction)showConsole:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized) {
        /*if (!_console.isHidden) {
            _console.hidden = true;
        } else {
            _console.hidden = false;
        }*/
    }
}

// MARK: Game options

- (IBAction)switchFog:(UIButton *)sender {
    if (!fogState) {
        [_fogBtn setTitle:@"Fog: On" forState:UIControlStateNormal];
        fogState = true;
    } else {
        [_fogBtn setTitle:@"Fog: Off" forState:UIControlStateNormal];
        fogState = false;
    }
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
    playerTransformations = [[Transformations alloc] initWithScale:1.0f Translation:GLKVector3Make(0.0f, -1.0f, -5.0f) Rotation:0 RotationAxis:GLKVector3Make(0.0, 0.0, 1.0)];
    [playerTransformations start];
    cubeTransformations = [[Transformations alloc] initWithScale:1.0f Translation:GLKVector3Make(3.0f, -1.0f, -5.0f) Rotation:0 RotationAxis:GLKVector3Make(0.0, 0.0, 1.0)];
    [cubeTransformations start];

    
    // set up the opengl window and draw
    // set up the manager
    manager = [[GameManager alloc] init];
    GLKMatrix4 initialPlayerTransformation = [playerTransformations getModelViewMatrix];
    [manager initManager:view initialPlayerTransform:initialPlayerTransformation];
    
        
    // Gestures setup
    // Single finger double tap
    _singleFinTap.numberOfTapsRequired = 2;
    _singleFinTap.numberOfTouchesRequired = 1;
    
    // Double finger double tap
    _doubleFinTap.numberOfTapsRequired = 2;
    _doubleFinTap.numberOfTouchesRequired = 2;
    
    //[_console sizeToFit];
    //_console.hidden = true;
}

- (void)update
{
    
    GLKMatrix4 modelViewMatrix = [playerTransformations getModelViewMatrix];
    GLKMatrix4 cubeModelViewMatrix = [cubeTransformations getModelViewMatrix];
    [manager update:modelViewMatrix initialCubeTranform:cubeModelViewMatrix]; // ###
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [manager draw];
}


@end
