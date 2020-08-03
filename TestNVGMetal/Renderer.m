#import <simd/simd.h>
#import "Renderer.h"

void drawColorwheel(NVGcontext* vg, float x, float y, float w, float h, float t)
{
    int i;
    float r0, r1, ax,ay, bx,by, cx,cy, aeps, r;
    float hue = sinf(t * 0.12f);
    NVGpaint paint;

    nvgSave(vg);

/*    nvgBeginPath(vg);
    nvgRect(vg, x,y,w,h);
    nvgFillColor(vg, nvgRGBA(255,0,0,128));
    nvgFill(vg);*/

    cx = x + w*0.5f;
    cy = y + h*0.5f;
    r1 = (w < h ? w : h) * 0.5f - 5.0f;
    r0 = r1 - 20.0f;
    aeps = 0.5f / r1;    // half a pixel arc length in radians (2pi cancels out).

    for (i = 0; i < 6; i++) {
        float a0 = (float)i / 6.0f * NVG_PI * 2.0f - aeps;
        float a1 = (float)(i+1.0f) / 6.0f * NVG_PI * 2.0f + aeps;
        nvgBeginPath(vg);
        nvgArc(vg, cx,cy, r0, a0, a1, NVG_CW);
        nvgArc(vg, cx,cy, r1, a1, a0, NVG_CCW);
        nvgClosePath(vg);
        ax = cx + cosf(a0) * (r0+r1)*0.5f;
        ay = cy + sinf(a0) * (r0+r1)*0.5f;
        bx = cx + cosf(a1) * (r0+r1)*0.5f;
        by = cy + sinf(a1) * (r0+r1)*0.5f;
        paint = nvgLinearGradient(vg, ax,ay, bx,by, nvgHSLA(a0/(NVG_PI*2),1.0f,0.55f,255), nvgHSLA(a1/(NVG_PI*2),1.0f,0.55f,255));
        nvgFillPaint(vg, paint);
        nvgFill(vg);
    }

    nvgBeginPath(vg);
    nvgCircle(vg, cx,cy, r0-0.5f);
    nvgCircle(vg, cx,cy, r1+0.5f);
    nvgStrokeColor(vg, nvgRGBA(0,0,0,64));
    nvgStrokeWidth(vg, 1.0f);
    nvgStroke(vg);

    // Selector
    nvgSave(vg);
    nvgTranslate(vg, cx,cy);
    nvgRotate(vg, hue*NVG_PI*2);

    // Marker on
    nvgStrokeWidth(vg, 2.0f);
    nvgBeginPath(vg);
    nvgRect(vg, r0-1,-3,r1-r0+2,6);
    nvgStrokeColor(vg, nvgRGBA(255,255,255,192));
    nvgStroke(vg);

    paint = nvgBoxGradient(vg, r0-3,-5,r1-r0+6,10, 2,4, nvgRGBA(0,0,0,128), nvgRGBA(0,0,0,0));
    nvgBeginPath(vg);
    nvgRect(vg, r0-2-10,-4-10,r1-r0+4+20,8+20);
    nvgRect(vg, r0-2,-4,r1-r0+4,8);
    nvgPathWinding(vg, NVG_HOLE);
    nvgFillPaint(vg, paint);
    nvgFill(vg);

    // Center triangle
    r = r0 - 6;
    ax = cosf(120.0f/180.0f*NVG_PI) * r;
    ay = sinf(120.0f/180.0f*NVG_PI) * r;
    bx = cosf(-120.0f/180.0f*NVG_PI) * r;
    by = sinf(-120.0f/180.0f*NVG_PI) * r;
    nvgBeginPath(vg);
    nvgMoveTo(vg, r,0);
    nvgLineTo(vg, ax,ay);
    nvgLineTo(vg, bx,by);
    nvgClosePath(vg);
    paint = nvgLinearGradient(vg, r,0, ax,ay, nvgHSLA(hue,1.0f,0.5f,255), nvgRGBA(255,255,255,255));
    nvgFillPaint(vg, paint);
    nvgFill(vg);
    paint = nvgLinearGradient(vg, (r+ax)*0.5f,(0+ay)*0.5f, bx,by, nvgRGBA(0,0,0,0), nvgRGBA(0,0,0,255));
    nvgFillPaint(vg, paint);
    nvgFill(vg);
    nvgStrokeColor(vg, nvgRGBA(0,0,0,64));
    nvgStroke(vg);

    // Select circle on triangle
    ax = cosf(120.0f/180.0f*NVG_PI) * r*0.3f;
    ay = sinf(120.0f/180.0f*NVG_PI) * r*0.4f;
    nvgStrokeWidth(vg, 2.0f);
    nvgBeginPath(vg);
    nvgCircle(vg, ax,ay,5);
    nvgStrokeColor(vg, nvgRGBA(255,255,255,192));
    nvgStroke(vg);

    paint = nvgRadialGradient(vg, ax,ay, 7,9, nvgRGBA(0,0,0,64), nvgRGBA(0,0,0,0));
    nvgBeginPath(vg);
    nvgRect(vg, ax-20,ay-20,40,40);
    nvgCircle(vg, ax,ay,7);
    nvgPathWinding(vg, NVG_HOLE);
    nvgFillPaint(vg, paint);
    nvgFill(vg);

    nvgRestore(vg);

    nvgRestore(vg);
}

void drawGraph(NVGcontext* vg, float x, float y, float w, float h, float t)
{
    NVGpaint bg;
    float samples[6];
    float sx[6], sy[6];
    float dx = w/5.0f;
    int i;

    samples[0] = (1+sinf(t*1.2345f+cosf(t*0.33457f)*0.44f))*0.5f;
    samples[1] = (1+sinf(t*0.68363f+cosf(t*1.3f)*1.55f))*0.5f;
    samples[2] = (1+sinf(t*1.1642f+cosf(t*0.33457)*1.24f))*0.5f;
    samples[3] = (1+sinf(t*0.56345f+cosf(t*1.63f)*0.14f))*0.5f;
    samples[4] = (1+sinf(t*1.6245f+cosf(t*0.254f)*0.3f))*0.5f;
    samples[5] = (1+sinf(t*0.345f+cosf(t*0.03f)*0.6f))*0.5f;

    for (i = 0; i < 6; i++) {
        sx[i] = x+i*dx;
        sy[i] = y+h*samples[i]*0.8f;
    }

    // Graph background
    bg = nvgLinearGradient(vg, x,y,x,y+h, nvgRGBA(0,160,192,0), nvgRGBA(0,160,192,64));
    nvgBeginPath(vg);
    nvgMoveTo(vg, sx[0], sy[0]);
    for (i = 1; i < 6; i++)
        nvgBezierTo(vg, sx[i-1]+dx*0.5f,sy[i-1], sx[i]-dx*0.5f,sy[i], sx[i],sy[i]);
    nvgLineTo(vg, x+w, y+h);
    nvgLineTo(vg, x, y+h);
    nvgFillPaint(vg, bg);
    nvgFill(vg);

    // Graph line
    nvgBeginPath(vg);
    nvgMoveTo(vg, sx[0], sy[0]+2);
    for (i = 1; i < 6; i++)
        nvgBezierTo(vg, sx[i-1]+dx*0.5f,sy[i-1]+2, sx[i]-dx*0.5f,sy[i]+2, sx[i],sy[i]+2);
    nvgStrokeColor(vg, nvgRGBA(0,0,0,32));
    nvgStrokeWidth(vg, 3.0f);
    nvgStroke(vg);

    nvgBeginPath(vg);
    nvgMoveTo(vg, sx[0], sy[0]);
    for (i = 1; i < 6; i++)
        nvgBezierTo(vg, sx[i-1]+dx*0.5f,sy[i-1], sx[i]-dx*0.5f,sy[i], sx[i],sy[i]);
    nvgStrokeColor(vg, nvgRGBA(0,160,192,255));
    nvgStrokeWidth(vg, 3.0f);
    nvgStroke(vg);

    // Graph sample pos
    for (i = 0; i < 6; i++) {
        bg = nvgRadialGradient(vg, sx[i],sy[i]+2, 3.0f,8.0f, nvgRGBA(0,0,0,32), nvgRGBA(0,0,0,0));
        nvgBeginPath(vg);
        nvgRect(vg, sx[i]-10, sy[i]-10+2, 20,20);
        nvgFillPaint(vg, bg);
        nvgFill(vg);
    }

    nvgBeginPath(vg);
    for (i = 0; i < 6; i++)
        nvgCircle(vg, sx[i], sy[i], 4.0f);
    nvgFillColor(vg, nvgRGBA(0,160,192,255));
    nvgFill(vg);
    nvgBeginPath(vg);
    for (i = 0; i < 6; i++)
        nvgCircle(vg, sx[i], sy[i], 2.0f);
    nvgFillColor(vg, nvgRGBA(220,220,220,255));
    nvgFill(vg);

    nvgStrokeWidth(vg, 1.0f);
}



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

//    nvgFillColor(ctx, nvgRGBA(28,30,34,192));
//    nvgRect(ctx, 100, 100, 40, 40);
//    nvgRect(ctx, 200, 100, 40, 40);
//
//    nvgFill(ctx);

//    drawColorwheel(ctx, 100, 200, 100, 100, 5.0);
    drawGraph(ctx, 100, 200, 100, 100, 5.0);
    //nvgStrokeWidth(ctx, 1.);
    //  nvgStrokeColor(ctx, nvgRGBA(0,0,0,255));
    //  nvgStroke(ctx);

    nvgEndFrame(ctx);
}

- (void)mtkView:(nonnull MTKView *)view drawableSizeWillChange:(CGSize)size
{

}

@end
