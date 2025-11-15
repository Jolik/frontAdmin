package session

import (
	"acl-for-wis/http/api/user"
	"acl-for-wis/http/common"
	"acl-for-wis/mcstorage"

	uuid "github.com/satori/go.uuid"
)

// InfoResponse represents response for Info handler
type InfoResponse struct {
	Session Session `json:"session"`
}

// GetResponse represents response for Get handler
type GetResponse struct {
	Session Session `json:"session"`
}

// FindResponse represents response for Find handler
type FindResponse struct {
	Sessions listItems `json:"sessions"`
}

type listItems struct {
	Info  common.ListInfo `json:"info"`
	Items []Session       `json:"items"`
}

func newListResponse(page, pageSize *int, total int, items []mcstorage.Info) FindResponse {
	res := make([]Session, len(items))
	for i := range items {
		res[i] = newSession(&items[i], false)
	}

	return FindResponse{
		Sessions: listItems{
			Info:  common.NewListInfo(total, page, pageSize),
			Items: res,
		},
	}
}

// Session represents a field in InfoResponse, GetResponse, FindResponse
type Session struct {
	ID        uuid.UUID          `json:"sessid"`
	CompanyID uuid.UUID          `json:"compid"`
	TGT       string             `json:"sid"`
	Tickets   []string           `json:"tickets"`
	Index     string             `json:"index"`
	Loc       *mcstorage.LonLatZ `json:"loc,omitempty"`
	User      *user.User         `json:"user,omitempty"`
	UserID    *uuid.UUID         `json:"usid,omitempty"`
	Created   int64              `json:"created"`
	Archived  *int64             `json:"archived"`
	Updated   int64              `json:"updated"`
}

func newSession(s *mcstorage.Info, isInfo bool) Session {
	tickets := make([]string, len(s.Tickets))
	for i, t := range s.Tickets {
		tickets[i] = t.ST
	}

	sess := Session{
		ID:        s.Session.ID,
		CompanyID: s.Session.CompanyID,
		TGT:       s.Session.TGT,
		Index:     s.Session.Index,
		Tickets:   tickets,
		Loc:       s.Session.Loc,
		Created:   s.Session.Created,
		Archived:  s.Session.Archived,
		Updated:   s.Session.Updated,
	}

	if isInfo {
		if s.User != nil {
			u := user.NewUser(s.User, true)
			sess.User = &u
		}
	} else {
		sess.UserID = &s.User.ID
	}

	return sess
}
