using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WarriorEffects : MonoBehaviour
{
    [SerializeField] private ParticleSystem _rightSlashEffect = null;
    [SerializeField] private ParticleSystem _leftslashEffect = null;


    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            GetComponent<Animator>().SetTrigger("Reset");
        }
    }


    public void SlashEffect(int index)
    {
        if(_rightSlashEffect != null && index == 0)
        {
            _rightSlashEffect.Play();
        }

        if (_leftslashEffect != null && index == 1)
        {
            _leftslashEffect.Play();
        }
    }
}
