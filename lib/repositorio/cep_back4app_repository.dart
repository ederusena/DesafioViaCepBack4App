import 'package:dio_back4app_desafio_cep/model/cep.dart';
import 'package:dio_back4app_desafio_cep/repositorio/cep_backapp_baseurl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CepBack4AppRepository {
  var _cep = CepBack4ppBaseUrl();

  CepBack4AppRepository() {
    _cep = CepBack4ppBaseUrl();
  }

  Future<ViaCepModel> obterListaCep() async {
    var url = "/ViaCep";

    var response = await _cep.dio.get(url);
    var tarefasModel = ViaCepModel.fromJson(response.data);

    return tarefasModel;
  }

  Future<ViaCepModel> consultarCEP(String cep) async {
    var isCepRegisted = await _cep.dio.get("/ViaCep?where={\"cep\":\"$cep\"}");

    if (isCepRegisted.data["results"].length > 0) {
      var cepModel = ViaCepModel.fromJson(isCepRegisted.data["results"][0]);
      return cepModel;
    }

    var response =
        await http.get(Uri.parse("https://viacep.com.br/ws/$cep/json/"));

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      return ViaCepModel.fromJson(json);
    }
    return ViaCepModel();
  }

  // Future<void> salvar(ViaCepModel cepModel) async {
  //   try {
  //     await _cep.dio
  //         .post("/Tarefas", data: cepModel.toJsonCreateTask());
  //   } catch (e) {
  //     throw Exception(e);
  //   }
  // }

  // Future<void> atualizar(TarefaBack4AppModel tarefaBack4AppModel) async {
  //   try {
  //     await _cep.dio.put("/Tarefas/${tarefaBack4AppModel.objectId}",
  //         data: tarefaBack4AppModel.toJsonCreateTask());
  //   } catch (e) {
  //     throw Exception(e);
  //   }
  // }

  // Future<void> excluir(TarefaBack4AppModel tarefaBack4AppModel) async {
  //   try {
  //     await _cep.dio.delete("/Tarefas/${tarefaBack4AppModel.objectId}");
  //   } catch (e) {
  //     throw Exception(e);
  //   }
  // }
}
