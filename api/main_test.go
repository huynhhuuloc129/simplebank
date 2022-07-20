package api

import (
	"math/rand"
	"os"
	"testing"
	"time"

	"github.com/gin-gonic/gin"
	_ "github.com/lib/pq"
)



func TestMain(m *testing.M) {
	gin.SetMode(gin.TestMode)
	rand.Seed(time.Now().UnixNano())
	os.Exit(m.Run())
}
