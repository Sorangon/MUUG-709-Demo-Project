Shader "Custom Shaders/ProceduralTerrain"
{
    Properties
    {
        [NoScaleOffset]_RampTexture("Ramp Texture", 2D) = "white" {}
        [NoScaleOffset]_NormalMap ("Normal Map", 2D) = "bump" {}

        [Space(5)]
        [NoScaleOffset]_HeightMap("Height Map", 2D) = "grey" {}
        _HeightMapScaleOffset("Offset Scale", Vector) = (0,0,1,1)
        _Displacement("Displacement", Range(0.001,10)) = 1.0
        _Tesselation("Tesselation",Range(1,50)) = 5.0

        [Header(Water)]
        _WaterLevel("Water Level", Range(0,1)) = 0.1
        _WaterColor("Water Color", Color) = (1,1,1,1)
        [Normal]_WaterNormal("Water Normal", 2D) = "bump" {}
        _ShoreFade("Shore Fade", Range(0, 20)) = 1.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200
        Cull Off

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows vertex:vert tessellate:tessFixed nolightmap


        #pragma target 4.6

        sampler2D _MainTex;
        sampler2D _NormalMap;   
        sampler2D _HeightMap;
        sampler2D _RampTexture;

        struct Input
        {
            float2 uv_HeightMap;
            float2 uv_RampTexture;
        };

        fixed4 _Color;
        fixed4 _WaterColor;
        float4 _HeightMapScaleOffset;
        float _Displacement;
        float _Tesselation;
        fixed _WaterLevel;


        fixed4 tessFixed()
        {
            return _Tesselation; //Tesselate the texture to increase vertex resolution
        }

        void vert(inout appdata_full v)
        {
            //Gets the height value on the height map depending the sclae and offset value
            float4 heightUv = float4((v.texcoord.xy + _HeightMapScaleOffset.xy) * _HeightMapScaleOffset.zw, 0,0);
            float height = tex2Dlod(_HeightMap, heightUv).r * _Displacement;

            //Displace the vertex in the normal direction depending the height value
            v.vertex.xyz += v.normal * height;
        }

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            //Gets the height value on the height map depending the sclae and offset value
            fixed height = tex2D(_HeightMap, (IN.uv_HeightMap + _HeightMapScaleOffset.xy) * _HeightMapScaleOffset.zw).r;

            //Gets the color on the ramp texture depending the height pixel value
            fixed4 heightColor = tex2D(_RampTexture, float2(clamp(height,0.01,1),IN.uv_RampTexture.y));

            o.Albedo = heightColor;
            o.Normal = UnpackNormal(tex2D(_NormalMap, (IN.uv_HeightMap + _HeightMapScaleOffset.xy ) * _HeightMapScaleOffset.zw));
            o.Metallic = 0;
            o.Smoothness = 0;
        }
        ENDCG



        //Water Pass

        Tags { "RenderType"="Transparent" "Queue"="Transparent"}
        Blend SrcAlpha OneMinusSrcAlpha
        ZWrite Off
        Cull Back

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows vertex:vert nolightmap alpha:fade
        #pragma target 3.0

        sampler2D _HeightMap;
        sampler2D _WaterNormal;

        struct Input
        {
            float2 uv_HeightMap;
            float2 uv_WaterNormal;
        };

        fixed4 _WaterColor;
        float _Displacement;
        fixed _WaterLevel;
        float4 _HeightMapScaleOffset;
        float _ShoreFade;



        void vert(inout appdata_full v)
        {
            //Sets the water vertex height
            v.vertex.xyz += v.normal * _Displacement * _WaterLevel;
        }

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 col = _WaterColor;
            fixed height = tex2D(_HeightMap, (IN.uv_HeightMap + _HeightMapScaleOffset.xy) * _HeightMapScaleOffset.zw).r;

            o.Albedo = _WaterColor;

            //Make uniform the normal map scale
            float normalTiling = max(_HeightMapScaleOffset.z, _HeightMapScaleOffset.w);

            //Makes the normal texture scroll
            o.Normal = UnpackNormal(tex2D(_WaterNormal, (IN.uv_WaterNormal + _HeightMapScaleOffset.xy + float2(0, _Time[0])) * normalTiling));

            o.Metallic = 0.7;
            o.Smoothness = 0.7;

            //Calculate the edge fade value depending the height map
            fixed edgeFade = pow(clamp(height + (1 - _WaterLevel) - 0.5,0,1), _ShoreFade) * _ShoreFade;
            o.Alpha = floor(1 - height + _WaterLevel) * clamp(edgeFade + col.a, col.a, 1);
        }
        ENDCG

    }
    FallBack "Diffuse"
}
