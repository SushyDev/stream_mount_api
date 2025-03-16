package stream_mount_api

import (
	"errors"
	"os"
	"syscall"

	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

func ToResponseError(err error) error {
	if err == nil {
		return nil
	}

	switch {
	case os.IsNotExist(err):
		return status.Error(codes.NotFound, err.Error())
	case os.IsPermission(err):
		return status.Error(codes.PermissionDenied, err.Error())
	case errors.Is(err, syscall.ENOENT):
		return status.Error(codes.NotFound, syscall.ENOENT.Error())
	default:
		return status.Error(codes.Unknown, err.Error())
	}
}

func FromResponseError(err error) error {
	if err == nil {
		return nil
	}

	st, ok := status.FromError(err)
	if !ok {
		return errors.New("Unknown gRPC error")
	}

	switch st.Code() {
	case codes.NotFound:
		return syscall.ENOENT
	case codes.PermissionDenied:
		return syscall.EACCES
	default:
		return errors.New(st.Message())
	}
}
