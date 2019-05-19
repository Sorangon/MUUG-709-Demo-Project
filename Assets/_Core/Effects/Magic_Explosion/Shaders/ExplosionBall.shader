Shader "Effects/Explosion Ball"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		[HDR]_ColorA ("Color A", Color) = (1,1,1,1)
        [HDR]_ColorB ("Color B", Color) = (0,1,1,1)
        _Alpha("Alpha", Range(0,1)) = 1.0
		[HDR]_RimColor ("Rim Color", Color) = (1,0,0,1)
        _Brightness ("Brightness", Range(1,15)) = 1.0
		_RimPower("Rim Power", Range(0,10)) = 1.0
        _PannerSpeed("Panner Speed", Float) = 1.0
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent"}
        LOD 100
        Blend SrcAlpha OneMinusSrcAlpha
        ZWrite Off

        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag


            #include "UnityCG.cginc"

            //Includes a functions file
            #include "Assets/CG_Includes/SimpleEffects.cginc"

            struct appdata
            {
                float4 color : COLOR;
                float4 vertex : POSITION;
                float4 texcoord0 : TEXCOORD0;
				float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 color : COLOR;
                float2 texcoord0 : TEXCOORD0;
                float4 vertex : SV_POSITION;
				float3 normal : NORMAL;
				float4 worldPos : TEXCOORD1;
				float3 viewDir : TEXCOORD2;
                float2 screenuv : TEXCOORD3;
                float4 depth : TEXCOORD4;
                float brightness : TEXCOORD5;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            sampler2D _CameraDepthNormalsTexture; //Camera Depth texture

			fixed4 _ColorA;
            fixed4 _ColorB;
			fixed4 _RimColor;
			float _RimPower;
            float _PannerSpeed;
            fixed _Alpha;
            float _Brightness;

            v2f vert (appdata v)
            {
                v2f o;
                o.color = v.color;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.texcoord0 = TRANSFORM_TEX(v.texcoord0, _MainTex);
				o.normal = v.normal;
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);
				o.viewDir = normalize(UnityWorldSpaceViewDir(o.worldPos));

                o.brightness = v.texcoord0.z; //Brightness value from vertex data input

                o.screenuv = ((o.vertex.xy/o.vertex.w) + 1) /2;
#if UNITY_UV_STARTS_AT_TOP
                o.screenuv.y = 1  - o.screenuv.y;
#endif
                o.depth = -UnityObjectToViewPos(v.vertex).z * _ProjectionParams.w;

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {

                fixed4 col = lerp(_ColorA,_ColorB,tex2D(_MainTex, Panner(i.texcoord0, float2(0,_PannerSpeed))).r) * i.color;
                col += _Brightness * i.brightness;

				fixed4 rim = 1 - abs(dot(normalize(i.normal), normalize(i.viewDir)));

                //Depth fade
                float screenDepth = DecodeFloatRG(tex2D(_CameraDepthNormalsTexture, i.screenuv).zw);
                float diff = screenDepth - i.depth;
                float intersect = 0;

                if(diff > 0)
                {
                    intersect = 1 - smoothstep(0, _ProjectionParams.w, diff);
                }
                //end depth fade

				col.rgb += (pow(rim, _RimPower) + intersect) * _RimColor;
                col.a = _Alpha * i.color.a;

                return col;
            }
            ENDCG
        }
    }
}
