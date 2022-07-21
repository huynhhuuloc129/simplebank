package api

import (
	"bytes"
	"database/sql"
	"encoding/json"
	"fmt"
	"io"
	"io/ioutil"
	"math/rand"
	"net/http"
	"net/http/httptest"
	"reflect"
	"testing"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/golang/mock/gomock"
	mockdb "github.com/huynhhuuloc129/simplebank/db/mock"
	db "github.com/huynhhuuloc129/simplebank/db/sqlc"
	"github.com/huynhhuuloc129/simplebank/util"
	"github.com/lib/pq"
	"github.com/stretchr/testify/require"
)

type eqCreateUserParamsMatcher struct {
	arg      db.CreateUserParams
	password string
}

func (e eqCreateUserParamsMatcher) Matches(x interface{}) bool {
	arg, ok := x.(db.CreateUserParams)
	if !ok {
		return false
	}

	if err := util.CheckPassword(e.password, arg.HashedPassword); err != nil {
		return false
	}
	e.arg.HashedPassword = arg.HashedPassword
	return reflect.DeepEqual(e.arg, arg)
}

func (e eqCreateUserParamsMatcher) String() string {
	return fmt.Sprintf("matches arg %v and password %v", e.arg, e.password)
}

func eqCreateUserParams(arg db.CreateUserParams, password string) gomock.Matcher {
	return eqCreateUserParamsMatcher{arg, password}
}

func TestCreateUserAPI(t *testing.T) {
	user, password := RandomUser(t)

	arg := db.CreateUserParams{
		Username:       user.Username,
		HashedPassword: user.HashedPassword,
		FullName:       user.FullName,
		Email:          user.Email,
	}

	testCases := []struct {
		name          string
		body          gin.H
		buildStubs    func(store *mockdb.MockStore)
		checkResponse func(recorder *httptest.ResponseRecorder)
	}{
		{
			name: "OK",
			body: gin.H{
				"username":  user.Username,
				"password":  password,
				"full_name": user.FullName,
				"email":     user.Email,
			},
			buildStubs: func(store *mockdb.MockStore) {
				store.EXPECT().CreateUser(gomock.Any(), eqCreateUserParams(arg, password)).Times(1).Return(user, nil)
			},
			checkResponse: func(recorder *httptest.ResponseRecorder) {
				require.Equal(t, http.StatusOK, recorder.Code)
				requireBodyMatchUser(t, recorder.Body, user)
			},
		},
		{
			name: "ShortPassword",
			body: gin.H{
				"username":  user.Username,
				"password":  util.RandomString(5),
				"full_name": user.FullName,
				"email":     user.Email,
			},
			buildStubs: func(store *mockdb.MockStore) {
				store.EXPECT().CreateUser(gomock.Any(), gomock.Any()).Times(0)
			},
			checkResponse: func(recorder *httptest.ResponseRecorder) {
				require.Equal(t, http.StatusBadRequest, recorder.Code)
			},
		},
		{
			name: "DatabaseInternalError",
			body: gin.H{
				"username":  user.Username,
				"password":  password,
				"full_name": user.FullName,
				"email":     user.Email,
			},
			buildStubs: func(store *mockdb.MockStore) {
				store.EXPECT().CreateUser(gomock.Any(), gomock.Any()).Times(1).Return(db.Users{}, sql.ErrConnDone)
			},
			checkResponse: func(recorder *httptest.ResponseRecorder) {
				require.Equal(t, http.StatusInternalServerError, recorder.Code)
			},
		},
		{
			name: "UniqueViolationError",
			body: gin.H{
				"username":  user.Username,
				"password":  password,
				"full_name": user.FullName,
				"email":     user.Email,
			},
			buildStubs: func(store *mockdb.MockStore) {
				store.EXPECT().CreateUser(gomock.Any(), eqCreateUserParams(arg, password)).Times(1).Return(db.Users{}, error(&pq.Error{
					Code: "23505",
				}))
			},
			checkResponse: func(recorder *httptest.ResponseRecorder) {
				require.Equal(t, http.StatusForbidden, recorder.Code)
			},
		},
	}
	for i := range testCases {
		tc := testCases[i]
		t.Run(tc.name, func(t *testing.T) {
			ctrl := gomock.NewController(t)

			store := mockdb.NewMockStore(ctrl)
			// build stubs
			tc.buildStubs(store)

			server := NewServer(store)
			recorder := httptest.NewRecorder()
			request, err := http.NewRequest(http.MethodPost, "/users", nil)
			require.NoError(t, err)
			body, err := json.Marshal(tc.body)
			require.NoError(t, err)
			request.Body = io.NopCloser(bytes.NewReader(body))

			server.router.ServeHTTP(recorder, request)

			// check response
			tc.checkResponse(recorder)

		})

	}
}
func TestListUserAPI(t *testing.T) {
	var users []db.Users

	for i := 0; i < int(rand.Int31n(10)+2); i++ {
		user, _ := RandomUser(t)
		users = append(users, user)
	}
	pageId := rand.Int31n(3) + 2
	PageSize := rand.Int31n(10) + 2
	arg := db.ListUsersParams{
		Limit:  PageSize,
		Offset: (pageId - 1) * PageSize,
	}
	testCases := []struct {
		name          string
		param         db.ListUsersParams
		buildStubs    func(store *mockdb.MockStore)
		checkResponse func(recorder *httptest.ResponseRecorder)
	}{
		{
			param: arg,
			name:  "OK",
			buildStubs: func(store *mockdb.MockStore) {
				store.EXPECT().ListUsers(gomock.Any(), arg).Times(1).Return(users, nil)
			},
			checkResponse: func(recorder *httptest.ResponseRecorder) {
				require.Equal(t, http.StatusOK, recorder.Code)
				requireBodyMatchAllUsers(t, recorder.Body, users)
			},
		},
		{
			param: db.ListUsersParams{
				Limit:  arg.Limit,
				Offset: 0,
			},
			name: "InvalidRequest",
			buildStubs: func(store *mockdb.MockStore) {
				store.EXPECT().ListUsers(gomock.Any(), db.ListUsersParams{
					Limit:  arg.Limit,
					Offset: 0,
				}).Times(0)
			},
			checkResponse: func(recorder *httptest.ResponseRecorder) {
				require.Equal(t, http.StatusBadRequest, recorder.Code)
			},
		},
		{
			param: arg,
			name:  "InternalError",
			buildStubs: func(store *mockdb.MockStore) {
				store.EXPECT().ListUsers(gomock.Any(), arg).Times(1).Return([]db.Users{}, sql.ErrConnDone)
			},
			checkResponse: func(recorder *httptest.ResponseRecorder) {
				require.Equal(t, http.StatusInternalServerError, recorder.Code)
			},
		},
	}
	for i := range testCases {
		tc := testCases[i]
		t.Run(tc.name, func(t *testing.T) {
			ctrl := gomock.NewController(t)

			store := mockdb.NewMockStore(ctrl)
			// build stubs
			tc.buildStubs(store)

			server := NewServer(store)
			recorder := httptest.NewRecorder()

			var url string
			if tc.param.Offset == 0 {
				url = "/users?page_id=abd"
			} else {
				url = fmt.Sprintf("/users?page_id=%d&page_size=%d", pageId, PageSize)
			}
			request, err := http.NewRequest(http.MethodGet, url, nil)
			require.NoError(t, err)

			server.router.ServeHTTP(recorder, request)

			// check response
			tc.checkResponse(recorder)

		})

	}
}

func TestGetAllUserAPI(t *testing.T) {
	var users []db.Users
	for i := 0; i < int(rand.Int31n(10)+2); i++ {
		user, _ := RandomUser(t)
		users = append(users, user)
	}

	testCases := []struct {
		name          string
		buildStubs    func(store *mockdb.MockStore)
		checkResponse func(recorder *httptest.ResponseRecorder)
	}{
		{
			name: "OK",
			buildStubs: func(store *mockdb.MockStore) {
				store.EXPECT().GetAllUsers(gomock.Any()).Times(1).Return(users, nil)
			},
			checkResponse: func(recorder *httptest.ResponseRecorder) {
				require.Equal(t, http.StatusOK, recorder.Code)
				requireBodyMatchAllUsers(t, recorder.Body, users)
			},
		},
		{
			name: "InternalError",
			buildStubs: func(store *mockdb.MockStore) {
				store.EXPECT().GetAllUsers(gomock.Any()).Times(1).Return([]db.Users{}, sql.ErrConnDone)
			},
			checkResponse: func(recorder *httptest.ResponseRecorder) {
				require.Equal(t, http.StatusInternalServerError, recorder.Code)
			},
		},
	}
	for i := range testCases {
		tc := testCases[i]
		t.Run(tc.name, func(t *testing.T) {
			ctrl := gomock.NewController(t)

			store := mockdb.NewMockStore(ctrl)
			// build stubs
			tc.buildStubs(store)

			server := NewServer(store)
			recorder := httptest.NewRecorder()
			request, err := http.NewRequest(http.MethodGet, "/users", nil)
			require.NoError(t, err)

			server.router.ServeHTTP(recorder, request)

			// check response
			tc.checkResponse(recorder)

		})

	}
}

func TestGetUserAPI(t *testing.T) {
	user, _ := RandomUser(t)

	testCases := []struct {
		name          string
		username      string
		buildStubs    func(store *mockdb.MockStore)
		checkResponse func(recorder *httptest.ResponseRecorder)
	}{
		{
			name:     "OK",
			username: user.Username,
			buildStubs: func(store *mockdb.MockStore) {
				store.EXPECT().GetUser(gomock.Any(), user.Username).Times(1).Return(user, nil)
			},
			checkResponse: func(recorder *httptest.ResponseRecorder) {
				require.Equal(t, http.StatusOK, recorder.Code)
				requireBodyMatchUser(t, recorder.Body, user)
			},
		},
		{
			name:     "UriError",
			username: "d",
			buildStubs: func(store *mockdb.MockStore) {
				store.EXPECT().GetUser(gomock.Any(), gomock.Any()).Times(0)
			},
			checkResponse: func(recorder *httptest.ResponseRecorder) {
				require.Equal(t, http.StatusBadRequest, recorder.Code)
			},
		},
		{
			name:     "NoRowsError",
			username: user.Username,
			buildStubs: func(store *mockdb.MockStore) {
				store.EXPECT().GetUser(gomock.Any(), gomock.Eq(user.Username)).Times(1).Return(db.Users{}, sql.ErrNoRows)
			},
			checkResponse: func(recorder *httptest.ResponseRecorder) {
				require.Equal(t, http.StatusNotFound, recorder.Code)
			},
		},
		{
			name:     "InternalError",
			username: user.Username,
			buildStubs: func(store *mockdb.MockStore) {
				store.EXPECT().GetUser(gomock.Any(), gomock.Eq(user.Username)).Times(1).Return(db.Users{}, sql.ErrConnDone)
			},
			checkResponse: func(recorder *httptest.ResponseRecorder) {
				require.Equal(t, http.StatusInternalServerError, recorder.Code)
			},
		},
	}
	for i := range testCases {
		tc := testCases[i]
		t.Run(tc.name, func(t *testing.T) {
			ctrl := gomock.NewController(t)
			store := mockdb.NewMockStore(ctrl)

			// build stubs
			tc.buildStubs(store)
			// start server
			url := fmt.Sprintf("/users/%s", tc.username)
			request, err := http.NewRequest(http.MethodGet, url, nil)
			require.NoError(t, err)
			recorder := httptest.NewRecorder()
			server := NewServer(store)
			server.router.ServeHTTP(recorder, request)

			// check response
			tc.checkResponse(recorder)
		})
	}
}

func RandomUser(t *testing.T) (db.Users, string) {
	password := util.RandomString(10)
	hashedPassword, err := util.HashPassword(password)
	require.NoError(t, err)

	return db.Users{
		Username:          util.RandomOwner(),
		HashedPassword:    hashedPassword,
		FullName:          util.RandomOwner(),
		Email:             util.RandomEmail(),
		PasswordChangedAt: time.Now(),
		CreatedAt:         time.Now(),
	}, password
}

func requireBodyMatchAllUsers(t *testing.T, body *bytes.Buffer, users []db.Users) {
	data, err := ioutil.ReadAll(body)
	require.NoError(t, err)

	var gotuser []db.Users
	err = json.Unmarshal(data, &gotuser)
	require.NoError(t, err)
	for i, user := range users {
		require.Equal(t, user.Username, gotuser[i].Username)
		require.Equal(t, user.FullName, gotuser[i].FullName)
		require.Equal(t, user.Email, gotuser[i].Email)
		require.WithinDuration(t, user.CreatedAt, gotuser[i].CreatedAt, time.Second)
		require.WithinDuration(t, user.PasswordChangedAt, gotuser[i].PasswordChangedAt, time.Second)
	}
}
func requireBodyMatchUser(t *testing.T, body *bytes.Buffer, user db.Users) {
	data, err := ioutil.ReadAll(body)
	require.NoError(t, err)

	var gotUser db.Users
	err = json.Unmarshal(data, &gotUser)
	require.NoError(t, err)
	require.Equal(t, user.Username, gotUser.Username)
	require.Equal(t, user.FullName, gotUser.FullName)
	require.Equal(t, user.Email, gotUser.Email)
	require.WithinDuration(t, user.CreatedAt, gotUser.CreatedAt, time.Second)
	require.WithinDuration(t, user.PasswordChangedAt, gotUser.PasswordChangedAt, time.Second)
}
