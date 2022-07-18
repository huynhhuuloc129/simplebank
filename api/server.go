package api

import (
	"github.com/gin-gonic/gin"
	db "github.com/huynhhuuloc129/simplebank/db/sqlc"
)

// Server serves HTTP requests for our banking service.
type Server struct{
	store db.Store
	router *gin.Engine
}

// NewServer create a new HTTP server and setup routing.
func NewServer(store db.Store) *Server{
	server := &Server{store: store}
	router := gin.Default()

	router.POST("/accounts", server.createAccount)
	router.GET("/accounts/:id", server.getAccount)
	router.GET("/accounts/", server.listAccount)
	router.DELETE("/accounts/:id", server.deleteAccount)

	router.POST("/users", server.createUser)
	router.GET("/users/:username", server.getUser)
	router.GET("/users/", server.listUser)
	router.DELETE("/users/:username", server.deleteUser)

	server.router = router
	return server
}

// Start runs the HTTP server on a specific address.
func (server *Server) Start(address string) error {
	return server.router.Run(address)
}

// errorResponse convert an error to a object
func errorResponse(err error) gin.H {
	return gin.H{"error": err.Error()}
}