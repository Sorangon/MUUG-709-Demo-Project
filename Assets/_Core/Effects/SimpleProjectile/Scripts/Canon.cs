using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Canon : MonoBehaviour
{
    [SerializeField] private GameObject _projectileA = null;
    [SerializeField] private GameObject _projectileB = null;
    [SerializeField] private Transform _muzzleTransform = null;
   
    private void FixedUpdate()
    {
        transform.LookAt(GetMouseAimPosition());
    }

    private void Update()
    {
        if (Input.GetMouseButtonDown(0))
        {
            Instantiate(_projectileA, _muzzleTransform.position, transform.rotation);
        }

        if (Input.GetMouseButtonDown(1))
        {
            Instantiate(_projectileB, _muzzleTransform.position, transform.rotation);
        }
    }


    private void Shoot(GameObject projectile)
    {
        
    }


    private Vector3 GetMouseAimPosition()
    {
        Ray mouseRay = Camera.main.ScreenPointToRay(Input.mousePosition);
        RaycastHit mouseHit;

        if(Physics.Raycast(mouseRay,out mouseHit))
        {
            return mouseHit.point;
        }

        return Vector3.zero;
    }
}
