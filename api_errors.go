package stream_mount_api

import (
	"errors"
	"os"
	"syscall"

	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

// ToResponseError converts a filesystem error to a gRPC status error.
// fsErrorType is the type of filesystem error to check against and will be used as the error code/type.
// err is any error you wish to pass and will be used as the error message.
func ToResponseError(fsErrorType error, err error) error {
	if err == nil {
	 		return status.Error(codes.Unknown, "error cannot be nil")
	}

	switch {
	case os.IsNotExist(fsErrorType):
		return status.Error(codes.NotFound, err.Error())
	case os.IsPermission(fsErrorType):
		return status.Error(codes.PermissionDenied, err.Error())
	case errors.Is(fsErrorType, syscall.ENOENT):
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
