using UnityEngine;
using System.Collections;
using UnityEngine.UI;

public class RescaleObject : MonoBehaviour {

	public GameObject _ARCam;
	private Slider _slider;

	// Use this for initialization
	void Start () {
		_slider = GetComponent<Slider> ();
	}
	
	// Update is called once per frame
	void Update () {
	
	}

	public void ChangeScale(GameObject plane) {
		_ARCam.GetComponent<socket_client> ().distance_range = _slider.value;
	}

	public void RotateObject(GameObject plane) {
		Vector3 _curRot = plane.transform.localEulerAngles;

		plane.transform.localEulerAngles = new Vector3 (_curRot.x, _curRot.y + 90, _curRot.z);
	}
}
