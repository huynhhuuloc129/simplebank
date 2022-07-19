package api

import (
	"encoding/json"
	"errors"
	"fmt"
)

func ConvertListRequestToMap(obj interface{}) (map[string]interface{}, error){
	var objMap map [string]interface{}
	
	objStruct := obj.(*listRequest)
	data, err := json.Marshal(*objStruct)
	if err != nil {
		return objMap, errors.New("can't marshal struct, err: "+err.Error())
	}

	if err := json.Unmarshal([]byte(data), &objMap); err != nil {
		return objMap, errors.New("can't unmarshal data, err: "+err.Error())
	}
	return objMap, nil
}

func MissingAllFieldStruct(obj interface{}) (bool, error) {
	objMap, err := ConvertListRequestToMap(obj)
	if err != nil {
		return false, err
	}
	fmt.Println(objMap)
	for _, val := range objMap {
		if val == "" || val == 0.0 {
			continue
		} else {
			return false, nil
		}
	}
	return true, nil
}

func MissingFieldStruct(obj interface{}) (bool, error) {
	objMap, err := ConvertListRequestToMap(obj)
	if err != nil {
		return false, err
	}

	for _, val := range objMap {
		if val == "" || val == 0.0 {
			return true, nil
		}
	}
	return false, nil
}
