Shader "StarrySky/Skybox/SuperEasyLogic"
{
  Properties { 
      _Scale ("Scale", Range(0,100)) = 20
      [IntRange] _StarNum ("Star Num", Range(0, 5)) = 1
      _StarSize ("Star Size", Range(0, 1)) = 0.02
  }
  SubShader
  {
    Tags { "RenderType" = "Background" "Queue" = "Background" "PreviewType" = "SkyBox" }
    
    Pass
    {
      CGPROGRAM
      
      #pragma vertex vert
      #pragma fragment frag
      
      #include "UnityCG.cginc"
      #include "Noise.cginc"
      
      struct appdata
      {
        float4 vertex: POSITION;
        float3 uv: TEXCOORD0;
      };
      
      struct v2f
      {
        float3 uv: TEXCOORD0;
        float4 vertex: SV_POSITION;
        float3 oPos : TEXCOORD1;
      };
      
      float _Scale;
      int _StarNum;
      float _StarSize;
      
      v2f vert(appdata v)
      {
        v2f o;
        o.vertex = UnityObjectToClipPos(v.vertex);
        o.uv = v.uv;
        o.oPos = v.vertex.xyz;
        return o;
      }
      
      fixed4 frag(v2f i): SV_Target
      {
        fixed4 col = 0;
        float3 scaledPos = i.uv * _Scale;
        float3 localOrigin = floor(scaledPos);
        float3 localPos = frac(scaledPos);
        for(int j = 0; j < _StarNum; j++){
            float3 starPos = rand3D(localOrigin + j)*0.5+0.5;
            float dist = length(localPos - starPos);
            if(dist < _StarSize){
                col.rgb += fixed3(1,1,0);
                break;
            }
        }
        return col;
      }
      ENDCG
      
    }
  }
}
