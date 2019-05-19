using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

public class MagicExplosionControler : MonoBehaviour
{
    [SerializeField] private ParticleSystem _explosionEffect = null;

    public void OnParticleSystemStopped()
    {
        Instantiate(_explosionEffect, transform.position, transform.rotation);
        Destroy(gameObject);

        Camera.main.transform.DOShakePosition(1.2f, 1, 12);
    }
}
