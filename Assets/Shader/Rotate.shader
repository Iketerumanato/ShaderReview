Shader "Unlit/Rotate"
{
    Properties
	{
		_MainTex("Texture", 2D) = "white" {}
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
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				float angle = _Time.y;
				float s = sin(angle);
				float c = cos(angle);

				float2x2 RotMatrix = float2x2(c, -s, s, c);

				//中心点を軸に回転
				float2 uv = mul(RotMatrix, i.uv - float2(0.5,0.5)) + float2(0.5, 0.5);
				//１面に複数表示させる場合はコメを消す
				fixed4 col = tex2D(_MainTex, saturate(uv));//uv;
				return col;
			}
			ENDCG
		}
	}
}
