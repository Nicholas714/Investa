package response

import (
	"encoding/json"
	"errors"
	"fmt"
	"net/http"
)

type Response struct {
	StatusCode int
	err        error
}

var Nil = Response{200, nil}
var ServerError = Response{500, errors.New("server error")}
var Unauthenticated = Response{401, errors.New("unauthorized")}

func NewResponse(status int, err error) *Response {
	return &Response{
		status,
		err,
	}
}

func (resp *Response) Write(w http.ResponseWriter) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(resp.StatusCode)
	out, err := resp.JSON()
	if err != nil {
		fmt.Fprintf(w, err.Error())
		return
	}

	fmt.Fprint(w, out)
}

func (resp *Response) JSON() (string, error) {
	var respErr string
	if resp.err == nil {
		respErr = ""
	} else {
		respErr = resp.err.Error()
	}

	result := struct {
		Error string `json:"error"`
	}{respErr}

	out, err := json.Marshal(result)
	return string(out), err
}

func (resp *Response) HasError() bool {
	return resp.err != nil
}

func (resp *Response) Error() string {
	return resp.err.Error()
}
