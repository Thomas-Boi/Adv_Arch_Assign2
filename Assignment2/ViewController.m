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
    Transformations *transformations;
    bool fogState, flashlightState, lightingState;
    
}

@property (weak, nonatomic) IBOutlet UIButton *fogBtn;
@property (weak, nonatomic) IBOutlet UIButton *flashlightBtn;
@property (weak, nonatomic) IBOutlet UIButton *lightingBtn;

@property (weak, nonatomic) IBOutlet UILabel *console;

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGesture;

@end


@implementation ViewController

// MARK: Gesture handling

- (IBAction)move:(UIPanGestureRecognizer *)sender {
    if (sender.numberOfTouches == 1) {
        NSLog(@"Single finger drag");
    }
}

- (IBAction)tap:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized) {
        NSLog(@"Double finger double tap");
        if (!_console.isHidden) {
            _console.hidden = true;
        } else {
            _console.hidden = false;
        }
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
        [_lightingBtn setTitle:@"Mode: Nightime" forState:UIControlStateNormal];
        lightingState = true;
    } else {
        [_lightingBtn setTitle:@"Mode: Daytime" forState:UIControlStateNormal];
        lightingState = false;
    }
}

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
    [glesRenderer setup:view]; // send a message to setup method with view as a param
    [glesRenderer loadModels];
    
    
    transformations = [[Transformations alloc] initWithDepth:5.0f Scale:1.0f Translation:GLKVector2Make(0.0f, 0.0f) Rotation:GLKVector3Make(0.0f, 0.0f, 0.0f)];
        
    // ### >>>
    _tapGesture.numberOfTapsRequired = 2;
    _tapGesture.numberOfTouchesRequired = 2;
    
    [_console sizeToFit];
    _console.hidden = true;
}

- (void)update
{
    
    GLKMatrix4 modelViewMatrix = [transformations getModelViewMatrix];
    [glesRenderer update:modelViewMatrix]; // ###
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [glesRenderer draw:rect]; // ### send message to draw method with rect as param
}


@end
