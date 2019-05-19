using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Projectile : MonoBehaviour
{
    [SerializeField] private float _speed = 15;
    [SerializeField] private ParticleSystem _impactEffect = null;
    [SerializeField] private GameObject _trail = null;

    private Rigidbody _rb;

    private void Awake()
    {
        _rb = GetComponent<Rigidbody>();
    }

    private void FixedUpdate()
    {
        _rb.velocity = transform.forward * _speed;
    }


    private void OnCollisionEnter(Collision col)
    {
        _trail.transform.parent = null;

        if (_impactEffect != null) Instantiate(_impactEffect, transform.position, Quaternion.identity);

        Destroy(gameObject);
    }
}
