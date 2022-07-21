package api

import (
	"bytes"
	"database/sql"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"math/rand"
	"net/http"
	"net/http/httptest"
	"testing"
	"time"

	"github.com/golang/mock/gomock"
	mockdb "github.com/huynhhuuloc129/simplebank/db/mock"
	db "github.com/huynhhuuloc129/simplebank/db/sqlc"
	"github.com/huynhhuuloc129/simplebank/util"
	"github.com/stretchr/testify/require"
)

func TestDeleteTransferAPI(t *testing.T) {
	Account1 := randomAccount()
	Account2 := randomAccount()
	Transfer := randomTransfer(Account1, Account2)

	testCases := []struct {
		name          string
		TransferID    int
		buildStubs    func(store *mockdb.MockStore)
		checkResponse func(t *testing.T, recorder *httptest.ResponseRecorder)
	}{
		{
			name:       "OK",
			TransferID: int(Transfer.ID),
			buildStubs: func(store *mockdb.MockStore) {
				store.EXPECT().DeleteTransfer(gomock.Any(), gomock.Eq(Transfer.ID)).Times(1).Return(nil)
			},
			checkResponse: func(t *testing.T, recorder *httptest.ResponseRecorder) {
				require.Equal(t, http.StatusOK, recorder.Code)
			},
		},
		{
			name:       "InvalidID",
			TransferID: 0,
			buildStubs: func(store *mockdb.MockStore) {
				store.EXPECT().DeleteTransfer(gomock.Any(), 0).Times(0)
			},
			checkResponse: func(t *testing.T, recorder *httptest.ResponseRecorder) {
				require.Equal(t, http.StatusBadRequest, recorder.Code)
			},
		},
		{
			name:       "InternalError",
			TransferID: int(Transfer.ID),
			buildStubs: func(store *mockdb.MockStore) {
				store.EXPECT().DeleteTransfer(gomock.Any(), gomock.Any()).Times(1).Return(sql.ErrConnDone)
			},
			checkResponse: func(t *testing.T, recorder *httptest.ResponseRecorder) {
				require.Equal(t, http.StatusInternalServerError, recorder.Code)
			},
		},
	}

	for i := range testCases {
		tc := testCases[i]
		t.Run(tc.name, func(t *testing.T) {
			ctrl := gomock.NewController(t)
			defer ctrl.Finish()

			store := mockdb.NewMockStore(ctrl)
			// build stubs
			tc.buildStubs(store)

			// start test server and send request
			server := NewServer(store)
			recorder := httptest.NewRecorder()

			url := fmt.Sprintf("/transfers/%d", tc.TransferID)
			request, err := http.NewRequest(http.MethodDelete, url, nil)
			require.NoError(t, err)
			server.router.ServeHTTP(recorder, request)
			// check response
			tc.checkResponse(t, recorder)
		})
	}

}

// func TestCreateTransferAPI(t *testing.T) {
// 	Account1 := randomAccount()
// 	Account2 := randomAccount()
// 	randCurrency := util.RandomCurrency()
// 	Account1.Currency = randCurrency
// 	Account2.Currency = randCurrency
// 	Transfer := randomTransfer(Account1, Account2)

// 	testCases := []struct {
// 		name          string
// 		fromAccountId int64
// 		toAccountId   int64
// 		amount        int64
// 		buildStubs    func(store *mockdb.MockStore)
// 		checkResponse func(t *testing.T, recorder *httptest.ResponseRecorder)
// 	}{
// 		{
// 			name:          "OK",
// 			fromAccountId: Transfer.FromAccountID,
// 			toAccountId:   Transfer.ToAccountID,
// 			amount:        Transfer.Amount,
// 			buildStubs: func(store *mockdb.MockStore) {
// 				store.EXPECT().GetAccount(gomock.Any(), gomock.Eq(Account1.ID)).Times(1).Return(Account1, nil)
// 				store.EXPECT().GetAccount(gomock.Any(), gomock.Eq(Account2.ID)).Times(1).Return(Account2, nil)
// 				store.EXPECT().CreateTransfer(gomock.Any(), db.CreateTransferParams{
// 					FromAccountID: Transfer.FromAccountID,
// 					ToAccountID:   Transfer.ToAccountID,
// 					Amount:        Transfer.Amount,
// 				}).Times(1).Return(Transfer, nil)
// 				store.EXPECT().TransferTx(gomock.Any(), db.TransferTxParams{
// 					FromAccountID: Transfer.FromAccountID,
// 					ToAccountID:   Transfer.ToAccountID,
// 					Amount:        Transfer.Amount,
// 				}).Times(1).Return(db.TransferTxResult{

// 				})
// 			},
// 			checkResponse: func(t *testing.T, recorder *httptest.ResponseRecorder) {
// 				require.Equal(t, http.StatusOK, recorder.Code)
// 				requireBodyMatchTransfer(t, recorder.Body, Transfer)
// 			},
// 		},
// {
// 	name:     "InvalidOwnerOrCurrency",
// 	Owner:    Transfer.Owner,
// 	Currency: "",
// 	buildStubs: func(store *mockdb.MockStore) {
// 		store.EXPECT().CreateTransfer(gomock.Any(), gomock.Any()).Times(0)
// 	},
// 	checkResponse: func(t *testing.T, recorder *httptest.ResponseRecorder) {
// 		require.Equal(t, http.StatusBadRequest, recorder.Code)
// 	},
// },
// {
// 	name:     "InternalError",
// 	Owner:    Transfer.Owner,
// 	Currency: Transfer.Currency,
// 	buildStubs: func(store *mockdb.MockStore) {
// 		store.EXPECT().CreateTransfer(gomock.Any(), db.CreateTransferParams{
// 			Owner:    Transfer.Owner,
// 			Currency: Transfer.Currency,
// 		}).Times(1).Return(Transfer, sql.ErrConnDone)
// 	},
// 	checkResponse: func(t *testing.T, recorder *httptest.ResponseRecorder) {
// 		require.Equal(t, http.StatusInternalServerError, recorder.Code)
// 	},
// },
// {
// 	name:     "ViolationError",
// 	Owner:    randomOwner,
// 	Currency: Transfer.Currency,
// 	buildStubs: func(store *mockdb.MockStore) {
// 		store.EXPECT().CreateTransfer(gomock.Any(), db.CreateTransferParams{
// 			Owner:    randomOwner,
// 			Currency: Transfer.Currency,
// 		}).Times(1).Return(Transfer, error(&pq.Error{
// 			Code: "23503",
// 		}))
// 	},
// 	checkResponse: func(t *testing.T, recorder *httptest.ResponseRecorder) {
// 		require.Equal(t, http.StatusForbidden, recorder.Code)
// 	},
// },
// {
// 	name:     "UniqueViolationError",
// 	Owner:    randomOwner,
// 	Currency: Transfer.Currency,
// 	buildStubs: func(store *mockdb.MockStore) {
// 		store.EXPECT().CreateTransfer(gomock.Any(), db.CreateTransferParams{
// 			Owner:    randomOwner,
// 			Currency: Transfer.Currency,
// 		}).Times(1).Return(Transfer, error(&pq.Error{
// 			Code: "23505",
// 		}))
// 	},
// 	checkResponse: func(t *testing.T, recorder *httptest.ResponseRecorder) {
// 		require.Equal(t, http.StatusForbidden, recorder.Code)
// 	},
// 	// },
// }

// 	for i := range testCases {
// 		tc := testCases[i]
// 		ctrl := gomock.NewController(t)
// 		defer ctrl.Finish()

// 		store := mockdb.NewMockStore(ctrl)
// 		// build stubs
// 		tc.buildStubs(store)

// 		// start test server and send request
// 		server := NewServer(store)
// 		recorder := httptest.NewRecorder()

// 		request, err := http.NewRequest(http.MethodPost, "/transfers", nil)
// 		require.NoError(t, err)
// 		body, err := json.Marshal(TransferRequest{
// 			FromAccountID: tc.fromAccountId,
// 			ToAccountID:   tc.toAccountId,
// 			Amount:        tc.amount,
// 			Currency:      randCurrency,
// 		})
// 		request.Body = io.NopCloser(bytes.NewReader(body))

// 		require.NoError(t, err)
// 		server.router.ServeHTTP(recorder, request)

// 		// check response
// 		tc.checkResponse(t, recorder)
// 	}

// }

func TestListTransfer(t *testing.T) {
	var Transfers []db.Transfers
	for i := 0; i < int(rand.Int31n(10)+2); i++ {
		Account1 := randomAccount()
		Account2 := randomAccount()
		Transfers = append(Transfers, randomTransfer(Account1, Account2))
	}
	pageId := rand.Int31n(3) + 2
	limit := rand.Int31n(10) + 2
	param := db.ListTransfersParams{
		Limit:  limit,
		Offset: (pageId - 1) * limit,
	}

	testCases := []struct {
		name          string
		limit         int
		offset        int
		buildStubs    func(store *mockdb.MockStore)
		checkResponse func(t *testing.T, recorder *httptest.ResponseRecorder)
	}{
		{
			name:   "OK",
			limit:  int(param.Limit),
			offset: int(param.Offset),
			buildStubs: func(store *mockdb.MockStore) {
				store.EXPECT().ListTransfers(gomock.Any(), param).Times(1).Return(Transfers, nil)
			},
			checkResponse: func(t *testing.T, recorder *httptest.ResponseRecorder) {
				require.Equal(t, http.StatusOK, recorder.Code)
				requireBodyMatchAllTransfers(t, recorder.Body, Transfers)
			},
		},
		{
			name:   "InvalidRequest",
			limit:  int(param.Limit),
			offset: 0,
			buildStubs: func(store *mockdb.MockStore) {
				store.EXPECT().ListTransfers(gomock.Any(), 0).Times(0)
			},
			checkResponse: func(t *testing.T, recorder *httptest.ResponseRecorder) {
				require.Equal(t, http.StatusBadRequest, recorder.Code)
			},
		},
		{
			name:   "InternalError",
			limit:  int(param.Limit),
			offset: int(param.Offset),
			buildStubs: func(store *mockdb.MockStore) {
				store.EXPECT().ListTransfers(gomock.Any(), gomock.Any()).Times(1).Return(Transfers, sql.ErrConnDone)
			},
			checkResponse: func(t *testing.T, recorder *httptest.ResponseRecorder) {
				require.Equal(t, http.StatusInternalServerError, recorder.Code)
			},
		},
	}

	for i := range testCases {
		tc := testCases[i]
		t.Run(tc.name, func(t *testing.T) {
			ctrl := gomock.NewController(t)
			defer ctrl.Finish()

			store := mockdb.NewMockStore(ctrl)
			// build stubs
			tc.buildStubs(store)

			server := NewServer(store)
			recorder := httptest.NewRecorder()

			var url string
			if tc.offset != 0 {
				url = fmt.Sprintf("/transfers?page_id=%d&page_size=%d", pageId, tc.limit)
			} else {
				url = "/transfers?page_size=abcd"
			}
			request, err := http.NewRequest(http.MethodGet, url, nil)
			require.NoError(t, err)

			server.router.ServeHTTP(recorder, request)
			// check response
			tc.checkResponse(t, recorder)

		})
	}
}

func TestGetAllTransferAPI(t *testing.T) {
	var Transfers []db.Transfers
	for i := 0; i < int(rand.Int31n(10)+2); i++ {
		Account1 := randomAccount()
		Account2 := randomAccount()
		Transfers = append(Transfers, randomTransfer(Account1, Account2))
	}
	testCases := []struct {
		name          string
		buildStubs    func(store *mockdb.MockStore)
		checkResponse func(t *testing.T, recorder *httptest.ResponseRecorder)
	}{
		{
			name: "OK",
			buildStubs: func(store *mockdb.MockStore) {
				store.EXPECT().GetAllTransfers(gomock.Any()).Times(1).Return(Transfers, nil)
			},
			checkResponse: func(t *testing.T, recorder *httptest.ResponseRecorder) {
				require.Equal(t, http.StatusOK, recorder.Code)
				requireBodyMatchAllTransfers(t, recorder.Body, Transfers)
			},
		},
		{
			name: "InternalError",
			buildStubs: func(store *mockdb.MockStore) {
				store.EXPECT().GetAllTransfers(gomock.Any()).Times(1).Return(Transfers, sql.ErrConnDone)
			},
			checkResponse: func(t *testing.T, recorder *httptest.ResponseRecorder) {
				require.Equal(t, http.StatusInternalServerError, recorder.Code)
			},
		},
	}
	for i := range testCases {
		tc := testCases[i]
		t.Run(tc.name, func(t *testing.T) {
			ctrl := gomock.NewController(t)
			defer ctrl.Finish()

			store := mockdb.NewMockStore(ctrl)
			// build stubs
			tc.buildStubs(store)

			// start test server and send request
			server := NewServer(store)
			recorder := httptest.NewRecorder()

			request, err := http.NewRequest(http.MethodGet, "/transfers", nil)
			require.NoError(t, err)
			server.router.ServeHTTP(recorder, request)
			// check response
			tc.checkResponse(t, recorder)
		})
	}
}

func TestGetTransferAPI(t *testing.T) {
	Account1 := randomAccount()
	Account2 := randomAccount()
	Transfer := randomTransfer(Account1, Account2)

	testCases := []struct {
		name          string
		TransferID    int
		buildStubs    func(store *mockdb.MockStore)
		checkResponse func(t *testing.T, recorder *httptest.ResponseRecorder)
	}{
		{
			name:       "OK",
			TransferID: int(Transfer.ID),
			buildStubs: func(store *mockdb.MockStore) {
				store.EXPECT().GetTransfer(gomock.Any(), gomock.Eq(Transfer.ID)).Times(1).Return(Transfer, nil)
			},
			checkResponse: func(t *testing.T, recorder *httptest.ResponseRecorder) {
				require.Equal(t, http.StatusOK, recorder.Code)
				requireBodyMatchTransfer(t, recorder.Body, Transfer)
			},
		},
		{
			name:       "NotFound",
			TransferID: int(util.RandomAccountID()),
			buildStubs: func(store *mockdb.MockStore) {
				store.EXPECT().GetTransfer(gomock.Any(), gomock.Any()).Times(1).Return(db.Transfers{}, sql.ErrNoRows)
			},
			checkResponse: func(t *testing.T, recorder *httptest.ResponseRecorder) {
				require.Equal(t, http.StatusNotFound, recorder.Code)
			},
		},
		{
			name:       "InternalError",
			TransferID: int(Transfer.ID),
			buildStubs: func(store *mockdb.MockStore) {
				store.EXPECT().GetTransfer(gomock.Any(), gomock.Eq(Transfer.ID)).Times(1).Return(db.Transfers{}, sql.ErrConnDone)
			},
			checkResponse: func(t *testing.T, recorder *httptest.ResponseRecorder) {
				require.Equal(t, http.StatusInternalServerError, recorder.Code)
			},
		},
		{
			name:       "InvalidID",
			TransferID: int(0),
			buildStubs: func(store *mockdb.MockStore) {
				store.EXPECT().GetTransfer(gomock.Any(), gomock.Any()).Times(0)
			},
			checkResponse: func(t *testing.T, recorder *httptest.ResponseRecorder) {
				require.Equal(t, http.StatusBadRequest, recorder.Code)
			},
		},
	}

	for i := range testCases {
		tc := testCases[i]
		t.Run(tc.name, func(t *testing.T) {
			ctrl := gomock.NewController(t)
			defer ctrl.Finish()

			store := mockdb.NewMockStore(ctrl)
			// build stubs
			tc.buildStubs(store)

			// start test server and send request
			server := NewServer(store)
			recorder := httptest.NewRecorder()

			url := fmt.Sprintf("/transfers/%d", tc.TransferID)
			request, err := http.NewRequest(http.MethodGet, url, nil)
			require.NoError(t, err)
			server.router.ServeHTTP(recorder, request)
			// check response
			tc.checkResponse(t, recorder)
		})
	}

}

func randomTransfer(acc1 db.Accounts, acc2 db.Accounts) db.Transfers {
	return db.Transfers{
		ID:            util.RandomInt(1, 1000),
		FromAccountID: acc1.ID,
		ToAccountID:   acc2.ID,
		Amount:        util.RandomAmount() + 1,
		CreatedAt:     time.Now(),
	}
}

func requireBodyMatchAllTransfers(t *testing.T, body *bytes.Buffer, Transfers []db.Transfers) {
	data, err := ioutil.ReadAll(body)
	require.NoError(t, err)

	var gotTransfer []db.Transfers
	err = json.Unmarshal(data, &gotTransfer)
	require.NoError(t, err)
	for i, Transfer := range Transfers {
		require.NoError(t, err)
		require.Equal(t, Transfer.ID, gotTransfer[i].ID)
		require.Equal(t, Transfer.FromAccountID, gotTransfer[i].FromAccountID)
		require.Equal(t, Transfer.ToAccountID, gotTransfer[i].ToAccountID)
		require.Equal(t, Transfer.Amount, gotTransfer[i].Amount)
		require.WithinDuration(t, Transfer.CreatedAt, gotTransfer[i].CreatedAt, time.Second)
	}
}

func requireBodyMatchTransfer(t *testing.T, body *bytes.Buffer, Transfer db.Transfers) {
	data, err := ioutil.ReadAll(body)
	require.NoError(t, err)

	var gotTransfer db.Transfers
	err = json.Unmarshal(data, &gotTransfer)
	require.NoError(t, err)
	require.Equal(t, Transfer.ID, gotTransfer.ID)
	require.Equal(t, Transfer.FromAccountID, gotTransfer.FromAccountID)
	require.Equal(t, Transfer.ToAccountID, gotTransfer.ToAccountID)
	require.Equal(t, Transfer.Amount, gotTransfer.Amount)
	require.WithinDuration(t, Transfer.CreatedAt, gotTransfer.CreatedAt, time.Second)
}
