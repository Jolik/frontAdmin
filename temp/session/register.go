package session

import (
	"acl-for-wis/service"

	"github.com/labstack/echo/v4"
)

// RegisterSessionAPIEndpoints register routers for session API
func RegisterSessionAPIEndpoints(g *echo.Group, s *service.Service, auth echo.MiddlewareFunc) {
	h := NewHandler(s)

	session := g.Group("/sessions")
	session.GET("/info", h.Info)
	session.GET("/:sessid", h.Get, auth)
	session.POST("/:sessid/update", h.Update, auth)
	session.POST("/list", h.Find, auth)
	session.POST("/archive", h.Archive, auth)
	session.POST("/rem", h.Delete, auth)
	session.POST("/dropall", h.DropAll, auth)
}
