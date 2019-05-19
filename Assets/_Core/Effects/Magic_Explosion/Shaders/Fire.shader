// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Effects/Dust"
{
	Properties
	{
		_Texture0("Texture 0", 2D) = "white" {}
		[HDR]_ColorA("Color A", Color) = (1,0,0,1)
		[HDR]_ColorB("Color B", Color) = (1,0.9622972,0,1)
		_Panner("Panner", Vector) = (-0.05,-0.5,0,0)
		_Fade("Fade", Range( 0 , 2)) = 1.193058
		_Power("Power", Range( 0 , 20)) = 0
	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Transparent" "Queue"="Transparent" }
		LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend SrcAlpha OneMinusSrcAlpha , SrcAlpha OneMinusSrcAlpha
		Cull Off
		ColorMask RGBA
		ZWrite Off
		ZTest LEqual
		Offset 0 , 0
		
		
		
		Pass
		{
			Name "Unlit"
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 ase_texcoord : TEXCOORD0;
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				float4 ase_color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
			};

			uniform float4 _ColorA;
			uniform float4 _ColorB;
			uniform float _Fade;
			uniform sampler2D _Texture0;
			uniform float2 _Panner;
			uniform float4 _Texture0_ST;
			uniform float _Power;
			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_color = v.color;
				o.ase_texcoord.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.zw = 0;
				float3 vertexValue =  float3(0,0,0) ;
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				fixed4 finalColor;
				float2 uv01 = i.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 uv0_Texture0 = i.ase_texcoord.xy * _Texture0_ST.xy + _Texture0_ST.zw;
				float2 panner6 = ( _Time.y * _Panner + uv0_Texture0);
				float4 temp_output_9_0 = ( ( 1.0 - ( uv01.y * _Fade ) ) * tex2D( _Texture0, panner6 ) );
				float4 lerpResult27 = lerp( _ColorA , _ColorB , temp_output_9_0);
				float4 clampResult35 = clamp( pow( lerpResult27 , 2.0 ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
				float4 break30 = ( i.ase_color * clampResult35 );
				float clampResult34 = clamp( ( pow( temp_output_9_0.r , 6.0 ) * 30.0 * i.ase_color.a ) , 0.0 , 1.0 );
				float4 appendResult31 = (float4(break30.r , break30.g , break30.b , pow( clampResult34 , _Power )));
				
				
				finalColor = appendResult31;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=16700
1927;7;1906;1004;456.2773;174.3295;1;True;True
Node;AmplifyShaderEditor.TexturePropertyNode;5;-1967.153,402.9715;Float;True;Property;_Texture0;Texture 0;0;0;Create;True;0;0;False;0;cd460ee4ac5c1e746b7a734cc7cc64dd;cd460ee4ac5c1e746b7a734cc7cc64dd;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;12;-1615.396,552.7505;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;7;-1613.396,879.7505;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;13;-1617.203,718.5247;Float;False;Property;_Panner;Panner;3;0;Create;True;0;0;False;0;-0.05,-0.5;-0.5,-0.4;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;1;-1609.781,38.43353;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;33;-1304.139,234.2578;Float;False;Property;_Fade;Fade;4;0;Create;True;0;0;False;0;1.193058;0.86;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;6;-1287.396,700.7505;Float;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-972.1543,87.20526;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;2;-778.1543,92.20526;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;11;-983.1543,403.2053;Float;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;28;-632.8535,-201.3688;Float;False;Property;_ColorB;Color B;2;1;[HDR];Create;True;0;0;False;0;1,0.9622972,0,1;0.7075472,0.5937594,0.5306604,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;25;-622.4047,-423.6639;Float;False;Property;_ColorA;Color A;1;1;[HDR];Create;True;0;0;False;0;1,0,0,1;0.2169811,0.2169811,0.2169811,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-467.1543,93.20526;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;27;-211.8997,-197.2788;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;24;-197.509,91.45819;Float;True;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.PowerNode;32;51.89082,-199.1514;Float;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;2;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;42;235.1252,-498.1978;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;36;222.0204,103.8651;Float;False;2;0;FLOAT;0;False;1;FLOAT;6;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;35;227.0524,-195.1748;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;474.9476,98.1105;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;30;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;34;678.8765,102.3721;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;532.2971,-210.9078;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;47;677.5768,377.8315;Float;False;Property;_Power;Power;5;0;Create;True;0;0;False;0;0;2;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;30;776.5257,-205.9685;Float;True;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.PowerNode;48;983.7227,103.6705;Float;False;2;0;FLOAT;0;False;1;FLOAT;65.77;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;31;1145.403,-204.7064;Float;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;1517.851,-198.9093;Float;False;True;2;Float;ASEMaterialInspector;0;1;Effects/Dust;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;2;5;False;-1;10;False;-1;2;5;False;-1;10;False;-1;True;0;False;-1;0;False;-1;True;False;True;2;False;-1;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;2;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;2;0;False;False;False;False;False;False;False;False;False;True;0;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;12;2;5;0
WireConnection;6;0;12;0
WireConnection;6;2;13;0
WireConnection;6;1;7;0
WireConnection;14;0;1;2
WireConnection;14;1;33;0
WireConnection;2;0;14;0
WireConnection;11;0;5;0
WireConnection;11;1;6;0
WireConnection;9;0;2;0
WireConnection;9;1;11;0
WireConnection;27;0;25;0
WireConnection;27;1;28;0
WireConnection;27;2;9;0
WireConnection;24;0;9;0
WireConnection;32;0;27;0
WireConnection;36;0;24;0
WireConnection;35;0;32;0
WireConnection;37;0;36;0
WireConnection;37;2;42;4
WireConnection;34;0;37;0
WireConnection;43;0;42;0
WireConnection;43;1;35;0
WireConnection;30;0;43;0
WireConnection;48;0;34;0
WireConnection;48;1;47;0
WireConnection;31;0;30;0
WireConnection;31;1;30;1
WireConnection;31;2;30;2
WireConnection;31;3;48;0
WireConnection;0;0;31;0
ASEEND*/
//CHKSM=8A79C4E99C509CC74DC124DAC0748876F17E214F