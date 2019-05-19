// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom Shaders/Cell Shading"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color ("Color", Color) = (1,1,1,1)
        _Remap ("Remap", Range(-1,1)) = 0.0
        _Brightness ("Brightness", Range(-1,1)) = 0.0
        [IntRange]_Cells("Cells", Range(1,10)) = 1.0
        
    }
    SubShader
    {
        Tags{"RenderType"="Opaque"}

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Color;
            float _Remap;
            float _Brightness;
            float _Cells;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.normal = UnityObjectToWorldNormal(v.normal); //Gets the world normals of the mesh
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                //Calculate the light with a dot product and round it
                fixed light = round((dot(normalize(i.normal), _WorldSpaceLightPos0) + _Remap) * _Cells) / _Cells;
                light = clamp(light + _Brightness,0.2,1);

                //Calculate the color depending the diffuse value and the ambient sky value
                fixed4 col = light * _Color + unity_AmbientSky;
                return col;
            }
            ENDCG
        }   
    }
    
}
