import 'package:grpc/grpc.dart';
import "../gen/proto/dart/hk/v1/petstore.pbgrpc.dart";

class PetStore extends PetStoreServiceBase {
  @override
  Future<GetPetResponse> getPet(ServiceCall call, GetPetRequest request) async {
    return GetPetResponse.create()..pet = Pet.create();
  }

  @override
  Future<PutPetResponse> putPet(ServiceCall call, PutPetRequest request) async {
    print("Receive the putPet request for pet name '${request.name}'");
    final response = PutPetResponse.create();
    response.pet = Pet.create();
    response.pet.name = request.name;
    return response;
  }
}

Future<void> main(List<String> args) async {
  final server = Server(
    [PetStore()],
  );
  await server.serve(port: 5001);
  print('Server listening on port ${server.port}...');
}
