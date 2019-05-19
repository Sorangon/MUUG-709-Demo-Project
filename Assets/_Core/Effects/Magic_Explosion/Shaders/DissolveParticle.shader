Shader "Effects/Dissolve Particle"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _DissolveTexture ("Dissolve Mask", 2D) = "black" {}
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" "PreviewType"="Plane"}
        LOD 100
        ZWrite Off
        Blend SrcAlpha OneMinusSrcAlpha
        Cull Off

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag


            #include "UnityCG.cginc"

            struct appdata
            {
                float4 color : COLOR;
                float4 vertex : POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float texcoord2 : TEXCOORD2;
            };

            struct v2f
            {
                float4 color : COLOR;
                float2 uv : TEXCOORD0;
                float2 uv2 : TEXCOORD1;
                float4 vertex : SV_POSITION;
                float1 custom1 : TEXCOORD2;
                fixed4 custom2 : TEXCOORD3;
            };

            sampler2D _MainTex;
            sampler2D _DissolveTexture;
            float4 _MainTex_ST;
            float4 _DissolveTexture_ST;


            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.texcoord0.xy, _MainTex);
                o.uv2 = TRANSFORM_TEX(v.texcoord0.zw, _DissolveTexture);
                o.color = v.color;

                //Set the custom data values from the input vertex datas
                o.custom1 = v.texcoord1.x;
                o.custom2.xyz = v.texcoord1.yzw;
                o.custom2.w = v.texcoord2.x;


                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv) * i.color * i.custom2;
                fixed dissolve = 1 + tex2D(_DissolveTexture, i.uv2).r - i.custom1.x * 2;
                col.a = clamp(col.a * dissolve,0,1);

                return col;
            }
            ENDCG
        }
    }
}
