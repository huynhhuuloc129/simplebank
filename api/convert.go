package api

import (
	"encoding/json"
	"errors"
	"fmt"
	"net/http"

	"github.com/gin-gonic/gin"
)

func (server *Server)passListToGetAll(ctx *gin.Context, req listRequest) bool {
	fmt.Println(ctx.Request.URL)
	if ok, err := MissingAllFieldStruct(&req); ok {
		switch ctx.Request.URL.String(){
		case "/users/", "/users":
			server.getAllUser(ctx)
		case "/accounts/", "/accounts":
			server.getAllAccount(ctx)
		case "/transfers/", "/transfers":
			server.getAllTransfers(ctx)
		}
		server.getAllTransfers(ctx)
		return false
	} else if err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))
		return false
	}
	if ok, err := MissingFieldStruct(&req); ok {
		ctx.JSON(http.StatusBadRequest, errorResponse(errors.New("Request must have all field or empty")))
		return false
	} else  if err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))
		return false
	}
	return true
}

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
