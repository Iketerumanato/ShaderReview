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
		//���o�x�N�g��
		float3 eyeDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPosition);
		//�n�[�t�x�N�g��
		float3 halfVec = normalize(eyeDir + _WorldSpaceLightPos0);
		//�ʂ̖@���ƌ����̌����̓��ς����߂�                //�����̌���
		float intensity = saturate(dot(normalize(i.normal), _WorldSpaceLightPos0));
		//���ς̒l�������邭����
		//fixed4 color = fixed4(1, 1, 1, 1);
		fixed4 color = _Color;

		//�J�����̈ʒu���l���̂��߂̕ϐ�
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