using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class SmoothNormals : MonoBehaviour {
	Mesh mesh;

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
		Smooth ();
	}

	void Smooth() {
		Mesh mesh = GetComponent<MeshFilter>().mesh;
		Vector3[] vertices = mesh.vertices;
		Vector3[] normals = mesh.normals;
		for ( var i=1; i<vertices.Length-1; i+=2 ) {
			if ( vertices[i] == vertices[i+1] ) {
				Vector3 averageNormal = ( normals[i] + normals[i+1] )/2;
				normals[i] = averageNormal;
				normals[i+1] = averageNormal;
			}
		}
		mesh.normals = normals;

	}
}
