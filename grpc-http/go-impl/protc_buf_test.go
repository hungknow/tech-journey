package goimpl

import (
	petv1 "grpc-http/gen/proto/go/hk/v1"
	"testing"

	"github.com/stretchr/testify/require"
	"google.golang.org/protobuf/proto"
)

func TestProcEncodeDecode(t *testing.T) {
	putGetRequest := &petv1.PutPetRequest{
		PetType: petv1.PetType_PET_TYPE_SNAKE,
		Name:    "Ekans",
	}
	putGetRequestEncoded, err := proto.Marshal(putGetRequest)
	require.NoError(t, err)

	putGetRequestNew := &petv1.PutPetRequest{}
	err = proto.Unmarshal(putGetRequestEncoded, putGetRequestNew)
	require.NoError(t, err)
	require.Equal(t, putGetRequest.Name, putGetRequestNew.Name)
	require.Equal(t, putGetRequest.PetType, putGetRequestNew.PetType)
}