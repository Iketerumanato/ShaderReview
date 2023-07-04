using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShaderMaterial : MonoBehaviour
{
    public Shader shader;
    private Material shaderMaterial;

    // Start is called before the first frame update
    void Awake()
    {
        //新たにマテリアルを生成
        shaderMaterial = new Material(shader);
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Graphics.Blit(source, destination, shaderMaterial);
    }
}
