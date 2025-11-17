package session

import (
	"net/http"

	errs "acl-for-wis/errCodes"
	"acl-for-wis/http/common"
	"acl-for-wis/mcservice"
	"acl-for-wis/service"

	httpError "dev.modext.ru/dcc5/fw/svccli/util/error"
	"github.com/labstack/echo/v4"
)

// Handler represent handler for session API
type Handler struct {
	useCase *mcservice.MeteoService
}

// NewHandler create new handler
func NewHandler(s *service.Service) *Handler {
	return &Handler{s.MeteoService}
}

// Info is an API handler for get info about session
func (h *Handler) Info(c echo.Context) error {
	ctx := c.Request().Context()

	p := new(InfoRequest)
	if err := (&echo.DefaultBinder{}).BindHeaders(c, p); err != nil {
		return httpError.GetStdHTTPMaker().NewBindError(err)
	}

	if err := c.Validate(p); err != nil {
		return httpError.GetStdHTTPMaker().NewValidateError(err)
	}

	if p.XTicket == "" {
		return httpError.New(errs.ServiceTicketNotFound, "Info", "xTicket is empty")
	}
	info, err := h.useCase.GetSystemInfoByST(ctx, p.XTicket)
	if err != nil {
		info, err = h.useCase.GetSession(ctx, p.XTicket, mcservice.TypeST)
	}

	if err != nil {
		return err
	}

	resp := common.Response{
		Meta:     common.Meta{},
		Response: InfoResponse{Session: newSession(info, true)},
	}
	return c.JSON(http.StatusOK, resp)
}

// Find is an API handler for find sessions
func (h *Handler) Find(c echo.Context) error {
	ctx := c.Request().Context()

	p := new(FindRequest)
	if err := c.Bind(p); err != nil {
		return httpError.GetStdHTTPMaker().NewBindError(err)
	}

	if err := c.Validate(p); err != nil {
		return httpError.GetStdHTTPMaker().NewValidateError(err)
	}

	items, err := h.useCase.FindSessions(ctx, p.toModel())
	if err != nil {
		return err
	}

	resp := common.Response{
		Meta:     common.Meta{},
		Response: newListResponse(p.Page, p.PageSize, len(items), items),
	}

	return c.JSON(http.StatusOK, resp)
}

// Get is an API handler for get session
func (h *Handler) Get(c echo.Context) error {
	ctx := c.Request().Context()

	p := new(Request)
	if err := c.Bind(p); err != nil {
		return httpError.GetStdHTTPMaker().NewBindError(err)
	}

	if err := c.Validate(p); err != nil {
		return httpError.GetStdHTTPMaker().NewValidateError(err)
	}

	info, err := h.useCase.GetSession(ctx, p.ID, mcservice.TypeID)
	if err != nil {
		return err
	}

	resp := common.Response{
		Meta:     common.Meta{},
		Response: GetResponse{Session: newSession(info, true)},
	}
	return c.JSON(http.StatusOK, resp)
}

// Update is an API handler for update session information
func (h *Handler) Update(c echo.Context) error {
	ctx := c.Request().Context()

	p := new(UpdateRequest)
	if err := c.Bind(p); err != nil {
		return httpError.GetStdHTTPMaker().NewBindError(err)
	}

	if err := c.Validate(p); err != nil {
		return httpError.GetStdHTTPMaker().NewValidateError(err)
	}

	err := h.useCase.UpdateSession(ctx, p.toModel())
	if err != nil {
		return err
	}

	return c.JSON(http.StatusOK, common.EmptyResponse{})
}

// Archive is an API handler for archive session
func (h *Handler) Archive(c echo.Context) error {
	ctx := c.Request().Context()

	p := new(Request)
	if err := (&echo.DefaultBinder{}).BindQueryParams(c, p); err != nil {
		return httpError.GetStdHTTPMaker().NewBindError(err)
	}

	if err := c.Validate(p); err != nil {
		return httpError.GetStdHTTPMaker().NewValidateError(err)
	}

	if err := h.useCase.ArchiveSession(ctx, p.ID); err != nil {
		return err
	}

	return c.JSON(http.StatusOK, common.EmptyResponse{})
}

// Delete is an API handler for delete session
func (h *Handler) Delete(c echo.Context) error {
	ctx := c.Request().Context()

	p := new(Request)
	if err := (&echo.DefaultBinder{}).BindQueryParams(c, p); err != nil {
		return httpError.GetStdHTTPMaker().NewBindError(err)
	}

	if err := c.Validate(p); err != nil {
		return httpError.GetStdHTTPMaker().NewValidateError(err)
	}

	if err := h.useCase.DeleteSession(ctx, p.ID); err != nil {
		return err
	}

	return c.JSON(http.StatusOK, common.EmptyResponse{})
}

// DropAll is an API handler for drop all sessions
func (h *Handler) DropAll(c echo.Context) error {
	ctx := c.Request().Context()

	if err := h.useCase.DropSession(ctx); err != nil {
		return err
	}

	return c.JSON(http.StatusOK, common.EmptyResponse{})
}
