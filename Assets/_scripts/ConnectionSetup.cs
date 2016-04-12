using UnityEngine;
using System.Collections;
using System;
using System.Text.RegularExpressions;
using UnityEngine.UI;
using Vuforia;
using UnityEngine.SceneManagement;

public class ConnectionSetup : MonoBehaviour {

	[Range(0, 8000)]
	public int mySliderFloat = 8000;

	public InputField ipAddressField;
	public InputField minDepth;
	public InputField maxDepth;
	public InputField portNo;

	void Start() {
		PlayerPrefs.DeleteAll ();
	}

	public bool CheckIPAddress(string ipAddress) {
		string pattern = "^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$";
			Match match = Regex.Match (ipAddress, pattern);
		if (!match.Success) {
			Debug.Log ("Invalid IP");
			return false;
		}
		return true;
	}

	public bool IsStringNull(string inputString) {
		if (inputString == "")
			return true;
		return false;
	}

	public void OnConnectClick() {
		if (IsStringNull (portNo.text) || IsStringNull (minDepth.text) || IsStringNull (maxDepth.text) || IsStringNull (ipAddressField.text)) {
			Debug.Log ("All fields not completed!");
			return;
		}

		if (!CheckIPAddress (ipAddressField.text)) {
			Debug.Log ("IP Address invalid");
			return;
		}

		// Set up player prefs
		PlayerPrefs.SetString("IPAddress", ipAddressField.text);
		PlayerPrefs.SetInt ("PortNo", int.Parse(portNo.text));
		PlayerPrefs.SetInt ("MinDepth", int.Parse(minDepth.text));
		PlayerPrefs.SetInt ("MaxDepth", int.Parse(maxDepth.text));
		PlayerPrefs.SetInt ("DistanceRange", int.Parse (maxDepth.text));

		SceneManager.LoadScene (1);
		/*
		//ARCamera.SetActive (true);
		VuforiaBehaviour.Instance.enabled = true;
		SampleUI.SetActive (true);
		myPlane.SetActive (true);
		connectionCanvas.SetActive (false);*/
	}
}