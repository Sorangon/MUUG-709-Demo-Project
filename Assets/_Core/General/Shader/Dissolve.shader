Shader "Custom Shaders/Dissolve"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        [NoScaleOffset]_Normal ("Normal Map", 2D) = "bump" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0

        [Space(5)]

        [Header(Dissolve)]
        _DissolvePath("Dissolve Texture",2D) = "black" {}
        [HDR]_DissolveColor("Dissolve Color", Color) = (1,1,1,1)
        _DissolvePower("Dissolve Power", Float) = 5.0
        _DissolveAmount("Dissolve Amount", Range(0,1)) = 0.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200
        Cull Off

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        #include "Assets/CG_Includes/SimpleEffects.cginc"

        sampler2D _MainTex;
        sampler2D _Normal;
        sampler2D _DissolvePath;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_DissolvePath;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;
   
        fixed _DissolveAmount;
        float _DissolvePower;
        fixed4 _DissolveColor;



        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;

            // Calculate the dissolve pixel value
            float dissolve = tex2D(_DissolvePath, IN.uv_DissolvePath).r - _DissolveAmount;
            clip(dissolve);

            // Metallic and smoothness come from slider variables
            o.Normal = UnpackNormal(tex2D(_Normal, IN.uv_MainTex));
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;

            o.Emission = pow(1 - dissolve, _DissolvePower) * _DissolveColor;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
