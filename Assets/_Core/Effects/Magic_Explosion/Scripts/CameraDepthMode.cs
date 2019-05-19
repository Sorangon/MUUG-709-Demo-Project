using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class CameraDepthMode : MonoBehaviour
{
    [SerializeField] private DepthTextureMode _cameraDepthTextureMode = DepthTextureMode.Depth;

    private void OnEnable()
    {
        GetComponent<Camera>().depthTextureMode = _cameraDepthTextureMode;
    }
}
