// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.14.0
// source: users.sql

package db

import (
	"context"
)

const createUser = `-- name: CreateUser :one
INSERT INTO users(
    username,
    hashed_password,
    full_name,
    email
) VALUES (
    $1, $2, $3, $4
) RETURNING username, hashed_password, full_name, email, password_changed_at, created_at
`

type CreateUserParams struct {
	Username       string `json:"username"`
	HashedPassword string `json:"hashed_password"`
	FullName       string `json:"full_name"`
	Email          string `json:"email"`
}

func (q *Queries) CreateUser(ctx context.Context, arg CreateUserParams) (Users, error) {
	row := q.queryRow(ctx, q.createUserStmt, createUser,
		arg.Username,
		arg.HashedPassword,
		arg.FullName,
		arg.Email,
	)
	var i Users
	err := row.Scan(
		&i.Username,
		&i.HashedPassword,
		&i.FullName,
		&i.Email,
		&i.PasswordChangedAt,
		&i.CreatedAt,
	)
	return i, err
}

const deleteUser = `-- name: DeleteUser :exec
DELETE FROM users 
WHERE username = $1
`

func (q *Queries) DeleteUser(ctx context.Context, username string) error {
	_, err := q.exec(ctx, q.deleteUserStmt, deleteUser, username)
	return err
}

const getUser = `-- name: GetUser :one
SELECT username, hashed_password, full_name, email, password_changed_at, created_at FROM users
WHERE username = $1 LIMIT 1
`

func (q *Queries) GetUser(ctx context.Context, username string) (Users, error) {
	row := q.queryRow(ctx, q.getUserStmt, getUser, username)
	var i Users
	err := row.Scan(
		&i.Username,
		&i.HashedPassword,
		&i.FullName,
		&i.Email,
		&i.PasswordChangedAt,
		&i.CreatedAt,
	)
	return i, err
}

const getUserForUpdate = `-- name: GetUserForUpdate :one
SELECT username, hashed_password, full_name, email, password_changed_at, created_at FROM users
WHERE username = $1 LIMIT 1
FOR NO KEY UPDATE
`

func (q *Queries) GetUserForUpdate(ctx context.Context, username string) (Users, error) {
	row := q.queryRow(ctx, q.getUserForUpdateStmt, getUserForUpdate, username)
	var i Users
	err := row.Scan(
		&i.Username,
		&i.HashedPassword,
		&i.FullName,
		&i.Email,
		&i.PasswordChangedAt,
		&i.CreatedAt,
	)
	return i, err
}

const listUsers = `-- name: ListUsers :many
SELECT username, hashed_password, full_name, email, password_changed_at, created_at FROM users
ORDER BY username
LIMIT $1
OFFSET $2
`

type ListUsersParams struct {
	Limit  int32 `json:"limit"`
	Offset int32 `json:"offset"`
}

func (q *Queries) ListUsers(ctx context.Context, arg ListUsersParams) ([]Users, error) {
	rows, err := q.query(ctx, q.listUsersStmt, listUsers, arg.Limit, arg.Offset)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	items := []Users{}
	for rows.Next() {
		var i Users
		if err := rows.Scan(
			&i.Username,
			&i.HashedPassword,
			&i.FullName,
			&i.Email,
			&i.PasswordChangedAt,
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

const updateUser = `-- name: UpdateUser :one
UPDATE users
SET hashed_password = $2,
    full_name = $3
WHERE username = $1
RETURNING username, hashed_password, full_name, email, password_changed_at, created_at
`

type UpdateUserParams struct {
	Username       string `json:"username"`
	HashedPassword string `json:"hashed_password"`
	FullName       string `json:"full_name"`
}

func (q *Queries) UpdateUser(ctx context.Context, arg UpdateUserParams) (Users, error) {
	row := q.queryRow(ctx, q.updateUserStmt, updateUser, arg.Username, arg.HashedPassword, arg.FullName)
	var i Users
	err := row.Scan(
		&i.Username,
		&i.HashedPassword,
		&i.FullName,
		&i.Email,
		&i.PasswordChangedAt,
		&i.CreatedAt,
	)
	return i, err
}
