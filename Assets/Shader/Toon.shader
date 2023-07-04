Shader "Unlit/Toon"
{
	Properties
	{
		_Color("Color",Color) = (1,0,0,0)
		_Ambient("Ambient",Color) = (1,0.2,0.2,1)
		_Diffuse("Diffuse", Color) = (1, 1, 1, 1)
	}

	SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			fixed4 _Color;
	//fixed4 _Ambient;
	//fixed4 _Diffuse;

	struct appdata
	{
	  float4 vertex : POSITION;
	  float3 normal : NORMAL;
	};

	struct v2f
	{
	  float4 vertex : SV_POSITION;
	  float3 normal : NORMAL;
	  float3 worldPosition : TEXCOORD1;
	};

	v2f vert(appdata v)
	{
	  v2f o;
	  o.vertex = UnityObjectToClipPos(v.vertex);
	  o.normal = UnityObjectToWorldNormal(v.normal);
	  o.worldPosition = mul(unity_ObjectToWorld, v.vertex);
	  return o;
	}

	fixed4 frag(v2f i) : SV_Target
	{
		//視覚ベクトル
		float3 eyeDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPosition);
		//ハーフベクトル
		float3 halfVec = normalize(eyeDir + _WorldSpaceLightPos0);
		//面の法線と光源の向きの内積を求める                //光源の向き
		float intensity = saturate(dot(normalize(i.normal), _WorldSpaceLightPos0));
		//内積の値だけ明るくする
		//fixed4 color = fixed4(1, 1, 1, 1);
		fixed4 color = _Color;

		//カメラの位置を考慮のための変数
		float diffuseIntensity = saturate(dot(normalize(i.normal), halfVec));

		//float specular = pow(intensity, 50);

		fixed4 ambient = (1 - smoothstep(0.01, 0.06,intensity)) * color * 0.3;
		fixed4 diffuse = color * smoothstep(0.01, 0.06, intensity);
		fixed4 specular = smoothstep(0.01, 0.06, pow(diffuseIntensity, 50)) * fixed4(1, 1, 1, 1);

		fixed4 ads = ambient + diffuse + specular;
		return ads;

		//return color * specular;
	}
	  ENDCG
        }
	}
}