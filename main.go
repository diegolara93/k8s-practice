package main

import (
	"net/http"

	"github.com/labstack/echo-contrib/echoprometheus"

	"github.com/labstack/echo/v4"
)

func main() {
	e := echo.New()
	e.Use(echoprometheus.NewMiddleware("myapp"))
	e.GET("/metrics", echoprometheus.NewHandler())
	e.GET("/", func(c echo.Context) error {
		return c.String(http.StatusOK, "hi")
	})
	e.Logger.Fatal(e.Start(":8080"))
}
