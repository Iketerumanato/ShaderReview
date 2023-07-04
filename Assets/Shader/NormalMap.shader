Shader "Unlit/NormalMap"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
	    _NormalMap("Normal",2D) = "bump" {}
	}

	SubShader
	{
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
				float3 normal : NORMAL;//法線
				float4 tangent : TANGENT;//接線
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
				float3 worldPosition : TEXCOORD1;
				float3 normal : NORMAL;
				float3 tangent : TANGENT;
				float3 binormal : TEXCOORD2;//従法線
			};

			 sampler2D _MainTex;
			 float4 _MainTex_ST;

			 v2f vert(appdata v)
			 {
				 v2f o;
				 o.vertex = UnityObjectToClipPos(v.vertex);
				 o.uv = v.uv;
				 o.normal = normalize(v.normal);
				 o.tangent = normalize(v.tangent.xyz);
				 o.binormal = normalize(cross(v.normal, v.tangent) * v.tangent.w * unity_WorldTransformParams.w);
				 o.worldPosition = mul(unity_ObjectToWorld, v.vertex);
				 return o;
			 }

			 sampler2D _NormalMap;

			 fixed4 frag(v2f i) : SV_Target
			 {
				 float4 nMap = tex2D(_NormalMap,i.uv) * 2 - 1;//色情報(0～1)をベクトル情報(-1～1)へ変更

				 //float3 normal = normalize(nMap.xyz);
				 nMap = normalize(nMap);
				 i.tangent = normalize(i.tangent);
				 i.binormal = normalize(i.binormal);
				 i.normal = normalize(i.normal);

				 //ノーマルマップから算出した法線ベクトルは接空間にあるので、ローカル空間に変換
				 float3 lNormal = normalize(nMap.x * i.tangent + nMap.y * i.binormal + nMap.z * i.normal);
				 //ローカル空間からワールド空間へ変更
				 float3 wNormal = UnityObjectToWorldNormal(lNormal);

				 //視覚ベクトル
				 float3 eyeDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPosition);
				 //ハーフベクトル
				 float3 halfVec = normalize(eyeDir + _WorldSpaceLightPos0);

				 //モデルから受け取ったnormal出ないことに注意
				 float intensity = saturate(dot(wNormal, halfVec));
				 float phong = pow(intensity, 50);
				 return phong * fixed4(1, 1, 1, 1);
			  }
			  ENDCG
		  }
	}
}