#import <simd/simd.h>
#import "Renderer.h"

@implementation Renderer
{
    NVGcontext* ctx;
}

-(nonnull instancetype)initWithMetalKitView:(nonnull MTKView *)view;
{
    self = [super init];
    if(self) {
        ctx = nvgCreateMTL((__bridge void *)(view.layer), NVG_ANTIALIAS /*| NVG_STENCIL_STROKES*/); // with stencil strokes enabled, strokewidth = 1. is invisible on non-retina screen
    }

    return self;
}

- (void)drawInMTKView:(nonnull MTKView *)view
{
    float w = view.frame.size.width;
    float h = view.frame.size.height;

    mnvgClearWithColor(ctx, nvgRGBA(255,128,0,255));
    nvgBeginFrame(ctx, w, h, [[view window] backingScaleFactor]);

    nvgFillColor(ctx, nvgRGBA(28,30,34,192));
    nvgRect(ctx, 100, 100, 40, 40);
    nvgFill(ctx);
    //nvgStrokeWidth(ctx, 1.);
    //  nvgStrokeColor(ctx, nvgRGBA(0,0,0,255));
    //  nvgStroke(ctx);

    nvgEndFrame(ctx);
}

- (void)mtkView:(nonnull MTKView *)view drawableSizeWillChange:(CGSize)size
{

}

@end
