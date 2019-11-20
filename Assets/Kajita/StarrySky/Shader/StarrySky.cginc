//copyright (C) Kajita Haruka
//This shader was made by Kajita Haruka


#ifndef KAJITA_STARRY_SKY
#define KAJITA_STARRY_SKY

//amoount
float _Scale;
int _StarNum;

//size
float _StarSize;

//stream animation
bool _UseAutoStreamAnimation;
float _StreamAmount;
float3 _StreamVector;
float _StreamSpeed;

//color
fixed4 _BackgroundColor;
int _ColorType;
fixed4 _SolidColor;
float _ColorIntensity;

//twinkleAnimation
float _NoiseScale;
float _MinimumAlpha;
float _NoisePower;
bool _AutoScroll;
float3 _ScrollVector;
float _ScrollSpeed;
float _ScrollAmount;

//星の色を返す
fixed4 getStarColor(float3 pos);

//瞬き表現のための0~1の値を返す
float getTwinkleStrength(float3 pos);

//星の流れの位置オフセット量を返す
float3 getStreamOffset();

struct appdata
{
    float4 vertex: POSITION;
};

struct v2f
{
    float4 vertex: SV_POSITION;
    float3 oPos : TEXCOORD0;
};

v2f vert(appdata v)
{
    v2f o;
    o.vertex = UnityObjectToClipPos(v.vertex);
    o.oPos = v.vertex.xyz;
    return o;
}

fixed4 frag(v2f i): SV_Target
{
    fixed4 col = _BackgroundColor;
    float3 scaledPos = i.oPos * _Scale;
    scaledPos += getStreamOffset();
    float3 localOrigin = floor(scaledPos);
    float3 localPos = frac(scaledPos);
    for(int j = 0; j < _StarNum; j++){
        float3 starPos = rand3D(localOrigin + j)*0.5+0.5;
        float dist = length(localPos - starPos);
        if(dist < _StarSize){
            fixed4 starColor = getStarColor(starPos);
            float  twinkleStrength = getTwinkleStrength(starPos + localOrigin);
            starColor.rgb *= twinkleStrength;
            col += starColor;
            break;
        }
    }
    return col;
}


fixed4 getStarColor(float3 pos){
    //posは星の位置
    //場合によってこれをシードに色を決定する
    fixed4 baseColor = 1;
    //uniform分岐なので負荷はないif文
    if(_ColorType == 0){//Random color
        
        baseColor.rgb = rand3D(pos)*0.5+0.5;

    } else if(_ColorType == 1){//Solid color
        baseColor = _SolidColor;
    }

    return baseColor * _ColorIntensity;
}

float getTwinkleStrength(float3 pos){
    float3 noisePos = pos;
    if(_AutoScroll) _ScrollAmount = _Time.y * _ScrollSpeed;//自動スクロール
    noisePos = (noisePos + _ScrollAmount * _ScrollVector) * _NoiseScale;//ノイズ座標決定
    float noiseValue = pNoise(noisePos);
    noiseValue = pow(noiseValue, _NoisePower);
    float strength = (1.0 - _MinimumAlpha) * noiseValue + _MinimumAlpha;//_MinimumAlpha ~ 1の範囲で返す(0~1)
    return strength;
}

float3 getStreamOffset(){
    if(_UseAutoStreamAnimation) _StreamAmount = _Time.y * _StreamSpeed;
    return _StreamAmount * _StreamVector;
}

#endif