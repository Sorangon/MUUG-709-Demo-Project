Shader "Effects/PanningDissolve"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        [HDR]_Color ("Color", Color) = (1,1,1,1)
        _DissolveMap ("Dissolve Map", 2D) = "black" {}
        _DissolveAmount ("Dissolve Amount", Range(0,1)) = 0.0
        
    }
    SubShader
    {
        Tags { "Queue"="Transparent" "RenderType"="Transparent" }
        LOD 100

        ZWrite Off
        Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"    
            #include "Assets/CG_Includes/SimpleEffects.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            float4 _Color;
            sampler2D _Dissolvemap;

            fixed _DissolveAmount;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {

                fixed tex = tex2D(_MainTex, Panner(i.uv, float2(16,0.4))).r;
                fixed4 color = _Color;

                tex = Dissolve(tex,_DissolveAmount);

                return fixed4(_Color.r,_Color.g,_Color.b, tex);
            }
            ENDCG
        }
    }
}
