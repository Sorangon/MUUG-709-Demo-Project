using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class VFXShowcase : MonoBehaviour
{
    [SerializeField] private KeyCode _triggerInput = KeyCode.Space;
    [SerializeField] private ParticleSystem _effect = null;

    private void Update()
    {
        if (Input.GetKeyDown(_triggerInput))
        {
            PlayEffect();
        }
    }

    private void PlayEffect()
    {
        Instantiate(_effect, transform.position, transform.rotation);
    }
}
