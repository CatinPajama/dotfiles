precision mediump float;
varying vec2 v_texcoord;
uniform sampler2D tex;

const float numShades = 128.0;
const vec3 backgroundWhite = vec3(255.0 / 255.0);
const vec3 primaryBlack = vec3(0.0 / 255.0);
const vec3 secondaryBlack = vec3(51.0 / 255.0);

float getDitherValue(int x, int y) {
    int index = y * 8 + x;
    if (index ==  0) return  0.0;
    if (index ==  1) return 32.0;
    if (index ==  2) return  8.0;
    if (index ==  3) return 40.0;
    if (index ==  4) return  2.0;
    if (index ==  5) return 34.0;
    if (index ==  6) return 10.0;
    if (index ==  7) return 42.0;
    
    if (index ==  8) return 48.0;
    if (index ==  9) return 16.0;
    if (index == 10) return 56.0;
    if (index == 11) return 24.0;
    if (index == 12) return 50.0;
    if (index == 13) return 18.0;
    if (index == 14) return 58.0;
    if (index == 15) return 26.0;
    
    if (index == 16) return 12.0;
    if (index == 17) return 44.0;
    if (index == 18) return  4.0;
    if (index == 19) return 36.0;
    if (index == 20) return 14.0;
    if (index == 21) return 46.0;
    if (index == 22) return  6.0;
    if (index == 23) return 38.0;
    
    if (index == 24) return 60.0;
    if (index == 25) return 28.0;
    if (index == 26) return 52.0;
    if (index == 27) return 20.0;
    if (index == 28) return 62.0;
    if (index == 29) return 30.0;
    if (index == 30) return 54.0;
    if (index == 31) return 22.0;
    
    if (index == 32) return  3.0;
    if (index == 33) return 35.0;
    if (index == 34) return 11.0;
    if (index == 35) return 43.0;
    if (index == 36) return  1.0;
    if (index == 37) return 33.0;
    if (index == 38) return  9.0;
    if (index == 39) return 41.0;
    
    if (index == 40) return 51.0;
    if (index == 41) return 19.0;
    if (index == 42) return 59.0;
    if (index == 43) return 27.0;
    if (index == 44) return 49.0;
    if (index == 45) return 17.0;
    if (index == 46) return 57.0;
    if (index == 47) return 25.0;
    
    if (index == 48) return 15.0;
    if (index == 49) return 47.0;
    if (index == 50) return  7.0;
    if (index == 51) return 39.0;
    if (index == 52) return 13.0;
    if (index == 53) return 45.0;
    if (index == 54) return  5.0;
    if (index == 55) return 37.0;
    
    if (index == 56) return 63.0;
    if (index == 57) return 31.0;
    if (index == 58) return 55.0;
    if (index == 59) return 23.0;
    if (index == 60) return 61.0;
    if (index == 61) return 29.0;
    if (index == 62) return 53.0;
    if (index == 63) return 21.0;
    
    return 0.0;
}

void main() {
    vec4 pixColor = texture2D(tex, v_texcoord);
    float grayscale = dot(pixColor.rgb, vec3(0.299, 0.587, 0.114));
    
    int x = int(mod(gl_FragCoord.x, 8.0));
    int y = int(mod(gl_FragCoord.y, 8.0));
    float ditherValue = getDitherValue(x, y) / 64.0;
    
    float shadeStep = 1.0 / (numShades - 1.0);
    float quantizedColor = floor(grayscale * numShades + ditherValue) * shadeStep;
    
    vec3 mappedColor = mix(backgroundWhite, primaryBlack, quantizedColor);
    gl_FragColor = vec4(mappedColor, pixColor.a);
}
