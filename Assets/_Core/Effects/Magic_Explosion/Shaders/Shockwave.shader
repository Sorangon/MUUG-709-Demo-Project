Shader "Effects/Shockwave"
{
    Properties
    {
        _MainTex ("RefractTexture", 2D) = "white" {}
		_ShockwaveAmount ("Shockwave Amount", Range(0,1)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent"}
        LOD 100
		ZTest Off //Rendered after

		GrabPass{} //Gets the texture behind mesh

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
				float4 color : COLOR;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)

				float4 color : COLOR;
                float4 vertex : SV_POSITION;
                float4 screenUV : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
			fixed _ShockwaveAmount;

			sampler2D _GrabTexture;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);

				o.screenUV = ComputeGrabScreenPos(o.vertex);
				o.color = v.color;

                return o;
            }


			fixed refr(fixed axis, fixed amount)
			{
				return (axis + 0.5) * amount + (1 - amount);
			}


            fixed4 frag (v2f i) : SV_Target
            {
				fixed4 halo = tex2D(_MainTex, i.uv);
				fixed4 grab = tex2Dproj(_GrabTexture, i.screenUV * fixed4(refr(halo.x, i.color.a), refr(halo.y, i.color.a),1,1));


                return grab;
            }
            ENDCG
        }
    }
}
