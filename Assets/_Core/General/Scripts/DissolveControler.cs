using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DissolveControler : MonoBehaviour
{
    private MeshFilter _mesh = null;
    private Color vertexColor;

    private void Awake()
    {
        _mesh = GetComponent<MeshFilter>();
    }

    private void FixedUpdate()
    {
        float t = Mathf.PingPong(Time.fixedTime, 1);
        vertexColor = new Color(t, t, t, 1);
        _mesh.mesh.colors = new Color[_mesh.mesh.vertexCount];
    }
}
