package api

import (
	"github.com/gin-gonic/gin"
	"github.com/gin-gonic/gin/binding"
	"github.com/go-playground/validator/v10"
	db "github.com/huynhhuuloc129/simplebank/db/sqlc"
)

// Server serves HTTP requests for our banking service.
type Server struct {
	store  db.Store
	router *gin.Engine
}

type listRequest struct {
	PageID   int32 `form:"page_id"`
	PageSize int32 `form:"page_size"`
}

// NewServer create a new HTTP server and setup routing.
func NewServer(store db.Store) *Server {
	server := &Server{store: store}

	if v, ok := binding.Validator.Engine().(*validator.Validate); ok {
		v.RegisterValidation("currency", validCurrency)
	}
	server.setupRouter()
	return server
}

// Start runs the HTTP server on a specific address.
func (server *Server) Start(address string) error {
	return server.router.Run(address)
}

func (server *Server) setupRouter(){
	router := gin.Default()

	router.POST("/accounts", server.createAccount)
	router.GET("/accounts/:id", server.getAccount)
	router.GET("/accounts", server.listAccount)
	router.DELETE("/accounts/:id", server.deleteAccount)

	router.POST("/users", server.createUser)
	router.GET("/users/:username", server.getUser)
	router.GET("/users", server.listUser)
	router.DELETE("/users/:username", server.deleteUser)

	router.POST("/transfers", server.createTransfer)
	router.GET("/transfers/:id", server.getTransfer)
	router.GET("/transfers", server.listTransfer)
	router.DELETE("/transfers/:id", server.deleteTransfer)

	// router.POST("/transfers", server.createEntry)
	// router.GET("/transfers/:id", server.getEntry)
	router.GET("/entries/", server.listEntry)
	router.GET("/entries", server.getAllEntries)
	// router.DELETE("/transfers/:id", server.deleteEntry)
	server.router = router

}

// errorResponse convert an error to a object
func errorResponse(err error) gin.H {
	return gin.H{"error": err.Error()}
}
