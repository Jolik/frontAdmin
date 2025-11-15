package session

import (
	"acl-for-wis/http/common"
	"acl-for-wis/mcstorage"

	"dev.modext.ru/dcc5/fw/svccli/objectservice"
	uuid "github.com/satori/go.uuid"

	"github.com/mtfelian/utils"
)

// Request represents parameter for Get, Archive, Delete handlers
type Request struct {
	ID uuid.UUID `json:"sessid" param:"sessid" query:"sessid" validate:"required,gt=0,be_uuid"`
}

type UpdateRequest struct {
	Request
	Loc *mcstorage.LonLatZ `json:"loc"`
}

// InfoRequest represents parameter for Info
type InfoRequest struct {
	XTicket string `header:"X-Ticket" validate:"required,gt=0"`
}

// FindRequest represents parameters for Find handler
type FindRequest struct {
	common.Pagination
	ID         []uuid.UUID               `json:"sesid" validate:"gte=0,lte=100,dive,be_uuid"`
	CompanyID  []uuid.UUID               `json:"compid" validate:"gte=0,lte=100,dive,be_uuid"`
	Sid        []string                  `json:"sid" validate:"gte=0,lte=100,dive,gt=0,lte=255"`
	UserID     []uuid.UUID               `json:"usid" validate:"gte=0,lte=100,dive,be_uuid"`
	UpdateFrom *int64                    `json:"updateFrom" validate:"omitempty,gt=0"`
	UpdateTo   *int64                    `json:"updateTo" validate:"omitempty,gt=0"`
	Area       *objectservice.SearchArea `json:"area"`
	Order      []string                  `json:"order" validate:"omitempty,dive,oneof=sid usid compid created updated deleted"`
	SearchStr  string                    `json:"searchStr" validate:"omitempty,gt=0,lte=255"`
	SearchBy   []string                  `json:"search" validate:"omitempty,dive,oneof=sid"`
	Flags      []string                  `json:"flags" validate:"gte=0,lte=100,dive,gt=0,oneof=all archiveonly"`
}

func (r *UpdateRequest) toModel() mcstorage.UpdateSessionParams {
	return mcstorage.UpdateSessionParams{
		ID:  r.ID,
		Loc: r.Loc,
	}
}

func (r *FindRequest) toModel() mcstorage.FindSessionParams {
	r.NormalizePagination()
	return mcstorage.FindSessionParams{
		Paginator:       mcstorage.NewPaginatorByValues(r.Page, r.PageSize, r.Order, r.OrderDir),
		BySessionID:     r.ID,
		ByUserID:        r.UserID,
		ByTGT:           r.Sid,
		ByCompanyID:     r.CompanyID,
		Search:          r.SearchBy,
		SearchStr:       r.SearchStr,
		Area:            r.Area,
		FlagAll:         utils.SliceContains("all", r.Flags),
		FlagArchiveOnly: utils.SliceContains("archiveonly", r.Flags),
	}
}
