//copyright (C) Kajita Haruka
//This shader was made by Kajita Haruka

Shader "Kajita/StarrySky/Skybox"
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
      _StreamSpeed  ("Stream Speed" , float) = 2

      [Header(Color)]
      [HDR] _BackgroundColor ("Background Color", color) = (0,0,0,0.5)
      [Enum(Random,0, Solid,1)] _ColorType ("Color Type", int) = 0
      [HDR] _SolidColor    ("Solid Color"   , color) = (1,1,0,1)
      _ColorIntensity ("Color Intensity", float) = 4

      [Header(Twinkle Animation)]
      _NoiseScale ("Noise Scale", float) = 10
      _MinimumAlpha ("Minimum Alpha", Range(0,1)) = 0
      _NoisePower ("Noise Power", float) = 1
      
      [Toggle] _AutoScroll ("Auto Scroll", int) = 1
      _ScrollVector ("Scroll Vector", vector) = (1,1,1,0)
      _ScrollSpeed  ("Scroll Speed" , float) = 10
      _ScrollAmount ("Scroll Amount", float) = 0

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
      #include "StarrySky.cginc"
      
      ENDCG
    }
  }
}