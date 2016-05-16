using UnityEngine;
using System.Collections;
using UnityEngine.UI;

public class SliderText : MonoBehaviour {

	[SerializeField] private Slider slider;
	[SerializeField] private Text text;


	public void Awake(){
		UpdateText();
	}

	public void UpdateText(){
		text.text = slider.value.ToString("N1");
	}

//	// Use this for initialization
//	void Start () {
//	
//	}
//	
//	// Update is called once per frame
//	void Update () {
//	
//	}
}
