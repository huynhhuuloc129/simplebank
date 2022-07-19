// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.14.0
// source: entries.sql

package db

import (
	"context"
)

const createEntry = `-- name: CreateEntry :one
INSERT INTO entries(
    account_id, amount
) VALUES (
    $1, $2
) RETURNING id, account_id, amount, created_at
`

type CreateEntryParams struct {
	AccountID int64 `json:"account_id"`
	Amount    int64 `json:"amount"`
}

func (q *Queries) CreateEntry(ctx context.Context, arg CreateEntryParams) (Entries, error) {
	row := q.queryRow(ctx, q.createEntryStmt, createEntry, arg.AccountID, arg.Amount)
	var i Entries
	err := row.Scan(
		&i.ID,
		&i.AccountID,
		&i.Amount,
		&i.CreatedAt,
	)
	return i, err
}

const deleteEntriesByAccountID = `-- name: DeleteEntriesByAccountID :exec
DELETE FROM entries
WHERE account_id = $1
`

func (q *Queries) DeleteEntriesByAccountID(ctx context.Context, accountID int64) error {
	_, err := q.exec(ctx, q.deleteEntriesByAccountIDStmt, deleteEntriesByAccountID, accountID)
	return err
}

const deleteEntry = `-- name: DeleteEntry :exec
DELETE FROM entries 
WHERE id = $1
`

func (q *Queries) DeleteEntry(ctx context.Context, id int64) error {
	_, err := q.exec(ctx, q.deleteEntryStmt, deleteEntry, id)
	return err
}

const getEntry = `-- name: GetEntry :one
SELECT id, account_id, amount, created_at FROM entries
WHERE id = $1 LIMIT 1
`

func (q *Queries) GetEntry(ctx context.Context, id int64) (Entries, error) {
	row := q.queryRow(ctx, q.getEntryStmt, getEntry, id)
	var i Entries
	err := row.Scan(
		&i.ID,
		&i.AccountID,
		&i.Amount,
		&i.CreatedAt,
	)
	return i, err
}

const listEntries = `-- name: ListEntries :many
SELECT id, account_id, amount, created_at FROM entries
ORDER BY id
LIMIT $1
OFFSET $2
`

type ListEntriesParams struct {
	Limit  int32 `json:"limit"`
	Offset int32 `json:"offset"`
}

func (q *Queries) ListEntries(ctx context.Context, arg ListEntriesParams) ([]Entries, error) {
	rows, err := q.query(ctx, q.listEntriesStmt, listEntries, arg.Limit, arg.Offset)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	items := []Entries{}
	for rows.Next() {
		var i Entries
		if err := rows.Scan(
			&i.ID,
			&i.AccountID,
			&i.Amount,
			&i.CreatedAt,
		); err != nil {
			return nil, err
		}
		items = append(items, i)
	}
	if err := rows.Close(); err != nil {
		return nil, err
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return items, nil
}

const updateEntry = `-- name: UpdateEntry :one
UPDATE entries
SET amount = $2
WHERE id = $1
RETURNING id, account_id, amount, created_at
`

type UpdateEntryParams struct {
	ID     int64 `json:"id"`
	Amount int64 `json:"amount"`
}

func (q *Queries) UpdateEntry(ctx context.Context, arg UpdateEntryParams) (Entries, error) {
	row := q.queryRow(ctx, q.updateEntryStmt, updateEntry, arg.ID, arg.Amount)
	var i Entries
	err := row.Scan(
		&i.ID,
		&i.AccountID,
		&i.Amount,
		&i.CreatedAt,
	)
	return i, err
}
