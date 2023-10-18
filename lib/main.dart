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
      title: 'Via Cep Back4App',
      theme: ThemeData(
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
  var _listaCeps = <ViaCepModel>[];

  var cepController = TextEditingController(text: "");
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  void carregarDados() async {
    setState(() {
      isLoading = true;
    });
    _listaCeps = await viaCepRepository.listarAll();
    setState(() {
      isLoading = false;
    });
  }

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
                  carregarDados();

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
            ),
            Expanded(
              child: isLoading
                  ? const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 250, horizontal: 2),
                      child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: _listaCeps.length,
                      itemBuilder: (BuildContext bc, int index) {
                        var cep = _listaCeps[index];
                        return Card(
                          child: ListTile(
                            title: Text(cep.logradouro ?? ""),
                            subtitle: Text(
                                "${cep.localidade ?? ''} - ${cep.uf ?? ''} - ${cep.cep ?? ''}"),
                          ),
                        );
                      }),
            ),
          ])),
    ));
  }
}
