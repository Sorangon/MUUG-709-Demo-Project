Shader "Custom Shaders/Surface Fresnel"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        [NoScaleOffset]_Normal ("Normal Map", 2D) = "bump" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0

        [Header(Fresnel)]

        _RimPower("Rim Power", Range(0.1,20)) = 1.0
        [HDR]_RimColor("Rim Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _Normal;

        struct Input
        {
            float2 uv_MainTex;
            float3 viewDir; //Gets the view direction vector
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;

        float _RimPower;
        fixed4 _RimColor;


        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Normal = UnpackNormal(tex2D (_Normal, IN.uv_MainTex));
            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;

            //Calculate fresnel value depending the normal vector and the view vector
            float fresnel = pow(1 - abs(dot(normalize(o.Normal), normalize(IN.viewDir))), _RimPower);
            o.Emission = fresnel * _RimColor;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
