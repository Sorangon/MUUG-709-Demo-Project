Shader "Custom Shaders/Moss"
{
    Properties
    {
		[Header(Base Texture)] //Base texture settings
		_BaseColor("Base Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		[Normal][NoScaleOffset]_NormalMap("Normal Map", 2D) = "bump" {}
		_Glossiness("Smoothness", Range(0,1)) = 0.5
		_Metallic("Metallic", Range(0,1)) = 0.0

		[Header(Moss Settings)] //Moss settings
		_MossColor("Moss Color", Color) = (1,1,1,1)
		_MossTexture("Moss Texture", 2D) = "white" {}
		[Normal][NoScaleOffset]_MossNormal("Moss Normal", 2D) = "bump" {}
		_MossAmount("Moss Amount", Range(0,1)) = 0
		_BlendSmoothness("Blend Hardness", Range(0.01,1)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows vertex:vert

        #pragma target 3.0

        sampler2D _MainTex;
		sampler2D _MossTexture;
		sampler2D _NormalMap;
		sampler2D _MossNormal;

        struct Input
        {
            float2 uv_MainTex;
			float2 uv_MossTexture;
			float3 normal;
        };

		float4 _BaseColor;
		float4 _MossColor;
        half _Glossiness;
        half _Metallic;
		half _MossAmount;
		float _BlendSmoothness;


		void vert(inout appdata_full v, out Input o)
		{
			UNITY_INITIALIZE_OUTPUT(Input,o);
			o.normal = normalize(UnityObjectToWorldNormal(normalize(v.normal)));
		}


        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _BaseColor;
			fixed4 moss = tex2D(_MossTexture, IN.uv_MossTexture) * _MossColor;

			fixed3 nrm = UnpackNormal(tex2D(_NormalMap, IN.uv_MainTex));
			fixed3 mossNrm = UnpackNormal(tex2D(_MossNormal, IN.uv_MossTexture));

			//Multiply the moss texture value with the y value of the normal
			fixed upNormal = pow(clamp(IN.normal.y - 1 + 2 * _MossAmount, 0, 1) , _BlendSmoothness);

            o.Albedo = c.rgb * (1 - upNormal) + moss * upNormal;
			o.Normal = nrm * (1 - upNormal) + mossNrm * upNormal;
            o.Metallic = _Metallic * (1 - upNormal);
            o.Smoothness = _Glossiness * (1 - upNormal);
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
