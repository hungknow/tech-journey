import 'package:grpc/grpc.dart';
import '../gen/proto/dart/hk/v1/petstore.pbgrpc.dart';

Future<void> main(List<String> args) async {
  final channel = ClientChannel(
    'localhost',
    port: 5001,
    options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
  );
  final stub = PetStoreServiceClient(channel);

  final name = args.isNotEmpty ? args[0] : 'world';

  try {
    var response = await stub.putPet(PutPetRequest()..name = name);
    print('putPet: ${response.pet.name}');
  } catch (e) {
    print('Caught error: $e');
  }
  await channel.shutdown();
}