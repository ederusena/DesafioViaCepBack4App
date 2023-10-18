import 'package:dio_back4app_desafio_cep/model/cep.dart';
import 'package:dio_back4app_desafio_cep/repositorio/cep_back4app_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ViapCep(),
    );
  }
}

class ViapCep extends StatefulWidget {
  const ViapCep({super.key});

  @override
  State<ViapCep> createState() => _ViapCepState();
}

class _ViapCepState extends State<ViapCep> {
  var viaCepModel = ViaCepModel();
  var viaCepRepository = CepBack4AppRepository();

  var cepController = TextEditingController(text: "");
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(children: [
            const Text("Consulta de CEP",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            TextField(
              controller: cepController,
              maxLength: 8,
              keyboardType: TextInputType.number,
              onChanged: (String value) async {
                var cep = value.replaceAll(RegExp(r'[^0-9]'), '');

                if (cep.length == 8) {
                  setState(() {
                    isLoading = true;
                  });
                  viaCepModel = await viaCepRepository.consultarCEP(cep);
                  // Bug com o teclado aberto
                  FocusManager.instance.primaryFocus?.unfocus();
                }

                setState(() {
                  isLoading = false;
                });
              },
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: "CEP"),
            ),
            const SizedBox(height: 50),
            Visibility(
                visible: isLoading, child: const CircularProgressIndicator()),
            Visibility(
              visible: !isLoading,
              child: Column(
                children: [
                  Text(viaCepModel.logradouro ?? "",
                      style: const TextStyle(fontSize: 22)),
                  Text(
                      "${viaCepModel.localidade ?? ''} - ${viaCepModel.uf ?? ''}",
                      style: const TextStyle(fontSize: 22)),
                ],
              ),
            )
          ])),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {},
        child: const Icon(Icons.add),
      ),
    ));
  }
}
