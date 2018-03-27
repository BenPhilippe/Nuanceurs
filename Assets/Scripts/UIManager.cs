using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class UIManager : MonoBehaviour {

	private Material currentMaterial;
	private Material startMaterial;
	public MouseOrbitImproved orbiter;


	// UI Elements
	public Text currentShaderName;

	// Use this for initialization
	void Start () {
		orbiter = Camera.main.GetComponent<MouseOrbitImproved>();
		if(orbiter != null){
			Debug.Log("Orbiter found");
			
			startMaterial = orbiter.target.gameObject.GetComponent<Renderer>().material;
			if(startMaterial != null){
				Debug.Log("Start material found");
				currentMaterial = startMaterial;
				currentShaderName.text = currentMaterial.shader.name;
			}
		}
	}
	
	// Update is called once per frame
	void Update () {
		
	}
}
