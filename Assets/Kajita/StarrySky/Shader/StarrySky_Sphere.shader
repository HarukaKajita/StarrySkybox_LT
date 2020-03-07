//copyright (C) Kajita Haruka
//This shader was made by Kajita Haruka

Shader "Kajita/StarrySky/Sphere"
{
  Properties {
      [Header(Amount)]
      _Scale ("Scale", float) = 20
      [IntRange] _StarNum ("Star Num", Range(0, 10)) = 1

      [Header(Size)]
      _StarSize ("Star Size", Range(0, 1)) = 0.02

      [Header(Stream Animation)]
      [Toggle] _UseAutoStreamAnimation ("Auto Stream Animation", int) = 1
      _StreamAmount ("Stream Amount", float) = 0
      _StreamVector ("Stream Vector", vector) = (1,1,1,0)
      _StreamSpeed  ("Stream Speed" , float) = 0.2

      [Header(Color)]
      [HDR] _BackgroundColor ("Background Color", color) = (0,0,0,0.5)
      [Enum(Random,0, Solid,1)] _ColorType ("Color Type", int) = 0
      [HDR] _SolidColor    ("Solid Color"   , color) = (1,1,0,1)
      _ColorIntensity ("Color Intensity", float) = 4

      [Header(Twinkle Animation)]
      _NoiseScale ("Noise Scale", float) = 10
      _MinimumStrength ("Minimum Strength", Range(0,1)) = 0
      _NoisePower ("Noise Power", float) = 1
      
      [Toggle] _AutoScroll ("Auto Scroll", int) = 1
      _ScrollVector ("Scroll Vector", vector) = (1,1,1,0)
      _ScrollSpeed  ("Scroll Speed" , float) = 10
      _ScrollAmount ("Scroll Amount", float) = 0

      [Header(Setting)]
      [Enum(UnityEngine.Rendering.CullMode)]
      _Cull("Cull", Float) = 0                // Off
      [Enum(Off, 0, On, 1)]
      _ZWrite("ZWrite", Float) = 0            // Off
      [Enum(UnityEngine.Rendering.BlendMode)]
      _SrcFactor("Src Factor", Float) = 5     // SrcAlpha
      [Enum(UnityEngine.Rendering.BlendMode)]
      _DstFactor("Dst Factor", Float) = 10    // OneMinusSrcAlpha
  }
  SubShader
  {
    Tags { "RenderType" = "Transparent" "Queue" = "Transparent-1"}
    
    Cull [_Cull]
    ZWrite [_ZWrite]
    Blend [_SrcFactor][_DstFactor]

    Pass
    {
      CGPROGRAM
      
      #pragma vertex vert
      #pragma fragment frag
      
      #include "UnityCG.cginc"
      #include "Noise.cginc"
      #include "StarrySky.cginc"

      ENDCG
      
    }
  }
}